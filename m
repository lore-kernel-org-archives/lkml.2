Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756160Ab2JCNyJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 09:54:09 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31402 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756016Ab2JCNx7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 09:53:59 -0400
X-Authority-Analysis: v=2.0 cv=Hsb06jvS c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=UaAUr2XLl5QA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=K-l3MIClUOAA:10 a=8pif782wAAAA:8 a=p4yhxsxNAAAA:8 a=Ceotw3OPAAAA:8 a=qDPcfrqXXuL-uzIVUqEA:9 a=PUjeQqilurYA:10 a=skilWyurgcAA:10 a=D23JKBVSs9wQaRZ5:21 a=6V0mJQlhKpyIoCPT:21 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349272435.22822.165.camel@gandalf.local.home>
Subject: Re: [PATCH -tip ] [BUGFIX] perf probe: Add a workaround for GCC
 -mfentry
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Arnaldo Carvalho de Melo <acme@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Michal Marek <mmarek@suse.cz>, Andi Kleen <andi@firstfloor.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Date: Wed, 03 Oct 2012 09:53:55 -0400
In-Reply-To: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
References: <20121003121707.4186.28696.stgit@ltc138.sdl.hitachi.co.jp>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-10-03 at 21:17 +0900, Masami Hiramatsu wrote:

> Here are examples:
> -----
>  <1><9a58>: Abbrev Number: 86 (DW_TAG_subprogram)
>     <9a59>   DW_AT_external    : 1
>     <9a59>   DW_AT_name        : (indirect string, offset: 0xd82): unregister_di
> e_notifier
>     <9a5d>   DW_AT_decl_file   : 1
>     <9a5e>   DW_AT_decl_line   : 551
>     <9a60>   DW_AT_prototyped  : 1
>     <9a60>   DW_AT_type        : <0x7c>
>     <9a64>   DW_AT_low_pc      : 0x740
>     <9a6c>   DW_AT_high_pc     : 0x75a
>     <9a74>   DW_AT_frame_base  : 1 byte block: 9c       (DW_OP_call_frame_cfa)
>     <9a76>   DW_AT_GNU_all_call_sites: 1
>     <9a76>   DW_AT_sibling     : <0x9aac>
>  <2><9a7a>: Abbrev Number: 87 (DW_TAG_formal_parameter)
>     <9a7b>   DW_AT_name        : nb
>     <9a7e>   DW_AT_decl_file   : 1
>     <9a7f>   DW_AT_decl_line   : 551
>     <9a81>   DW_AT_type        : <0x2a96>
>     <9a85>   DW_AT_location    : 0x172f (location list)
> ...
>     0000172f 0000000000000745 0000000000000750 (DW_OP_reg5 (rdi))
>     0000172f 0000000000000750 0000000000000757 (DW_OP_reg4 (rsi))
>     0000172f 0000000000000757 000000000000075a (DW_OP_GNU_entry_value: (DW_OP_reg5 (rdi)); DW_OP_stack_value)
>     0000172f <End of list>
> -----
> 
> As you can see, the location of the parameter "nb", starts from 0x745
> but unregister_die_notifier() function itself starts from 0x740.

Um, no I can't see. I guess I need to go and read up on DWARF formats.
Any good recommended links?

A quick google gives me:

http://en.wikipedia.org/wiki/DWARF
http://wiki.dwarfstd.org/index.php?title=Dwarf_FAQ
http://www.eagercon.com/dwarf/dwarf-2.0.0.pdf

Is this what you recommend reading? Or is there better documentation?

-- Steve



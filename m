Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757249Ab2BIIkE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Feb 2012 03:40:04 -0500
Received: from e37.co.us.ibm.com ([32.97.110.158]:54939 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751268Ab2BIIkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Feb 2012 03:40:02 -0500
Date: Thu, 9 Feb 2012 13:57:22 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Denys Vlasenko <vda.linux@googlemail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Linux-mm <linux-mm@kvack.org>,
        Andi Kleen <andi@firstfloor.org>,
        Christoph Hellwig <hch@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Roland McGrath <roland@hack.frob.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Anton Arapov <anton@redhat.com>,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>,
        Jim Keniston <jkenisto@linux.vnet.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [PATCH v10 3.3-rc2 1/9] uprobes: Install and remove
 breakpoints.
Message-ID: <20120209082722.GD16600@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20120202141840.5967.39687.sendpatchset@srdronam.in.ibm.com>
 <20120202141851.5967.68000.sendpatchset@srdronam.in.ibm.com>
 <20120207171707.GA24443@linux.vnet.ibm.com>
 <CAK1hOcOd3hd31vZYw1yAVGK=gMV=vQotL1mRZkVgM=7M8mbMyw@mail.gmail.com>
 <4F3320E5.1050707@hitachi.com>
 <20120209063745.GB16600@linux.vnet.ibm.com>
 <4F338135.5090407@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <4F338135.5090407@hitachi.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020908-7408-0000-0000-00000284234F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >>
> > 
> > I am confused by why we need to call insn_get_length(insn) before
> > checking insn->rex_prefix.nbytes? Is it needed.
> 
> Ah, certainly, no, if the insn is already decoded.

Okay, 

> > 
> > 	uprobe->arch_info.rip_rela_target_address = 0x0;
> > 	if (!insn_rip_relative(insn))
> > 		return;
> 
> Here, I think it is better to add a comment that
> insn_rip_relative() decodes until modrm. :)

Will do.

> 
> > 	return;
> > }
> 
> Confirmed, this looks good to me ;)
> 
> Thanks!

Okay, Thanks for confirming, 

Do you have a handy instruction whose REX.B is set that I could use to test.

-- 
Thanks and Regards
Srikar


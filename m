Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab0KYBFa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:05:30 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:53631 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753293Ab0KYBF3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:05:29 -0500
Message-ID: <4CEDB53E.5000203@cn.fujitsu.com>
Date: Thu, 25 Nov 2010 09:00:46 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Richard Kennedy <richard@rsk.demon.co.uk>
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing/slub: Move kmalloc tracepoint
 out of inline code
References: <20101124212333.808256210@goodmis.org> <20101124212717.468748477@goodmis.org>
In-Reply-To: <20101124212717.468748477@goodmis.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-25 08:59:21,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2010-11-25 09:05:44,
	Serialize complete at 2010-11-25 09:05:44
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Cc: Richard Kennedy <richard@rsk.demon.co.uk>

Steven Rostedt wrote:
> From: Steven Rostedt <srostedt@redhat.com>
> 
> The tracepoint for kmalloc is in the slub inlined code which causes
> every instance of kmalloc to have the tracepoint.
> 
> This patch moves the tracepoint out of the inline code to the
> slub C file (and to page_alloc), which removes a large number of
> inlined trace points.
> 
>   objdump -dr vmlinux.slub| grep 'jmpq.*<trace_kmalloc' |wc -l
> 375
>   objdump -dr vmlinux.slub.patched| grep 'jmpq.*<trace_kmalloc' |wc -l
> 2
> 
> This also has a nice impact on size.
>    text	   data	    bss	    dec	    hex	filename
> 7050424	1961068	2482688	11494180	 af6324	vmlinux.slub
> 6979599	1944620	2482688	11406907	 ae0e3b	vmlinux.slub.patched
> 
> Siged-off-by: Steven Rostedt <rostedt@goodmis.org>

See this patch from Richard: :)

http://marc.info/?l=linux-kernel&m=128765337729262&w=2

But he only touched slub.

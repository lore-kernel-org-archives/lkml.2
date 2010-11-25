Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755279Ab0KYBRb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 20:17:31 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:42584 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752548Ab0KYBRa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 20:17:30 -0500
X-Authority-Analysis: v=1.1 cv=+c36koQ5Dcj/1qolKHjtkYAGXvrVJRRiKMp+84F5sLg= c=1 sm=0 a=D99tk35Pu7IA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=YoxM-lRnAAAA:8 a=20KFwNOVAAAA:8 a=meVymXHHAAAA:8 a=gu6fZOg2AAAA:8 a=oOAXyfZ0BpzW9YU8YE4A:9 a=VyyM4bZx_dfo_jkjEthylVjZCCQA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=a6l4FZsTB8EGKnGc:21 a=_v72vUsXIEDSLyin:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [RFC][PATCH 2/2] [PATCH 2/2] tracing/slub: Move kmalloc
 tracepoint out of inline code
From: Steven Rostedt <rostedt@goodmis.org>
To: Li Zefan <lizf@cn.fujitsu.com>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>, Matt Mackall <mpm@selenic.com>,
        linux-mm@kvack.org,
        Eduard - Gabriel Munteanu <eduard.munteanu@linux360.ro>,
        Richard Kennedy <richard@rsk.demon.co.uk>
In-Reply-To: <4CEDB53E.5000203@cn.fujitsu.com>
References: <20101124212333.808256210@goodmis.org>
	 <20101124212717.468748477@goodmis.org>  <4CEDB53E.5000203@cn.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Wed, 24 Nov 2010 20:17:26 -0500
Message-ID: <1290647846.30543.707.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-11-25 at 09:00 +0800, Li Zefan wrote:
> Cc: Richard Kennedy <richard@rsk.demon.co.uk>
> 
> Steven Rostedt wrote:
> > From: Steven Rostedt <srostedt@redhat.com>
> > 
> > The tracepoint for kmalloc is in the slub inlined code which causes
> > every instance of kmalloc to have the tracepoint.
> > 
> > This patch moves the tracepoint out of the inline code to the
> > slub C file (and to page_alloc), which removes a large number of
> > inlined trace points.
> > 
> >   objdump -dr vmlinux.slub| grep 'jmpq.*<trace_kmalloc' |wc -l
> > 375
> >   objdump -dr vmlinux.slub.patched| grep 'jmpq.*<trace_kmalloc' |wc -l
> > 2
> > 
> > This also has a nice impact on size.
> >    text	   data	    bss	    dec	    hex	filename
> > 7050424	1961068	2482688	11494180	 af6324	vmlinux.slub
> > 6979599	1944620	2482688	11406907	 ae0e3b	vmlinux.slub.patched
> > 
> > Siged-off-by: Steven Rostedt <rostedt@goodmis.org>
> 
> See this patch from Richard: :)
> 
> http://marc.info/?l=linux-kernel&m=128765337729262&w=2
> 
> But he only touched slub.

Hehe, and I forgot about it ;-) I notice the large number of kmalloc
tracepoints while analyzing the jump label code, and wanted to do
something about it.

I also see that Pekka replied saying that he applied it.

Pekka, want to take my first patch?

-- Steve



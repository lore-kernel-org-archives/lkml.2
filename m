Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757381Ab0GNWm2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Jul 2010 18:42:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:56435 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754133Ab0GNWm1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Jul 2010 18:42:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=N71sLWGf1kx9cHjulx4Qy1nfv4yVCQCoywMMPlDLOvet0PTSsrk5WGEDITWwhqgTld
         471nq9LFAGcZAOGwPHU2yVIPdUx2LuwBTL9SbPJDdgh4fx8MRnJ8M5IYlyEBh74uWOok
         hc0BcTX3izWgmmXWR8s5q1UbmiOP3MkRFEupY=
Date: Thu, 15 Jul 2010 00:31:19 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>, Tejun Heo <htejun@gmail.com>
Subject: Re: [patch 1/2] x86_64 page fault NMI-safe
Message-ID: <20100714223116.GB14533@nowhere>
References: <20100714154923.947138065@efficios.com> <20100714155804.049012415@efficios.com> <AANLkTiml2uwYqQayTKjMN2gI3LnjVFpwxXkv8GN3McEE@mail.gmail.com> <20100714170617.GB4955@Krystal> <AANLkTinLB3gQNKFk9QRfBS8YEfxL3qxZDFw7vWHDOnmL@mail.gmail.com> <20100714184642.GA9728@elte.hu> <AANLkTil2r3sUcoCC_ktp3TV2JNTSMxbpke8yJMx_8lmm@mail.gmail.com> <AANLkTinfmoKvi1SauDA5_RiTmu6bztTDk8b_ycS-lr8S@mail.gmail.com> <20100714195617.GC22373@basil.fritz.box> <20100714200552.GA22096@Krystal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100714200552.GA22096@Krystal>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 14, 2010 at 04:05:52PM -0400, Mathieu Desnoyers wrote:
> * Andi Kleen (andi@firstfloor.org) wrote:
> > > or similar. Wouldn't that be nice to have as a capability?
> > 
> > It means the NMI watchdog would get useless if these areas
> > become common.
> > 
> > Again I suspect all of this is not really needed anyways if 
> > vmalloc_sync_all() works properly. That would solve the original
> > problem Mathieu was trying to solve for per_cpu data. The rule
> > would be just to call vmalloc_sync_all() properly when changing
> > per CPU data too.
> 
> Yep, that would solve the page fault in nmi problem altogether without adding
> complexity.
> 
> > 
> > In fact I'm pretty sure it worked originally. Perhaps it regressed?
> 
> I'd first ask the obvious to Perf authors: does perf issue vmalloc_sync_all()
> between percpu data allocation and tracing activation ? The generic ring buffer
> library I posted last week does it already as a precaution for this very
> specific reason (making sure NMIs never trigger page faults).


Ok, I should try.

Until now I didn't because I clearly misunderstand the vmalloc internals. I'm
not even quite sure why a memory allocated with vmalloc sometimes can be not
mapped (and then fault once for this to sync). Some people have tried to explain
me but the picture is still vague to me.

And moreover, I'm not quite sure whether vmalloc_sync_all() syncs the pgd
for every tasks or so... Tejun seemed to say it's not necessary the case in
x86-32... Again I think I haven't totally understood the details.

Thanks.


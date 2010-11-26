Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753551Ab0KZHwj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 02:52:39 -0500
Received: from mx3.mail.elte.hu ([157.181.1.138]:53162 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753186Ab0KZHwi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 02:52:38 -0500
Date: Fri, 26 Nov 2010 08:51:58 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Kees Cook <kees.cook@canonical.com>
Cc: Kyle McMartin <kyle@mcmartin.ca>, Marcus Meissner <meissner@suse.de>,
        torvalds@linux-foundation.org, linux-kernel@vger.kernel.org,
        tj@kernel.org, akpm@osdl.org, hpa@zytor.com, w@1wt.eu,
        alan@lxorguk.ukuu.org.uk, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] kernel: make /proc/kallsyms mode 400 to reduce ease of
 attacking
Message-ID: <20101126075158.GE19589@elte.hu>
References: <20101116104600.GA24015@suse.de>
 <20101117050759.GE22651@bombadil.infradead.org>
 <20101118074804.GC32621@elte.hu>
 <20101120031820.GC4617@outflux.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101120031820.GC4617@outflux.net>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Kees Cook <kees.cook@canonical.com> wrote:

> On Thu, Nov 18, 2010 at 08:48:04AM +0100, Ingo Molnar wrote:
> > Agreed. A few other kernel address things that should be hidden are:
> > [snip]
> 
> For reference, here's what GRKERNSEC_HIDESYM looks like in grsecurity.
> It's quite a sledgehammer, but it does help to point out at least the
> minimum number of things that need fixing.

Yeah, it's a somewhat disgusting patch - but it also looks useful.

It would be more palatable for upstream if it was:

 - split up

 - if all those GRKERNSEC_HIDESYM #ifdefs were removed, either by making the 
   grsecurity defaults the default behavior, or by intelligently hiding it behinds 
   wrappers.

I'd suggest a single CONFIG_LEGACY_SYMBOLS=y config option for this, but only used 
to show those symbols that are absolutely needed for compatibility - like 
/proc/kallsyms. (Newer distros could disable this option and the kernel could 
eventually default to it being disabled as well.)

Also, while changing hexa output to symbolic output is fine, changing the oops 
output is borderline - that is an absolutely useful piece of information that helps 
us in decoding crashes. So i'd suggest to split that into a super-paranoid option or 
so.

Anyway, after a split-up we'll see how good the individual bits are - it's a bit of 
a mixed bag right now.

Thanks,

	Ingo

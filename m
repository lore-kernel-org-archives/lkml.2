Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756339Ab2EWQ3r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 12:29:47 -0400
Received: from merlin.infradead.org ([205.233.59.134]:41528 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751369Ab2EWQ3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 12:29:44 -0400
Subject: Re: [tip:x86/mce] x86/bitops: Move BIT_64() for a wider use
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Borislav Petkov <borislav.petkov@amd.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, frank.arnold@amd.com,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, linux-tip-commits@vger.kernel.org
In-Reply-To: <20120523161932.GN14757@aftab.osrc.amd.com>
References: <1337684026-19740-1-git-send-email-bp@amd64.org>
	 <tip-e8f380e00840f694599e6ab42806639f7de26f11@git.kernel.org>
	 <1337789429.9783.16.camel@laptop> <4FBD0C47.70600@zytor.com>
	 <20120523161932.GN14757@aftab.osrc.amd.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 23 May 2012 18:29:31 +0200
Message-ID: <1337790571.9783.28.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-23 at 18:19 +0200, Borislav Petkov wrote:
> On Wed, May 23, 2012 at 09:11:51AM -0700, H. Peter Anvin wrote:
> > On 05/23/2012 09:10 AM, Peter Zijlstra wrote:
> > > On Wed, 2012-05-23 at 09:07 -0700, tip-bot for Borislav Petkov wrote:
> > >> +#define BIT_64(n)                      (U64_C(1) << (n))
> > > 
> > > Because writing 1ULL << n is too much work? 
> > > 
> > 
> > Because writing 1ULL << n is broken in anything that needs to be used in
> > assembly, for example.
> 
> Actually we need a BIT() macro that works both
> on 32- and 64-bit. But that won't be that easy:
> http://lkml.indiana.edu/hypermail/linux/kernel/1010.1/02335.html
> 
> And it should return UL for shift values < 32 and ULL otherwise.

If I remember my type rules correctly you'll get something like that
with:

#define BIT(n)	({ typeof(n) __n = (n); (__n < 32) ? (1UL << __n) : (1ULL << __n); })

That said, having it do this might be unexpected, also hpa mentioned
something about assembly magics which will obviously not work with the
above either.

Anyway, ignore me, I just thought the BIT_64() thing looked funny, but
apparently there's good reasons for it.


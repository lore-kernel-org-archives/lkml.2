Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756111Ab0JODED (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 23:04:03 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:36536 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755644Ab0JODEB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 23:04:01 -0400
Date: Fri, 15 Oct 2010 05:03:36 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-ID: <20101015030336.GB9640@elte.hu>
References: <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>
 <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
 <4CB688F4.9040706@zytor.com>
 <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>
 <4CB7240E.9000905@zytor.com>
 <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
 <4CB7418C.7010505@zytor.com>
 <20101014183448.GA3187@elte.hu>
 <20101014123511.d628f873.akpm@linux-foundation.org>
 <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1bdcb8fa-d858-4a79-ae28-de8c94d13f5f@email.android.com>
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


* H. Peter Anvin <hpa@zytor.com> wrote:

> I don't like the CONFIG_EXPERT prefix, just because it makes it hard 
> to move things into and out of this rubric, and that's bad... 

Hm, i'm not sure i agree.

> (consider: "oh, that would mean this *huge* patch) ...

If config options are present in many places in the source that's an 
independent problem already.

Typically kconfig variables are used in a few places and any rename 
patch makes it clear in all those places what happened: either a config 
variable became obscure (moved into CONFIG_EXPERT's scope), *or* a 
config variable became much less obscure (moved out of that scope) - 
both important pieces of information, which i dont mind to see happen in 
every place that gets affected.

Put differently: if we have a CONFIG_EXPERT_ kconfig variable in so many 
places in the kernel that it creates a huge patch then we have some 
other kind of problem: it either should not be an expert option (it's 
too common or too important), or it should not be an option at all (it's 
a perpetual build failure risk).

Also, historically we have not been moving kconfig variables in and out 
of CONFIG_EMBEDDED all that often for this to be an issue in the future.

> [...] not to mention that what is CONFIG_EXPERT on one platform may 
> not be for another! [...]

Dunno, that i'd consider more of a bug. If an architecture absolutely 
needs to configure in or out a kernel feature then it should not be 
under CONFIG_EXPERT on other architectures either: it only sets us up 
for cross-arch build failures if say the CONFIG_EXPERT dependency is 
present on x86.

Or, if an architecture still wants it that way, it better be explicitly 
aware that it's configuring in a little-tested kconfig switch of the 
kerenl.

I.e. something being an 'expert option' is synonymous with obscurity and 
potential weirdness on at least one arch - which i dont see as 
inherently wrong to be visible (via the name) on other architectures 
either.

Thanks,

	Ingo

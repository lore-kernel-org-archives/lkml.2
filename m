Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755934Ab0JNSfQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 14:35:16 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:54681 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754807Ab0JNSfO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 14:35:14 -0400
Date: Thu, 14 Oct 2010 20:34:48 +0200
From: Ingo Molnar <mingo@elte.hu>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>,
        Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Casey Dahlin <cdahlin@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [patch] x86: allow ZONE_DMA to be configurable
Message-ID: <20101014183448.GA3187@elte.hu>
References: <alpine.DEB.2.00.1010131739010.27124@chino.kir.corp.google.com>
 <4CB65262.3070507@zytor.com>
 <alpine.DEB.2.00.1010131744540.27124@chino.kir.corp.google.com>
 <cbd8b37e-a1a3-4275-8acb-a76476211366@email.android.com>
 <alpine.DEB.2.00.1010131832400.794@chino.kir.corp.google.com>
 <4CB688F4.9040706@zytor.com>
 <alpine.DEB.2.00.1010132140550.20995@chino.kir.corp.google.com>
 <4CB7240E.9000905@zytor.com>
 <AANLkTin-VOKXe6wcwt_r3bLcS6=WYJ4EAPPUZWLbEGQF@mail.gmail.com>
 <4CB7418C.7010505@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB7418C.7010505@zytor.com>
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

> On 10/14/2010 09:00 AM, Pekka Enberg wrote:
>
> >> CONFIG_EMBEDDED *is* "I am a user who (think I) know what I'm 
> >> doing". That is *what it is* and *all it is*.
> > 
> > Yup. The naming is quite unfortunate, though. Can we change it to 
> > something else?
> 
> Funny, this seems to come up repeatedly ;)

I'd suggest to rename CONFIG_EMBEDDED=y to CONFIG_EXPERT=y, but i'd also 
suggest to rename all sub-config-options that depend on CONFIG_EXPERT to 
have a CONFIG_EXPERT_ prefix.

So we'd have:

  CONFIG_EXPERT_CPU_SUP_INTEL=y
  CONFIG_EXPERT_MMAP_ALLOW_UNINITIALIZED=y

etc.

That way all the enabled 'expert options' become easily visible in the 
.config file and they advertise themselves properly - it's also easily 
greppable. In the source code it also becomes self-documenting, it's 
obvious when a dependency is 'rare' or 'special' - it has a 
CONFIG_EXPERT_ prefix.

Something for the KS i guess.

Thanks,

	Ingo

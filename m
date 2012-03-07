Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757401Ab2CGNkG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 08:40:06 -0500
Received: from mx2.mail.elte.hu ([157.181.151.9]:58550 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755786Ab2CGNkE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 08:40:04 -0500
Date: Wed, 7 Mar 2012 14:39:37 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Alex Shi <alex.shi@intel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, gcc@gcc.gnu.org, tglx@linutronix.de,
        "mingo@redhat.com" <mingo@redhat.com>, hpa@zytor.com,
        akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        x86@kernel.org, andi.kleen@intel.com, gcc-help@gcc.gnu.org
Subject: Re: [RFC patch] spindep: add cross cache lines checking
Message-ID: <20120307133937.GB12676@elte.hu>
References: <1330917630.18835.44.camel@debian>
 <201203060932.45223.arnd@arndb.de>
 <1331108607.18835.343.camel@debian>
 <201203071154.36059.arnd@arndb.de>
 <4F575F09.3010107@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F575F09.3010107@intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
 -2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
                             [score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Alex Shi <alex.shi@intel.com> wrote:

> > I think the check should be (__alignof__(lock) < 
> > __alignof__(rwlock_t)), otherwise it will still pass when 
> > you have structure with attribute((packed,aligned(2)))
> 
> reasonable!
> 
> >> 1, it is alignof bug for default gcc on my fc15 and Ubuntu 11.10 etc?
> >>
> >> struct sub {
> >>         int  raw_lock;
> >>         char a;
> >> };
> >> struct foo {
> >>         struct sub z;
> >>         int slk;
> >>         char y;
> >> }__attribute__((packed));
> >>
> >> struct foo f1;
> >>
> >> __alignof__(f1.z.raw_lock) is 4, but its address actually can align on
> >> one byte. 
> > 
> > That looks like correct behavior, because the alignment of 
> > raw_lock inside of struct sub is still 4. But it does mean 
> > that there can be cases where the compile-time check is not 
> > sufficient, so we might want the run-time check as well, at 
> > least under some config option.
> 
> what's your opinion of this, Ingo?

Dunno. How many real bugs have you found via this patch?

Thanks,

	Ingo

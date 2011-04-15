Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab1DONRK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 09:17:10 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:33267 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753579Ab1DONRI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 09:17:08 -0400
Date: Fri, 15 Apr 2011 15:16:50 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Joerg Roedel <joro@8bytes.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
        Alex Deucher <alexdeucher@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        alexandre.f.demers@gmail.com
Subject: Re: Linux 2.6.39-rc3
Message-ID: <20110415131650.GB18660@elte.hu>
References: <4DA5F62F.3030504@kernel.org>
 <20110413193459.GL19819@8bytes.org>
 <4DA60C30.4060606@kernel.org>
 <BANLkTik7W0u92n_s0t32dsoLULu4QTZneA@mail.gmail.com>
 <4DA6145D.9070703@kernel.org>
 <BANLkTinud+4nUkZtnYRrU_gAFaMDWRa_AA@mail.gmail.com>
 <4DA655E7.3000904@zytor.com>
 <BANLkTimqR_M5keMqr5WAuz-t+1BkCZbwCg@mail.gmail.com>
 <BANLkTincU4rM+SqhzGOK_Rgxgg8fqJOOdQ@mail.gmail.com>
 <20110415131152.GJ18463@8bytes.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110415131152.GJ18463@8bytes.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
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


* Joerg Roedel <joro@8bytes.org> wrote:

> On Wed, Apr 13, 2011 at 07:33:40PM -0700, Linus Torvalds wrote:
> >  we definitely want to also understand the reason for things not
> > working, even if we do revert..
> 
> Okay, here it is.
> 
> After experimenting with different configurations for the north-bridge
> it turned out that a GART related MCE fires at the time the machine
> reboots. BIOSes configure the machine to sync-flood in that case which
> causes a reboot.
> 
> After decoding the MCE it turned out to be a GART TBL Wlk Error. Such
> errors can happen if devices (speculativly) access GART ranges mapped
> invalid. The AMD BKDG for Fam10h CPUs recommends to disable these errors
> at all. But unfortunatly some BIOSes (including the one on my laptop)
> forget to do this.
> 
> Below is a patch which disables these errors if the BIOS didn't do it.
> It fixes the problem on my site.

Ok, but how did the allocation changes start triggering this error in 
v2.6.39-rc1? There must still be some layout specific thing here, right?
Do we understand the details of that as well?

Thanks,

	Ingo

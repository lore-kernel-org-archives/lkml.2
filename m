Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752832Ab1HXXNl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 19:13:41 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:35967 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752791Ab1HXXNj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 19:13:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: try_to_freeze() called with IRQs disabled on ARM
Date: Thu, 25 Aug 2011 01:15:25 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: "Russell King - ARM Linux" <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <20110823151936.GM9232@opensource.wolfsonmicro.com> <CAOS58YNtQEuke=Ko9J2oNGMECjabzxj=Nrg1o64X1JC3YRmJuw@mail.gmail.com> <20110823223518.GI2803@mtj.dyndns.org>
In-Reply-To: <20110823223518.GI2803@mtj.dyndns.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201108250115.25987.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, August 24, 2011, Tejun Heo wrote:
> On Wed, Aug 24, 2011 at 12:17:03AM +0200, Tejun Heo wrote:
> > if (freezing() && IRQ disabled) {
> >       bust on IRQ;
> >       try_to_freeze();
> >       replug IRQ;
> > }
> > 
> > But, that can't be right. The current code isn't triggering warning
> > from scheduler code, right? If the above is the case, it should be
> > triggering that. What am I missing?
> 
> I think the refrigerator() code was actually doing that through
> spin_[un]lock_irq(), so it was accidentally masking the problem.  It
> definitely seems to need fixing.
> 
> Anyways, for now, we can do two things,
> 
> 1. if (freezing()) { irq_save; try_to_freeze(); irq_restore; } w/ BIG
>    FAT UGLY comment.
> 
> 2. Drop might_sleep() from try_to_freeze().  Moving it to
>    refrigerator() wouldn't help much.  It would just trigger more
>    sporadically during freeze, which is arguably worse than now.
> 
> I'd prefer #1 given that it documents the breakage while also
> restoring the IRQ state afterwards FWIW.

OK, I'm fine with 1.

Thanks,
Rafael

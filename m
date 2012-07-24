Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756044Ab2GXS6a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jul 2012 14:58:30 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:59245 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755506Ab2GXS62 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jul 2012 14:58:28 -0400
Date: Tue, 24 Jul 2012 19:58:26 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sven Neumann <s.neumann@raumfeld.com>, Olof Johansson <olof@lixom.net>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Eric Miao <eric.y.miao@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: Emulating level IRQs (was: Re: [PATCH] Input: eeti_ts: Mark as
 CONFIG_BROKEN)
Message-ID: <20120724185825.GA32169@sirena.org.uk>
References: <1333777207-4151-1-git-send-email-olof@lixom.net>
 <20120407070206.GA17623@core.coreip.homeip.net>
 <4F8089A9.6080704@raumfeld.com>
 <20120503043651.GA11830@core.coreip.homeip.net>
 <20120713070102.GA2223@core.coreip.homeip.net>
 <500561AF.9090901@gmail.com>
 <5008296C.5070709@gmail.com>
 <20120723165120.GB26577@core.coreip.homeip.net>
 <500EE314.7040708@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <500EE314.7040708@gmail.com>
X-Cookie: A rolling stone gathers momentum.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 24, 2012 at 08:01:56PM +0200, Daniel Mack wrote:
> On 23.07.2012 18:51, Dmitry Torokhov wrote:

> > Hmm, but that would mean we need to restore reading the data in open()
> > to make sure we re-arm IRQ in case somebody touched the screen before it
> > was opened by userspace...

> I had another look at this and don't really know what to do here. We
> definitely need level interrupts for this device as the interrupt line's
> level is the only that tells us when we can stop reading from the
> device. So it's not just the start condition that bites us here.

> I copied some people that might help find a solution.

I've raised the same issue myself, it's fairly common.

> So it boils down to the question: Is there any easy and generic way to
> emulate level irq on chips that don't support that natively?

Nothing in core.  The nearest thing is to poll until you run out of work
(which is rude but survivable for threaded IRQs that don't assert too
much), ideally just reusing the level IRQ if it can report IRQ_NONE.

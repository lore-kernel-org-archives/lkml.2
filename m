Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753505Ab0L1N76 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 08:59:58 -0500
Received: from na3sys009aog107.obsmtp.com ([74.125.149.197]:52465 "EHLO
	na3sys009aog107.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752156Ab0L1N74 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 08:59:56 -0500
From: Felipe Balbi <balbi@ti.com>
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Cc: Tony Lindgren <tony@atomide.com>, David Brownell <david-b@pacbell.net>,
        Thomas Gleixner <tglx@linutronix.de>, Felipe Balbi <balbi@ti.com>
Subject: [RFC/PATCH 0/2] Move twl*-irq.c to threaded_irq infrastructure
Date: Tue, 28 Dec 2010 15:59:48 +0200
Message-Id: <1293544790-793-1-git-send-email-balbi@ti.com>
X-Mailer: git-send-email 1.7.3.4.598.g85356
Organization: Texas Instruments\n
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

This is truly untested. I only compile tested thus far
as I'm not sure it's the right path. It looks like that's
what's supposed to be done, but I wanted to check with you
guys before going any further.

In a few minutes, I'll be starting to test these two
patches and will try to find any possible errors with them
but, please, give it a good review as IMO it's a rather
invasive change.

Thomas, I've got one extra question for you. I remember
reading you suggested all drivers should actually try
to use threaded IRQ infrastructure for handling the IRQ
and the hardirq handler would only check if the IRQ
is coming from this device. Is that how you expect
theaded IRQ to be used ? What's the purpose ?

Please, correct me if I'm wrong, but I came to the
conclusion that threaded IRQs can be reniced and
preempted which would mean we could be setting IRQ
priorities from userland and we could also be running
N IRQ threads if we have N cpu cores. Is that correct ?
Is that your goal ?

I tried searching for some more documentation on
the threaded IRQ infrastructure but couldn't find
much by grepping Documentation/ maybe my match string
wasn't good enough. Anyway, let me know what are your
feeling about the following two patches and what would
be your goal should we move all IRQ handlers to threaded
IRQ infrastructure as I remember you suggested.

Happy new year all.

Felipe Balbi (2):
  mfd: twl6030-irq: move to threaded_irq
  mfd: twl4030-irq: move to threaded_irq

 drivers/mfd/twl4030-irq.c |  133 +++++++++++++-----------------------------
 drivers/mfd/twl6030-irq.c |  141 ++++++++++++++++-----------------------------
 2 files changed, 91 insertions(+), 183 deletions(-)

-- 
1.7.3.4.598.g85356


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab2JPT2J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 15:28:09 -0400
Received: from mail.df.lth.se ([194.47.250.12]:44875 "EHLO mail.df.lth.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755838Ab2JPT2H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 15:28:07 -0400
X-Greylist: delayed 360 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 15:28:07 EDT
From: Linus Walleij <linus.walleij@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@linaro.org>
Subject: [PATCH 0/7] gpio: assorted irqdomain cleanups
Date: Tue, 16 Oct 2012 21:21:55 +0200
Message-Id: <1350415315-2451-1-git-send-email-linus.walleij@linaro.org>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have noted that some of the GPIO drivers have been copy-pasting
and contaminating each other with bad examples, so I've tried in
this series to mitigate this by correcting the most obvious
examples.

I have no clue how to even compile-test some of these, so I rely
on maintainers to test them and maybe refactor them up if they are
sucky.

Remains: gpio-omap, gpio-pxa and gpio-twl4030.

These three drivers do *REALLY* scary stuff, like creating domains
and flat out ignoring to use them, keeping the irq_base after
allocating descriptors around and abusing it etc. I would really
like to see these fixed up to use irqdomains properly. The
twl4030 looks really hairy with the IRQ handling centralized
into the main MFD driver...

Linus Walleij (7):
  gpio/tc3589x: convert to use the simple irqdomain
  gpio/em: convert to linear IRQ domain
  gpio/mvebu: convert to use irq_domain_add_simple()
  gpio/mxs: convert to use linear irqdomain
  gpio/pcf857x: find the irq domain mapping
  gpio/langwell: find the irq domain mapping
  gpio/tegra: convert to use linear irqdomain

 drivers/gpio/gpio-em.c       | 22 +++-------------------
 drivers/gpio/gpio-langwell.c |  2 +-
 drivers/gpio/gpio-mvebu.c    |  6 +++---
 drivers/gpio/gpio-mxs.c      | 19 ++++++-------------
 drivers/gpio/gpio-pcf857x.c  |  2 +-
 drivers/gpio/gpio-tc3589x.c  | 14 +++-----------
 drivers/gpio/gpio-tegra.c    | 12 ++++--------
 7 files changed, 21 insertions(+), 56 deletions(-)

-- 
1.7.11.7


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757729Ab2JKJQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 05:16:11 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:60632 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755600Ab2JKJQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 05:16:04 -0400
MIME-Version: 1.0
Date: Thu, 11 Oct 2012 11:16:03 +0200
Message-ID: <CACRpkdYAOfaDi7GscPX6nBH=t=hbOdN7=n=vVD_ayYFwdRmcJA@mail.gmail.com>
Subject: [GIT PULL] late pinctrl patches for v3.7
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Thomas Gleixner <tglx@linutronix.de>, Lee Jones <lee.jones@linaro.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

here is a late pinctrl pull request with stuff that wasn't quite
tested at the first
pull request.

The main reason to not hold off is that the modifications to
irq_domain_add_simple()
as reviewed by Rob Herring introduce new infrastructure for irqdomains that will
be useful for the next cycle: instead of sprinkling irq descriptor
allocation all over
the kernel wherever a "legacy" domain is registered, which is necessary for any
platform using sparse IRQs, and many irq chips are say GPIO controllers which
may be used with several systems, some with sparse IRQs some not, we
push this into the irq_domain_add_simple() so we can atleast do mistakes in
one place.

The irq_domain_add_simple() is currently unused in the kernel, so I need to
provide a user. The Nomadik stuff that goes with are changes to the driver I use
day-to-day to make use of this facility (and a dependency), so see it
as a way to
eat my own dogfood: if this blows up the egg hits my face.

Please pull it in!
Linus Walleij

The following changes since commit 547b1e81afe3119f7daf702cc03b158495535a25:

  Fix staging driver use of VM_RESERVED (2012-10-09 21:06:41 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/linusw/linux-pinctrl.git
tags/pinctrl-for-3.7-late

for you to fetch changes up to 6054b9cae24f7ff09e502cea408dad140210681a:

  pinctrl/nomadik: use simple or linear IRQ domain (2012-10-10 08:57:26 +0200)

----------------------------------------------------------------
A second round of pinctrl patches for v3.7:
- Complement the Nomadik pinctrl driver with alternate Cx functions
  so it handles all oddities.
- A patch to the IRQdomain to reform the simple irqdomain to handle
  IRQ descriptor allocation dynamically.
- Use the above feature in the Nomadik pin controller.

----------------------------------------------------------------
Jean-Nicolas Graux (1):
      pinctrl/nomadik: support other alternate-C functions

Linus Walleij (2):
      irqdomain: augment add_simple() to allocate descs
      pinctrl/nomadik: use simple or linear IRQ domain

 arch/arm/plat-nomadik/include/plat/gpio-nomadik.h |   6 +
 arch/arm/plat-nomadik/include/plat/pincfg.h       |   2 +
 drivers/pinctrl/pinctrl-nomadik-db8500.c          | 289 +++++++++++++++++-
 drivers/pinctrl/pinctrl-nomadik-db8540.c          | 344 +++++++++++++++++++---
 drivers/pinctrl/pinctrl-nomadik.c                 | 117 +++++++-
 drivers/pinctrl/pinctrl-nomadik.h                 |  78 +++++
 kernel/irq/irqdomain.c                            |  33 ++-
 7 files changed, 814 insertions(+), 55 deletions(-)

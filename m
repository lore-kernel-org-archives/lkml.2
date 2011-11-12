Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756425Ab1KLBu2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Nov 2011 20:50:28 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54426 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab1KLBu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Nov 2011 20:50:26 -0500
From: ddaney.cavm@gmail.com
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        devicetree-discuss@lists.ozlabs.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org, rob.herring@calxeda.com,
        tglx@linutronix.de, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
Cc: David Daney <david.daney@cavium.com>
Subject: [PATCH 0/2] irq/of: Enchance irq_domain support.
Date: Fri, 11 Nov 2011 17:50:14 -0800
Message-Id: <1321062616-28317-1-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

This is the first cut at hooking up my Octeon port to the irq_domain things.

The Octeon specific patches are part of a larger set, and will need to
be applied with that set, the first patch is stand-alone.

The basic problem being solved taken from one of my other e-mails:

   Unfortunately, although a good idea, kernel/irq/irqdomain.c makes a
   bunch of assumptions that don't hold for Octeon.  We may be able to
   improve it so that it flexible enough to suit us.


   Here are the problems I see:

   1) It is assumed that there is some sort of linear correspondence
   between 'hwirq' and 'irq', and that the range of valid values is
   contiguous.

   2) It is assumed that the concepts of nr_irq, irq_base and
   hwirq_base have easy to determine values and you can do iteration
   over their ranges by adding indexes to the bases.


David Daney (2):
  irq/of/ARM: Enhance irq iteration capability of irq_domain code.
  MIPS: Octeon: Add irq_create_of_mapping() and GPIO interrupts.

 arch/arm/common/gic.c                |   32 +++--
 arch/mips/Kconfig                    |    1 +
 arch/mips/cavium-octeon/octeon-irq.c |  279 +++++++++++++++++++++++++++++++++-
 include/linux/irqdomain.h            |   29 +++-
 kernel/irq/irqdomain.c               |   97 +++++++++---
 5 files changed, 390 insertions(+), 48 deletions(-)

-- 
1.7.2.3


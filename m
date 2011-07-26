Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab1GZJgn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 05:36:43 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:44665 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711Ab1GZJgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 05:36:39 -0400
Subject: [PATCH v3 0/2] Simple irq_domain implementation
To: devicetree-discuss@lists.ozlabs.org, tglx@linutronix.de,
        linux@arm.linux.org.uk, linux-kernel@vger.kernel.org
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 26 Jul 2011 03:36:36 -0600
Message-ID: <20110726093141.12508.48108.stgit@ponder>
User-Agent: StGit/0.15
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the interest of getting this infrastructure merged, I've reworked the
basic irq_domain patch to implement only what is required for ARM device
tree board support.  That means it doesn't affect any architectures other
than ARM, and I'll send follow-on patches targeted at v3.2 to migrate
MIPS, Microblaze, x86 embedded and PowerPC over to it.

Thomas, can you please take a look?  I've got devicetree board support
queued up and ready to be merged but for this infrastructure.

g.

---

Grant Likely (2):
      irq: add irq_domain translation infrastructure
      dt/irq: add irq_domain_generate_simple() helper


 arch/arm/Kconfig            |    1 
 arch/arm/include/asm/prom.h |    5 -
 arch/arm/kernel/devtree.c   |   14 ---
 include/linux/irq.h         |    6 +
 include/linux/irqdomain.h   |   93 ++++++++++++++++++++++
 include/linux/of_irq.h      |    4 +
 kernel/irq/Kconfig          |    4 +
 kernel/irq/Makefile         |    1 
 kernel/irq/irqdomain.c      |  180 +++++++++++++++++++++++++++++++++++++++++++
 9 files changed, 289 insertions(+), 19 deletions(-)
 create mode 100644 include/linux/irqdomain.h
 create mode 100644 kernel/irq/irqdomain.c

-- 
Signature

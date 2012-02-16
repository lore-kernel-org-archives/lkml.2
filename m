Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932397Ab2BPJL7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 04:11:59 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:63358 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2BPJJr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 04:09:47 -0500
MIME-Version: 1.0
From: Grant Likely <grant.likely@secretlab.ca>
To: linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Milton Miller <miltonm@bga.com>,
        Rob Herring <rob.herring@calxeda.com>
Cc: Grant Likely <grant.likely@secretlab.ca>, Mark Salter <msalter@redhat.com>
Subject: [PATCH v5 20/27] irq_domain/c6x: constify irq_domain structures
Date: Thu, 16 Feb 2012 02:09:21 -0700
Message-Id: <1329383368-12122-21-git-send-email-grant.likely@secretlab.ca>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
References: <1329383368-12122-1-git-send-email-grant.likely@secretlab.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Salter <msalter@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/arm/common/gic.c            |    2 +-
 arch/c6x/kernel/irq.c            |    2 +-
 arch/c6x/platforms/megamod-pic.c |    2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm/common/gic.c b/arch/arm/common/gic.c
index 7275d80..f0783be 100644
--- a/arch/arm/common/gic.c
+++ b/arch/arm/common/gic.c
@@ -635,7 +635,7 @@ static int gic_irq_domain_xlate(struct irq_domain *d,
 	return 0;
 }
 
-struct irq_domain_ops gic_irq_domain_ops = {
+const struct irq_domain_ops gic_irq_domain_ops = {
 	.map = gic_irq_domain_map,
 	.xlate = gic_irq_domain_xlate,
 };
diff --git a/arch/c6x/kernel/irq.c b/arch/c6x/kernel/irq.c
index 3d5ac60..c6b36e8 100644
--- a/arch/c6x/kernel/irq.c
+++ b/arch/c6x/kernel/irq.c
@@ -86,7 +86,7 @@ static int core_domain_map(struct irq_domain *h, unsigned int virq,
 	return 0;
 }
 
-static struct irq_domain_ops core_domain_ops = {
+static const struct irq_domain_ops core_domain_ops = {
 	.map = core_domain_map,
 };
 
diff --git a/arch/c6x/platforms/megamod-pic.c b/arch/c6x/platforms/megamod-pic.c
index 61f5863..9f35fbf 100644
--- a/arch/c6x/platforms/megamod-pic.c
+++ b/arch/c6x/platforms/megamod-pic.c
@@ -148,7 +148,7 @@ static int megamod_xlate(struct irq_domain *h, struct device_node *ct,
 	return 0;
 }
 
-static struct irq_domain_ops megamod_domain_ops = {
+static const struct irq_domain_ops megamod_domain_ops = {
 	.map	= megamod_map,
 	.xlate	= megamod_xlate,
 };
-- 
1.7.9


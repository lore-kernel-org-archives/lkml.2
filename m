Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559Ab1HPR04 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 13:26:56 -0400
Received: from smtp2.caviumnetworks.com ([209.113.159.134]:9606 "EHLO
	smtp2.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751295Ab1HPR0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 13:26:55 -0400
X-Greylist: delayed 910 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Aug 2011 13:26:55 EDT
From: David Daney <david.daney@cavium.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: David Daney <david.daney@cavium.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH] staging: octeon-ethernet: Add missing #includes.
Date: Tue, 16 Aug 2011 10:10:56 -0700
Message-Id: <1313514656-24482-1-git-send-email-david.daney@cavium.com>
X-Mailer: git-send-email 1.7.2.3
X-OriginalArrivalTime: 16 Aug 2011 17:11:05.0727 (UTC) FILETIME=[7BD2C8F0:01CC5C37]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I looks like something used to implicitly include linux/interrupt.h,
and no longer does.  Fix the resulting build error by explicitly
including it.

Signed-off-by: David Daney <david.daney@cavium.com>
Cc: David S. Miller <davem@davemloft.net>
Cc: Greg Kroah-Hartman <gregkh@suse.de>
---

This could go via Ralf's linux-mips.org tree as Octeon is a MIPS
archecture SOC.  It would be nice to get in before the final 3.1 as it
is a build breaker.

 drivers/staging/octeon/ethernet-rgmii.c |    1 +
 drivers/staging/octeon/ethernet-spi.c   |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/octeon/ethernet-rgmii.c b/drivers/staging/octeon/ethernet-rgmii.c
index 9c0d293..c3d73f8 100644
--- a/drivers/staging/octeon/ethernet-rgmii.c
+++ b/drivers/staging/octeon/ethernet-rgmii.c
@@ -26,6 +26,7 @@
 **********************************************************************/
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/interrupt.h>
 #include <linux/phy.h>
 #include <linux/ratelimit.h>
 #include <net/dst.h>
diff --git a/drivers/staging/octeon/ethernet-spi.c b/drivers/staging/octeon/ethernet-spi.c
index 9708254..d0e2d51 100644
--- a/drivers/staging/octeon/ethernet-spi.c
+++ b/drivers/staging/octeon/ethernet-spi.c
@@ -26,6 +26,7 @@
 **********************************************************************/
 #include <linux/kernel.h>
 #include <linux/netdevice.h>
+#include <linux/interrupt.h>
 #include <net/dst.h>
 
 #include <asm/octeon/octeon.h>
-- 
1.7.2.3


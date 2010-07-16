Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759466Ab0GPXLc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 19:11:32 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:36917 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754185Ab0GPXLb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 19:11:31 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer;
        b=o7OS8y98/PlVPM6QZQUe6g5XDNQMDu6pDhdWaM4ivzugQOSxUG0mAKLev3b+uurJ+p
         sEXxy/XSb59R7UM62uJ2kvddPAdzPTcJrr7QsgRLFninlObxBtXvFxMAMjti1x+dOAP7
         JokHZyGcgkf89PWvuCsk/CfPNYE9ljyVyOgcw=
From: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Doug Thompson <dougthompson@xmission.com>,
        bluesmoke-devel@lists.sourceforge.net, stable@kernel.org
Subject: [PATCH] edac/Kconfig: reenable edac_mpc85xx on MPC85xx
Date: Sat, 17 Jul 2010 03:11:28 +0400
Message-Id: <1279321888-27335-1-git-send-email-dbaryshkov@gmail.com>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Somewhere after 2.6.32 MPC85xx got renamed to FSL_BOOKE (to include
QorIQ family of chips). However drivers/edac/Kconfig wasn't updated to
reflect this change. Fix it now.

Signed-off-by: Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>
Cc: stable@kernel.org
---
 drivers/edac/Kconfig |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index aedef79..2328c95 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -209,7 +209,7 @@ config EDAC_I5100
 
 config EDAC_MPC85XX
 	tristate "Freescale MPC83xx / MPC85xx"
-	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || MPC85xx)
+	depends on EDAC_MM_EDAC && FSL_SOC && (PPC_83xx || FSL_SOC_BOOKE)
 	help
 	  Support for error detection and correction on the Freescale
 	  MPC8349, MPC8560, MPC8540, MPC8548
-- 
1.7.1


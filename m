Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755651Ab2GaFC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 01:02:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:48656 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755497Ab2GaEu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 00:50:26 -0400
Message-Id: <20120731044321.292378788@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Tue, 31 Jul 2012 05:44:12 +0100
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Daniel Drake <dsd@laptop.org>,
        Chris Ball <cjb@laptop.org>
Subject: [ 62/73] mmc: sdhci-pci: CaFe has broken card detection
In-Reply-To: <20120731044310.013763753@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Drake <dsd@laptop.org>

commit 55fc05b7414274f17795cd0e8a3b1546f3649d5e upstream.

At http://dev.laptop.org/ticket/11980 we have determined that the
Marvell CaFe SDHCI controller reports bad card presence during
resume. It reports that no card is present even when it is.
This is a regression -- resume worked back around 2.6.37.

Around 400ms after resuming, a "card inserted" interrupt is
generated, at which point it starts reporting presence.

Work around this hardware oddity by setting the
SDHCI_QUIRK_BROKEN_CARD_DETECTION flag.
Thanks to Chris Ball for helping with diagnosis.

Signed-off-by: Daniel Drake <dsd@laptop.org>
[stable@: please apply to 3.0+]
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/mmc/host/sdhci-pci.c b/drivers/mmc/host/sdhci-pci.c
index 69ef0be..504da71 100644
--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -157,6 +157,7 @@ static const struct sdhci_pci_fixes sdhci_ene_714 = {
 static const struct sdhci_pci_fixes sdhci_cafe = {
 	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
 			  SDHCI_QUIRK_NO_BUSY_IRQ |
+			  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 



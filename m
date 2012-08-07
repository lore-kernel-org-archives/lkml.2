Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031012Ab2HGWp2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 18:45:28 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:53839 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030993Ab2HGWpV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 18:45:21 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Daniel Drake <dsd@laptop.org>, Chris Ball <cjb@laptop.org>
Subject: [ 01/49] mmc: sdhci-pci: CaFe has broken card detection
Date: Tue,  7 Aug 2012 15:44:19 -0700
Message-Id: <20120807222026.989016963@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120807222026.848194739@linuxfoundation.org>
References: <20120807222026.848194739@linuxfoundation.org>
User-Agent: quilt/0.60-20.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Chris Ball <cjb@laptop.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mmc/host/sdhci-pci.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mmc/host/sdhci-pci.c
+++ b/drivers/mmc/host/sdhci-pci.c
@@ -140,6 +140,7 @@ static const struct sdhci_pci_fixes sdhc
 static const struct sdhci_pci_fixes sdhci_cafe = {
 	.quirks		= SDHCI_QUIRK_NO_SIMULT_VDD_AND_POWER |
 			  SDHCI_QUIRK_NO_BUSY_IRQ |
+			  SDHCI_QUIRK_BROKEN_CARD_DETECTION |
 			  SDHCI_QUIRK_BROKEN_TIMEOUT_VAL,
 };
 



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756775Ab2J1XrB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Oct 2012 19:47:01 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:41901 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756547Ab2J1X1Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Oct 2012 19:27:24 -0400
Message-Id: <20121028231604.947653682@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Sun, 28 Oct 2012 23:17:06 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Anisse Astier <anisse@astier.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [ 090/105] ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS
 versions
In-Reply-To: <20121028231536.970033833@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:21c:bfff:fe03:f805
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit c323dc023b9501e5d09582ec7efd1d40a9001d99 upstream.

BIOS vendors keep changing the BIOS versions. Only match the beginning
of the string to match all Lucid tablets with board name M11JB.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/pci-quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/usb/host/pci-quirks.c b/drivers/usb/host/pci-quirks.c
index 966d148..ead4525 100644
--- a/drivers/usb/host/pci-quirks.c
+++ b/drivers/usb/host/pci-quirks.c
@@ -545,7 +545,7 @@ static const struct dmi_system_id __devinitconst ehci_dmi_nohandoff_table[] = {
 		/*  Pegatron Lucid (Ordissimo AIRIS) */
 		.matches = {
 			DMI_MATCH(DMI_BOARD_NAME, "M11JB"),
-			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-GE-133"),
+			DMI_MATCH(DMI_BIOS_VERSION, "Lucid-"),
 		},
 	},
 	{ }



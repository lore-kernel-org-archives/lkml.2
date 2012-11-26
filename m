Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934228Ab2KZRWL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 12:22:11 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:48251 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934145Ab2KZRPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 12:15:37 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Anisse Astier <anisse@astier.eu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 252/270] ehci: fix Lucid nohandoff pci quirk to be more generic with BIOS versions
Date: Mon, 26 Nov 2012 14:59:02 -0200
Message-Id: <1353949160-26803-253-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
References: <1353949160-26803-1-git-send-email-herton.krzesinski@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7u1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anisse Astier <anisse@astier.eu>

commit c323dc023b9501e5d09582ec7efd1d40a9001d99 upstream.

BIOS vendors keep changing the BIOS versions. Only match the beginning
of the string to match all Lucid tablets with board name M11JB.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
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
-- 
1.7.9.5


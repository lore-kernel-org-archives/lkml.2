Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753885Ab2JBOGk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 10:06:40 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:52224 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753133Ab2JBOGi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 10:06:38 -0400
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: [PATCH] x86: remove quirk entry for SBC FITPC
To: x86@kernel.org, linux-kernel@vger.kernel.org
Date: Tue, 02 Oct 2012 15:26:53 +0100
Message-ID: <20121002142635.17403.59959.stgit@localhost.localdomain>
User-Agent: StGIT/0.14.3
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Hooper <dave@beermex.com>

Remove the quirk for the SBC FITPC. It seems ot have been required when the
default was kbd reboot, but no longer required now that the default is acpi
reboot. Furthermore, BIOS reboot no longer works for this board as of
2.6.39 or any of the 3.x kernels.

Signed-off-by: David Hooper <dave@beermex.com>
Signed-off-by: Alan Cox <alan@linux.intel.com>
---

 arch/x86/kernel/reboot.c |    8 --------
 1 file changed, 8 deletions(-)

diff --git a/arch/x86/kernel/reboot.c b/arch/x86/kernel/reboot.c
index 52190a9..4e8ba39 100644
--- a/arch/x86/kernel/reboot.c
+++ b/arch/x86/kernel/reboot.c
@@ -358,14 +358,6 @@ static struct dmi_system_id __initdata reboot_dmi_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "VGN-Z540N"),
 		},
 	},
-	{	/* Handle problems with rebooting on CompuLab SBC-FITPC2 */
-		.callback = set_bios_reboot,
-		.ident = "CompuLab SBC-FITPC2",
-		.matches = {
-			DMI_MATCH(DMI_SYS_VENDOR, "CompuLab"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "SBC-FITPC2"),
-		},
-	},
 	{	/* Handle problems with rebooting on ASUS P4S800 */
 		.callback = set_bios_reboot,
 		.ident = "ASUS P4S800",


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932697Ab1IAW4j (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 18:56:39 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49240 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932686Ab1IAW4f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 18:56:35 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Thu Sep  1 15:53:30 2011
Message-Id: <20110901225330.690329529@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Thu, 01 Sep 2011 15:50:03 -0700
From: gregkh@suse.de
To: Matthew Garrett <mjg@redhat.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        greg@kroah.com, Stefan Beller <stefanbeller@googlemail.com>,
        stable <stable@kernel.org>
Subject: [patch 1/8] platform: samsung_laptop: add dmi information for Samsung R700 laptops
In-Reply-To: <20110901225401.GA26870@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

My DMI model is this:
>dmesg |grep DMI
[    0.000000] DMI present.
[    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. SR700/SR700, BIOS
04SR 02/20/2008

adding dmi information of Samsung R700 laptops
This adds the dmi information of Samsungs R700 laptops.

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
Cc: stable <stable@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -641,6 +641,15 @@ static struct dmi_system_id __initdata s
 		.callback = dmi_check_cb,
 	},
 	{
+		.ident = "R700",
+		.matches = {
+		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),
+		      DMI_MATCH(DMI_PRODUCT_NAME, "SR700"),
+		      DMI_MATCH(DMI_BOARD_NAME, "SR700"),
+		},
+		.callback = dmi_check_cb,
+	},
+	{
 		.ident = "R530/R730",
 		.matches = {
 		      DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD."),



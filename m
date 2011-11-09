Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934212Ab1KJDX1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 22:23:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:41928 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934162Ab1KJDXU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 22:23:20 -0500
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Nov  9 13:27:07 2011
Message-Id: <20111109212707.445228543@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 09 Nov 2011 13:26:32 -0800
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Stefan Beller <stefanbeller@googlemail.com>,
        Matthew Garrett <mjg@redhat.com>
Subject: [070/262] platform: samsung_laptop: add dmi information for Samsung R700 laptops
In-Reply-To: <20111109212847.GA20838@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stefan Beller <stefanbeller@googlemail.com>

commit f87d02996f05ec1789ceecce9ec839f629b7aa80 upstream.

My DMI model is this:
>dmesg |grep DMI
[    0.000000] DMI present.
[    0.000000] DMI: SAMSUNG ELECTRONICS CO., LTD. SR700/SR700, BIOS
04SR 02/20/2008

adding dmi information of Samsung R700 laptops
This adds the dmi information of Samsungs R700 laptops.

Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
Signed-off-by: Matthew Garrett <mjg@redhat.com>

---
 drivers/platform/x86/samsung-laptop.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/platform/x86/samsung-laptop.c
+++ b/drivers/platform/x86/samsung-laptop.c
@@ -631,6 +631,15 @@ static struct dmi_system_id __initdata s
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



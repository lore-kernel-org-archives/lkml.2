Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758146Ab1BKUsD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:48:03 -0500
Received: from adelie.canonical.com ([91.189.90.139]:34179 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758103Ab1BKUsA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:48:00 -0500
Message-ID: <4D55A07A.7050608@canonical.com>
Date: Fri, 11 Feb 2011 15:47:54 -0500
From: Ayan George <ayan.george@canonical.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] dell-laptop: add Dell Vostro 1520 to blacklist.
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dell-laptop module erroneously hard-blocks the wireless interface on
the Dell Vostro 1520.

All functionality (backlight, volume, physical wireless switch, &c)
is there without the dell-laptop module so this blacklists the
Dell Vostro 1520.

BugLink: http://bugs.launchpad.net/bugs/701259
Signed-off-by: Ayan George <ayan.george@canonical.com>
Cc: <stable@kernel.org>
---
 drivers/platform/x86/dell-laptop.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/dell-laptop.c
b/drivers/platform/x86/dell-lapt
op.c
index 34657f9..ed889a2 100644
--- a/drivers/platform/x86/dell-laptop.c
+++ b/drivers/platform/x86/dell-laptop.c
@@ -144,6 +144,13 @@ static struct dmi_system_id __devinitdata
dell_blacklist[]
= {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Inspiron 1210"),
 		},
 	},
+	{
+		.ident = "Dell Vostro 1520",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1520"),
+		},
+	},
 	{}
 };

-- 
1.7.1


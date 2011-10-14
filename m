Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756068Ab1JNJIv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:08:51 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:51990 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755731Ab1JNJIs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:48 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 5/8] asus-laptop: hide leds on Pegatron Lucid
Date: Fri, 14 Oct 2011 11:13:39 +0200
Message-Id: <1318583622-23518-6-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Corentin Chary <corentin.chary@gmail.com>

Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 7fe5aa5..168084e 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -629,6 +629,13 @@ static int asus_led_init(struct asus_laptop *asus)
 	int r;
 
 	/*
+	 * The Pegatron Lucid has no physical leds, but all methods are
+	 * available in the DSDT...
+	 */
+	if (asus->is_pega_lucid)
+		return 0;
+
+	/*
 	 * Functions that actually update the LED's are called from a
 	 * workqueue. By doing this as separate work rather than when the LED
 	 * subsystem asks, we avoid messing with the Asus ACPI stuff during a
-- 
1.7.3.4


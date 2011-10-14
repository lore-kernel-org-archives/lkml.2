Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932191Ab1JNJJA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 05:09:00 -0400
Received: from smtp5-g21.free.fr ([212.27.42.5]:52422 "EHLO smtp5-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756158Ab1JNJI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 05:08:57 -0400
From: Corentin Chary <corentincj@iksaif.net>
To: Matthew Garrett <mjg@redhat.com>
Cc: Anisse Astier <anisse@astier.eu>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andy Ross <andy.ross@windriver.com>,
        Corentin Chary <corentin.chary@gmail.com>
Subject: [PATCH 7/8] asus-laptop: pega_accel - Report accelerometer orientation change through udev
Date: Fri, 14 Oct 2011 11:13:41 +0200
Message-Id: <1318583622-23518-8-git-send-email-corentincj@iksaif.net>
X-Mailer: git-send-email 1.7.3.4
In-Reply-To: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
References: <1318583622-23518-1-git-send-email-corentincj@iksaif.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Anisse Astier <anisse@astier.eu>

Signed-off-by: Anisse Astier <anisse@astier.eu>
Signed-off-by: Corentin Chary <corentin.chary@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index d67b7b5..0dfd162 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -1342,6 +1342,14 @@ static void asus_acpi_notify(struct acpi_device *device, u32 event)
 		}
 		return ;
 	}
+
+	/* Accelerometer "coarse orientation change" event */
+	if (asus->pega_accel_poll && event == 0xEA) {
+		kobject_uevent(&asus->pega_accel_poll->input->dev.kobj,
+			       KOBJ_CHANGE);
+		return ;
+	}
+
 	asus_input_notify(asus, event);
 }
 
-- 
1.7.3.4


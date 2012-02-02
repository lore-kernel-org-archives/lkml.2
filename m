Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756507Ab2BBOWg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 09:22:36 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:50347 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756295Ab2BBOWe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 09:22:34 -0500
Date: Thu, 2 Feb 2012 18:22:25 +0400
From: Igor Murzov <intergalactic.anonymous@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Igor Murzov <e-mail@date.by>,
        Tomas Miljenovic <TomasM@tomasm.tk>, Ike Panhc <ike.pan@canonical.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sergey V <sftp.mtuci@gmail.com>
Subject: [PATCH] Input: i8042 - add Lenovo Ideapad U455 to 'reset' blacklist
Message-ID: <20120202182225.68666279@garik>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.4; i486-slackware-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>From 2d5a38a56453421e82428155f4b00303f3fb19b2 Mon Sep 17 00:00:00 2001
From: Igor Murzov <e-mail@date.by>
Date: Wed, 1 Feb 2012 03:11:53 +0400
Subject: [PATCH] Input: i8042 - add Lenovo Ideapad U455 to 'reset' blacklist

Lenovo Ideapad U455 needs to be in the reset quirk list for its
touchpad's proper function.

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=40672

Signed-off-by: Igor Murzov <e-mail@date.by>
---
 drivers/input/serio/i8042-x86ia64io.h |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/input/serio/i8042-x86ia64io.h b/drivers/input/serio/i8042-x86ia64io.h
index b4cfc6c..5ec774d 100644
--- a/drivers/input/serio/i8042-x86ia64io.h
+++ b/drivers/input/serio/i8042-x86ia64io.h
@@ -512,6 +512,13 @@ static const struct dmi_system_id __initconst i8042_dmi_reset_table[] = {
 			DMI_MATCH(DMI_PRODUCT_NAME, "Vostro 1720"),
 		},
 	},
+	{
+		/* Lenovo Ideapad U455 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "20046"),
+		},
+	},
 	{ }
 };
 
-- 
1.7.5.1


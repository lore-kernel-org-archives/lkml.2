Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754729Ab1A3Mjd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Jan 2011 07:39:33 -0500
Received: from mail-in-03.arcor-online.net ([151.189.21.43]:56041 "EHLO
	mail-in-03.arcor-online.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427Ab1A3Mih (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Jan 2011 07:38:37 -0500
X-DKIM: Sendmail DKIM Filter v2.8.2 mail-in-15.arcor-online.net 863F61AB5F8
Subject: [PATCH 7/8] HID: roccat: Fixed NULL pointer dereference when
 unloading module
From: Stefan Achatz <erazor_de@users.sourceforge.net>
Reply-To: erazor_de@users.sourceforge.net
To: Randy Dunlap <rdunlap@xenotime.net>, Jiri Kosina <jkosina@suse.cz>,
        Stefan Achatz <erazor_de@users.sourceforge.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Hans Verkuil <hverkuil@xs4all.nl>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Weber <weber@corscience.de>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Jan 2011 13:38:27 +0100
Message-ID: <1296391107.2283.186.camel@neuromancer>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Class was destroyed before starting the unregistering driver chain.
Disconnecting a device from roccat chardev in this process then
raised a NULL pointer dereference.
Fixed this by destroying class after unregistering driver.

Signed-off-by: Stefan Achatz <erazor_de@users.sourceforge.net>
---
 drivers/hid/hid-roccat-arvo.c     |    2 +-
 drivers/hid/hid-roccat-kone.c     |    2 +-
 drivers/hid/hid-roccat-koneplus.c |    2 +-
 drivers/hid/hid-roccat-kovaplus.c |    2 +-
 drivers/hid/hid-roccat-pyra.c     |    2 +-
 5 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/hid/hid-roccat-arvo.c b/drivers/hid/hid-roccat-arvo.c
index 7b9a992..75f532f 100644
--- a/drivers/hid/hid-roccat-arvo.c
+++ b/drivers/hid/hid-roccat-arvo.c
@@ -438,8 +438,8 @@ static int __init arvo_init(void)
 
 static void __exit arvo_exit(void)
 {
-	class_destroy(arvo_class);
 	hid_unregister_driver(&arvo_driver);
+	class_destroy(arvo_class);
 }
 
 module_init(arvo_init);
diff --git a/drivers/hid/hid-roccat-kone.c b/drivers/hid/hid-roccat-kone.c
index 5cdb282..d749796 100644
--- a/drivers/hid/hid-roccat-kone.c
+++ b/drivers/hid/hid-roccat-kone.c
@@ -844,8 +844,8 @@ static int __init kone_init(void)
 
 static void __exit kone_exit(void)
 {
-	class_destroy(kone_class);
 	hid_unregister_driver(&kone_driver);
+	class_destroy(kone_class);
 }
 
 module_init(kone_init);
diff --git a/drivers/hid/hid-roccat-koneplus.c b/drivers/hid/hid-roccat-koneplus.c
index 7367e4e..ac20107 100644
--- a/drivers/hid/hid-roccat-koneplus.c
+++ b/drivers/hid/hid-roccat-koneplus.c
@@ -774,8 +774,8 @@ static int __init koneplus_init(void)
 
 static void __exit koneplus_exit(void)
 {
-	class_destroy(koneplus_class);
 	hid_unregister_driver(&koneplus_driver);
+	class_destroy(koneplus_class);
 }
 
 module_init(koneplus_init);
diff --git a/drivers/hid/hid-roccat-kovaplus.c b/drivers/hid/hid-roccat-kovaplus.c
index 7664e2c..4eeb62f 100644
--- a/drivers/hid/hid-roccat-kovaplus.c
+++ b/drivers/hid/hid-roccat-kovaplus.c
@@ -703,8 +703,8 @@ static int __init kovaplus_init(void)
 
 static void __exit kovaplus_exit(void)
 {
-	class_destroy(kovaplus_class);
 	hid_unregister_driver(&kovaplus_driver);
+	class_destroy(kovaplus_class);
 }
 
 module_init(kovaplus_init);
diff --git a/drivers/hid/hid-roccat-pyra.c b/drivers/hid/hid-roccat-pyra.c
index be4daa9..02a7243 100644
--- a/drivers/hid/hid-roccat-pyra.c
+++ b/drivers/hid/hid-roccat-pyra.c
@@ -685,8 +685,8 @@ static int __init pyra_init(void)
 
 static void __exit pyra_exit(void)
 {
-	class_destroy(pyra_class);
 	hid_unregister_driver(&pyra_driver);
+	class_destroy(pyra_class);
 }
 
 module_init(pyra_init);
-- 
1.7.3.4




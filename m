Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757989Ab0GBJE2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Jul 2010 05:04:28 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49962 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757954Ab0GBJEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Jul 2010 05:04:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=frIIVmXBNUOH5EI6a7CYDNcEAoWZDNpmAc0z/FoWQKyBOymtL0Tz6rTShTHXyZJJb/
         G6oFZrk8RkyJOAkLEKjeOMEbFzeQ4aQF6Y45czHgM+Ovbqeju3UB2PNVWluF4JAmSV0S
         fuK3esewiCEMgzJl3vnLZEQDJLaabZ8DJ38k4=
Subject: [PATCH] compal-laptop/fujitsu-laptop/msi-laptop: make dmi_check_cb
	to return 1 instead of 0
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Cezary Jackiewicz <cezary.jackiewicz@gmail.com>,
       Matthew Garrett <mjg@redhat.com>,
       Tim Gardner <tim.gardner@canonical.com>,
       Mario Limonciello <Mario_Limonciello@Dell.com>,
       Richard Purdie <rpurdie@linux.intel.com>, Michal Marek <mmarek@suse.cz>,
       Jonathan Woithe <jwoithe@physics.adelaide.edu.au>,
       Len Brown <len.brown@intel.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Stefani Seibold <stefani@seibold.net>, Andi Kleen <ak@linux.intel.com>,
       Lennart Poettering <mzxreary@0pointer.de>,
       "Lee, Chun-Yi" <jlee@novell.com>, platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Fri, 02 Jul 2010 17:04:13 +0800
Message-Id: <1278061453.15256.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dmi_check_system() walks the table running matching functions until someone
returns non zero or we hit the end.

This patch makes dmi_check_cb to return 1 so dmi_check_system() return
immediately when a match is found.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/compal-laptop.c  |    2 +-
 drivers/platform/x86/fujitsu-laptop.c |    6 +++---
 drivers/platform/x86/msi-laptop.c     |    2 +-
 3 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/compal-laptop.c b/drivers/platform/x86/compal-laptop.c
index 71ff154..dc31a08 100644
--- a/drivers/platform/x86/compal-laptop.c
+++ b/drivers/platform/x86/compal-laptop.c
@@ -190,7 +190,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
 	printk(KERN_INFO "compal-laptop: Identified laptop model '%s'.\n",
 		id->ident);
 
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata compal_dmi_table[] = {
diff --git a/drivers/platform/x86/fujitsu-laptop.c b/drivers/platform/x86/fujitsu-laptop.c
index dab1a0e..1859d7f 100644
--- a/drivers/platform/x86/fujitsu-laptop.c
+++ b/drivers/platform/x86/fujitsu-laptop.c
@@ -603,7 +603,7 @@ static int dmi_check_cb_s6410(const struct dmi_system_id *id)
 	dmi_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
-	return 0;
+	return 1;
 }
 
 static int dmi_check_cb_s6420(const struct dmi_system_id *id)
@@ -611,7 +611,7 @@ static int dmi_check_cb_s6420(const struct dmi_system_id *id)
 	dmi_check_cb_common(id);
 	fujitsu->keycode1 = KEY_SCREENLOCK;	/* "Lock" */
 	fujitsu->keycode2 = KEY_HELP;	/* "Mobility Center" */
-	return 0;
+	return 1;
 }
 
 static int dmi_check_cb_p8010(const struct dmi_system_id *id)
@@ -620,7 +620,7 @@ static int dmi_check_cb_p8010(const struct dmi_system_id *id)
 	fujitsu->keycode1 = KEY_HELP;	/* "Support" */
 	fujitsu->keycode3 = KEY_SWITCHVIDEOMODE;	/* "Presentation" */
 	fujitsu->keycode4 = KEY_WWW;	/* "Internet" */
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id fujitsu_dmi_table[] = {
diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index afd762b..c67a74c 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -434,7 +434,7 @@ static int dmi_check_cb(const struct dmi_system_id *id)
 {
 	printk(KERN_INFO "msi-laptop: Identified laptop model '%s'.\n",
 	       id->ident);
-	return 0;
+	return 1;
 }
 
 static struct dmi_system_id __initdata msi_dmi_table[] = {
-- 
1.5.4.3




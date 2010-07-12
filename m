Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab0GLBNV (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:13:21 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:44925 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755426Ab0GLBNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:13:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=iz5anDlu688Ke6QoLwYStTyHBDA/koJXrzDkbyQl0h55FzxuLtTTF3OoOuaPgA6dFz
         s7g6TarQskoTvTFdBQ7G7M+VVAOiB0p4GiT8+qLxUisEgAX1eAOIGRf1OkfTUT6gkiMH
         +IVnA67yL3PwEBzzr4RXM9iy5zepTkH/ko94M=
Subject: [PATCH] asus-laptop: fix wapf, wlan_status and bluetooth_status
	module_param permissions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Jul 2010 09:13:47 +0800
Message-Id: <1278897227.6563.5.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The wapf module parameters defines the behavior of the Fn+Fx wlan key.
The wlan_status and bluetooth_status module parameters are for setting the
wlan/bluetooth status on boot.
All above module parameters are determinated only at the module load time.
Change the value after the module is loaded does not make sense and has
no effect at all, thus set the permissions to 0444 instead of 0644.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/asus-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/asus-laptop.c b/drivers/platform/x86/asus-laptop.c
index 71db2ef..7c44dce 100644
--- a/drivers/platform/x86/asus-laptop.c
+++ b/drivers/platform/x86/asus-laptop.c
@@ -76,18 +76,18 @@ MODULE_LICENSE("GPL");
  * So, if something doesn't work as you want, just try other values =)
  */
 static uint wapf = 1;
-module_param(wapf, uint, 0644);
+module_param(wapf, uint, 0444);
 MODULE_PARM_DESC(wapf, "WAPF value");
 
 static int wlan_status = 1;
 static int bluetooth_status = 1;
 
-module_param(wlan_status, int, 0644);
+module_param(wlan_status, int, 0444);
 MODULE_PARM_DESC(wlan_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
 
-module_param(bluetooth_status, int, 0644);
+module_param(bluetooth_status, int, 0444);
 MODULE_PARM_DESC(bluetooth_status, "Set the wireless status on boot "
 		 "(0 = disabled, 1 = enabled, -1 = don't do anything). "
 		 "default is 1");
-- 
1.5.4.3




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755487Ab0GLBO7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Jul 2010 21:14:59 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:37485 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755357Ab0GLBO5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Jul 2010 21:14:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=VUMteg88bQseE0EW108CwhhHCDHAENU8KV4Wfbzhy7e/4e8Hm3e+X4c5OMDBeFs0s3
         DdC9hpCHS+0VoC7OWoR5HowIq+ML7br1JWdQldNBkaHGQAnKar5+SvJ0eFEwwSbvUYDE
         Pe8XV1fQ8AIQT0MFEQbieeDxWjNfp7fhCdnGo=
Subject: [PATCH] eeepc-laptop: fix hotplug_disabled module_param permissions
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Corentin Chary <corentincj@iksaif.net>, Matthew Garrett <mjg@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Jenkins <alan-jenkins@tuffmail.co.uk>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Mon, 12 Jul 2010 09:15:25 +0800
Message-Id: <1278897325.6563.7.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The hotplug_disabled module parameter is determinated at the module load time.
Change the value after the module is loaded does not make sense and has
no effect at all, thus set the permissions to 0444 instead of 0644.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/eeepc-laptop.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/eeepc-laptop.c b/drivers/platform/x86/eeepc-laptop.c
index 0306174..6b8e062 100644
--- a/drivers/platform/x86/eeepc-laptop.c
+++ b/drivers/platform/x86/eeepc-laptop.c
@@ -53,7 +53,7 @@ MODULE_LICENSE("GPL");
 
 static bool hotplug_disabled;
 
-module_param(hotplug_disabled, bool, 0644);
+module_param(hotplug_disabled, bool, 0444);
 MODULE_PARM_DESC(hotplug_disabled,
 		 "Disable hotplug for wireless device. "
 		 "If your laptop need that, please report to "
-- 
1.5.4.3




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758325Ab0GHBuS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 21:50:18 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:48651 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758303Ab0GHBuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 21:50:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=tVW7XLfhPn7NCB9ipDmZ56z0VQ6dZYRi/7z5ytt6eCmMWUdAC4SfshFBpkXpYMS+rN
         sKGWGcISMpBq/fEfVJgkjiu0agCH7O/evj349T/vSQzb1vHhRk+PSU8aQuowDVS1Pgb7
         7XfFm0qP5vPh+Jd6xPehagGRzmpaPhnQxtr8c=
Subject: [PATCH] msi-wmi: make needlessly global symbols static
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Anisse Astier <anisse@astier.eu>, Matthew Garrett <mjg@redhat.com>,
       Thomas Renninger <trenn@suse.de>,
       Richard Purdie <rpurdie@linux.intel.com>,
       Carlos Corbacho <carlos@strangeworlds.co.uk>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 09:50:30 +0800
Message-Id: <1278553830.7162.9.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

backlight is needlessly defined global.
This patch makes the symbol static.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/msi-wmi.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/platform/x86/msi-wmi.c b/drivers/platform/x86/msi-wmi.c
index d173600..42a5469 100644
--- a/drivers/platform/x86/msi-wmi.c
+++ b/drivers/platform/x86/msi-wmi.c
@@ -57,7 +57,7 @@ static struct key_entry msi_wmi_keymap[] = {
 };
 static ktime_t last_pressed[ARRAY_SIZE(msi_wmi_keymap) - 1];
 
-struct backlight_device *backlight;
+static struct backlight_device *backlight;
 
 static int backlight_map[] = { 0x00, 0x33, 0x66, 0x99, 0xCC, 0xFF };
 
-- 
1.5.4.3




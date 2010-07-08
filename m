Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab0GHCIn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 22:08:43 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:33757 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754007Ab0GHCIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 22:08:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=gMsUVxwGCymdhJ26CWLOES8EUQ0XdgGHSgaS+0aIp20lGeoT0ZepRQN+qDsGYhoJws
         dZzuwTZ2B8g0yGkt91FSE5QWDHgvrJW/Yqmka9qmisyao5tr3K3jV5Lqu5oxUBHQQu8b
         Q39Ky+tjZCRMe7OmIvluE0nF/zwiUREL4exq0=
Subject: [PATCH] msi-laptop: make struct rfkill_ops const
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Lennart Poettering <mzxreary@0pointer.de>,
       Matthew Garrett <mjg@redhat.com>, "Lee, Chun-Yi" <jlee@novell.com>,
       Greg Kroah-Hartman <gregkh@suse.de>,
       Richard Purdie <rpurdie@linux.intel.com>,
       platform-driver-x86@vger.kernel.org
Content-Type: text/plain
Date: Thu, 08 Jul 2010 10:08:55 +0800
Message-Id: <1278554935.7162.12.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

rfkill uses a const struct rfkill_ops pointer.

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/platform/x86/msi-laptop.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/platform/x86/msi-laptop.c b/drivers/platform/x86/msi-laptop.c
index afd762b..05634f8 100644
--- a/drivers/platform/x86/msi-laptop.c
+++ b/drivers/platform/x86/msi-laptop.c
@@ -562,15 +562,15 @@ static int rfkill_threeg_set(void *data, bool blocked)
 	return 0;
 }
 
-static struct rfkill_ops rfkill_bluetooth_ops = {
+static const struct rfkill_ops rfkill_bluetooth_ops = {
 	.set_block = rfkill_bluetooth_set
 };
 
-static struct rfkill_ops rfkill_wlan_ops = {
+static const struct rfkill_ops rfkill_wlan_ops = {
 	.set_block = rfkill_wlan_set
 };
 
-static struct rfkill_ops rfkill_threeg_ops = {
+static const struct rfkill_ops rfkill_threeg_ops = {
 	.set_block = rfkill_threeg_set
 };
 
-- 
1.5.4.3




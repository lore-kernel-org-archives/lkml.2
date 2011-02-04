Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab1BDMZx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 07:25:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:32973 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751799Ab1BDMXy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 07:23:54 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:date:message-id:x-mailer:in-reply-to
         :references;
        b=Rb95GnloeLKH/oM1yGjbHmrI5gHVZmXxjU09DJ9I+iym0Pxy5RVPw9Bd34nK5U4GqL
         sl2rtDE6DfuMCi779vGBiIlRYh5A2qRCkX9gUwuZvc0bzB4EO9TORLEgIWQXFOywj9Tv
         af1bOEw46DYeTyTHYUMCYFdbjGuZbwnwLb9iw=
From: Vasiliy Kulikov <segoon@openwall.com>
To: linux-kernel@vger.kernel.org
Cc: security@kernel.org, Wolfgang Grandegger <wg@grandegger.com>,
        socketcan-core@lists.berlios.de, netdev@vger.kernel.org
Subject: [PATCH 12/20] net: can: at91_can: world-writable sysfs files
Date: Fri,  4 Feb 2011 15:23:50 +0300
Message-Id: <a6800dc8b0daed78256f98f52844cbbb48f4a76d.1296818921.git.segoon@openwall.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <cover.1296818921.git.segoon@openwall.com>
References: <cover.1296818921.git.segoon@openwall.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Don't allow everybody to write to mb0_id file.

Signed-off-by: Vasiliy Kulikov <segoon@openwall.com>
---
 Cannot compile the driver, so it is not tested at all.

 drivers/net/can/at91_can.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/net/can/at91_can.c b/drivers/net/can/at91_can.c
index 2532b96..57d2ffb 100644
--- a/drivers/net/can/at91_can.c
+++ b/drivers/net/can/at91_can.c
@@ -1109,7 +1109,7 @@ static ssize_t at91_sysfs_set_mb0_id(struct device *dev,
 	return ret;
 }
 
-static DEVICE_ATTR(mb0_id, S_IWUGO | S_IRUGO,
+static DEVICE_ATTR(mb0_id, S_IWUSR | S_IRUGO,
 	at91_sysfs_show_mb0_id, at91_sysfs_set_mb0_id);
 
 static struct attribute *at91_sysfs_attrs[] = {
-- 
1.7.0.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758653Ab2ILNES (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 09:04:18 -0400
Received: from smtp4.mundo-r.com ([212.51.32.151]:52874 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758059Ab2ILMzw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 08:55:52 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AqECACCFUFBbdWObgWdsb2JhbABFu0AiAQEWJieCIAEBBSdSECAxVwYTiBG8YpFSA5Vfkwc
X-IronPort-AV: E=Sophos;i="4.80,410,1344204000"; 
   d="scan'208";a="950511743"
From: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        industrypack-devel@lists.sourceforge.net,
        Jens Taprogge <jens.taprogge@taprogge.org>,
        Samuel Iglesias Gonsalvez <siglesias@igalia.com>
Subject: [PATCH 09/24] Staging: ipack/devices/ipoctal: remove superfluous function.
Date: Wed, 12 Sep 2012 14:55:31 +0200
Message-Id: <1347454546-23236-9-git-send-email-siglesias@igalia.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
References: <1347454546-23236-1-git-send-email-siglesias@igalia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jens Taprogge <jens.taprogge@taprogge.org>

ipoctal_write_tty and ipoctal_write are merged.

Signed-off-by: Jens Taprogge <jens.taprogge@taprogge.org>
Signed-off-by: Samuel Iglesias Gonsalvez <siglesias@igalia.com>
---
 drivers/staging/ipack/devices/ipoctal.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/drivers/staging/ipack/devices/ipoctal.c b/drivers/staging/ipack/devices/ipoctal.c
index e0be660..4cc9173 100644
--- a/drivers/staging/ipack/devices/ipoctal.c
+++ b/drivers/staging/ipack/devices/ipoctal.c
@@ -493,9 +493,11 @@ static inline int ipoctal_copy_write_buffer(struct ipoctal_channel *channel,
 	return i;
 }
 
-static int ipoctal_write(struct ipoctal_channel *channel,
-			 const unsigned char *buf, int count)
+static int ipoctal_write_tty(struct tty_struct *tty,
+			     const unsigned char *buf, int count)
 {
+	struct ipoctal_channel *channel = tty->driver_data;
+
 	channel->nb_bytes = 0;
 	channel->count_wr = 0;
 
@@ -519,14 +521,6 @@ static int ipoctal_write(struct ipoctal_channel *channel,
 	return channel->count_wr;
 }
 
-static int ipoctal_write_tty(struct tty_struct *tty,
-			     const unsigned char *buf, int count)
-{
-	struct ipoctal_channel *channel = tty->driver_data;
-
-	return ipoctal_write(channel, buf, count);
-}
-
 static int ipoctal_write_room(struct tty_struct *tty)
 {
 	struct ipoctal_channel *channel = tty->driver_data;
-- 
1.7.10.4


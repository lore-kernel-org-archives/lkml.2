Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753901Ab0KJAfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 19:35:30 -0500
Received: from mail.perches.com ([173.55.12.10]:4833 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752563Ab0KJAf2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 19:35:28 -0500
From: Joe Perches <joe@perches.com>
To: linux-kernel@vger.kernel.org
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org
Subject: [PATCH 1/9] drivers/gpu/drm/drm_stub.c: Use printf extension %pV
Date: Tue,  9 Nov 2010 16:35:15 -0800
Message-Id: <4da8e82f773833e126fc5d2d5563093b784144e5.1289348757.git.joe@perches.com>
X-Mailer: git-send-email 1.7.3.1.g432b3.dirty
In-Reply-To: <cover.1289348757.git.joe@perches.com>
References: <cover.1289348757.git.joe@perches.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Using %pV reduces the number of printk calls and
eliminates any possible message interleaving from
other printk calls.

Signed-off-by: Joe Perches <joe@perches.com>
---
 drivers/gpu/drm/drm_stub.c |   14 +++++++++++---
 1 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/drm_stub.c b/drivers/gpu/drm/drm_stub.c
index cdc89ee..e632527 100644
--- a/drivers/gpu/drm/drm_stub.c
+++ b/drivers/gpu/drm/drm_stub.c
@@ -57,13 +57,21 @@ void drm_ut_debug_printk(unsigned int request_level,
 			 const char *function_name,
 			 const char *format, ...)
 {
+	struct va_format vaf;
 	va_list args;
 
 	if (drm_debug & request_level) {
-		if (function_name)
-			printk(KERN_DEBUG "[%s:%s], ", prefix, function_name);
 		va_start(args, format);
-		vprintk(format, args);
+
+		vaf.fmt = format;
+		vaf.va = &args;
+
+		if (function_name)
+			printk(KERN_DEBUG "[%s:%s], %pV",
+			       prefix, function_name, &vaf);
+		else
+			printk(KERN_DEBUG "%pV", &vaf);
+
 		va_end(args);
 	}
 }
-- 
1.7.3.1.g432b3.dirty


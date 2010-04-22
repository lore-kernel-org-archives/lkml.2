Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755714Ab0DVPXw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 11:23:52 -0400
Received: from gw1.transmode.se ([213.115.205.20]:39735 "EHLO gw1.transmode.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755590Ab0DVPXu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 11:23:50 -0400
From: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
To: "Andrew Morton" <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Subject: [PATCH 2/2] crc32: use __BYTE_ORDER macro for endian detection.
Date: Thu, 22 Apr 2010 17:23:29 +0200
Message-Id: <1271949809-24030-2-git-send-email-Joakim.Tjernlund@transmode.se>
X-Mailer: git-send-email 1.6.4.4
In-Reply-To: <1271949809-24030-1-git-send-email-Joakim.Tjernlund@transmode.se>
References: <1271949809-24030-1-git-send-email-Joakim.Tjernlund@transmode.se>
X-MIMETrack: Itemize by SMTP Server on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-04-22 17:23:49,
	Serialize by Router on sesr04/Transmode(Release 8.5.1|September 28, 2009) at
 2010-04-22 17:23:49,
	Serialize complete at 2010-04-22 17:23:49
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since crc32.c contains a nifty test program that can be
executed in user space, make sure endian detection works
reliably in user space too.

Signed-off-by: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
---
 lib/crc32.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/lib/crc32.c b/lib/crc32.c
index 54ca885..89b0624 100644
--- a/lib/crc32.c
+++ b/lib/crc32.c
@@ -51,7 +51,7 @@ MODULE_LICENSE("GPL");
 static inline u32
 crc32_body(u32 crc, unsigned char const *buf, size_t len, const u32 (*tab)[256])
 {
-# ifdef __LITTLE_ENDIAN
+# if __BYTE_ORDER == __LITTLE_ENDIAN
 #  define DO_CRC(x) crc = tab[0][(crc ^ (x)) & 255 ] ^ (crc >> 8)
 #  define DO_CRC4 crc = tab[3][(crc) & 255 ] ^ \
 		tab[2][(crc >> 8) & 255 ] ^ \
-- 
1.6.4.4


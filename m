Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933744Ab1IJSNL (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Sep 2011 14:13:11 -0400
Received: from jester.euphonynet.be ([212.87.96.13]:55980 "EHLO
	mailpush2.euphonynet.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933578Ab1IJSNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Sep 2011 14:13:10 -0400
From: Bart Van Assche <bvanassche@acm.org>
To: linux-fbdev@vger.kernel.org
Subject: [PATCH] backlight: Declare backlight_types[] const
Date: Sat, 10 Sep 2011 20:13:01 +0200
User-Agent: KMail/1.13.6 (Linux/2.6.38.8-scst; KDE/4.6.0; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <mjg@redhat.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201109102013.01588.bvanassche@acm.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since backlight_types[] isn't modified, let's declare it const. That
was probably the intention of the author of commit
bb7ca747f8d6243b3943c5b133048652020f4a50, via which the "const char
const *" construct was introduced. The duplicate const was detected
by sparse.

Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Cc: Matthew Garrett <mjg@redhat.com>
Cc: Richard Purdie <rpurdie@rpsys.net>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
---
 drivers/video/backlight/backlight.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/backlight/backlight.c b/drivers/video/backlight/backlight.c
index 80d292f..7363c1b 100644
--- a/drivers/video/backlight/backlight.c
+++ b/drivers/video/backlight/backlight.c
@@ -19,7 +19,7 @@
 #include <asm/backlight.h>
 #endif
 
-static const char const *backlight_types[] = {
+static const char *const backlight_types[] = {
 	[BACKLIGHT_RAW] = "raw",
 	[BACKLIGHT_PLATFORM] = "platform",
 	[BACKLIGHT_FIRMWARE] = "firmware",
-- 
1.7.3.4


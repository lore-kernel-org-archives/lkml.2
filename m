Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934012Ab1J3MI6 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 08:08:58 -0400
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:37006 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933965Ab1J3MI5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 08:08:57 -0400
Subject: [PATCH] [RESEND] media: tea5764: reconcile Kconfig symbol and macro
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 13:08:50 +0100
Message-ID: <1319976530.14409.17.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Kconfig symbol RADIO_TEA5764_XTAL is unused. The code does use a
RADIO_TEA5764_XTAL macro, but does that rather peculiar. But there seems
to be a way to keep both. (The easiest way out would be to rip out both
the Kconfig symbol and the macro.)

Note there's also a module parameter 'use_xtal' to influence all this.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
I didn't dare to submit this a trivial patch. This is still untested. By
the way, is xtal a common abbreviation of crystal?

 drivers/media/radio/radio-tea5764.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/drivers/media/radio/radio-tea5764.c b/drivers/media/radio/radio-tea5764.c
index 95ddcc4..db20904 100644
--- a/drivers/media/radio/radio-tea5764.c
+++ b/drivers/media/radio/radio-tea5764.c
@@ -128,8 +128,10 @@ struct tea5764_write_regs {
 	u16 rdsbbl;				/* PAUSEDET & RDSBBL */
 } __attribute__ ((packed));
 
-#ifndef RADIO_TEA5764_XTAL
+#ifdef CONFIG_RADIO_TEA5764_XTAL
 #define RADIO_TEA5764_XTAL 1
+#else
+#define RADIO_TEA5764_XTAL 0
 #endif
 
 static int radio_nr = -1;
-- 
1.7.4.4




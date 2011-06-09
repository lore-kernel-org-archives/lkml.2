Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757302Ab1FILSX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 07:18:23 -0400
Received: from hera.kernel.org ([140.211.167.34]:41206 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753515Ab1FILSV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 07:18:21 -0400
Date: Thu, 9 Jun 2011 11:18:08 GMT
From: tip-bot for Ralf Baechle <ralf@linux-mips.org>
Message-ID: <tip-1a8588c908e98c3b31a3a35595a94c655d569222@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@redhat.com,
        ralf@linux-mips.org, tglx@linutronix.de, tiwai@suse.de, perex@perex.cz
Reply-To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        ralf@linux-mips.org, tglx@linutronix.de, perex@perex.cz, tiwai@suse.de
In-Reply-To: <20110601180610.532642190@duck.linux-mips.net>
References: <20110601180610.532642190@duck.linux-mips.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/cleanup] i8253: Make pcsp sound driver use the shared i8253_lock
Git-Commit-ID: 1a8588c908e98c3b31a3a35595a94c655d569222
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org> to get blacklisted from these emails
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Thu, 09 Jun 2011 11:18:09 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  1a8588c908e98c3b31a3a35595a94c655d569222
Gitweb:     http://git.kernel.org/tip/1a8588c908e98c3b31a3a35595a94c655d569222
Author:     Ralf Baechle <ralf@linux-mips.org>
AuthorDate: Wed, 1 Jun 2011 19:05:03 +0100
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Thu, 9 Jun 2011 12:03:50 +0200

i8253: Make pcsp sound driver use the shared i8253_lock

Signed-off-by: Ralf Baechle <ralf@linux-mips.org>
Cc: Jaroslav Kysela <perex@perex.cz>
Acked-by: Takashi Iwai <tiwai@suse.de>
Cc: alsa-devel@alsa-project.org
Link: http://lkml.kernel.org/r/20110601180610.532642190@duck.linux-mips.net
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 sound/drivers/pcsp/pcsp.h |    8 +-------
 1 files changed, 1 insertions(+), 7 deletions(-)

diff --git a/sound/drivers/pcsp/pcsp.h b/sound/drivers/pcsp/pcsp.h
index 6757c30..fc7a2dc 100644
--- a/sound/drivers/pcsp/pcsp.h
+++ b/sound/drivers/pcsp/pcsp.h
@@ -10,14 +10,8 @@
 #define __PCSP_H__
 
 #include <linux/hrtimer.h>
-#include <linux/timex.h>
-#if defined(CONFIG_MIPS) || defined(CONFIG_X86)
-/* Use the global PIT lock ! */
 #include <linux/i8253.h>
-#else
-#include <asm/8253pit.h>
-static DEFINE_RAW_SPINLOCK(i8253_lock);
-#endif
+#include <linux/timex.h>
 
 #define PCSP_SOUND_VERSION 0x400	/* read 4.00 */
 #define PCSP_DEBUG 0

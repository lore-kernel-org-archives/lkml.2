Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756225Ab2BGMl2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 07:41:28 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:44528 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755676Ab2BGMl1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 07:41:27 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH v2] cs5535-mfgpt: don't call __init function from __devinit
Date: Tue,  7 Feb 2012 13:41:10 +0100
Message-Id: <1328618470-26953-1-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328618487;32a9d0f3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix scan_timers() and reset_all_timers()  to be __devinit
and not __init since the function get called from
cs5535_mfgpt_probe which is __devinit.

v2: set also reset_all_timers() to __devinit

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/misc/cs5535-mfgpt.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index bc685bf..f505a40 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
@@ -246,7 +246,7 @@ EXPORT_SYMBOL_GPL(cs5535_mfgpt_write);
  * Jordan tells me that he and Mitch once played w/ it, but it's unclear
  * what the results of that were (and they experienced some instability).
  */
-static void __init reset_all_timers(void)
+static void __devinit reset_all_timers(void)
 {
 	uint32_t val, dummy;
 
@@ -262,7 +262,7 @@ static void __init reset_all_timers(void)
  * In other cases (such as with VSAless OpenFirmware), the system firmware
  * leaves timers available for us to use.
  */
-static int __init scan_timers(struct cs5535_mfgpt_chip *mfgpt)
+static int __devinit scan_timers(struct cs5535_mfgpt_chip *mfgpt)
 {
 	struct cs5535_mfgpt_timer timer = { .chip = mfgpt };
 	unsigned long flags;
-- 
1.7.7.3


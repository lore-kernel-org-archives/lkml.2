Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755509Ab2BBNVB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 08:21:01 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:36044 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753589Ab2BBNU6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 08:20:58 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: linux-kernel@vger.kernel.org
Cc: Danny Kukawka <dkukawka@suse.de>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andres Salomon <dilinger@queued.net>
Subject: [PATCH] cs5535-mfgpt: don't call __init function from __devinit
Date: Thu,  2 Feb 2012 14:20:29 +0100
Message-Id: <1328188830-28133-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
References: <1328188830-28133-1-git-send-email-danny.kukawka@bisect.de>
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328188858;67df008a;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix scan_timers() to be __devinit and not __init since
the function get called from cs5535_mfgpt_probe which is
__devinit.

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/misc/cs5535-mfgpt.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/cs5535-mfgpt.c b/drivers/misc/cs5535-mfgpt.c
index bc685bf..87a390d 100644
--- a/drivers/misc/cs5535-mfgpt.c
+++ b/drivers/misc/cs5535-mfgpt.c
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


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756554Ab0FHXd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jun 2010 19:33:57 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:35272 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754732Ab0FHXd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jun 2010 19:33:56 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:date:message-id:x-mailer:x-mailer-version;
        b=ojcEOLDkAzALLvdUmFbke54gbrf9ZvBXXMXWsyqcy8l5E/wRuRLet7hryBcvsVeP2o
         cM1PNVWtCs0FowEOIcd2unVuoz8Nxl2gn7ZbIzB43hDwRxbl1F8a30i+MxFXfLCHsfZT
         H/KkhyHWVq3925ni+s3giVVF97h4PGdwsaDTQ=
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Geert Uytterhoeven <geert@linux-m68k.org>,
       Arnd Bergmann <arnd@arndb.de>
Subject: [GIT PULL] ioctl bkl pushdown fix
Date: Wed,  9 Jun 2010 01:33:52 +0200
Message-Id: <1276040032-12232-1-git-send-regression-fweisbec@gmail.com>
X-Mailer: git-send-regression
X-Mailer-version: 0.1, "The maintainer couldn't reproduce after one week full time debugging" special version.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the bkl/fixes branch that can be found at:

git://git.kernel.org/pub/scm/linux/kernel/git/frederic/random-tracing.git
	bkl/fixes

Thanks,
	Frederic
---

Arnd Bergmann (1):
      hp_sdc_rtc: fix broken ioctl conversion


 drivers/input/misc/hp_sdc_rtc.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

---
commit af0d5cb908f7f9adeb5d3d3dbef64c644bb6809c
Author: Arnd Bergmann <arnd@arndb.de>
Date:   Sat Jun 5 22:52:21 2010 +0200

    hp_sdc_rtc: fix broken ioctl conversion
    
    Commit 55929332c92 "drivers: Push down BKL into various drivers"
    introduced a regression in hp_sdc_rtc, caused by a missing
    change of the .unlocked_ioctl pointer to the newly introduced
    function.
    
    Fixes:
    
    	drivers/input/misc/hp_sdc_rtc.c:681: warning: initialization from
    	incompatible pointer type
    	drivers/input/misc/hp_sdc_rtc.c:665: warning:
    	‘hp_sdc_rtc_unlocked_ioctl’ defined but not used
    
    Reported-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Arnd Bergmann <arnd@arndb.de>
    Acked-by: Geert Uytterhoeven <geert@linux-m68k.org>
    Signed-off-by: Frederic Weisbecker <fweisbec@gmail.com>

diff --git a/drivers/input/misc/hp_sdc_rtc.c b/drivers/input/misc/hp_sdc_rtc.c
index e00a1cc..c190664 100644
--- a/drivers/input/misc/hp_sdc_rtc.c
+++ b/drivers/input/misc/hp_sdc_rtc.c
@@ -678,7 +678,7 @@ static const struct file_operations hp_sdc_rtc_fops = {
         .llseek =		no_llseek,
         .read =			hp_sdc_rtc_read,
         .poll =			hp_sdc_rtc_poll,
-        .unlocked_ioctl = 	hp_sdc_rtc_ioctl,
+        .unlocked_ioctl =	hp_sdc_rtc_unlocked_ioctl,
         .open =			hp_sdc_rtc_open,
         .fasync =		hp_sdc_rtc_fasync,
 };

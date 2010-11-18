Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760189Ab0KRUWQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 15:22:16 -0500
Received: from mail.klingt.org ([86.59.21.178]:47726 "EHLO klingt.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755568Ab0KRUWP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 15:22:15 -0500
X-Greylist: delayed 339 seconds by postgrey-1.27 at vger.kernel.org; Thu, 18 Nov 2010 15:22:14 EST
From: Tim Blechmann <tim@klingt.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Palash Bandyopadhyay <Palash.Bandyopadhyay@conexant.com>,
        devel@driverdev.osuosl.org, Tim Blechmann <tim@klingt.org>
Subject: [PATCH] cx25821: fix build failure
Date: Thu, 18 Nov 2010 21:15:58 +0100
Message-Id: <ac9bb5b7fddd363c37c511e9af688128285fa1c1.1290110765.git.tim@klingt.org>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.7 (klingt.org [86.59.21.178]); Thu, 18 Nov 2010 21:16:12 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

include specific header for bkl functions

drivers/staging/cx25821/cx25821-video.c:815:8: error: implicit declaration of function ‘lock_kernel’
drivers/staging/cx25821/cx25821-video.c:832:9: error: implicit declaration of function ‘unlock_kernel’

Signed-off-by: Tim Blechmann <tim@klingt.org>
---
 drivers/staging/cx25821/cx25821-video.h |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/staging/cx25821/cx25821-video.h b/drivers/staging/cx25821/cx25821-video.h
index cc6034b..0df20dc 100644
--- a/drivers/staging/cx25821/cx25821-video.h
+++ b/drivers/staging/cx25821/cx25821-video.h
@@ -34,6 +34,7 @@
 #include <linux/interrupt.h>
 #include <linux/delay.h>
 #include <linux/kthread.h>
+#include <linux/smp_lock.h>
 #include <asm/div64.h>
 
 #include "cx25821.h"
-- 
1.7.1


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756783Ab2HOTvO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 15:51:14 -0400
Received: from mail.windriver.com ([147.11.1.11]:36914 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756597Ab2HOTvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 15:51:10 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
To: <stable@vger.kernel.org>, <linux-kernel@vger.kernel.org>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [v2.6.34-stable 094/165] tuner_xc2028: Allow selection of the frequency adjustment code for XC3028
Date: Wed, 15 Aug 2012 15:47:18 -0400
Message-ID: <1345060109-9187-95-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: git-send-email 1.7.12.rc2
In-Reply-To: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
References: <1345060109-9187-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab@redhat.com>

                   -------------------
    This is a commit scheduled for the next v2.6.34 longterm release.
    http://git.kernel.org/?p=linux/kernel/git/paulg/longterm-queue-2.6.34.git
    If you see a problem with using this for longterm, please comment.
                   -------------------

commit 9bed77ee2fb46b74782d0d9d14b92e9d07f3df6e upstream.

This device is not using the proper demod IF. Instead of using the
IF macro, it is specifying a IF frequency. This doesn't work, as xc3028
needs to load an specific SCODE for the tuner. In this case, there's
no IF table for 5 MHz.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---
 drivers/media/video/cx23885/cx23885-dvb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/media/video/cx23885/cx23885-dvb.c b/drivers/media/video/cx23885/cx23885-dvb.c
index 939079d..3f85b6c 100644
--- a/drivers/media/video/cx23885/cx23885-dvb.c
+++ b/drivers/media/video/cx23885/cx23885-dvb.c
@@ -747,7 +747,7 @@ static int dvb_register(struct cx23885_tsport *port)
 			static struct xc2028_ctrl ctl = {
 				.fname   = XC3028L_DEFAULT_FIRMWARE,
 				.max_len = 64,
-				.demod   = 5000,
+				.demod   = XC3028_FE_DIBCOM52,
 				/* This is true for all demods with
 					v36 firmware? */
 				.type    = XC2028_D2633,
-- 
1.7.12.rc2


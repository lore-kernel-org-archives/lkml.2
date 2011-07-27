Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754346Ab1G0J4A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 05:56:00 -0400
Received: from narfation.org ([79.140.41.39]:43169 "EHLO v3-1039.vlinux.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab1G0Jzw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 05:55:52 -0400
X-Greylist: delayed 477 seconds by postgrey-1.27 at vger.kernel.org; Wed, 27 Jul 2011 05:55:52 EDT
From: Sven Eckelmann <sven@narfation.org>
To: linux-arch@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Sven Eckelmann <sven@narfation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        linux-media@vger.kernel.org
Subject: [PATCHv4 05/11] omap3isp: Use *_dec_not_zero instead of *_add_unless
Date: Wed, 27 Jul 2011 11:47:44 +0200
Message-Id: <1311760070-21532-5-git-send-email-sven@narfation.org>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <1311760070-21532-1-git-send-email-sven@narfation.org>
References: <1311760070-21532-1-git-send-email-sven@narfation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

atomic_dec_not_zero is defined for each architecture through
<linux/atomic.h> to provide the functionality of
atomic_add_unless(x, -1, 0).

Signed-off-by: Sven Eckelmann <sven@narfation.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: linux-media@vger.kernel.org
---
 drivers/media/video/omap3isp/ispstat.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/omap3isp/ispstat.c b/drivers/media/video/omap3isp/ispstat.c
index b44cb68..81b1ec9 100644
--- a/drivers/media/video/omap3isp/ispstat.c
+++ b/drivers/media/video/omap3isp/ispstat.c
@@ -652,7 +652,7 @@ static int isp_stat_buf_process(struct ispstat *stat, int buf_state)
 {
 	int ret = STAT_NO_BUF;
 
-	if (!atomic_add_unless(&stat->buf_err, -1, 0) &&
+	if (!atomic_dec_not_zero(&stat->buf_err) &&
 	    buf_state == STAT_BUF_DONE && stat->state == ISPSTAT_ENABLED) {
 		ret = isp_stat_buf_queue(stat);
 		isp_stat_buf_next(stat);
-- 
1.7.5.4


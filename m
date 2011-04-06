Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755368Ab1DFJYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 05:24:37 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:35736 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755212Ab1DFJYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 05:24:36 -0400
From: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        Viresh Kumar <viresh.kumar@st.com>,
        linux-arm-kernel@lists.infradead.org, shiraz.hashim@st.com
Subject: [PATCH 2/5] driver core/platform_device_add_data: free platform data before overwriting
Date: Wed,  6 Apr 2011 11:24:22 +0200
Message-Id: <1302081865-2962-2-git-send-email-u.kleine-koenig@pengutronix.de>
X-Mailer: git-send-email 1.7.2.3
In-Reply-To: <20110301153438.GB15633@suse.de>
References: <20110301153438.GB15633@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:215:17ff:fe12:23b0
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
---
 drivers/base/platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index f836f2e..01caf61 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -227,6 +227,7 @@ int platform_device_add_data(struct platform_device *pdev, const void *data,
 			return -ENOMEM;
 	}
 
+	kfree(pdev->dev.platform_data);
 	pdev->dev.platform_data = d;
 	return 0;
 }
-- 
1.7.2.3


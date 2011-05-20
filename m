Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934720Ab1ETALn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 20:11:43 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:57029 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933442Ab1ETALi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 20:11:38 -0400
X-Sasl-enc: NuhilhfiBiIHiO4Gizc+7jg6hEYCtK6ajmwLYXwJRBHn 1305850297
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: =?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 19/44] driver core/platform_device_add_data: free platform data before overwriting
Date: Thu, 19 May 2011 17:10:37 -0700
Message-Id: <1305850262-9575-19-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1305850262-9575-1-git-send-email-gregkh@suse.de>
References: <20110520000821.GA9367@kroah.com>
 <1305850262-9575-1-git-send-email-gregkh@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

Reviewed-by: Viresh Kumar <viresh.kumar@st.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/base/platform.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index 65cb4c3..58ad8e8 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -228,6 +228,7 @@ int platform_device_add_data(struct platform_device *pdev, const void *data,
 			return -ENOMEM;
 	}
 
+	kfree(pdev->dev.platform_data);
 	pdev->dev.platform_data = d;
 	return 0;
 }
-- 
1.7.4.2


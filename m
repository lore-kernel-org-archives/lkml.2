Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932679Ab1LERY1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:24:27 -0500
Received: from smtp.nokia.com ([147.243.1.47]:29499 "EHLO mgw-sa01.nokia.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932658Ab1LERYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:24:22 -0500
From: Felipe Contreras <felipe.contreras@nokia.com>
To: linux-main <linux-kernel@vger.kernel.org>
Cc: Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>,
        Felipe Contreras <felipe.contreras@gmail.com>
Subject: [PATCH 1/2] isp1704_charger: fix missing check
Date: Mon,  5 Dec 2011 19:23:39 +0200
Message-Id: <1323105820-25946-2-git-send-email-felipe.contreras@nokia.com>
X-Mailer: git-send-email 1.7.8.rc3.17.gf56ef1
In-Reply-To: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
References: <1323105820-25946-1-git-send-email-felipe.contreras@nokia.com>
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Felipe Contreras <felipe.contreras@gmail.com>

A segfault happens if there's no board information.

Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
---
 drivers/power/isp1704_charger.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/power/isp1704_charger.c b/drivers/power/isp1704_charger.c
index f6d72b4..768cf5e 100644
--- a/drivers/power/isp1704_charger.c
+++ b/drivers/power/isp1704_charger.c
@@ -79,7 +79,7 @@ static void isp1704_charger_set_power(struct isp1704_charger *isp, bool on)
 {
 	struct isp1704_charger_data	*board = isp->dev->platform_data;
 
-	if (board->set_power)
+	if (board && board->set_power)
 		board->set_power(on);
 }
 
-- 
1.7.8.rc3.17.gf56ef1


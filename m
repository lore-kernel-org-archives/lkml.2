Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759348Ab2CGDmo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 22:42:44 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:45039 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759007Ab2CGDmE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 22:42:04 -0500
From: santosh nayak <santoshprasadnayak@gmail.com>
To: mchehab@infradead.org
Cc: dheitmueller@kernellabs.com, hans.verkuil@cisco.com,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org,
        Santosh Nayak <santoshprasadnayak@gmail.com>
Subject: [PATCH] [media] dvb: negative value assigned to unsigned int in CDRXD().
Date: Wed,  7 Mar 2012 09:11:03 +0530
Message-Id: <1331091663-4790-1-git-send-email-santoshprasadnayak@gmail.com>
X-Mailer: git-send-email 1.7.4.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Santosh Nayak <santoshprasadnayak@gmail.com>

In CDRXD(), Negative number is assigned to unsigned variable
'state->noise_cal.tdCal2.

Members of 'SNoiseCal' should be 'signed short'.

Signed-off-by: Santosh Nayak <santoshprasadnayak@gmail.com>
---
 drivers/media/dvb/frontends/drxd_hard.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/media/dvb/frontends/drxd_hard.c b/drivers/media/dvb/frontends/drxd_hard.c
index 7bf39cd..f380eb4 100644
--- a/drivers/media/dvb/frontends/drxd_hard.c
+++ b/drivers/media/dvb/frontends/drxd_hard.c
@@ -101,9 +101,9 @@ struct SCfgAgc {
 
 struct SNoiseCal {
 	int cpOpt;
-	u16 cpNexpOfs;
-	u16 tdCal2k;
-	u16 tdCal8k;
+	short cpNexpOfs;
+	short tdCal2k;
+	short tdCal8k;
 };
 
 enum app_env {
-- 
1.7.4.4


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab1KMQQq (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Nov 2011 11:16:46 -0500
Received: from smtp-out1.tiscali.nl ([195.241.79.176]:43467 "EHLO
	smtp-out1.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753276Ab1KMQQp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Nov 2011 11:16:45 -0500
Subject: [PATCH] [media] Fix typos in VIDEO_CX231XX_DVB Kconfig entry
From: Paul Bolle <pebolle@tiscali.nl>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Nov 2011 17:16:40 +0100
Message-ID: <1321201000.20271.72.camel@x61.thuisdomein>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.3 (2.32.3-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit ede676c72d ("[...] add digital support for PV SBTVD hybrid")
added "select MEDIA_TUNER_NXP18271" to the VIDEO_CX231XX_DVB Kconfig
entry. But there's no Kconfig symbol MEDIA_TUNER_NXP18271. That should
have been MEDIA_TUNER_TDA18271. (The code added in that commit uses
tda18271_attach, which is only available if MEDIA_TUNER_TDA18271 is
set.)

The selects of MEDIA_TUNER_XC5000 and MEDIA_TUNER_TDA18271 should only
be done if MEDIA_TUNER_CUSTOMISE isn't set.

Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
---
0) git grep tested only. The second statement is pure bluff: I'm not
familiar with the usage of DVB_FE_CUSTOMISE and MEDIA_TUNER_CUSTOMISE. I
only noticed that these two lines looked odd when compared to all
similar lines in drivers/media.

1) Apparently no one noticed because no one build with settings that
could trigger a problem (ie, both MEDIA_TUNER_TDA18271 and
MEDIA_TUNER_CUSTOMISE not set). 

 drivers/media/video/cx231xx/Kconfig |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx231xx/Kconfig b/drivers/media/video/cx231xx/Kconfig
index ae85a7a..c74ce9e 100644
--- a/drivers/media/video/cx231xx/Kconfig
+++ b/drivers/media/video/cx231xx/Kconfig
@@ -42,8 +42,8 @@ config VIDEO_CX231XX_DVB
 	tristate "DVB/ATSC Support for Cx231xx based TV cards"
 	depends on VIDEO_CX231XX && DVB_CORE
 	select VIDEOBUF_DVB
-	select MEDIA_TUNER_XC5000 if !DVB_FE_CUSTOMISE
-	select MEDIA_TUNER_NXP18271 if !DVB_FE_CUSTOMISE
+	select MEDIA_TUNER_XC5000 if !MEDIA_TUNER_CUSTOMISE
+	select MEDIA_TUNER_TDA18271 if !MEDIA_TUNER_CUSTOMISE
 	select DVB_MB86A20S if !DVB_FE_CUSTOMISE
 
 	---help---
-- 
1.7.4.4




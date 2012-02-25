Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2BYJ2X (ORCPT <rfc822;w@1wt.eu>);
	Sat, 25 Feb 2012 04:28:23 -0500
Received: from smtprelay04.ispgateway.de ([80.67.31.32]:45807 "EHLO
	smtprelay04.ispgateway.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755453Ab2BYJ2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 25 Feb 2012 04:28:20 -0500
From: Bernhard Walle <bernhard@bwalle.de>
To: gregkh@linuxfoundation.org
Cc: christoph.mair@gmail.com, arnd@arndb.de, linux-kernel@vger.kernel.org
Subject: [PATCH] misc: bmp085: Use unsigned long to store jiffies
Date: Sat, 25 Feb 2012 10:28:12 +0100
Message-Id: <1330162092-30053-1-git-send-email-bernhard@bwalle.de>
X-Mailer: git-send-email 1.7.5.4
In-Reply-To: <20120224221807.GA20680@kroah.com>
References: <20120224221807.GA20680@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Df-Sender: MTIyNzgwNg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes following compilation warning:

drivers/misc/bmp085.c: In function ‘bmp085_get_pressure’:
drivers/misc/bmp085.c:238:4: warning: comparison of distinct pointer
         types lacks a cast [enabled by default]

Signed-off-by: Bernhard Walle <bernhard@bwalle.de>
---
 drivers/misc/bmp085.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/misc/bmp085.c b/drivers/misc/bmp085.c
index b088abc..76c3064 100644
--- a/drivers/misc/bmp085.c
+++ b/drivers/misc/bmp085.c
@@ -87,7 +87,7 @@ struct bmp085_data {
 	u32 raw_temperature;
 	u32 raw_pressure;
 	unsigned char oversampling_setting;
-	u32 last_temp_measurement;
+	unsigned long last_temp_measurement;
 	s32 b6; /* calculated temperature correction coefficient */
 };
 
-- 
1.7.5.4


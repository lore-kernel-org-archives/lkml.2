Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135Ab2A3WCL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 17:02:11 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:45890 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753854Ab2A3WAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 17:00:40 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 05/16] cx18: fix handling of 'radio' module parameter
Date: Mon, 30 Jan 2012 23:00:09 +0100
Message-Id: <1327960820-11867-6-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
References: <1327960820-11867-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1327960840;836e2fd0;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixed handling of 'radio' module parameter from module_param_array
to module_param_named to fix these compiler warnings in cx18-driver.c:

In function ‘__check_radio’:
113:1: warning: return from incompatible pointer type [enabled by default]
At top level:
113:1: warning: initialization from incompatible pointer type [enabled by default]
113:1: warning: (near initialization for ‘__param_arr_radio.num’) [enabled by default]

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/video/cx18/cx18-driver.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 349bd9c..27b5330 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -110,7 +110,7 @@ static int retry_mmio = 1;
 int cx18_debug;
 
 module_param_array(tuner, int, &tuner_c, 0644);
-module_param_array(radio, bool, &radio_c, 0644);
+module_param_named(radio, radio_c, bool, 0644);
 module_param_array(cardtype, int, &cardtype_c, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
-- 
1.7.7.3


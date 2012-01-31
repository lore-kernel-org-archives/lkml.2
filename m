Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2AaP1h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 10:27:37 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:37564 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753505Ab2AaP1f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 10:27:35 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Mauro Carvalho Chehab <mchehab@infradead.org>, ivtv-devel@ivtvdriver.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>, mchehab@redhat.com
Subject: [PATCH v3 2/2] ivtv-driver: fix handling of 'radio' module parameter
Date: Tue, 31 Jan 2012 16:27:08 +0100
Message-Id: <1328023628-15097-3-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.7.3
In-Reply-To: <1328023628-15097-1-git-send-email-danny.kukawka@bisect.de>
References: <1328023628-15097-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1328023655;c4c8f8f3;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverse ivtv-driver part of commit
90ab5ee94171b3e28de6bb42ee30b527014e0be7 and change
module_param_array() type from bool to int to fix
compiler warning:

In function ‘__check_radio’:
113:1: warning: return from incompatible pointer type [enabled by default]
At top level:
113:1: warning: initialization from incompatible pointer type [enabled by default]
113:1: warning: (near initialization for ‘__param_arr_radio.num’) [enabled by default]

v2: set radio_c to true instead of 1 since it's bool
v3: corrected version, don't change to module_param_named(), change 
    all to int/uint

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/video/ivtv/ivtv-driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/ivtv/ivtv-driver.c b/drivers/media/video/ivtv/ivtv-driver.c
index 3949b7d..06192ae 100644
--- a/drivers/media/video/ivtv/ivtv-driver.c
+++ b/drivers/media/video/ivtv/ivtv-driver.c
@@ -99,7 +99,7 @@ static int i2c_clock_period[IVTV_MAX_CARDS] = { -1, -1, -1, -1, -1, -1, -1, -1,
 
 static unsigned int cardtype_c = 1;
 static unsigned int tuner_c = 1;
-static bool radio_c = 1;
+static unsigned int radio_c = 1;
 static unsigned int i2c_clock_period_c = 1;
 static char pal[] = "---";
 static char secam[] = "--";
@@ -139,7 +139,7 @@ static int tunertype = -1;
 static int newi2c = -1;
 
 module_param_array(tuner, int, &tuner_c, 0644);
-module_param_array(radio, bool, &radio_c, 0644);
+module_param_array(radio, int, &radio_c, 0644);
 module_param_array(cardtype, int, &cardtype_c, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
-- 
1.7.7.3


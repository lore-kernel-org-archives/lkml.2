Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752687Ab2BVNZO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Feb 2012 08:25:14 -0500
Received: from wp188.webpack.hosteurope.de ([80.237.132.195]:38741 "EHLO
	wp188.webpack.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab2BVNZJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Feb 2012 08:25:09 -0500
From: Danny Kukawka <danny.kukawka@bisect.de>
To: Andy Walls <awalls@md.metrocast.net>
Cc: Danny Kukawka <dkukawka@suse.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        ivtv-devel@ivtvdriver.org, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rusty Russell <rusty@rustcorp.com.au>,
        mchehab@redhat.com
Subject: [RESEND][PATCH v2 1/2] cx18-driver: fix handling of 'radio' module parameter
Date: Wed, 22 Feb 2012 14:24:55 +0100
Message-Id: <1329917096-19438-2-git-send-email-danny.kukawka@bisect.de>
X-Mailer: git-send-email 1.7.8.3
In-Reply-To: <1329917096-19438-1-git-send-email-danny.kukawka@bisect.de>
References: <1329917096-19438-1-git-send-email-danny.kukawka@bisect.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-bounce-key: webpack.hosteurope.de;danny.kukawka@bisect.de;1329917109;fd5565d4;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reverse cx18-driver part of commit
90ab5ee94171b3e28de6bb42ee30b527014e0be7 and change
module_param_array() type from bool to int to fix
compiler warning:

In function ‘__check_radio’:
113:1: warning: return from incompatible pointer type [enabled by default]
At top level:
113:1: warning: initialization from incompatible pointer type [enabled by default]
113:1: warning: (near initialization for ‘__param_arr_radio.num’) [enabled by default]

v2: corrected version, don't change to module_param_named(), change
    all to int/uint

Signed-off-by: Danny Kukawka <danny.kukawka@bisect.de>
---
 drivers/media/video/cx18/cx18-driver.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/media/video/cx18/cx18-driver.c b/drivers/media/video/cx18/cx18-driver.c
index 349bd9c..9355745 100644
--- a/drivers/media/video/cx18/cx18-driver.c
+++ b/drivers/media/video/cx18/cx18-driver.c
@@ -75,7 +75,7 @@ static int radio[CX18_MAX_CARDS] = { -1, -1, -1, -1, -1, -1, -1, -1,
 				     -1, -1, -1, -1, -1, -1, -1, -1 };
 static unsigned cardtype_c = 1;
 static unsigned tuner_c = 1;
-static bool radio_c = 1;
+static unsigned radio_c = 1;
 static char pal[] = "--";
 static char secam[] = "--";
 static char ntsc[] = "-";
@@ -110,7 +110,7 @@ static int retry_mmio = 1;
 int cx18_debug;
 
 module_param_array(tuner, int, &tuner_c, 0644);
-module_param_array(radio, bool, &radio_c, 0644);
+module_param_array(radio, int, &radio_c, 0644);
 module_param_array(cardtype, int, &cardtype_c, 0644);
 module_param_string(pal, pal, sizeof(pal), 0644);
 module_param_string(secam, secam, sizeof(secam), 0644);
-- 
1.7.8.3


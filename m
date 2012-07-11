Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757631Ab2GKNuU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 09:50:20 -0400
Received: from smtp3.mundo-r.com ([212.51.32.191]:40949 "EHLO
	smtp4.mundo-r.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757478Ab2GKNuP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 09:50:15 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvwEAG6E/U9bdWOb/2dsb2JhbABFt16BB4IgAX8wbSISiBG9V5EuA5U6kAaCYQ
X-IronPort-AV: E=Sophos;i="4.77,568,1336341600"; 
   d="scan'208";a="541808124"
From: "Javier M. Mellid" <jmunhoz@igalia.com>
To: gregkh@linuxfoundation.org, gewang@siliconmotion.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        "Javier M. Mellid" <jmunhoz@igalia.com>
Subject: [PATCH 0/9] staging: sm7xxfb: code improvements and cleanup
Date: Wed, 11 Jul 2012 15:49:32 +0200
Message-Id: <1342014581-2979-1-git-send-email-jmunhoz@igalia.com>
X-Mailer: git-send-email 1.7.2.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Javier M. Mellid" <jmunhoz@igalia.com>

This patchset is part of the effort to get sm7xxfb in shape. It resolves
some issues in functions related with mode setting and timing logic
paths.

The first 5 patches work on sm712vga_setup in order to get a more
coherent and clear code.

Patches 6 and 7 work on timing path. They rename sm712_set_timing
together with the proper code relocation to ease reviewing and
maintenance.

Patch 8 erases a global variable. This patch moves pseudo palette into
smtcfb_info.

Patch 9 cleans on smtc_alloc_fb_info. This change looks for coherency
with the rest of functions.

Patches 3 and 5 warn about the same line going over 80 chars when
checked with checkpatch. I think it makes sense going over 80 chars in
this case since the readability improves.

Tested with SM712.

Javier M. Mellid (9):
  staging: sm7xxfb: fix struct names related to vesa modes
  staging: sm7xxfb: rename index var on sm712vga_setup
  staging: sm7xxfb: rename smtc_screen_info to smtc_scr_info
  staging: sm7xxfb: rename sm712vga_setup to sm7xx_vga_setup
  staging: sm7xxfb: minor maintenance on sm7xx_vga_setup
  staging: sm7xxfb: rename sm712_set_timing to sm7xx_set_timing
  staging: sm7xxfb: minor maintenance on timing path
  staging: sm7xxfb: move pseudo palette into smtcfb_info
  staging: sm7xxfb: cleanup on smtc_alloc_fb_info

 drivers/staging/sm7xxfb/sm7xxfb.c |  374 ++++++++++++++++++-------------------
 1 file changed, 183 insertions(+), 191 deletions(-)

-- 
1.7.10


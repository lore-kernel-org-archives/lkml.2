Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752842Ab1HXUCz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 16:02:55 -0400
Received: from na3sys009aog115.obsmtp.com ([74.125.149.238]:43485 "EHLO
	na3sys009aog115.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752044Ab1HXUCy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 16:02:54 -0400
From: Omar Ramirez Luna <omar.ramirez@ti.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Omar Ramirez Luna <omar.ramirez@ti.com>,
        devel <devel@driverdev.osuosl.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: tidspbridge: fix compilation on dsp clock functions
Date: Wed, 24 Aug 2011 15:07:04 -0500
Message-Id: <1314216424-28538-1-git-send-email-omar.ramirez@ti.com>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Seen on v3.1-rc3, patch:

omap: mcbsp: Drop in-driver transfer support
bafe2721a0fbd1cc1af04384133684f660f3658e

Removed code that now cause tidspbridge to break while compiling.

Signed-off-by: Omar Ramirez Luna <omar.ramirez@ti.com>
---
 drivers/staging/tidspbridge/core/dsp-clock.c |    1 -
 1 files changed, 0 insertions(+), 1 deletions(-)

diff --git a/drivers/staging/tidspbridge/core/dsp-clock.c b/drivers/staging/tidspbridge/core/dsp-clock.c
index 589a055..3d1279c 100644
--- a/drivers/staging/tidspbridge/core/dsp-clock.c
+++ b/drivers/staging/tidspbridge/core/dsp-clock.c
@@ -209,7 +209,6 @@ int dsp_clk_enable(enum dsp_clk_id clk_id)
 		break;
 #ifdef CONFIG_OMAP_MCBSP
 	case MCBSP_CLK:
-		omap_mcbsp_set_io_type(MCBSP_ID(clk_id), OMAP_MCBSP_POLL_IO);
 		omap_mcbsp_request(MCBSP_ID(clk_id));
 		omap2_mcbsp_set_clks_src(MCBSP_ID(clk_id), MCBSP_CLKS_PAD_SRC);
 		break;
-- 
1.7.0.4


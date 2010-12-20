Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757662Ab0LTNKD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Dec 2010 08:10:03 -0500
Received: from mail-ew0-f45.google.com ([209.85.215.45]:33933 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757567Ab0LTNKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Dec 2010 08:10:00 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:in-reply-to:user-agent;
        b=JO/C7LDdK9zctabM3bzR3A1rvMv09PO+Z70RHlTW3vCJGelWBxF/H2aJo8xy8hDTNS
         eF807v6PpMG3HpRgSWF5RLqk/t2OmOwFpasHIBB/7WH6AvmxGzNkB9ZC9elRMvu72WtB
         DHfkcaKQf4q2VnYhZLz9KLo2AZLC42mGTakEo=
Date: Mon, 20 Dec 2010 16:09:57 +0300
From: Alexey Charkov <alchark@gmail.com>
To: "Janorkar, Mayuresh" <mayur@ti.com>
Cc: Alexey Charkov <alchark@gmail.com>, Paul Mundt <lethal@linux-sh.org>,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "vt8500-wm8505-linux-kernel@googlegroups.com" 
	<vt8500-wm8505-linux-kernel@googlegroups.com>
Subject: [PATCH 2/2] fbdev: Modify vsync timing calculation in wm8505fb
Message-ID: <20101220130957.GB3627@alchark-u3s>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101220130314.GA3627@alchark-u3s>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This removes the '+1' in vsync timing calculation for wm8505fb to
directly use values provided from the board setup code.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/video/wm8505fb.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/video/wm8505fb.c b/drivers/video/wm8505fb.c
index 9ca9dbb..96e34a5 100644
--- a/drivers/video/wm8505fb.c
+++ b/drivers/video/wm8505fb.c
@@ -88,7 +88,7 @@ static int wm8505fb_set_timing(struct fb_info *info)
 	int v_start = info->var.upper_margin;
 	int v_end = v_start + info->var.yres;
 	int v_all = v_end + info->var.lower_margin;
-	int v_sync = info->var.vsync_len + 1;
+	int v_sync = info->var.vsync_len;
 
 	writel(0, fbi->regbase + WMT_GOVR_TG);
 
-- 
1.7.3.4


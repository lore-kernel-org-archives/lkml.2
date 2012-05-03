Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754345Ab2ECARm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 20:17:42 -0400
Received: from mail160.messagelabs.com ([216.82.253.99]:14688 "EHLO
	mail160.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2ECARl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 20:17:41 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-7.tower-160.messagelabs.com!1336004254!2701491!4
X-Originating-IP: [216.166.12.178]
X-StarScan-Version: 6.5.7; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] video: smscufx.c: local functions should not be exposed globally
Date: Wed, 2 May 2012 17:17:23 -0700
User-Agent: KMail/1.9.9
CC: <linux-fbdev@vger.kernel.org>, <steve.glendinning@smsc.com>,
        <FlorianSchandinat@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201205021717.23749.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Functions not referenced outside of a source file should be marked
static to prevent them from being exposed globally.

Quiets the sparse warnings:

warning: symbol 'ufx_handle_damage' was not declared. Should it be static?

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Steve Glendinning <steve.glendinning@smsc.com>
Cc: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>

---

diff --git a/drivers/video/smscufx.c b/drivers/video/smscufx.c
index 9985785..af3ef27 100644
--- a/drivers/video/smscufx.c
+++ b/drivers/video/smscufx.c
@@ -846,7 +846,7 @@ static void ufx_raw_rect(struct ufx_data *dev, u16 *cmd, int x, int y,
 	}
 }
 
-int ufx_handle_damage(struct ufx_data *dev, int x, int y,
+static int ufx_handle_damage(struct ufx_data *dev, int x, int y,
 	int width, int height)
 {
 	size_t packed_line_len = ALIGN((width * 2), 4);

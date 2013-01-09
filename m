Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934207Ab3AIVWz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:22:55 -0500
Received: from mail.kernel.org ([198.145.19.201]:42635 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933532Ab3AIUjR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:39:17 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Christophe TORDEUX <christophe@tordeux.net>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [ 058/123] Input: sentelic - only report position of first finger as ST coordinates
Date: Wed,  9 Jan 2013 12:34:57 -0800
Message-Id: <20130109201506.011108897@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe TORDEUX <christophe@tordeux.net>

commit a25461659050b913e114d282bf58823682eb56b6 upstream.

Report only the position of the first finger as absolute non-MT coordinates,
instead of reporting both fingers alternatively. Actual MT events are
unaffected.

This fixes horizontal and improves vertical scrolling with the touchpad.

Signed-off-by: Christophe TORDEUX <christophe@tordeux.net>
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/input/mouse/sentelic.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/input/mouse/sentelic.c
+++ b/drivers/input/mouse/sentelic.c
@@ -791,7 +791,7 @@ static psmouse_ret_t fsp_process_byte(st
 			fsp_set_slot(dev, 0, fgrs > 0, abs_x, abs_y);
 			fsp_set_slot(dev, 1, false, 0, 0);
 		}
-		if (fgrs > 0) {
+		if (fgrs == 1 || (fgrs == 2 && !(packet[0] & FSP_PB0_MFMC_FGR2))) {
 			input_report_abs(dev, ABS_X, abs_x);
 			input_report_abs(dev, ABS_Y, abs_y);
 		}



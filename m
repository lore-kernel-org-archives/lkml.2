Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1CQIrD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 04:47:03 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:62083 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab1CQIrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 04:47:01 -0400
Subject: [PATCH] vt: Add K_OFF return value to vt_ioctl KDGKBMODE
From: Arthur Taylor <art@ified.ca>
To: linux-kernel@vger.kernel.org
Cc: gregkh@suse.de
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 17 Mar 2011 01:47:32 -0700
Message-ID: <1300351652.10531.2.camel@art-x200>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


After adding support for K_OFF in KDSKBMODE, it was forgotten to
add support for returning it in KDGKBMODE.

Signed-off-by: Arthur Taylor <art@ified.ca>
---
 drivers/tty/vt/vt_ioctl.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
index 937d172..e71477a 100644
--- a/drivers/tty/vt/vt_ioctl.c
+++ b/drivers/tty/vt/vt_ioctl.c
@@ -701,6 +701,7 @@ int vt_ioctl(struct tty_struct *tty,
 		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
 				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
 				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
+				 (kbd->kbdmode == VC_OFF) ? K_OFF :
 				 K_XLATE);
 		goto setint;
 
-- 
1.7.4.1



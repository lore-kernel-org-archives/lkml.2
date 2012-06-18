Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753827Ab2FRXx3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 19:53:29 -0400
Received: from mail209.messagelabs.com ([216.82.255.3]:14348 "EHLO
	mail209.messagelabs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752883Ab2FRXx2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 19:53:28 -0400
X-Env-Sender: hartleys@visionengravers.com
X-Msg-Ref: server-2.tower-209.messagelabs.com!1340063604!6250552!3
X-Originating-IP: [216.166.12.31]
X-StarScan-Version: 6.5.10; banners=-,-,-
X-VirusChecked: Checked
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: [PATCH] staging: comedi: comedi_compat_ioctl should be NULL not 0
Date: Mon, 18 Jun 2012 16:53:17 -0700
User-Agent: KMail/1.9.9
CC: <devel@driverdev.osuosl.org>, <abbotti@mev.co.uk>,
        <fmhess@users.sourceforge.net>, <gregkh@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-ID: <201206181653.18034.hartleys@visionengravers.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When CONFIG_COMPAT is not defined, comedi_compat_ioctl should be
NULL not 0 in order to set the file_operations compat_ioctl variable
correctly.

This quiets a sparse warning about:

warning: Using plain integer as NULL pointer

Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
Cc: Ian Abbott <abbotti@mev.co.uk>
Cc: Frank Mori Hess <fmhess@users.sourceforge.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/comedi/comedi_compat32.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/comedi_compat32.h b/drivers/staging/comedi/comedi_compat32.h
index 0340a89..c99573b 100644
--- a/drivers/staging/comedi/comedi_compat32.h
+++ b/drivers/staging/comedi/comedi_compat32.h
@@ -37,7 +37,7 @@ extern long comedi_compat_ioctl(struct file *file, unsigned int cmd,
 
 #else /* CONFIG_COMPAT */
 
-#define comedi_compat_ioctl 0	/* NULL */
+#define comedi_compat_ioctl	NULL
 
 #endif /* CONFIG_COMPAT */
 
-- 
1.7.11


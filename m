Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932668Ab2DSVGX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 17:06:23 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38883 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932655Ab2DSVGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 17:06:21 -0400
Message-Id: <20120419210305.419793933@linuxfoundation.org>
User-Agent: quilt/0.60-19.1
Date: Thu, 19 Apr 2012 14:03:30 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Kukjin Kim <kgene.kim@samsung.com>
Subject: [ 27/75] serial: samsung: fix omission initialize ulcon in reset port fn()
In-Reply-To: <20120419210322.GA6478@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kukjin Kim <kgene.kim@samsung.com>

commit 7b246a1d0dfe75346a22bf6589b858a0389e6df1 upstream.

Fix omission initialize ulcon in s3c24xx_serial_resetport(),
reset port function in drivers/tty/serial/samsung.c. It has
been happened from commit 0dfb3b41("serial: samsung: merge
all SoC specific port reset functions")

Signed-off-by: Kukjin Kim <kgene.kim@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/tty/serial/samsung.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/tty/serial/samsung.c
+++ b/drivers/tty/serial/samsung.c
@@ -982,6 +982,7 @@ static void s3c24xx_serial_resetport(str
 
 	ucon &= ucon_mask;
 	wr_regl(port, S3C2410_UCON,  ucon | cfg->ucon);
+	wr_regl(port, S3C2410_ULCON, cfg->ulcon);
 
 	/* reset both fifos */
 	wr_regl(port, S3C2410_UFCON, cfg->ufcon | S3C2410_UFCON_RESETBOTH);



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498Ab0JPOsS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 10:48:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:54202 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750776Ab0JPOsQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 10:48:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=JSRoqY79tE1WQjJ0R33E7DWY/qMyz3DLp0rCzDeNs7q4D7fX+7ZpHnyxa07Ke1XNrT
         rRGfOZDhLTJ/I9X5tSFC8GzHy4325xVP3WavxEcwhrCmlooaso/VJMChLs4NkfyvKdKv
         EOA7ctGaJKANRZEy8vPFjtIVGctpoUzVGgT+Y=
Subject: [PATCH] USB: imx21-hcd - fix off by one resource size calculation
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Martin Fuzzey <mfuzzey@gmail.com>,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 16 Oct 2010 22:48:08 +0800
Message-ID: <1287240488.2831.1.camel@phoenix>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/host/imx21-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/imx21-hcd.c b/drivers/usb/host/imx21-hcd.c
index 2264c99..e49b75a 100644
--- a/drivers/usb/host/imx21-hcd.c
+++ b/drivers/usb/host/imx21-hcd.c
@@ -1906,7 +1906,7 @@ failed_clock_set:
 failed_clock_get:
 	iounmap(imx21->regs);
 failed_ioremap:
-	release_mem_region(res->start, res->end - res->start);
+	release_mem_region(res->start, resource_size(res));
 failed_request_mem:
 	remove_debug_files(imx21);
 	usb_put_hcd(hcd);
-- 
1.7.0.4




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab0KIBM5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 20:12:57 -0500
Received: from mail-gw0-f46.google.com ([74.125.83.46]:50871 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753972Ab0KIBM4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 20:12:56 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=wWllIKCzvru0LFgVSpL7xSTR7yQekO3viDX4+M/k5Wndlh64wey53Fb8obUIuLVEdI
         vKsgachyH5HvW+XzBRqrrLn3wF2IgYUbGZ7UKHzJnkkLUQJv5joWLExXiCjJYm2oBsJd
         GOu2AWx6UETxwtk3JEpD9PgMWMp06iQxgZy0g=
Subject: [PATCH] USB: isp1362-hcd - fix section mismatch warning
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Mike Frysinger <vapier@gentoo.org>,
        Lothar Wassmann <LW@KARO-electronics.de>, linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Tue, 09 Nov 2010 09:16:39 +0800
Message-Id: <1289265399.14461.1.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix section mismatch warning by using "__devinit" annotation for isp1362_probe.

WARNING: drivers/usb/host/isp1362-hcd.o(.data+0x0): Section mismatch in reference from the variable isp1362_driver to the function .init.text:isp1362_probe()
The variable isp1362_driver references
the function __init isp1362_probe()
If the reference is valid then annotate the
variable with __init* or __refdata (see linux/init.h) or name the variable:
*_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console,

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/host/isp1362-hcd.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/usb/host/isp1362-hcd.c b/drivers/usb/host/isp1362-hcd.c
index 8196fa1..97cce59 100644
--- a/drivers/usb/host/isp1362-hcd.c
+++ b/drivers/usb/host/isp1362-hcd.c
@@ -2684,7 +2684,7 @@ static int __devexit isp1362_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static int __init isp1362_probe(struct platform_device *pdev)
+static int __devinit isp1362_probe(struct platform_device *pdev)
 {
 	struct usb_hcd *hcd;
 	struct isp1362_hcd *isp1362_hcd;
-- 
1.7.2




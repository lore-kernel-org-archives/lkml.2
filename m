Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754162Ab0HQBjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 21:39:06 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:57289 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752657Ab0HQBjF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 21:39:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:content-type:date:message-id:mime-version
         :x-mailer:content-transfer-encoding;
        b=MvtmepxrOZhIUvurlSdIiCMHsXs4ioPxmnWeVXWIUl2XA3nPFD54CjRsB5ltOl85xH
         gCI/kQJjIyaNixWaEU6ECwmxfu3fF9FaC+krNuGiGvpTBSsXEcAth7tiLdy1wuxLdT79
         qRQeeRxvMRf4IGgz7dmO5dzHaM1txS9Sohjg0=
Subject: [PATCH] USB: r8a66597-udc: return -ENOMEM if kzalloc() fails
From: Axel Lin <axel.lin@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Paul Mundt <lethal@linux-sh.org>,
        linux-usb@vger.kernel.org
Content-Type: text/plain
Date: Tue, 17 Aug 2010 09:41:29 +0800
Message-Id: <1282009289.18724.0.camel@mola>
Mime-Version: 1.0
X-Mailer: Evolution 2.22.3.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Axel Lin <axel.lin@gmail.com>
---
 drivers/usb/gadget/r8a66597-udc.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/gadget/r8a66597-udc.c b/drivers/usb/gadget/r8a66597-udc.c
index 70a8178..2456ccd 100644
--- a/drivers/usb/gadget/r8a66597-udc.c
+++ b/drivers/usb/gadget/r8a66597-udc.c
@@ -1557,6 +1557,7 @@ static int __init r8a66597_probe(struct platform_device *pdev)
 	/* initialize ucd */
 	r8a66597 = kzalloc(sizeof(struct r8a66597), GFP_KERNEL);
 	if (r8a66597 == NULL) {
+		ret = -ENOMEM;
 		printk(KERN_ERR "kzalloc error\n");
 		goto clean_up;
 	}
-- 
1.7.2




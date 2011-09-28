Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1I1Xfi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 19:35:38 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53398 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754817Ab1I1WhM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:37:12 -0400
X-Mailbox-Line: From gregkh@clark.kroah.org Wed Sep 28 15:01:26 2011
Message-Id: <20110928220126.827247005@clark.kroah.org>
User-Agent: quilt/0.48-16.4
Date: Wed, 28 Sep 2011 14:59:39 -0700
From: Greg KH <gregkh@suse.de>
To: linux-kernel@vger.kernel.org, stable@kernel.org
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Yulgon Kim <yulgon.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Subject: [015/244] usb: s5p-ehci: fix a NULL pointer deference
In-Reply-To: <20110928220225.GA27128@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let us know.

------------------

From: Yulgon Kim <yulgon.kim@samsung.com>

commit e5d3d4463fb30998385f9e78ab3c7f63b5813000 upstream.

This patch fixes a NULL pointer deference. A NULL pointer
dereference happens since s5p_ehci->hcd field is not initialized
yet in probe function.

[jg1.han@samsung.com: edit commit message]
Signed-off-by: Yulgon Kim <yulgon.kim@samsung.com>
Signed-off-by: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

---
 drivers/usb/host/ehci-s5p.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/usb/host/ehci-s5p.c
+++ b/drivers/usb/host/ehci-s5p.c
@@ -86,6 +86,7 @@ static int __devinit s5p_ehci_probe(stru
 		goto fail_hcd;
 	}
 
+	s5p_ehci->hcd = hcd;
 	s5p_ehci->clk = clk_get(&pdev->dev, "usbhost");
 
 	if (IS_ERR(s5p_ehci->clk)) {



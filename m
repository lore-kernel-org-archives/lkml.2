Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933304Ab3AIVmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 16:42:15 -0500
Received: from mail.kernel.org ([198.145.19.201]:41875 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933159Ab3AIUiC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 15:38:02 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        =?UTF-8?q?Lothar=20Wa=C3=9Fmann?= <LW@KARO-electronics.de>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: [ 030/123] USB: chipidea: fix use after free bug
Date: Wed,  9 Jan 2013 12:34:29 -0800
Message-Id: <20130109201502.398469757@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130109201458.392601412@linuxfoundation.org>
References: <20130109201458.392601412@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lothar Waßmann <LW@KARO-electronics.de>

commit 98c35534420d3147553bd3071a5fc63cd56de5b1 upstream.

The pointer to a platform_device struct must not be dereferenced after
the device has been unregistered.

This bug produces a crash when unloading the ci13xxx kernel module
compiled with CONFIG_PAGE_POISONING enabled.

Signed-off-by: Lothar Waßmann <LW@KARO-electronics.de>
Acked-by: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/chipidea/core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/usb/chipidea/core.c
+++ b/drivers/usb/chipidea/core.c
@@ -385,8 +385,9 @@ EXPORT_SYMBOL_GPL(ci13xxx_add_device);
 
 void ci13xxx_remove_device(struct platform_device *pdev)
 {
+	int id = pdev->id;
 	platform_device_unregister(pdev);
-	ida_simple_remove(&ci_ida, pdev->id);
+	ida_simple_remove(&ci_ida, id);
 }
 EXPORT_SYMBOL_GPL(ci13xxx_remove_device);
 



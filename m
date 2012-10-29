Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761287Ab2J2WOT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Oct 2012 18:14:19 -0400
Received: from mail.kernel.org ([198.145.19.201]:47433 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761190Ab2J2VhH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Oct 2012 17:37:07 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        Peter Huewe <peterhuewe@gmx.de>, Chanwoo Choi <cw00.choi@samsung.com>
Subject: [ 036/101] extcon: unregister compat link on cleanup
Date: Mon, 29 Oct 2012 14:34:49 -0700
Message-Id: <20121029213244.247653489@linuxfoundation.org>
X-Mailer: git-send-email 1.7.12.2.421.g261b511
In-Reply-To: <20121029213240.128426598@linuxfoundation.org>
References: <20121029213240.128426598@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Huewe <peterhuewe@gmx.de>

commit 824a1bc045cef278aec15bef35d8d0b59ce77856 upstream.

Since extcon registers this compat link at device registration
(extcon_dev_register), we should probably remove them at deregistration/cleanup.

Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>

---
 drivers/extcon/extcon_class.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/extcon/extcon_class.c
+++ b/drivers/extcon/extcon_class.c
@@ -575,6 +575,10 @@ static void extcon_cleanup(struct extcon
 			kfree(edev->cables);
 		}
 
+#if defined(CONFIG_ANDROID)
+		if (switch_class)
+			class_compat_remove_link(switch_class, edev->dev, NULL);
+#endif
 		device_unregister(edev->dev);
 		put_device(edev->dev);
 	}



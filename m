Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757632Ab2GRAGY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 20:06:24 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48276 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757479Ab2GRAER (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 20:04:17 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Greg KH <gregkh@linuxfoundation.org>, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, alan@lxorguk.ukuu.org.uk,
        Federico Fuga <fuga@studiofuga.com>, Ohad Ben-Cohen <ohad@wizery.com>
Subject: [ 18/37] rpmsg: fix dependency on initialization order
Date: Tue, 17 Jul 2012 17:02:55 -0700
Message-Id: <20120717232432.851103872@linuxfoundation.org>
X-Mailer: git-send-email 1.7.10.1.362.g242cab3
In-Reply-To: <20120717232431.399005532@linuxfoundation.org>
References: <20120717232455.GA5994@kroah.com>
 <20120717232431.399005532@linuxfoundation.org>
User-Agent: quilt/0.60-20.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Greg KH <gregkh@linuxfoundation.org>

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Federico Fuga <fuga@studiofuga.com>

commit 9634252617441991b01dacaf4040866feecaf36f upstream.

When rpmsg drivers are built into the kernel, they must not initialize
before the rpmsg bus does, otherwise they'd trigger a BUG() in
drivers/base/driver.c line 169 (driver_register()).

To fix that, and to stop depending on arbitrary linkage ordering of
those built-in rpmsg drivers, we make the rpmsg bus initialize at
subsys_initcall.

Signed-off-by: Federico Fuga <fuga@studiofuga.com>
[ohad: rewrite the commit log]
Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/rpmsg/virtio_rpmsg_bus.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/rpmsg/virtio_rpmsg_bus.c
+++ b/drivers/rpmsg/virtio_rpmsg_bus.c
@@ -1085,7 +1085,7 @@ static int __init rpmsg_init(void)
 
 	return ret;
 }
-module_init(rpmsg_init);
+subsys_initcall(rpmsg_init);
 
 static void __exit rpmsg_fini(void)
 {



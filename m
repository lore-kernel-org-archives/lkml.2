Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757826Ab1IAO5U (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 10:57:20 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:60977 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757808Ab1IAO5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 10:57:18 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Jason Baron <jbaron@redhat.com>
Subject: [PATCH ] dynamic_debug: call __netdev_printk only for CONFIG_NET
Date: Thu, 1 Sep 2011 16:57:02 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: gregkh@suse.de, joe@perches.com, jim.cromie@gmail.com, bvanassche@acm.org,
        linux-kernel@vger.kernel.org, davem@davemloft.net,
        aloisio.almeida@openbossa.org, netdev@vger.kernel.org
References: <cover.1313085588.git.jbaron@redhat.com> <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com>
In-Reply-To: <5514795fe63ccfd4b3a80283ed04a526abe3c59d.1313085588.git.jbaron@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201109011657.02407.arnd@arndb.de>
X-Provags-ID: V02:K0:gmLp3TAasn5iM62MFNIRamxlbA1iZxsXi5GGBG7nnIo
 8edB42zdsQZfHe+mkSGHYDog+XdCeMkgItuf2E6qmvXTcyFbO8
 HMns3UPTJI/yiMTaD76XZOzQeJLCRgtcWv3t5tm284A7bACXeH
 G3HfaenR+k8iPh0V1Sq9XYc4ViMKhnkizmxsjBIrMlxh+t3Bpc
 RiMvo0eOnmNVrvtXlCfrQQVmZVSFudhBwq5/SzzdbRryhRgR1W
 GiPnSgdCs2qnKmXIBoD9q1fN4gTA8VS7M1uAK2jfBQnQu+xfFi
 qT8pVZaj/LRFf8QFLnPLv2dGLAVb+92VgG/YWb8Rvc+HPoKCFL
 3LonmUVEVf7DBtlf2pkw=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

__netdev_printk is only defined when CONFIG_NET is set. Since we only need
__dynamic_netdev_dbg for network drivers, we can make it conditional on the
same Kconfig symbol.

Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
On Thursday 11 August 2011, Jason Baron wrote:
> 
> From: Jason Baron <jbaron@redhat.com>
> 
> Previously, if dynamic debug was enabled netdev_dbg() was using
> dynamic_dev_dbg() to print out the underlying msg. Fix this by making
> sure netdev_dbg() uses __netdev_printk().
> 
> Cc: David S. Miller <davem@davemloft.net>
> Signed-off-by: Jason Baron <jbaron@redhat.com>
> ---

--- a/lib/dynamic_debug.c
+++ b/lib/dynamic_debug.c
@@ -504,6 +504,7 @@ int __dynamic_dev_dbg(struct _ddebug *descriptor,
 }
 EXPORT_SYMBOL(__dynamic_dev_dbg);
 
+#ifdef CONFIG_NET
 int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 		      const struct net_device *dev, const char *fmt, ...)
 {
@@ -527,6 +528,7 @@ int __dynamic_netdev_dbg(struct _ddebug *descriptor,
 	return res;
 }
 EXPORT_SYMBOL(__dynamic_netdev_dbg);
+#endif
 
 static __initdata char ddebug_setup_string[1024];
 static __init int ddebug_setup_query(char *str)

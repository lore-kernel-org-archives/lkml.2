Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932277Ab0FIWp0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:45:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33549 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932120Ab0FIWpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:45:22 -0400
Date: Wed, 9 Jun 2010 15:44:05 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>,
       Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 1/2 -next] of_device.h: provide struct of_device even when
 not enabled
Message-Id: <20100609154405.20095178.randy.dunlap@oracle.com>
In-Reply-To: <20100609.110638.112605100.davem@davemloft.net>
References: <20100609133443.38f1f957.sfr@canb.auug.org.au>
	<20100609103657.66252a27.randy.dunlap@oracle.com>
	<20100609.110638.112605100.davem@davemloft.net>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090204.4C10197D.00BE:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Drivers may use struct of_device (struct platform_device), even when
CONFIG_OF_DEVICE is not enabled, so minimally provide that struct
for that kconfig case.

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Grant Likely <grant.likely@secretlab.ca>
Cc:	Dave Miller <davem@davemloft.net>
---
 include/linux/of_device.h |    4 ++++
 1 file changed, 4 insertions(+)

--- linux-next-20100609.orig/include/linux/of_device.h
+++ linux-next-20100609/include/linux/of_device.h
@@ -47,6 +47,10 @@ extern ssize_t of_device_get_modalias(st
 
 extern int of_device_uevent(struct device *dev, struct kobj_uevent_env *env);
 
+#else
+
+#include <linux/platform_device.h>
+#define of_device platform_device
 
 #endif /* CONFIG_OF_DEVICE */
 

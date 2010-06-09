Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758582Ab0FIWpT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jun 2010 18:45:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33278 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757409Ab0FIWpQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jun 2010 18:45:16 -0400
Date: Wed, 9 Jun 2010 15:44:09 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: David Miller <davem@davemloft.net>,
       Grant Likely <grant.likely@secretlab.ca>
Cc: sfr@canb.auug.org.au, netdev@vger.kernel.org, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: [PATCH 2/2 -next] niu: always include of_device.h
Message-Id: <20100609154409.bf024c0c.randy.dunlap@oracle.com>
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
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090208.4C101977.0190:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

The niu driver uses struct of_device when built on any arch, not
only SPARC64, so always #include <linux/of_device.h>.

drivers/net/niu.c:9700: warning: 'struct of_device' declared inside parameter list
drivers/net/niu.c:9700: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/net/niu.c:9716: warning: assignment from incompatible pointer type

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc:	Grant Likely <grant.likely@secretlab.ca>
Cc:	Dave Miller <davem@davemloft.net>
---
 drivers/net/niu.c |    3 ---
 1 file changed, 3 deletions(-)

--- linux-next-20100609.orig/drivers/net/niu.c
+++ linux-next-20100609/drivers/net/niu.c
@@ -28,10 +28,7 @@
 #include <linux/slab.h>
 
 #include <linux/io.h>
-
-#ifdef CONFIG_SPARC64
 #include <linux/of_device.h>
-#endif
 
 #include "niu.h"
 

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932584Ab0D3RMe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:12:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45599 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932698Ab0D3RIe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:08:34 -0400
Date: Fri, 30 Apr 2010 10:07:12 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: lkml <linux-kernel@vger.kernel.org>
Cc: linux-next@vger.kernel.org, Bob Beers <bob.beers@gmail.com>,
       gregkh@suse.de
Subject: [PATCH -next] staging/cxt1e1: use netdev_priv to fix build
Message-Id: <20100430100712.041f6fcc.randy.dunlap@oracle.com>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-CT-RefId: str=0001.0A090207.4BDB0E8A.007D:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <randy.dunlap@oracle.com>

Fix cxt1e1 build error:
drivers/staging/cxt1e1/linux.c:1195: error: 'struct net_device' has no member named 'priv'

Signed-off-by: Randy Dunlap <randy.dunlap@oracle.com>
Cc: Bob Beers <bob.beers@gmail.com>
---
 drivers/staging/cxt1e1/linux.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- linux-next-20100430.orig/drivers/staging/cxt1e1/linux.c
+++ linux-next-20100430/drivers/staging/cxt1e1/linux.c
@@ -1192,7 +1192,7 @@ c4_add_dev (hdw_info_t * hi, int brdno, 
                 hi->devname, irq1);
         unregister_netdev (ndev);
         free_irq (irq0, ndev);
-        OS_kfree (ndev->priv);
+        OS_kfree (netdev_priv(ndev));
         OS_kfree (ndev);
         error_flag = EIO;
         return 0;

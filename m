Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573Ab0IQFFt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Sep 2010 01:05:49 -0400
Received: from mx1.vsecurity.com ([209.67.252.12]:49798 "EHLO
	mx1.vsecurity.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0IQFFs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Sep 2010 01:05:48 -0400
Subject: [PATCH v3] drivers/net/tulip/de4x5.c: fix union member name in
 DE4X5_GET_REG ioctl
From: Dan Rosenberg <drosenberg@vsecurity.com>
To: David Miller <davem@davemloft.net>
Cc: grundler@parisc-linux.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, kyle@mcmartin.ca, jeffm@suse.com,
        security@kernel.org
In-Reply-To: <20100916.215313.180410528.davem@davemloft.net>
References: <1284586998.6275.94.camel@dan>
	 <20100916.215313.180410528.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Sep 2010 01:05:44 -0400
Message-ID: <1284699944.2565.4.camel@dan>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now with descriptive title, as requested.

This was previously reported as a security issue due to leakage of
uninitialized stack memory.  Jeff Mahoney pointed out that this is
incorrect since the copied data is from a union (rather than a struct).
Therefore, this patch is only under consideration for the sake of
correctness, and is not security relevant. 

Signed-off-by: Dan Rosenberg <dan.j.rosenberg@gmail.com>
Acked-by: Grant Grundler <grundler@parisc-linux.org>

--- linux-2.6.35.4.orig/drivers/net/tulip/de4x5.c       2010-08-26 19:47:12.000000000 -0400
+++ linux-2.6.35.4/drivers/net/tulip/de4x5.c    2010-09-14 21:26:52.499474207 -0400
@@ -5474,7 +5474,7 @@ de4x5_ioctl(struct net_device *dev, stru
        tmp.lval[6] = inl(DE4X5_STRR); j+=4;
        tmp.lval[7] = inl(DE4X5_SIGR); j+=4;
        ioc->len = j;
-       if (copy_to_user(ioc->data, tmp.addr, ioc->len)) return -EFAULT;
+       if (copy_to_user(ioc->data, tmp.lval, ioc->len)) return -EFAULT;
        break;
 
 #define DE4X5_DUMP              0x0f /* Dump the DE4X5 Status */







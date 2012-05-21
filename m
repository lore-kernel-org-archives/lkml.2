Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757996Ab2EUOMG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 10:12:06 -0400
Received: from stargate.chelsio.com ([67.207.112.58]:13517 "EHLO
	stargate.chelsio.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757034Ab2EUOMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 10:12:03 -0400
Message-ID: <4FBA4B84.9030302@chelsio.com>
Date: Mon, 21 May 2012 19:34:52 +0530
From: Vipul Pandya <vipul@chelsio.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Roland Dreier <roland@kernel.org>, linux-rdma@vger.kernel.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steve Wise <swise@opengridcomputing.com>
Subject: Re: linux-next: build failure after merge of the infiniband tree
References: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au>
In-Reply-To: <20120521120512.15f1e9dfc961b05dfee72f79@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 21 May 2012 14:04:56.0722 (UTC) FILETIME=[B3D41F20:01CD375A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 21-05-2012 07:35, Stephen Rothwell wrote:

> Hi all,
> 
> After merging the infiniband tree, today's linux-next build (powerpc
> ppc64_defconfig) failed like this:
> 
> drivers/infiniband/hw/cxgb4/device.c: In function 'qp_release':
> drivers/infiniband/hw/cxgb4/device.c:124:2: error: implicit declaration of function 'vfree' [-Werror=implicit-function-declaration]
> drivers/infiniband/hw/cxgb4/device.c: In function 'qp_open':
> drivers/infiniband/hw/cxgb4/device.c:148:2: error: implicit declaration of function 'vmalloc' [-Werror=implicit-function-declaration]
> drivers/infiniband/hw/cxgb4/device.c:148:11: warning: assignment makes pointer from integer without a cast [enabled by default]
> 
> Caused by commit d716a2a014ad ("RDMA/cxgb4: Use vmalloc() for debugfs QP
> dump").  See Rule 1 in Documentation/SubmitChecklist.
> 
> I have used the infiniband tree from next-20120518 for today.
> 


Hi Stephen,

Below patch should resolve this issue.

>From 433d2002d3ba2119146fdec6e0a97b67834df960 Mon Sep 17 00:00:00 2001
From: Vipul Pandya <vipul@chelsio.com>
Date: Mon, 21 May 2012 17:31:13 +0530
Subject: [PATCH] RDMA/cxgb4: Include vmalloc.h for vmalloc and vfree

Signed-off-by: Vipul Pandya <vipul@chelsio.com>
---
 drivers/infiniband/hw/cxgb4/device.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/device.c
b/drivers/infiniband/hw/cxgb4/device.c
index c8fd1d8..cb4ecd7 100644
--- a/drivers/infiniband/hw/cxgb4/device.c
+++ b/drivers/infiniband/hw/cxgb4/device.c
@@ -32,6 +32,7 @@
 #include <linux/module.h>
 #include <linux/moduleparam.h>
 #include <linux/debugfs.h>
+#include <linux/vmalloc.h>

 #include <rdma/ib_verbs.h>

--

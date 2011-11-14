Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755540Ab1KNXML (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Nov 2011 18:12:11 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:39336 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751592Ab1KNXMJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Nov 2011 18:12:09 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Stephen Rothwell <sfr@canb.auug.org.au>, Tejun Heo <tj@kernel.org>
Subject: Re: linux-next: build failure after merge of the pm tree (and warning)
Date: Tue, 15 Nov 2011 00:14:50 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Vinod Koul <vinod.koul@intel.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Dan Williams <dan.j.williams@intel.com>
References: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au>
In-Reply-To: <20111114131730.ae09bb18b87e67f61a97275e@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201111150014.50898.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 14, 2011, Stephen Rothwell wrote:
> Hi Rafael,
> 
> After merging the pm tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
> 
> drivers/dma/dmatest.c: In function 'dmatest_func':
> drivers/dma/dmatest.c:255:2: error: implicit declaration of function 'set_freezable_with_signal' [-Werror=implicit-function-declaration]
> 
> Caused by commit cd3bc8fbc2d5 ("freezer: kill unused
> set_freezable_with_signal()") interacting with commit 981ed70d8e4f
> ("dmatest: make dmatest threads freezable") from Linus' tree (merged into
> v3.2-rc1).
> 
> I reverted the pm tree commit for today.

Thanks, I've added the following patch to linux-pm/linux-next, which should
fix this problem (Tejun, if that's not the right thing to do, please let me
know).

Rafael


---
From: Rafael J. Wysocki <rjw@sisk.pl>
Subject: Freezer: Make dmatest_func() use set_freezable()

According to the commit cd3bc8fbc2d55ae0918184fb34992054dc4eb710
(freezer: kill unused set_freezable_with_signal()) changelog,
it should be sufficient to use set_freezable() instead of
set_freezable_with_signal(), which has been removed, in
dmatest_func(), so do that and fix a build issue.

Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>
---
 drivers/dma/dmatest.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

Index: linux/drivers/dma/dmatest.c
===================================================================
--- linux.orig/drivers/dma/dmatest.c
+++ linux/drivers/dma/dmatest.c
@@ -252,7 +252,7 @@ static int dmatest_func(void *data)
 	int			i;
 
 	thread_name = current->comm;
-	set_freezable_with_signal();
+	set_freezable();
 
 	ret = -ENOMEM;
 

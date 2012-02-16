Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753386Ab2BPFl7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 00:41:59 -0500
Received: from rcsinet15.oracle.com ([148.87.113.117]:42739 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752842Ab2BPFlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 00:41:25 -0500
From: Yinghai Lu <yinghai@kernel.org>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Yinghai Lu <yinghai@kernel.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: [PATCH 4/4] PCI: quirk print dev name with duration
Date: Wed, 15 Feb 2012 21:40:32 -0800
Message-Id: <1329370832-2253-5-git-send-email-yinghai@kernel.org>
X-Mailer: git-send-email 1.7.7
In-Reply-To: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
References: <1329370832-2253-1-git-send-email-yinghai@kernel.org>
X-Source-IP: ucsinet22.oracle.com [156.151.31.94]
X-CT-RefId: str=0001.0A090205.4F3C96FA.0007,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So could find out which device is involved with the calling

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Cc: Arjan van de Ven <arjan@infradead.org>

---
 drivers/pci/quirks.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/pci/quirks.c
===================================================================
--- linux-2.6.orig/drivers/pci/quirks.c
+++ linux-2.6/drivers/pci/quirks.c
@@ -2854,14 +2854,15 @@ static void do_one_fixup_debug(void (*fn
 	ktime_t calltime, delta, rettime;
 	unsigned long long duration;
 
-	printk(KERN_DEBUG "calling  %pF @ %i\n", fn, task_pid_nr(current));
+	printk(KERN_DEBUG "calling  %pF @ %i for %s\n",
+			fn, task_pid_nr(current), dev_name(&dev->dev));
 	calltime = ktime_get();
 	fn(dev);
 	rettime = ktime_get();
 	delta = ktime_sub(rettime, calltime);
 	duration = (unsigned long long) ktime_to_ns(delta) >> 10;
-	printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs\n", fn,
-		duration);
+	printk(KERN_DEBUG "pci fixup %pF returned after %lld usecs for %s\n",
+			fn, duration, dev_name(&dev->dev));
 }
 
 /*

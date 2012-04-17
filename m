Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755760Ab2DPWCG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 18:02:06 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:36288 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755604Ab2DPWB3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 18:01:29 -0400
Message-ID: <4F8CC0ED.2000006@xenotime.net>
Date: Mon, 16 Apr 2012 18:01:33 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        netdev@vger.kernel.org, linux-hippi@sunsite.dk,
        Jes Sorensen <jes@trained-monkey.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH -next] hippi: fix printk format in rrunner.c
References: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
In-Reply-To: <20120416161121.261ba4e7e38989173accfb16@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Randy Dunlap <rdunlap@xenotime.net>

Fix printk format warning (from i386 build):

drivers/net/hippi/rrunner.c:146:9: warning: format '%08llx' expects type 'long long unsigned int', but argument 3 has type 'resource_size_t'

Signed-off-by: Randy Dunlap <rdunlap@xenotime.net>
Cc: Jes Sorensen <jes@trained-monkey.org>
Cc:	linux-hippi@sunsite.dk
---
 drivers/net/hippi/rrunner.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- linux-next-20120416.orig/drivers/net/hippi/rrunner.c
+++ linux-next-20120416/drivers/net/hippi/rrunner.c
@@ -142,8 +142,9 @@ static int __devinit rr_init_one(struct
 	pci_set_master(pdev);
 
 	printk(KERN_INFO "%s: Essential RoadRunner serial HIPPI "
-	       "at 0x%08llx, irq %i, PCI latency %i\n", dev->name,
-	       pci_resource_start(pdev, 0), pdev->irq, pci_latency);
+	       "at 0x%llx, irq %i, PCI latency %i\n", dev->name,
+	       (unsigned long long)pci_resource_start(pdev, 0),
+	       pdev->irq, pci_latency);
 
 	/*
 	 * Remap the MMIO regs into kernel space.

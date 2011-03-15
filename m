Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab1COG2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Mar 2011 02:28:37 -0400
Received: from chilli.pcug.org.au ([203.10.76.44]:36829 "EHLO smtps.tip.net.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1COG2f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Mar 2011 02:28:35 -0400
Date: Tue, 15 Mar 2011 17:28:33 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: linux-next: manual merge of the xen-two tree with the tip tree
Message-Id: <20110315172833.4fd17a0c.sfr@canb.auug.org.au>
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Konrad,

Today's linux-next merge of the xen-two tree got a conflict in
arch/x86/pci/xen.c between commit 2c778651f73d ("x86: Cleanup the genirq
name space") from the tip tree and commit bf480d952bcf ("xen: events:
separate MSI PIRQ allocation from PIRQ binding to IRQ") from the xen-two
tree.  Commit f420e010edd8 ("xen: events: push set_irq_msi down into
xen_create_msi_irq") then moved the code modified by the tip tree commit
into drivers/xen/events.c.

I fixed it up (I think - see below) and can carry the fix as necessary (I
used the xen-two tree's version of arch/x86/pci/xen.c).
-- 
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au

diff --git a/drivers/xen/events.c b/drivers/xen/events.c
index 62e5237..934a3b1 100644
--- a/drivers/xen/events.c
+++ b/drivers/xen/events.c
@@ -692,7 +692,7 @@ int xen_bind_pirq_msi_to_irq(struct pci_dev *dev, struct msi_desc *msidesc,
 				      handle_level_irq, name);
 
 	xen_irq_info_pirq_init(irq, 0, pirq, 0, vector, 0);
-	ret = set_irq_msi(irq, msidesc);
+	ret = irq_set_msi_desc(irq, msidesc);
 	if (ret < 0)
 		goto error_irq;
 out:
-- 
1.7.4.1


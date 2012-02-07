Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755401Ab2BGQ7u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 11:59:50 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47675 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752090Ab2BGQ7t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 11:59:49 -0500
Date: Tue, 7 Feb 2012 16:59:44 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Matthias Schniedermeyer <ms@citd.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Linux 3.2.5
Message-ID: <20120207165944.GA30442@srcf.ucam.org>
References: <20120206181622.GA28811@kroah.com>
 <20120207084037.GA6140@citd.de>
 <4F30FABF.4060409@ladisch.de>
 <20120207105835.GA12864@citd.de>
 <4F310DBC.1040501@ladisch.de>
 <20120207114806.GA15323@citd.de>
 <4F3118F7.8050205@ladisch.de>
 <CA+55aFxLKAN7rBWo_5oFNJdvaDfvvJydgmaHYPF5JQ_enDPe+Q@mail.gmail.com>
 <20120207165416.GA27342@citd.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207165416.GA27342@citd.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok. Can you try this?

diff --git a/drivers/pci/pcie/aspm.c b/drivers/pci/pcie/aspm.c
index 1cfbf22..24f049e 100644
--- a/drivers/pci/pcie/aspm.c
+++ b/drivers/pci/pcie/aspm.c
@@ -500,6 +500,9 @@ static int pcie_aspm_sanity_check(struct pci_dev *pdev)
 	int pos;
 	u32 reg32;
 
+	if (aspm_disabled)
+		return 0;
+
 	/*
 	 * Some functions in a slot might not all be PCIe functions,
 	 * very strange. Disable ASPM for the whole slot

-- 
Matthew Garrett | mjg59@srcf.ucam.org

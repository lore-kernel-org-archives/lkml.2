Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754440Ab2BFBhC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 20:37:02 -0500
Received: from mga01.intel.com ([192.55.52.88]:27716 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753436Ab2BFBhA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 20:37:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="114414677"
Subject: Re: Regression 3.2 -> 3.3-rc1 10 sec hang at boot and resume,
 COMRESET failed
From: Lin Ming <ming.m.lin@intel.com>
To: Norbert Preining <preining@logic.at>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, jeff@garzik.org,
        Tejun Heo <tj@kernel.org>,
        "stern@rowland.harvard.edu >> Alan Stern" <stern@rowland.harvard.edu>,
        linux-ide@vger.kernel.org,
        Linux PM mailing list <linux-pm@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>
In-Reply-To: <20120206004608.GA9413@gamma.logic.tuwien.ac.at>
References: <20120202051258.GA15550@gamma.logic.tuwien.ac.at>
	 <4F2A4B7E.2090503@linux.vnet.ibm.com> <1328231716.15079.15.camel@minggr>
	 <1328242884.15079.22.camel@minggr>
	 <20120203052452.GC24563@gamma.logic.tuwien.ac.at>
	 <1328247269.15079.26.camel@minggr>
	 <20120203054319.GA25510@gamma.logic.tuwien.ac.at>
	 <1328257660.15079.30.camel@minggr>
	 <20120206004608.GA9413@gamma.logic.tuwien.ac.at>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 06 Feb 2012 09:36:58 +0800
Message-ID: <1328492218.15079.38.camel@minggr>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-02-06 at 09:46 +0900, Norbert Preining wrote:
> Hi Lin,
> 
> 
> sorry for the delay, weekend I was off ...
> 
> On Fr, 03 Feb 2012, Lin Ming wrote:
> > > Confirmed. Reverted 7faa33da9b7 on top of 6c073a7ee250 made
> > > the boot delay go away. dmesg from this boot attached.
> > 
> > Dig into the code, but I can't find where the problem is.
> > 
> > Anyway, does below DEBUG patch help?
> > Let's always stop the engine during hard reset.
> 
> If you meant: 
>   "Try that patch on top of HEAD *without* reverting 7faa33da9b7?"
> then I can report that it does NOT help. With *only* this patch I still
> get 10sec delay, and otherwise nothing changes.

Does below help?

diff --git a/drivers/ata/libahci.c b/drivers/ata/libahci.c
index a72bfd0..33f7333 100644
--- a/drivers/ata/libahci.c
+++ b/drivers/ata/libahci.c
@@ -746,6 +746,9 @@ static void ahci_start_port(struct ata_port *ap)
 	/* enable FIS reception */
 	ahci_start_fis_rx(ap);
 
+	/* enable DMA */
+	ahci_start_engine(ap);
+
 	/* turn on LEDs */
 	if (ap->flags & ATA_FLAG_EM) {
 		ata_for_each_link(link, ap, EDGE) {





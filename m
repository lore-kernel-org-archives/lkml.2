Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760607Ab2DLRAQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 13:00:16 -0400
Received: from utopia.booyaka.com ([72.9.107.138]:53122 "EHLO
	utopia.booyaka.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754962Ab2DLRAN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 13:00:13 -0400
Date: Thu, 12 Apr 2012 11:00:12 -0600 (MDT)
From: Paul Walmsley <paul@pwsan.com>
To: "Mohammed, Afzal" <afzal@ti.com>
cc: Greg KH <greg@kroah.com>, "Shilimkar, Santosh" <santosh.shilimkar@ti.com>,
        "V, Aneesh" <aneesh@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "mgreer@animalcreek.com" <mgreer@animalcreek.com>,
        "msalter@redhat.com" <msalter@redhat.com>
Subject: RE: [PATCH v4 0/7] Add TI EMIF SDRAM controller driver
In-Reply-To: <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
Message-ID: <alpine.DEB.2.00.1204121053570.29473@utopia.booyaka.com>
References: <1331934707-29487-1-git-send-email-aneesh@ti.com> <alpine.DEB.2.00.1204112042070.29473@utopia.booyaka.com> <20120412030044.GA26236@kroah.com> <4F867A95.9030104@ti.com> <20120412131045.GB31384@kroah.com>
 <C8443D0743D26F4388EA172BF4E2A7A93E95947E@DQHE04.ent.ti.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi

On Thu, 12 Apr 2012, Mohammed, Afzal wrote:

> On Thu, Apr 12, 2012 at 18:40:45, Greg KH wrote:
> > On Thu, Apr 12, 2012 at 12:17:49PM +0530, Santosh Shilimkar wrote:
> > > I was hoping that we will have some thing like drivers/memory/*
> > > but since it doesn't exist, we used drivers/misc.
> > 
> > Why not create it?  I have no objection to that, it makes it more
> > obvious as to what this really is.
> 
> There is another memory controller used in a few TI SoCs,
> namely GPMC [1], do you prefer having it too there.
> 
> As of now it is not a driver, platform code handles GPMC, a patch
> series for converting it into a driver (but still residing in
> platform folder) was sent a few days back [2,3].

Probably the GPMC driver should go into a slightly different place than 
SDRC/EMIF.  

GPMC is actually a general-purpose parallel bus driver.  It's used to 
interface Ethernet controllers, UARTs, FPGAs, NAND/NOR flash, SRAM, etc.  
It cannot be used to control DRAM, at least not without a separate DRAM 
controller chip.

SDRC/EMIF are both DRAM controllers.  That's all they do.  They can't be 
used to control anything else.  They implement DRAM refresh, etc.

So perhaps something like drivers/memory/dram/ for the SDRAM controllers, 
and maybe drivers/memory/ for the GPMC?


- Paul

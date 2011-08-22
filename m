Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756822Ab1HVKqd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 06:46:33 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:37698 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751539Ab1HVKq3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 06:46:29 -0400
Date: Mon, 22 Aug 2011 06:46:21 -0400
From: Neil Horman <nhorman@tuxdriver.com>
To: "Roedel, Joerg" <Joerg.Roedel@amd.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Divy LeRay <divy@chelsio.com>, Stanislaw Gruszka <sgruszka@redhat.com>,
        Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] dma-debug: hash_bucket_find needs to allow for offsets
 within an entry (v2)
Message-ID: <20110822104621.GA12337@hmsreliant.think-freely.org>
References: <1311097278-30841-1-git-send-email-nhorman@tuxdriver.com>
 <20110808191354.GA22117@hmsreliant.think-freely.org>
 <20110810133158.GB7598@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110810133158.GB7598@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Score: 0.2 (/)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 03:31:59PM +0200, Roedel, Joerg wrote:
> On Mon, Aug 08, 2011 at 03:13:54PM -0400, Neil Horman wrote:
> > dma-debug: hash_bucket_find needs to allow for offsets within an entry (v2)
> > 
> > Summary:
> > Users of the pci_dma_sync_single_* api allow users to sync address ranges within
> > the range of a mapped entry (i.e. you can dma map address X to dma_addr_t A and
> > then pci_dma_sync_single on dma_addr_t A+1.  The dma-debug library however
> > assume dma syncs will always occur using the base address of a mapped region,
> > and uses that assumption to find entries in its hash table.  Since thats often
> > (but not always the case), the dma debug library can give us false errors about
> > missing entries, which are reported as syncing of memory not allocated by the
> > driver.  This was noted in the cxgb3 driver as this error:
> 
> Hi Neil,
> 
> thanks for your patch. Im out-of-office this week and traveling next
> week. So it may take a couple of days until I can take an in-depth look
> at it. But I get to it as soon as I can :-)
> 
> Regards,
> 
> 	Joerg
> 
Hey, Jeorg, just wondering if you managed to get a look at this?
Neil

> -- 
> AMD Operating System Research Center
> 
> Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

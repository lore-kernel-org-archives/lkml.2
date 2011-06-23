Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758802Ab1FWDPk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 23:15:40 -0400
Received: from mga02.intel.com ([134.134.136.20]:8876 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758190Ab1FWDPj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 23:15:39 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,410,1304319600"; 
   d="scan'208";a="18574543"
Date: Thu, 23 Jun 2011 11:21:03 +0800
From: Feng Tang <feng.tang@intel.com>
To: Dirk Brandewie <dirk.brandewie@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "spi-devel-general@lists.sourceforge.net" 
	<spi-devel-general@lists.sourceforge.net>
Subject: Re: [PATCH 08/11] spi-dw: Ensure fifo lenght is set.
Message-ID: <20110623112103.0434c73d@feng-i7>
In-Reply-To: <4E02AC85.90300@gmail.com>
References: <1308794413-11069-1-git-send-email-dirk.brandewie@gmail.com>
	<1308794413-11069-9-git-send-email-dirk.brandewie@gmail.com>
	<20110623104144.024cc955@feng-i7>
	<4E02AC85.90300@gmail.com>
Organization: intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.22.0; i486-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 23 Jun 2011 11:01:25 +0800
Dirk Brandewie <dirk.brandewie@gmail.com> wrote:


> >> -	/*
> >> -	 * Try to detect the FIFO depth if not set by interface
> >> driver,
> >> -	 * the depth could be from 2 to 256 from HW spec
> >> -	 */
> >> -	if (!dws->fifo_len) {
> >> -		u32 fifo;
> >> -		for (fifo = 2; fifo<= 257; fifo++) {
> >> -			dw_writew(dws, txfltr, fifo);
> >> -			if (fifo != dw_readw(dws, txfltr))
> >> -				break;
> >> -		}
> >> -
> >> -		dws->fifo_len = (fifo == 257) ? 0 : fifo;
> >> -		dw_writew(dws, txfltr, 0);
> >> -	}
> >>   }
> >
> > This code is requested by other community developers, the FIFO
> > length is adjustable for the dw_spi core when deployed on
> > different platforms, for those who are not certain about the
> > FIFO len, they can use this code to probe the FIFO len.
> >
> > So we need to keep it.
> >
> 
> Then I have bad documentation because document I have says that you
> can NOt write to txfltr while the controller is enabled.  The sizing
> routine as it stands can't work for the implementation in Moorsetown
> and Medfield.
> 
> If there are other SOC's that are implementing different semantics
> for txfltr we will need to handle this differently and do some
> runtime detection of how the fifo should be sized.
> 
> Can you give ne a reference to the person that requiested the sizing
> code so I can follow-up

Git-show c587b6fa0510

commit c587b6fa05106606053fc5e8e344f07cd34ace23
Author: Feng Tang <feng.tang@intel.com>
Date:   Thu Jan 21 10:41:10 2010 +0800

    spi/dw_spi: add a FIFO depth detection

    FIFO depth is configurable for each implementation of DW core,
    so add a depth detection for those interface drivers who don't set
    the fifo_len explicitly

    Signed-off-by: Feng Tang <feng.tang@intel.com>
    Acked-by: Jean-Hugues Deschenes <jean-hugues.deschenes@octasic.com>
    Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

I added the code per request from Jean-Hugues Deschenes.

Recently Alek Du has tested this code on his Medfield platform.

Thanks,
Feng

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757458Ab1CAUqH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:46:07 -0500
Received: from cantor2.suse.de ([195.135.220.15]:51816 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757208Ab1CAUqG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:46:06 -0500
Date: Tue, 1 Mar 2011 15:46:12 -0500
From: Greg KH <gregkh@suse.de>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org,
        Don Skidmore <donald.c.skidmore@intel.com>,
        Milton Miller <miltonm@bga.com>,
        "David S. Miller" <davem@davemloft.net>,
        Anton Blanchard <anton@samba.org>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable-review@kernel.org,
        alan@lxorguk.ukuu.org.uk, Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: Re: [Stable-review] [22/68] ixgbe: prevent speculative processing
 of descriptors before ready
Message-ID: <20110301204612.GA16194@suse.de>
References: <20110228162407.878045010@clark.kroah.org>
 <1298945674.3069.188.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1298945674.3069.188.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 01, 2011 at 02:14:33AM +0000, Ben Hutchings wrote:
> On Mon, 2011-02-28 at 08:22 -0800, Greg KH wrote:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: Milton Miller <miltonm@bga.com>
> > 
> > commit 3c945e5b3719bcc18c6ddd31bbcae8ef94f3d19a upstream.
> > 
> > The PowerPC architecture does not require loads to independent bytes to be
> > ordered without adding an explicit barrier.
> > 
> > In ixgbe_clean_rx_irq we load the status bit then load the packet data.
> > With packet split disabled if these loads go out of order we get a
> > stale packet, but we will notice the bad sequence numbers and drop it.
> > 
> > The problem occurs with packet split enabled where the TCP/IP header and data
> > are in different descriptors. If the reads go out of order we may have data
> > that doesn't match the TCP/IP header. Since we use hardware checksumming this
> > bad data is never verified and it makes it all the way to the application.
> [...]
> 
> Packet splitting should be completely disabled on the 82599, anyway.
> Greg, what happened to this patch:
> 
> commit a124339ad28389093ed15eca990d39c51c5736cc
> Author: Don Skidmore <donald.c.skidmore@intel.com>
> Date:   Tue Jan 18 22:53:47 2011 +0000
> 
>     ixgbe: fix for 82599 erratum on Header Splitting
>     
>     We have found a hardware erratum on 82599 hardware that can lead to
>     unpredictable behavior when Header Splitting mode is enabled.  So
>     we are no longer enabling this feature on affected hardware.
>     
>     Please see the 82599 Specification Update for more information.
>     
>     CC: stable@kernel.org
>     Signed-off-by: Don Skidmore <donald.c.skidmore@intel.com>
>     Tested-by: Stephen Ko <stephen.s.ko@intel.com>
>     Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>

It does not apply to the .32 kernel.

Care to provide a backport if you feel it should be there?

thanks,

greg k-h

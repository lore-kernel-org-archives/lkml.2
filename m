Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932247Ab1KIQeU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 11:34:20 -0500
Received: from mail.solarflare.com ([216.237.3.220]:29987 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752748Ab1KIQeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 11:34:19 -0500
Message-ID: <1320856444.18929.78.camel@deadeye>
Subject: Re: [PATCH] drivers/net/usb/asix:  resync from vendor's copy
From: Ben Hutchings <bhutchings@solarflare.com>
To: Mark Lord <kernel@teksavvy.com>
CC: David Miller <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Wed, 9 Nov 2011 16:34:04 +0000
In-Reply-To: <4EBAA967.10403@teksavvy.com>
References: <4EA89972.5060101@teksavvy.com>
	  <20111026.194045.2019668159403582571.davem@davemloft.net>
	  <4EA8B283.3010105@teksavvy.com>
	  <20111026.221719.2216112919297458522.davem@davemloft.net>
	  <4EB19BBE.5050602@teksavvy.com> <1320266549.2782.21.camel@bwh-desktop>
	 <4EBAA967.10403@teksavvy.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3-2 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.500.1024-18502.005
X-TM-AS-Result: No--15.525300-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-OriginalArrivalTime: 09 Nov 2011 16:34:19.0107 (UTC) FILETIME=[6DB00B30:01CC9EFD]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 11:25 -0500, Mark Lord wrote:
> On 11-11-02 04:42 PM, Ben Hutchings wrote:
> > On Wed, 2011-11-02 at 15:36 -0400, Mark Lord wrote:
> > [...]
> >> First cut (for review) at updating the in-kernel asix usb/network driver
> >> from the latest vendor GPL version of the driver, obtained from here:
> >>
> >>   http://www.asix.com.tw/download.php?sub=searchresult&PItemID=84&download=driver
> ..
> >> --- linux-3.0/drivers/net/usb/asix.c	2011-10-12 17:59:03.000000000 -0400
> >> +++ linux/drivers/net/usb/asix.c	2011-11-01 19:00:50.051289683 -0400
> > [...]
> ...
> >> +	.set_tx_csum		= ax88772b_set_tx_csum,
> >> +	.get_tx_csum		= ax88772b_get_tx_csum,
> >> +	.get_rx_csum		= ax88772b_get_rx_csum,
> >> +	.set_rx_csum		= ax88772b_set_rx_csum,
> >> +};
> > 
> > The various ethtool operations for offload flags are being (or have
> > been) removed.  The driver must set net_device::hw_features and
> > implement net_device_ops::ndo_set_features instead.
> 
> Okay, I see what to do for the rx_csum stuff, based on other drivers.
> 
> But is there anything to replace the tx_csum stuff,
> or should I just remove it entirely without a substitute?

If TX checksum offload only needs to be requested in TX descriptors and
not in a configuration register, then you don't need to do anything when
it's enabled or disabled.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.


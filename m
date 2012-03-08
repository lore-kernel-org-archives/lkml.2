Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759244Ab2CHWs6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 17:48:58 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:49502 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759217Ab2CHWsx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 17:48:53 -0500
Date: Thu, 8 Mar 2012 14:48:49 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Roland Stigge <stigge@antcom.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, w.sang@pengutronix.de,
        kevin.wells@nxp.com, linux-arm-kernel@lists.infradead.org,
        arnd@arndb.de
Subject: Re: [PATCH v4] USB: Support for LPC32xx SoC
Message-ID: <20120308224849.GA32667@kroah.com>
References: <1331244574-32570-1-git-send-email-stigge@antcom.de>
 <20120308222234.GA25576@kroah.com>
 <4F593652.90809@antcom.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F593652.90809@antcom.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 08, 2012 at 11:44:34PM +0100, Roland Stigge wrote:
> Hi,
> 
> On 08/03/12 23:22, Greg Kroah-Hartman wrote:
> > So, should this function just be called something else, for the type of
> > hardware (lpc32xx?), and then do this check within the function?
> 
> Right. LPC32xx and PNX4008 seem to share much of the functionality but
> they don't share the bits() part. How about renaming (the static)
> 
> pnx4008_set_usb_bits()
> pnx4008_unset_usb_bits()
> 
> to
> 
> set_usb_bits()
> unset_usb_bits()
> 
> and internally doing machine_is_pnx4008() dependent stuff?
> 
> Regarding the other pnx4008_*() functions that are shared with lpc32xx,
> they only inherit the name for historical reasons. Which naming scheme
> should apply here if change is due? One common name between those two
> would be "nxp". We could replace everything common between pnx4008 and
> lpc32xx with nxp (including ths driver name) and handle the small
> pnx4008-specific stuff via machine_is_pnx4008().

That sounds more reasonable, right?  But do it in at least two patches
to make things obvious as to what is happening.

thanks,

greg k-h

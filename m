Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753223Ab1C1Iqc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 04:46:32 -0400
Received: from na3sys009aog110.obsmtp.com ([74.125.149.203]:58621 "EHLO
	na3sys009aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752553Ab1C1Iqb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 04:46:31 -0400
Date: Mon, 28 Mar 2011 11:46:25 +0300
From: Felipe Balbi <balbi@ti.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, gregkh@suse.de, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/5 v6] usb: Add usb_endpoint_descriptor to be part of
 the struct usb_ep
Message-ID: <20110328084624.GI2251@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <1300867420-20864-1-git-send-email-tlinder@codeaurora.org>
 <20110325134248.GN2609@legolas.emea.dhcp.ti.com>
 <000301cbec7a$3ff5cdf0$bfe169d0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <000301cbec7a$3ff5cdf0$bfe169d0$@org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 27, 2011 at 02:26:48PM +0200, Tanya Brokhman wrote:
> > 
> > On Wed, Mar 23, 2011 at 10:03:38AM +0200, Tatyana Brokhman wrote:
> > > Change usb_ep_enable() prototype to use endpoint descriptor from
> > usb_ep.
> > > This optimization spares the FDs from saving the endpoint chosen
> > > descriptor. This optimization is not full though. To fully exploit
> > this
> > > change one needs to update all the UDCs as well since in the current
> > > implementation each of them saves the endpoint descriptor in it's
> > > internal (and extended) endpoint structure.
> > 
> > I'm not sure this is such a good patch. But I don't have strong
> > arguments against it either.
> > 
> 
> Could you please share you concerns? Even if they are not strong arguments
> :).
> Our pros for this change were that it seems more accurate that the EP
> descriptor will be handled by the composite layer and not the FDs. Thus we
> tried to spare the FD from saving the chosen EP descriptor and passing it to
> different functions.
> This change is needed for our algorithm of SS implementation in the later
> patches in this series. 

Yes, I understood that much, but it's useful for UDCs to access the EP
descriptor (ok, we can still access it by dereferencing ep) since we can
(actually we need to) use that to let the HW know about max packet
sizes, endpoint types, etc etc.

Also, I'm not sure composite.c should know the details about the
endpoint. That's just a thin layer implementing the more generic part
(standard usb requests, handling, helpers for finding endpoints, etc),
but the one who should look into endpoint descriptors is the underlying
controller code for the reasons I listed above.

That's my feeling...

-- 
balbi

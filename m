Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530Ab1BXI5t (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Feb 2011 03:57:49 -0500
Received: from na3sys009aog105.obsmtp.com ([74.125.149.75]:47802 "EHLO
	na3sys009aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753699Ab1BXI5r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Feb 2011 03:57:47 -0500
Date: Thu, 24 Feb 2011 10:57:39 +0200
From: Felipe Balbi <balbi@ti.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Felipe Balbi <balbi@ti.com>, Alexander Holler <holler@ahsoftware.de>,
        Michael Jones <michael.jones@matrix-vision.de>,
        Greg KH <gregkh@suse.de>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        USB list <linux-usb@vger.kernel.org>, linux-omap@vger.kernel.org
Subject: Re: [024/115] USB: prevent buggy hubs from crashing the USB stack
Message-ID: <20110224085735.GD3528@legolas.emea.dhcp.ti.com>
Reply-To: balbi@ti.com
References: <4D64C81B.5060807@ahsoftware.de>
 <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="H1spWtNR+x+ondvy"
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1102231021210.2233-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--H1spWtNR+x+ondvy
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

On Wed, Feb 23, 2011 at 10:26:20AM -0500, Alan Stern wrote:
> In both cases, it appears that the problem is caused by the fact that 
> the musb host-controller driver doesn't set the hcd->has_tt flag.
> 
> Felipe, you should know where it belongs.  It should be easy enough to 
> add.

Sure Alan, it's attached to this mail. Compile tested only though.
Michael, would you care to give your tested-by ?

-- 
balbi

--H1spWtNR+x+ondvy
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="0001-usb-musb-core-set-has_tt-flag.diff"

>From 65315c60a17f83e69d01888babe4445097c8ead0 Mon Sep 17 00:00:00 2001
From: Felipe Balbi <balbi@ti.com>
Date: Thu, 24 Feb 2011 10:36:53 +0200
Subject: [PATCH] usb: musb: core: set has_tt flag
Organization: Texas Instruments\n

MUSB is a non-standard host implementation which
can handle all speeds with the same core. We need
to set has_tt flag after commit
d199c96d41d80a567493e12b8e96ea056a1350c1 (USB: prevent
buggy hubs from crashing the USB stack) in order for
MUSB HCD to continue working.

Signed-off-by: Felipe Balbi <balbi@ti.com>
---
 drivers/usb/musb/musb_core.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/usb/musb/musb_core.c b/drivers/usb/musb/musb_core.c
index 54a8bd1..c292d5c 100644
--- a/drivers/usb/musb/musb_core.c
+++ b/drivers/usb/musb/musb_core.c
@@ -1864,6 +1864,7 @@ allocate_instance(struct device *dev,
 	INIT_LIST_HEAD(&musb->out_bulk);
 
 	hcd->uses_new_polling = 1;
+	hcd->has_tt = 1;
 
 	musb->vbuserr_retry = VBUSERR_RETRY_COUNT;
 	musb->a_wait_bcon = OTG_TIME_A_WAIT_BCON;
-- 
1.7.4.rc2


--H1spWtNR+x+ondvy--

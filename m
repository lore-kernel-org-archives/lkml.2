Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757503Ab1FFPZT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 11:25:19 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:50772 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754159Ab1FFPZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 11:25:15 -0400
Date: Mon, 6 Jun 2011 11:25:14 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Tanya Brokhman <tlinder@codeaurora.org>, <greg@kroah.com>,
        <linux-usb@vger.kernel.org>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v14 4/9] usb: Add max_speed to usb_composite_driver
 structure
In-Reply-To: <20110606113742.GY18731@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1106061120060.1953-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 Jun 2011, Felipe Balbi wrote:

> But we might still want to force HighSpeed even though the HW has
> SuperSpeed support.

That would be a useful module parameter for a SuperSpeed UDC driver.  
Like the parameter Tanya added to dummy-hcd.

>  The real solution, for the long run would be to
> always start with pullups disabled (iow, don't connect to host
> immediately) and only connect after the gadget driver is all
> initialized, then we will know the gadget speed before connecting, and
> we can have the gadget driver "request" for a particular speed from the
> controller.

Unfortunately this would mean changing a bunch of UDC drivers.  But I 
agree, it makes sense for the gadget driver to specifically ask for the 
pullups to be enabled when it is ready.

Don't some of the existing UDC drivers fail to implement the pullup 
method at all?

Alan Stern


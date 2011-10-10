Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754680Ab1JJTzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Oct 2011 15:55:33 -0400
Received: from netrider.rowland.org ([192.131.102.5]:55523 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754653Ab1JJTzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Oct 2011 15:55:32 -0400
Date: Mon, 10 Oct 2011 15:55:30 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: "Munegowda, Keshava" <keshava_mgowda@ti.com>,
        Paul Walmsley <paul@pwsan.com>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <khilman@ti.com>, <b-cousson@ti.com>, <gadiyar@ti.com>,
        <sameo@linux.intel.com>, <parthab@india.ti.com>, <tony@atomide.com>,
        <johnstul@us.ibm.com>, <vishwanath.bs@ti.com>,
        Greg KH <greg@kroah.com>
Subject: Re: [PATCH 1/5 v13] arm: omap: usb: ehci and ohci hwmod structures
 for omap4
In-Reply-To: <20111010160354.GP6685@legolas.emea.dhcp.ti.com>
Message-ID: <Pine.LNX.4.44L0.1110101551510.24082-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Oct 2011, Felipe Balbi wrote:

> On Mon, Oct 10, 2011 at 11:19:43AM -0400, Alan Stern wrote:
> > On Mon, 10 Oct 2011, Felipe Balbi wrote:
> > 
> > > > > do we have sibling structures today? I dont think so.
> > > > 
> > > > no we don't.
> > > 
> > > Ok, here's a first shot at it:
> > 
> > In fact we do already have sibling lists.  They are maintained as part 
> > of the device_private structure.  What we are missing is a 
> > device_for_each_sibling() routine.  It could be added pretty easily; it 
> > would be similar to device_for_each_child().
> 
> care to point out where is ?
> 
> 68 struct device_private {
> 69         struct klist klist_children;
> 70         struct klist_node knode_parent;
-------------^  Here.  The "parent" in the name refers to where the
                head of the list is stored.

> 71         struct klist_node knode_driver;
> 72         struct klist_node knode_bus;
> 73         void *driver_data;
> 74         struct device *device;
> 75 };

>From device_add():

	if (parent)
		klist_add_tail(&dev->p->knode_parent,
			       &parent->p->klist_children);

Alan Stern


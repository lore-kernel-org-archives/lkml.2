Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754719Ab2DXOOJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 10:14:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:37211 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754480Ab2DXOOG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 10:14:06 -0400
Date: Tue, 24 Apr 2012 10:14:05 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wang YanQing <udknight@gmail.com>
cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC]Is usb port number fixed?
In-Reply-To: <20120424021600.GA5283@udknight>
Message-ID: <Pine.LNX.4.44L0.1204241010270.1511-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 24 Apr 2012, Wang YanQing wrote:

> On Mon, Apr 23, 2012 at 11:13:06AM -0400, Alan Stern wrote:
> > The port numbers are determined by the hardware -- each set of wires
> > has its own port number.  The numbers have nothing to do with
> > bandwidth.
> Could you figure out the codes in kernel that read out the port number from
> hub, if there is a piece of codes do that things?

In drivers/usb/core/hub.c, look through the hub_events() routine.  
There are several function calls similar to this one:

			ret = hub_port_status(hub, i,
					&portstatus, &portchange);

Here i is the port number.  This asks the hub to send back status and 
change information for port i.  (See also the code for the 
hub_port_status() and get_port_status() routines.)

Alan Stern


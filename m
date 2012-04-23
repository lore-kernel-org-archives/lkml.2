Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754374Ab2DWPNK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:13:10 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:35657 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753396Ab2DWPNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:13:07 -0400
Date: Mon, 23 Apr 2012 11:13:06 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Wang YanQing <udknight@gmail.com>
cc: Anil Nair <anilcoll90@gmail.com>, Greg KH <greg@kroah.com>,
        lkml <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>
Subject: Re: [RFC]Is usb port number fixed?
In-Reply-To: <20120423015212.GA7547@udknight>
Message-ID: <Pine.LNX.4.44L0.1204231109380.1612-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Apr 2012, Wang YanQing wrote:

> On Sun, Apr 22, 2012 at 08:47:24AM -0400, Alan Stern wrote:
> > On Sun, 22 Apr 2012, Anil Nair wrote:
> > 
> > > The port number comes from root hub managed by the host controller. Its
> > > fixed dynamically during enumeration, and can change.
> > > Please correct me if i am wrong.
> > 
> > You are indeed wrong.  Port numbers are not fixed dynamically and they 
> > cannot change.
> Right?

Right.

> Could you pin out the codes in kernel?

I don't understand the question.  What code in the kernel do you want 
to see?

> > On the other hand, bus numbers _are_ assigned dynamically and they can 
> > (and do) change.
> > 
> Indeed, I never meat the situation lspci output different bus number on the same machine.
> Any more comment?

Try unloading ehci-hcd, uhci-hcd, and ohci-hcd, and then reloading them 
in different orders.  Depending on what sort of hardware you have, the 
bus numbers will change.


On Mon, 23 Apr 2012, Anil Nair wrote:

>   You meant to say port numbers are fixed but bus address changes
> dynamically, also does the host controller
>   fixes the port number?

Yes.

> If USB Bus bandwidth is not available, how does it
> assign port numbers?

The port numbers are determined by the hardware -- each set of wires
has its own port number.  The numbers have nothing to do with
bandwidth.

Alan Stern


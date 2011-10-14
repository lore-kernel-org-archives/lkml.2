Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756696Ab1JNUTh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 16:19:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:41711 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753245Ab1JNUTf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 16:19:35 -0400
Date: Fri, 14 Oct 2011 16:19:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Johannes Stezenbach <js@sig21.net>
cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
In-Reply-To: <20111014192153.GA18439@sig21.net>
Message-ID: <Pine.LNX.4.44L0.1110141613420.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 14 Oct 2011, Johannes Stezenbach wrote:

> I don't really want to help Markus with his proprietary, binary-only
> userspace driver crap, but I wonder why nobody seems to remember
> how the USB protocol works on the wire?

I remember it perfectly well.

>  The transfer size is
> never seen by the device, thus it cannot matter if two small URBs
> or one large URB are queued.  What matters is the packet size.

That's what I have been saying.  Markus's experience contradicts this,
however.

> Apparently the device can only handle fixed size packets
> of either 188 or 2*188 byte, thus it breaks with 12288 or 11776.

No.  The device expects 512-byte packets because it uses a bulk 
endpoint.

> The endpoint's wMaxPacketSize might reflect this.

For high-speed devices, a bulk endpoint's wMaxPacketSize must always be 
512.

> I guess a transfer size of e.g. 188*60=11280 would work.
> See the first mail of this thread.

According to Markus, with this particular device nothing but 24064 
works.  The discussion is a little difficult to follow because he 
talked about two different devices without always being clear about 
which was which.

> See also Sergei's comment in
> http://lkml.org/lkml/2011/10/12/183

Alan Stern


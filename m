Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933531Ab1JNWpx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 18:45:53 -0400
Received: from bar.sig21.net ([80.81.252.164]:49788 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933501Ab1JNWpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 18:45:52 -0400
Date: Sat, 15 Oct 2011 00:45:49 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111014224549.GA22810@sig21.net>
References: <20111014192153.GA18439@sig21.net>
 <Pine.LNX.4.44L0.1110141613420.2036-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110141613420.2036-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -1.0 (-)
X-Spam-21-Report: No, score=-1.0 required=5.0 tests=ALL_TRUSTED=-1,BAYES_20=-0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 14, 2011 at 04:19:34PM -0400, Alan Stern wrote:
> On Fri, 14 Oct 2011, Johannes Stezenbach wrote:
> 
> > I don't really want to help Markus with his proprietary, binary-only
> > userspace driver crap, but I wonder why nobody seems to remember
> > how the USB protocol works on the wire?
> 
> I remember it perfectly well.

My bad, I'm sorry for hitting the wrong tone.

What I meant to say is Markus' statement that the device only
works at a certain transfer size cannot be true since
this size is not visible to the device via the USB bus.

> > Apparently the device can only handle fixed size packets
> > of either 188 or 2*188 byte, thus it breaks with 12288 or 11776.
> 
> No.  The device expects 512-byte packets because it uses a bulk 
> endpoint.
> 
> > The endpoint's wMaxPacketSize might reflect this.
> 
> For high-speed devices, a bulk endpoint's wMaxPacketSize must always be 
> 512.

OK, after re-reading the USB spec I see you are right
and I stand corrected.

> > I guess a transfer size of e.g. 188*60=11280 would work.
> > See the first mail of this thread.
> 
> According to Markus, with this particular device nothing but 24064 
> works.  The discussion is a little difficult to follow because he 
> talked about two different devices without always being clear about 
> which was which.

If you queue two URBs, one 12288 and 11776 bytes, the device
does not see any difference to one URB with 24064.  It's just not
in the USB wire protocol.  It would make a difference if the
device violated the spec and sent 188 byte packets. However, the
spec says a short packet terminates the transfer.  But I wonder
if this is really the case?


Johannes

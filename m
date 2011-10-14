Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756330Ab1JNTWD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Oct 2011 15:22:03 -0400
Received: from bar.sig21.net ([80.81.252.164]:46532 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753857Ab1JNTWB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Oct 2011 15:22:01 -0400
Date: Fri, 14 Oct 2011 21:21:53 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111014192153.GA18439@sig21.net>
References: <CA+O4pCL-QDUJNyfGueb163wNgO4dE+bn5ykmOxfHsoHaaH3oyA@mail.gmail.com>
 <Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110131032400.2026-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -1.0 (-)
X-Spam-21-Report: No, score=-1.0 required=5.0 tests=ALL_TRUSTED=-1,BAYES_20=-0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 13, 2011 at 10:58:39AM -0400, Alan Stern wrote:
> On Thu, 13 Oct 2011, Markus Rechberger wrote:
> 
> > And for those who are curious about the logfiles:
> > Not working one as proposed by Alan that the full buffer size should
> > be split into 2 requests:
> > 
> > ffff8800b38d9f00 1231540351 S Bi:2:013:1 -115 12288 <
> > ffff8800b38d96c0 1231540404 S Bi:2:013:1 -115 11776 <
... 
> This is very interesting.  There are only two things that could be
> happening: Either the device sends different data during the two tests,
> or there's a bug in the kernel.
> 
> Now, it is possible the device is sending bad data.  The initial parts
> of the two logs do not agree exactly; there are numerous small
> differences in the control data sent by the device and by the program.  
> I don't know whether they are significant, but if they aren't, there's
> no reason for the device to send different bulk data.  The transfer
> size certainly cannot account for it.  Indeed, even if the transfer
> size were only 512 bytes, the first data packet should still be the 
> same.

I don't really want to help Markus with his proprietary, binary-only
userspace driver crap, but I wonder why nobody seems to remember
how the USB protocol works on the wire?  The transfer size is
never seen by the device, thus it cannot matter if two small URBs
or one large URB are queued.  What matters is the packet size.
Apparently the device can only handle fixed size packets
of either 188 or 2*188 byte, thus it breaks with 12288 or 11776.
The endpoint's wMaxPacketSize might reflect this.
I guess a transfer size of e.g. 188*60=11280 would work.
See the first mail of this thread.

See also Sergei's comment in
http://lkml.org/lkml/2011/10/12/183


Johannes

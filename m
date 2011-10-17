Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab1JQSLW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 14:11:22 -0400
Received: from bar.sig21.net ([80.81.252.164]:47710 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751198Ab1JQSLV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 14:11:21 -0400
Date: Mon, 17 Oct 2011 20:11:18 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111017181117.GA17422@sig21.net>
References: <20111014224549.GA22810@sig21.net>
 <Pine.LNX.4.44L0.1110151459030.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110151459030.15129-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -1.0 (-)
X-Spam-21-Report: No, score=-1.0 required=5.0 tests=ALL_TRUSTED=-1,BAYES_20=-0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 03:04:28PM -0400, Alan Stern wrote:
> On Sat, 15 Oct 2011, Johannes Stezenbach wrote:
> 
> >  It would make a difference if the
> > device violated the spec and sent 188 byte packets. However, the
> > spec says a short packet terminates the transfer.  But I wonder
> > if this is really the case?
> 
> The device does not send short packets.  If it did, the 24064-byte 
> transfers would end early.

Re-reading the USB-2.0 standard, a short packet which terminates
the transfer is defined by packet_size < wMaxPacketSize,
not by packet_size < 512.
Thus wMaxPacketSize == 188 (or 2*188) might be possible.

There is a comment in linux/drivers/usb/host/ehci-q.c:

	/* The USB spec says that high speed bulk endpoints
	 * always use 512 byte maxpacket.  But some device
	 * vendors decided to ignore that, and MSFT is happy
	 * to help them do so.  So now people expect to use
	 * such nonconformant devices with Linux too; sigh.
	 */

Maybe we should look at the descriptors?


Johannes

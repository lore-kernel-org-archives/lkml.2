Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753655Ab1JPJKX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Oct 2011 05:10:23 -0400
Received: from bar.sig21.net ([80.81.252.164]:41431 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab1JPJKV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Oct 2011 05:10:21 -0400
Date: Sun, 16 Oct 2011 11:10:09 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Markus Rechberger <mrechberger@gmail.com>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [Patch] Increase USBFS Bulk Transfer size
Message-ID: <20111016091009.GB32551@sig21.net>
References: <20111014224549.GA22810@sig21.net>
 <Pine.LNX.4.44L0.1110151459030.15129-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1110151459030.15129-100000@netrider.rowland.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -1.0 (-)
X-Spam-21-Report: No, score=-1.0 required=5.0 tests=ALL_TRUSTED=-1,BAYES_40=-0.001 autolearn=no
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 15, 2011 at 03:04:28PM -0400, Alan Stern wrote:
> On Sat, 15 Oct 2011, Johannes Stezenbach wrote:
> 
> > What I meant to say is Markus' statement that the device only
> > works at a certain transfer size cannot be true since
> > this size is not visible to the device via the USB bus.
> 
> That's what I would expect, too.  But did you take a look at the usbmon 
> traces Markus acquired?
> 
> 	http://marc.info/?l=linux-usb&m=131845614819045&w=2

I glanced at them for 3 seconds, but I cannot be bothered
to analyze them in detail.  The ASCII usbmon traces don't
show full USB packet contents anyway so you can't see if
partial MPEG TS packets are missing.

> They aren't completely definitive because the communications between
> the computer and the device _before_ the bulk transfers started were
> different.  However they do clearly show the device working with
> 24064-byte transfers and not working with 12288+11776-byte transfers.

The device transfers data in the "not working" case, it's just that
the MPEG TS sync byte is not where Markus expects it, which could
be explained by a partial MPEG TS packet left in the device's FIFO
from previous interaction.


Johannes

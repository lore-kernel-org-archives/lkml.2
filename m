Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757188Ab0DIUvy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 16:51:54 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:47419 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756535Ab0DIUvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 16:51:51 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Date: Fri, 9 Apr 2010 22:51:51 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1004091114500.1852-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004091114500.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004092251.51739.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. April 2010 17:15:43 schrieb Alan Stern:
> > > Then usb_submit_urb(urb[i]) will copy the appropriate four bytes to a
> > > bounce buffer and map the bounce buffer.  Accesses to the other parts
> > > of xbuf won't violate the cacheline rules, because xbuf isn't mapped
> > > for DMA -- only the bounce buffer is.  When urb[i] completes, the
> > > bounce buffer contents will be copied back to the original four bytes
> > > in xbuf.  Again, there is no violation of cacheline rules.
> > 
> > I think you are assuming that either every or no part of the buffer is mapped
> > for DMA in place. I don't think you can assume that.
> 
> Yes I can, because the code that makes this decision is part of 
> usbcore and it is under m

It seems to me that in usbcore you can positively know that a buffer
will be mapped. However if the mapping is not done in usbcore you
cannot know what the HCD driver will do to a buffer, in particular
you don't know whether it will be processed by PIO or mapped for
DMA.

Maybe I understand this wrongly. Which code exactly were you refering to?

	Regards
		Oliver

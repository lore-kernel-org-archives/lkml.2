Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753938Ab0DIOuc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 10:50:32 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:58535 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753638Ab0DIOua (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 10:50:30 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Date: Fri, 9 Apr 2010 16:50:31 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1004091033150.1852-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004091033150.1852-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004091650.31488.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 9. April 2010 16:41:48 schrieb Alan Stern:
> > It'll work on x86. On incoherent architectures this violates the cacheline
> > rules for DMA-mapping if you have to bounce.
> 
> Not true.  Consider: The driver allocates a 16-byte buffer (xbuf)  
> divided up into four sets of four bytes, and sets
> 
>         urb[i].transfer_buffer_dma = xbuf_dma + 4*i;
> 
> Then usb_submit_urb(urb[i]) will copy the appropriate four bytes to a
> bounce buffer and map the bounce buffer.  Accesses to the other parts
> of xbuf won't violate the cacheline rules, because xbuf isn't mapped
> for DMA -- only the bounce buffer is.  When urb[i] completes, the
> bounce buffer contents will be copied back to the original four bytes
> in xbuf.  Again, there is no violation of cacheline rules.

I think you are assuming that either every or no part of the buffer is mapped
for DMA in place. I don't think you can assume that.

	Regards
		Oliver

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758134Ab0DGQ4f (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Apr 2010 12:56:35 -0400
Received: from smtp-out003.kontent.com ([81.88.40.217]:32975 "EHLO
	smtp-out003.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758117Ab0DGQ4d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Apr 2010 12:56:33 -0400
From: Oliver Neukum <oliver@neukum.org>
To: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: USB transfer_buffer allocations on 64bit systems
Date: Wed, 7 Apr 2010 18:54:55 +0200
User-Agent: KMail/1.12.4 (Linux/2.6.34-rc3-0.1-default; KDE/4.3.5; x86_64; ; )
Cc: Daniel Mack <daniel@caiaq.de>, linux-kernel@vger.kernel.org,
       Pedro Ribeiro <pedrib@gmail.com>, akpm@linux-foundation.org,
       Greg KH <gregkh@suse.de>, alsa-devel@alsa-project.org,
       linux-usb@vger.kernel.org
References: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1004071036060.1779-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201004071854.55530.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Mittwoch, 7. April 2010 16:59:47 schrieb Alan Stern:
> > The fix is to use usb_buffer_alloc() for that purpose which ensures
> > memory that is suitable for DMA. And on x86_64, this also means that the
> > upper 32 bits of the address returned are all 0's.
> 
> That is not a good fix.  usb_buffer_alloc() provides coherent memory, 
> which is not what we want.  I believe the correct fix is to specify the 
> GFP_DMA32 flag in the kzalloc() call.
> 
> Of course, some EHCI hardware is capable of using 64-bit addresses.  
> But not all, and other controller types aren't.  In principle we could
> create a new allocation routine, which would take a pointer to the USB
> bus as an additional argument and use it to decide whether the memory 
> needs to lie below 4 GB.  I'm not sure adding this extra complexity 
> would be worthwhile.

What about XHCI? Do you really want to limit it to 32bits?

	Regards
		Oliver

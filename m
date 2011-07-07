Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756772Ab1GGPGS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 11:06:18 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:52556 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752807Ab1GGPGQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 11:06:16 -0400
Date: Thu, 7 Jul 2011 11:06:16 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <zonque@gmail.com>
cc: Oliver Neukum <oliver@neukum.org>, <linux-usb@vger.kernel.org>,
        <alsa-devel@alsa-project.org>, Takashi Iwai <tiwai@suse.de>,
        Clemens Ladisch <clemens@ladisch.de>, <florian@mickler.org>,
        <pedrib@gmail.com>, William Light <wrl@illest.net>,
        Greg KH <greg@kroah.com>, <linux-kernel@vger.kernel.org>
Subject: Re: Allocating buffers for USB transfers (again)
In-Reply-To: <CACTFLAN=GOw8KLtvVBM6omvYzW3RBHggv-Kc2_2QVD--M-Jxkg@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1107071100250.2186-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 7 Jul 2011, Daniel Mack wrote:

> On Thu, Jul 7, 2011 at 2:33 PM, Oliver Neukum <oliver@neukum.org> wrote:
> 
> > PS:  Do you still see this if you enable 64bit DMA for EHCI?
> 
> The problem is that I personally don't see that issue at all. I even
> installed 4GB of RAM to my development machine last year to be able to
> reproduce this, but I can't, even when the memory allocator is under
> heavy load. The only people who see this effect are Pedro Ribeiro and
> William Light (both in Cc:), and both have been very helpful in trying
> patches and reporting back in detail. Which instructions could we
> probably give to these people to finally hunt this issue down?

Oliver is perfectly right; this problem needs to be solved at the 
source.

One thing you might be able to do is put together a debugging patch
that would print out the bus address corresponding to the DMA handle
after the DMA mapping takes place, i.e., after the second
dma_map_single() call in usb_hcd_map_urb_for_dma() returns.  Or at
least, check the bus address to see if it is below the 4 GB limit and
print out an error message if it isn't.

(I don't know how one translates a DMA address to a bus address.  You'd 
have to ask somebody who knows or figure it out.)

Alan Stern


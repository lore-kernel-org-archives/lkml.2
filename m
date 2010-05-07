Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755444Ab0EGOvM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:51:12 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51690 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755125Ab0EGOvK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:51:10 -0400
Date: Fri, 7 May 2010 10:51:10 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: Clemens Ladisch <clemens@ladisch.de>, Takashi Iwai <tiwai@suse.de>,
       <alsa-devel@alsa-project.org>, Greg KH <gregkh@suse.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, <iommu@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100507102408.GM30801@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1005071048220.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Daniel Mack wrote:

> > At least the audio class and ua101 drivers don't do this and fill the
> > buffers before they are submitted.
> 
> Gnaa, you're right. I _thought_ my code does it the way I described, but
> what I wrote is how I _wanted_ to do it, not how it's currently done. I
> have a plan to change this in the future.
> 
> So unfortunately, that doesn't explain it either. Sorry for the noise.

At one point we tried an experiment, printing out the buffer and DMA 
addresses.  I don't recall seeing anything obviously wrong, but if an 
IOMMU was in use then that might not mean anything.  Is it possible 
that the IOMMU mappings sometimes get messed up for addresses above 4 
GB?

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab0EGOpY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 10:45:24 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:34593 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755126Ab0EGOpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 10:45:22 -0400
Date: Fri, 7 May 2010 10:45:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Daniel Mack <daniel@caiaq.de>
cc: Oliver Neukum <oneukum@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Takashi Iwai <tiwai@suse.de>, <alsa-devel@alsa-project.org>,
       Greg KH <gregkh@suse.de>,
       Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
       USB list <linux-usb@vger.kernel.org>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Chris Wright <chrisw@sous-sol.org>, <iommu@lists.linux-foundation.org>,
       Andi Kleen <andi@firstfloor.org>, Pedro Ribeiro <pedrib@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>
Subject: Re: [alsa-devel] USB transfer_buffer allocations on 64bit systems
In-Reply-To: <20100507115810.GN30801@buzzloop.caiaq.de>
Message-ID: <Pine.LNX.4.44L0.1005071042410.1804-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 7 May 2010, Daniel Mack wrote:

> > Or to be precise it could be done with coherent memory, but you'd risk
> > transfering partially updated buffers, as you cannot know when DMA will
> > be done and we don't guarantee that DMA will be done right as we transfer.
> 
> If the memory is coherent, it should be possible. And if buffers are
> only partially updated, the audio buffer scheduling is too tight. IOW,
> the configured buffer size of audio clients in userspace is too small.

Even with coherent memory, this dynamic updating of buffer contents 
isn't a good idea.  There's no guarantee that coherent memory won't be 
implemented using a bounce buffer during URB submission.

Alan Stern


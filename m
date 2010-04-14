Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab0DNOIt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 10:08:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60809 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751127Ab0DNOIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 10:08:48 -0400
Date: Wed, 14 Apr 2010 10:08:47 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Pedro Ribeiro <pedrib@gmail.com>
cc: linux-usb@vger.kernel.org, Andi Kleen <andi@firstfloor.org>,
       <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
       Greg KH <gregkh@suse.de>, <alsa-devel@alsa-project.org>
Subject: Re: USB transfer_buffer allocations on 64bit systems
In-Reply-To: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1004141003170.1716-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Apr 2010, Pedro Ribeiro wrote:

> On 14 April 2010 11:09, Daniel Mack <daniel@caiaq.de> wrote:
> 
> > Thanks! So the only thing I can do for now is submit exactly this patch.
> > At least, it helps you and it shouldn't break anything. The question
> > remains whether this type of memory should be used for all
> > transfer_buffers.
> >
> 
> Is there any chance you could push this to -stable? I don't care
> because I always use the latest kernel, but the next Debian stable and
> Ubuntu LTS are going to use 2.6.32.

No!  Please don't do it: Don't submit the patch and _certainly_ don't
submit it to -stable.  It doesn't fix anything; it only works around a
bug, and at the moment we don't even know if the bug is in the kernel
or in Pedro's hardware (and even though it affects two different
systems of his, nobody else has reported a similar problem).  Papering
over it will only remove the incentive to fix it properly.

In addition, you'll most likely find that lots of Linux developers will
object vociferously to any proposed patch that uses GFP_DMA.  That flag
is supposed to be _only_ for ISA devices, which really need it.  By 
limiting the memory allocation to the lowest 16 MB of physical memory, 
it greatly increases the chances that the allocation will fail.

Alan Stern


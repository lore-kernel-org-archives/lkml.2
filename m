Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757355Ab0DOHfJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 03:35:09 -0400
Received: from buzzloop.caiaq.de ([212.112.241.133]:50990 "EHLO
	buzzloop.caiaq.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab0DOHfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 03:35:07 -0400
Date: Thu, 15 Apr 2010 09:35:01 +0200
From: Daniel Mack <daniel@caiaq.de>
To: Pedro Ribeiro <pedrib@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
       Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
       akpm@linux-foundation.org, Greg KH <gregkh@suse.de>,
       alsa-devel@alsa-project.org
Subject: Re: USB transfer_buffer allocations on 64bit systems
Message-ID: <20100415073501.GY30807@buzzloop.caiaq.de>
References: <t2w74fd948d1004140347k3447bffapb73856eacddfde55@mail.gmail.com>
 <Pine.LNX.4.44L0.1004141003170.1716-100000@iolanthe.rowland.org>
 <20100414163637.GV30807@buzzloop.caiaq.de>
 <n2k74fd948d1004141021r8815647cx2b74085fc37a27b2@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <n2k74fd948d1004141021r8815647cx2b74085fc37a27b2@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 14, 2010 at 06:21:05PM +0100, Pedro Ribeiro wrote:
> On 14 April 2010 17:36, Daniel Mack <daniel@caiaq.de> wrote:
> > No worries - I agree. But unfortunately, I'm out of ideas now, and my
> > initial thoughts about what might cause the trouble were abviously not
> > able to explain the issue. Does anyone see further steps of tracking
> > this issue down?
> >
> > Thanks,
> > Daniel
> >
> 
> Well if this is a dirty / dangerous hack, what about your first patch?
> I've been testing it for days and has given me no problems.

[For those who haven't followed all the discussions - this patch used
 usb_buffer_alloc() instead of kmalloc() in the audio USB driver]

No, Alan is right. As long as we don't know what's going on, it
shouldn't be fixed that way.

There might be an update to all USB drivers to use a special allocation
function in order to avoid DMA bounce buffers for non-64-bit aware host
controllers, but that's certainly a second step. First, the bug that you
see needs attention, and the longer you can reproduce it, the better :)

Daniel

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab1LLTa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 14:30:58 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:44779 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753227Ab1LLTa5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 14:30:57 -0500
X-Sasl-enc: I7PJ1ZI9sKgau0+wEBreJGAL1/qhYCl9h3Mlg6OHvDHH 1323718251
Date: Mon, 12 Dec 2011 11:30:40 -0800
From: Greg KH <greg@kroah.com>
To: Oliver Neukum <oneukum@suse.de>
Cc: Ming Lei <tom.leiming@gmail.com>, Peter Zijlstra <peterz@infradead.org>,
        gregkh@suse.de, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, ostrikov@nvidia.com, adobriyan@gmail.com,
        eric.dumazet@gmail.com, mingo@elte.hu
Subject: Re: [PATCH 3/3] kref: Remove the memory barriers
Message-ID: <20111212193040.GA13131@kroah.com>
References: <20111210104341.592561407@chello.nl>
 <1323680078.16764.45.camel@twins>
 <CACVXFVPOsUrEEDT=iMZyrvaX3G_XqWpVOJyz24=FPTtB_9J9HQ@mail.gmail.com>
 <201112121120.16326.oneukum@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201112121120.16326.oneukum@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 12, 2011 at 11:20:16AM +0100, Oliver Neukum wrote:
> Am Montag, 12. Dezember 2011, 10:57:31 schrieb Ming Lei:
> > On Mon, Dec 12, 2011 at 4:54 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > > On Mon, 2011-12-12 at 11:48 +0800, Ming Lei wrote:
> > >> For kref, maybe it is still multiple operations done on one cpu vs them
> > >> being visible on another, but seems a bit implicit, see the common kref
> > >> usage below:
> > >>
> > >> CPU0                            CPU1
> > >>                                         A:kref_init(&obj->ref)
> > >
> > > how does CPU0 get a ref to obj?
> > 
> > Suppose open/close/read/.. context is run on CPU0, and driver .probe/.release
> > context(hotplug context) is run on CPU1. There are a few examples on
> > usb driver(eg. usb-skeleton.c, ...)
> 
> USB generally relies on an implied barrier just as:
> 
>         /* we can register the device now, as it is ready */
>         retval = usb_register_dev(interface, &skel_class);
> 
> Generally reference counting cannot help you if kfree() is involved

So, Oliver, you don't have any objection to this patch removing the
barriers in kref, right?  Originally you added them, I just wanted to
make sure before I applied this.

thanks,

greg k-h

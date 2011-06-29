Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757189Ab1F2RfJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 13:35:09 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60682 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754456Ab1F2RfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 13:35:05 -0400
Date: Wed, 29 Jun 2011 13:35:04 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
In-Reply-To: <20110629164027.GA8552@tugrik.mns.mnsspb.ru>
Message-ID: <Pine.LNX.4.44L0.1106291333440.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Kirill Smelkov wrote:

> > Also, when decreasing the schedule limit, do you think it is really 
> > necessary to check that the current allocation doesn't exceed the new 
> > limit?  I think it would be sufficient to apply the new limit just to 
> > new bandwidth allocation requests.  After all, this API is meant for 
> > experts only.
> 
> I think yes, it is needed. E.g. because there is this check in
> periodic_usecs():
> 
> #ifdef  DEBUG
>         if (usecs > ehci->uframe_periodic_max)
>                 ehci_err (ehci, "uframe %d sched overrun: %d usecs\n",
>                         frame * 8 + uframe, usecs);
> #endif
>         return usecs;
> }
> 
> and periodic_usecs() is called in e.g. this chain:
> 
>     itd_submit
>     iso_stream_schedule
>     itd_slot_ok
>     periodic_usecs
> 
> and others.

That won't matter unless DEBUG is defined.

> I'd leave this check as is - to me it would be useful in debug mode to
> verify that we've not overallocated a period.
> 
> Also, even if this knob would be useful only to experts, it would be
> better to put feedback onto the knob so that people could know whether
> thir request could be served or not.
> 
> What do you think?

Can you make that check conditional on DEBUG being set?

Alan Stern


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889Ab1F2Svp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Jun 2011 14:51:45 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:49352 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752921Ab1F2Svn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Jun 2011 14:51:43 -0400
Date: Wed, 29 Jun 2011 14:51:42 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Kirill Smelkov <kirr@mns.spb.ru>
cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into ehci-sysfs.c
In-Reply-To: <20110629180359.GA12511@tugrik.mns.mnsspb.ru>
Message-ID: <Pine.LNX.4.44L0.1106291448010.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 29 Jun 2011, Kirill Smelkov wrote:

> Yes, but still it would be good to always keep the invariant
> 
>     allocated <= uframe_periodic_max
> 
> and that debug is there to catch when this breaks.

Then perhaps it should print out the maximum number of microseconds
already allocated for any uframe, instead of stopping as soon as it
finds something above the new limit.

> > Can you make that check conditional on DEBUG being set?
> 
> Yes I can, but it seems to me we are starting to complicate the code.
> 
> What's the problem with returning error on setting uframe_periodic_max <
> already allocated usb bandwith?

No problem, really.

> The checking is not a priority for me here, so if you think it's better not
> to check or do it under #ifdef - let's do it. Though of course we all
> have our preferences :)

Yes, it's just a matter of taste.  I prefer to add as little code as 
possible for a feature that won't be used much.

Alan Stern


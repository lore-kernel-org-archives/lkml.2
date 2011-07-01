Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755678Ab1GALuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 07:50:25 -0400
Received: from mail.mnsspb.ru ([84.204.75.2]:33673 "EHLO mail.mnsspb.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755255Ab1GALuW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 07:50:22 -0400
Date: Fri, 1 Jul 2011 15:49:27 +0400
From: Kirill Smelkov <kirr@mns.spb.ru>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: matt mooney <mfm@muteddisk.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/2] USB: EHCI: Move sysfs related bits into
	ehci-sysfs.c
Message-ID: <20110701114927.GA15802@tugrik.mns.mnsspb.ru>
References: <20110629180359.GA12511@tugrik.mns.mnsspb.ru> <Pine.LNX.4.44L0.1106291448010.2064-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1106291448010.2064-100000@iolanthe.rowland.org>
Organization: Marine Bridge & Navigation Systems
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 02:51:42PM -0400, Alan Stern wrote:
> On Wed, 29 Jun 2011, Kirill Smelkov wrote:
> 
> > Yes, but still it would be good to always keep the invariant
> > 
> >     allocated <= uframe_periodic_max
> > 
> > and that debug is there to catch when this breaks.
> 
> Then perhaps it should print out the maximum number of microseconds
> already allocated for any uframe, instead of stopping as soon as it
> finds something above the new limit.

Yes, this makes sense, thanks. I've adjusted the patch accordingly.


> > > Can you make that check conditional on DEBUG being set?
> > 
> > Yes I can, but it seems to me we are starting to complicate the code.
> > 
> > What's the problem with returning error on setting uframe_periodic_max <
> > already allocated usb bandwith?
> 
> No problem, really.
> 
> > The checking is not a priority for me here, so if you think it's better not
> > to check or do it under #ifdef - let's do it. Though of course we all
> > have our preferences :)
> 
> Yes, it's just a matter of taste.  I prefer to add as little code as 
> possible for a feature that won't be used much.


Look: we have 3 choices: to check or not to check, and if we are
checking whether it is under #ifdef DEBUG. Not checking at all makes the
code inconsistent with the check in periodic_usecs(). Then, if we are
checking, putting it under #ifdef DEBUG goes against minimum complexity /
"to add as little code as possible ...". It looks the good balance is to
leave the checking as is module you above remark.

And with the above-mentioned correction and comments inspired by Sarah's
concern I'm resending the whole series as v3. Can we do it this way,
please?


Thanks,
Kirill

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932434Ab1BCSt3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 13:49:29 -0500
Received: from kroah.org ([198.145.64.141]:50524 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932331Ab1BCSt2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 13:49:28 -0500
Date: Thu, 3 Feb 2011 10:48:52 -0800
From: Greg KH <greg@kroah.com>
To: Arthur Taylor <art@ified.ca>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, Pavel Machek <pavel@ucw.cz>
Subject: Re: [PATCH] [resend] vt: Add virtual console keyboard mode OFF
Message-ID: <20110203184852.GC20911@kroah.com>
References: <AANLkTikZe1EuvNQHceNUdKFpmmeAbQG8H+34AG9fw43u@mail.gmail.com>
 <20110131174622.GA25097@suse.de>
 <1296612452.28176.52.camel@art-x200>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296612452.28176.52.camel@art-x200>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 06:07:32PM -0800, Arthur Taylor wrote:
> On Mon, 2011-01-31 at 09:46 -0800, Greg KH wrote:
> > Care to document this somewhere (i.e. Documentation/ABI?)
> Sure. Can it wait for a future patch though as currently all VT IOCTLs
> aren't documented in the source tree. I'm willing to write said
> documentation.

Ok, that is fine, but care to do it as part of the requirements to get
this patch in?  Yeah, it's not fair, but it ensures that the
documentation gets written :)

> > Your patch is line-wrapped and can not be applied :(
> Fixed in this mail (hopefully).

Yes, looks good.

> > Are you sure you can change the size of this structure and no one is
> > going to have problems?
> >From what I can tell, no. kbd_struct and it's members are defined in the
> non-exported kbd_kern.h, and it is never packed into weird places. Is
> that sufficient? What else should be checked?

No, you are correct.

> 
> > Also, what userspace code is going to use this new feature?  Has it been
> > tested to work properly?
> Xorg is the intended user. In short, reasons for the feature are:
>       * Removes having to flush unnecessary duplicate data.
>       * Fixes an Xorg corner case.
>       * Less code run in both kernel and userspace per key event (I know
>         kinda meh, but hey, it's a plus.)
> 
> Since the switch to evdev and automatic input device detection, Xorg
> sets the console to RAW to disable kernel special key handling and
> flushes the console input buffer per key event.
> 
> If Xorg is configured with static input device definitions, it can't
> flush the input in case the older kbd driver is in use, leading to the
> buffer filling. If the console input buffer fills, bad things happen
> (which I'm currently looking into as well.)
> 
> I modified my xserver to use this feature. I tested Xorg with the
> input-evdev and input-kbd drivers for keyboard events. Since input-kbd
> sets the keyboard back to RAW when needed, everything is fine. If
> input-kbd isn't in use, the keyboard stays in OFF and he input buffer is
> always kept empty, things always work. Shift key states are maintained,
> and SysRq's unRaw function is still works as expected.

Are the xorg patches upstream and accepted or are they waiting for this
change?  Will they work properly with the BSDs as well?

> To: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Pavel Machek <pavel@ucw.cz>
> Signed-off-by: Arthur Taylor <art@ified.ca>

Thanks for the information, but we also need the original changelog
comment here for me to be able to apply it.

Care to resend with all of the text correct?

thanks,

greg k-h

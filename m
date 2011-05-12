Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756148Ab1ELCQJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:16:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44940 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223Ab1ELCQI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:16:08 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding:message-id;
        b=CTizkHBsJCQFcl9yk79EqNMoyr0sj9dtx2Wkxk23fN0OfORer3lMd4RiH/aIALQa+y
         vjfFEYZx3Nme0fe2iAPIdN+6GoAOX4adgiN/vFQ42VUk/jd6bZUX8wQRM0xiFewHeHmd
         YdjCw5MF+gx1yD7lwyALM/idCMjTOXNY+VFCg=
From: Jason Stubbs <jasonbstubbs@gmail.com>
To: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Date: Thu, 12 May 2011 12:13:59 +1000
User-Agent: KMail/1.13.7 (Linux/2.6.38-gentoo-r3; KDE/4.6.3; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
References: <201104201358.50443.jasonbstubbs@gmail.com> <201105111447.49816.jasonbstubbs@gmail.com> <20110511135114.GD12717@kroah.com>
In-Reply-To: <20110511135114.GD12717@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201105121214.00015.jasonbstubbs@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 May 2011 23:51:14 Greg KH wrote:
> On Wed, May 11, 2011 at 02:47:49PM +1000, Jason Stubbs wrote:
> > On Wed, 11 May 2011 08:39:08 Greg KH wrote:
> > > On Thu, Apr 28, 2011 at 06:55:50PM +1000, Jason Stubbs wrote:
> > > > Not sure of the "bump" process, so I'll just go over each part of the
> > > > patch.
> > > > 
> > > > Note that all the changes only affect the sabi_config where
> > > > min_brightness is 1 so you might not see in difference on your
> > > > hardware.
> > > 
> > > This isn't needed anymore due to your other patch superseeding it,
> > > right?
> > 
> > Actually, this one is irrelevant to the nc210/nc110 support as that
> > laptop uses the "SwSmi@" sabi. It was just something I noticed while
> > learning the code. The miscalculations will only affect any laptops that
> > use the "SECLINUX" sabi but I tested it by setting min_brightness to 2
> > for my laptop.
> 
> That's wierd, as that is the type of laptop I have here and it seems to
> work just fine for me as-is.

Throwing a printk of user_level into set_brightness when min_brightness = 1,
I get the following behaviour:

# cd /sys/class/backlight/samsung
# for x in 8 7 2 1 0; do echo $x > brightness; done
# dmesg | tail -n6
user_level is 0x07
user_level is 0x06
user_level is 0x01
user_level is 0x00
user_level is 0xff
samsung_laptop: SABI set command 0x11 failed with completion flag 0xaa and data 0xff

Essentially, setting brightness to the maximum actually sets it one less and
setting it to zero does bad thngs.

> > The patch doesn't apply cleanly on top of the nc210/nc110 patch though as
> > they both modify set_brightness(). It might apply with a higher fuzz
> > factor as the changes don't actually clash. Should I redo the patch?
> 
> Please do.

Will send seperately. Doing this though, I found a problem with the
nc210/nc110 patch in that (user_level == read_brightness()) check should
actually be (user_brightness == read_brightness()). What should I do about
this?

Regards,
Jason Stubbs

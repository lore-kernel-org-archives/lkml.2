Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756835Ab1EUVOh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 May 2011 17:14:37 -0400
Received: from cantor.suse.de ([195.135.220.2]:34164 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753770Ab1EUVOg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 May 2011 17:14:36 -0400
Date: Sat, 21 May 2011 14:14:23 -0700
From: Greg KH <gregkh@suse.de>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] add register_chrdev_ids() to char_dev.c, API
Message-ID: <20110521211423.GA24330@suse.de>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
 <20110519224445.GA9885@suse.de>
 <BANLkTik6QHxzXoC-xAgkfw3-O_fzorLGww@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BANLkTik6QHxzXoC-xAgkfw3-O_fzorLGww@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 20, 2011 at 11:15:04PM -0600, Jim Cromie wrote:
> On Thu, May 19, 2011 at 4:44 PM, Greg KH <gregkh@suse.de> wrote:
> > On Thu, May 19, 2011 at 03:33:03PM -0600, Jim Cromie wrote:
> >> over on kernelnewbies, gregkh said:
> >>
> >>      The chardev stuff is a mess, I keep meaning for years to clean it
> >>      up.  Any proposals on a sane interface for this stuff is greatly
> >>      appreciated.
> >>
> >> this is a 1st step.
> >>
> >> register_chrdev_ids() replaces and deprecates register_chrdev_region()
> >> and alloc_chrdev_region() with a single function that works for both
> >> dynamic and static major numbers.
> >>
> >> Like alloc_chrdev_region(), 1st arg is a dev_t*, but its an in/out
> >> parameter, and expects both major and minor to be preset, and thus the
> >> separate minor arg is dropped.  If major == 0, a dynamic major is
> >> reserved, saved into 1st arg, and thus available to caller afterwards.
> >>
> >> [PATCH 01/23] add register_chrdev_ids() to char_dev.c, API
> >> [PATCH 02/23] reimplement alloc_chrdev_region with
> >> [PATCH 03/23] use register_chrdev_ids to replace
> >> [PATCH 04/23] use register_chrdev_ids in drivers/tty/
> >> [PATCH 05/23] use register_chrdev_ids in drivers/infiniband/
> >> [PATCH 06/23] use register_chrdev_ids in drivers/media/
> >> [PATCH 07/23] use register_chrdev_ids in drivers/s390/
> >> [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
> >> [PATCH 09/23] use register_chrdev_ids in drivers/staging/
> >>
> >> Ive held back the rest, no point in spamming.
> >
> > It's a nice first step, but that's the easy part, what is your 2nd
> > through 4th one going to be?  :)
> >
> > I'd also like to sanatize the function namespace a bit as well, how
> > about chrdev_register_ids() instead?
> 
> that seems sensible, modern.
> also have register_chrdev(), which I presume should also be fixed.
> 
> > Ideally, we could drop down to a single register/unregister pair of
> > functions, that are easy to use and understand.
> 
> __register_chrdev() does more stuff, mainly around cdevs, fops.
> If fops was passed as NULL, we just do the __register_chardev_region()
> and return early, skipping the cdev_alloc() and everything afterwards,
> thus yielding register_chrdev_ids() behavior.
> 
> > Do you think you can
> > get there with this intermediate step or do you want to step back and
> > rethink this?
> 
> hmm.  If above is right, theres no need for the new api fn I added,
> and probably should also drop the __ on both (un)?register_chardev.
> So thats step 2 :)  Any ideas for 3 ?

Well, what do you think the end result should look like?  That will
determine the steps needed here.

thanks,

greg k-h

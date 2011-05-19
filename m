Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933174Ab1ESXEu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 19:04:50 -0400
Received: from cantor.suse.de ([195.135.220.2]:54481 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932238Ab1ESXEt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 19:04:49 -0400
Date: Thu, 19 May 2011 15:44:45 -0700
From: Greg KH <gregkh@suse.de>
To: Jim Cromie <jim.cromie@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 00/23] add register_chrdev_ids() to char_dev.c, API
Message-ID: <20110519224445.GA9885@suse.de>
References: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305840792-25877-1-git-send-email-jim.cromie@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 19, 2011 at 03:33:03PM -0600, Jim Cromie wrote:
> over on kernelnewbies, gregkh said:
> 
>      The chardev stuff is a mess, I keep meaning for years to clean it
>      up.  Any proposals on a sane interface for this stuff is greatly
>      appreciated.
> 
> this is a 1st step.
> 
> register_chrdev_ids() replaces and deprecates register_chrdev_region()
> and alloc_chrdev_region() with a single function that works for both
> dynamic and static major numbers.
> 
> Like alloc_chrdev_region(), 1st arg is a dev_t*, but its an in/out
> parameter, and expects both major and minor to be preset, and thus the
> separate minor arg is dropped.  If major == 0, a dynamic major is
> reserved, saved into 1st arg, and thus available to caller afterwards.
> 
> [PATCH 01/23] add register_chrdev_ids() to char_dev.c, API
> [PATCH 02/23] reimplement alloc_chrdev_region with
> [PATCH 03/23] use register_chrdev_ids to replace
> [PATCH 04/23] use register_chrdev_ids in drivers/tty/
> [PATCH 05/23] use register_chrdev_ids in drivers/infiniband/
> [PATCH 06/23] use register_chrdev_ids in drivers/media/
> [PATCH 07/23] use register_chrdev_ids in drivers/s390/
> [PATCH 08/23] use register_chrdev_ids in drivers/scsi/
> [PATCH 09/23] use register_chrdev_ids in drivers/staging/
> 
> Ive held back the rest, no point in spamming.

It's a nice first step, but that's the easy part, what is your 2nd
through 4th one going to be?  :)

I'd also like to sanatize the function namespace a bit as well, how
about chrdev_register_ids() instead?

Ideally, we could drop down to a single register/unregister pair of
functions, that are easy to use and understand.  Do you think you can
get there with this intermediate step or do you want to step back and
rethink this?

thanks,

greg k-h

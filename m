Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755964Ab2KMXcc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 18:32:32 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:39362 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755153Ab2KMXca (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 18:32:30 -0500
Date: Tue, 13 Nov 2012 15:32:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Constantine Shulyupin <const@makelinux.com>
Cc: linux-kernel@vger.kernel.org, celinux-dev@lists.celinuxforum.org
Subject: Re: [PATCH] LDT - Linux Driver Template
Message-ID: <20121113233226.GA25922@kroah.com>
References: <1352832397-1349-1-git-send-email-const@MakeLinux.com>
 <20121113190123.GA32271@kroah.com>
 <CAE7jHC8H1aB5ZOLC+brXKNvk-842_EUrJUOim5SV4B1h7i7r5g@mail.gmail.com>
 <20121113230236.GA25569@kroah.com>
 <CAE7jHC9EU=1VWG+quFZw=9b9GTh+TLzCQQvpS0qMKXNznVZZYA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAE7jHC9EU=1VWG+quFZw=9b9GTh+TLzCQQvpS0qMKXNznVZZYA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 01:19:06AM +0200, Constantine Shulyupin wrote:
> On Wed, Nov 14, 2012 at 1:02 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Wed, Nov 14, 2012 at 12:31:13AM +0200, Constantine Shulyupin wrote:
> >> >> + *   Device Model (class, device)
> >> > Don't use class code in an example, it is slowly going away from the
> >> > whole kernel.
> >> What to use instead class_create and device_create?
> >
> > What are you trying to do?
> 
> I trying to properly register char device and device region.
> Single char device could be registered as misc device with just misc_register.

When you do that, the struct device is automatically registered with the
system, why do you need to do it again?

> How to register properly char devices region?

Using the proper calls, which are not the misc_register ones :)

> Should to use device_register instead device_create to create dev files?

Depends on what you want to do :)

> Which other registration functions char device must to call besides
> alloc_chrdev_region, cdev_add?

Again, I think you are mixing two different things here.  You can't mix
the char interface with the misc_register interface, they don't play
well, it's either one or the other.

Now I agree using the char interface isn't the most "obvious" and I have
a set of ideas/half-baked patches floating around that aim to clean it
up, but for now, I'd recommend just using the misc interface, it's
worlds simpler, makes sense, and handles all of the struct device work
for you automatically.

thanks,

greg k-h

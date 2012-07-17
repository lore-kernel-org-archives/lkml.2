Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754156Ab2GQBqG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 21:46:06 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:32868 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2GQBqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 21:46:03 -0400
Date: Mon, 16 Jul 2012 18:45:58 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ming Lei <ming.lei@canonical.com>
Cc: Sebastian Ott <sebott@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] driver core: move uevent call to driver_register
Message-ID: <20120717014558.GA28969@kroah.com>
References: <alpine.LFD.2.02.1207021900100.1784@c4eb>
 <CACVXFVM+u+o=R0M31mqqzmtRN4YvqgUKvJZKfBYtgH15JDh3bQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACVXFVM+u+o=R0M31mqqzmtRN4YvqgUKvJZKfBYtgH15JDh3bQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 09:35:02AM +0800, Ming Lei wrote:
> On Tue, Jul 3, 2012 at 1:08 AM, Sebastian Ott <sebott@linux.vnet.ibm.com> wrote:
> 
> > --- a/drivers/base/driver.c
> > +++ b/drivers/base/driver.c
> > @@ -187,6 +187,9 @@ int driver_register(struct device_driver
> >         ret = driver_add_groups(drv, drv->groups);
> >         if (ret)
> >                 bus_remove_driver(drv);
> > +
> > +       kobject_uevent(&drv->p->kobj, KOBJ_ADD);
> 
> You should just send the uevent if 'ret' equals to zero., otherwise
> OOPS may be triggered by kobject_uevent() after the 'drv' has been
> removed.

Ugh, just missed that.

Sebastian, care to send a follow-on patch for this?

thanks,

greg k-h

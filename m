Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754153Ab1IPN35 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 09:29:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:42781 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752182Ab1IPN34 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 09:29:56 -0400
Date: Fri, 16 Sep 2011 15:23:19 +0200
From: Greg KH <gregkh@suse.de>
To: Neil Horman <nhorman@tuxdriver.com>
Cc: linux-kernel@vger.kernel.org, Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: Re: [PATCH] sysfs: add per pci device msi[x] irq listing (v2)
Message-ID: <20110916132319.GC8973@suse.de>
References: <1316025413-5855-1-git-send-email-nhorman@tuxdriver.com>
 <1316117318-22027-1-git-send-email-nhorman@tuxdriver.com>
 <20110916083646.GA30915@suse.de>
 <20110916105716.GA32672@hmsreliant.think-freely.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110916105716.GA32672@hmsreliant.think-freely.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 06:57:16AM -0400, Neil Horman wrote:
> On Fri, Sep 16, 2011 at 10:36:46AM +0200, Greg KH wrote:
> > On Thu, Sep 15, 2011 at 04:08:38PM -0400, Neil Horman wrote:
> > > +static struct kobj_type msi_irq_ktype = {
> > > +	.sysfs_ops = &msi_irq_sysfs_ops,
> > > +	.default_attrs = msi_irq_default_attrs,
> > > +};
> > 
> > You still haven't successfully removed the kobject associated with this
> > kobj_type.  Otherwise you would have seen the error messages in the
> > kernel log and fixed up what it told you to fix.
> > 
> > Please do so.
> > 
> Well, I'm not using kobject_del, you're right, I'm just using a kobject_put, and
> I swear I'm not getting any error messages about it:

Then you really are not ever freeing that kobject, so there's a
reference counting bug in your code which you need to fix.

You will notice the real problem once you try to finally release that
kobject, trust me :)

greg k-h

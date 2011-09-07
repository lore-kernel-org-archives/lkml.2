Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751420Ab1IGQ1S (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:27:18 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:37556 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750859Ab1IGQ1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:27:16 -0400
X-Sasl-enc: eNex+BM8/Z1jGoF0j/5YisPeBelojDHNgcM/qvB3J82o 1315408225
Date: Wed, 7 Sep 2011 08:10:17 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "hverkuil@xs4all.nl" <hverkuil@xs4all.nl>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "mchehab@redhat.com" <mchehab@redhat.com>
Subject: Re: [PATCH] Staging: dt3155v4l: Convert printk's to pr_<level>
Message-ID: <20110907151017.GB30361@kroah.com>
References: <201109011653.56089.hartleys@visionengravers.com>
 <20110906235253.GC26281@kroah.com>
 <ADE657CA350FB648AAC2C43247A983F001F39D748D0C@AUSP01VMBX24.collaborationhost.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ADE657CA350FB648AAC2C43247A983F001F39D748D0C@AUSP01VMBX24.collaborationhost.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 06, 2011 at 07:15:38PM -0500, H Hartley Sweeten wrote:
> On Tuesday, September 06, 2011 4:53 PM, Greg KH wrote:
> > On Thu, Sep 01, 2011 at 04:53:55PM -0700, H Hartley Sweeten wrote:
> >> Convert all the printk(KERN_<level>) messages in the driver to pr_<level>()
> >> and use pr_fmt to provide the module name.
> >
> > What's wrong with using dev_* instead of pr_*?  Lots of these should be
> > converted to that format instead, right?
> 
> Nothing... dev_* should be used when possible.
> 
> Actually all of the messages look like they are just plain noise and should
> be removed.  Especially the ones in dt3155_{init,exit}_module.  A lot of the
> ones in dt3155_probe look like noise also.
> 
> The ones in {read,write,wait}_i2c_reg just look messy.  Those functions also
> don't have a device pointer to use the dev_* functions.

Really?  It should have an i2c device somewhere.

> The ones in dt3155_irq_handler seem troublesome.  Isn't it a bad idea to output
> a kernel message in an interrupt handler?

Yes, don't do that.

> dt3155_{open,close} also look like noise.  Same with dt3155_init_board.
> 
> Maybe I should just submit a patch removing all of them?

Please do :)

thanks,

greg k-h

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932448Ab1JROrA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Oct 2011 10:47:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:52096 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932420Ab1JROq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Oct 2011 10:46:58 -0400
Date: Tue, 18 Oct 2011 07:41:09 -0700
From: Greg KH <gregkh@suse.de>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Lee Jones <lee.jones@linaro.org>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linus.walleij@stericsson.com,
        jamie@jamieiles.com
Subject: Re: [PATCH 2/6] drivers/base: add bus for System-on-Chip devices
Message-ID: <20111018144109.GB19561@suse.de>
References: <1318852378-14180-1-git-send-email-lee.jones@linaro.org>
 <20111017161616.GA5108@suse.de>
 <4E9D5F29.1070303@linaro.org>
 <201110181614.02312.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201110181614.02312.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 18, 2011 at 04:14:02PM +0200, Arnd Bergmann wrote:
> On Tuesday 18 October 2011, Lee Jones wrote:
> > >> +struct device *soc_device_register(struct soc_device_attribute *soc_dev_attr)
> > >> +{
> > >> +    struct soc_device *soc_dev;
> > >> +    static atomic_t soc_device_num = ATOMIC_INIT(0);
> > > 
> > > No, please don't do this, use the proper kernel interface to dynamically
> > > handle numbering devices (hint, if you unload a SOC device, you will
> > > never reclaim that device number, which isn't that nice.)
> > 
> > Again, some help would really be appreciated here. I searched the kernel
> > last time you mentioned numbering, but this is all I came up with.
> 
> I guess the correct interface to use here would be an "ida", see
> linux/idr.h. However, I'm not convinced that's actually worth the
> extra space for maintaining it here.

Why?  That is the interface for this type of thing, it's very simple to
use, and it handles all of the logic for you for this type of thing.

Please don't roll your own solutions for things when there is already
code in the kernel to do it.

> IMHO, we could also remove the soc_device_unregister() function entirely
> and add a comment along the lines of 
> /*
>  * If you really need to add hot-pluggable soc_devices, add a
>  * soc_device_unregister function and turn the number generation
>  * into an IDA.
>  */

No, please provide this.  I want to see it tested, as when it is, then
the code will be fixed properly as right now it does some things it
shouldn't be doing in this regard.

greg k-h

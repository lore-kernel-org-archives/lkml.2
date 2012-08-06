Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755691Ab2HFJ61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:58:27 -0400
Received: from bar.sig21.net ([80.81.252.164]:36246 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754894Ab2HFJ6Z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:58:25 -0400
Date: Mon, 6 Aug 2012 11:58:05 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@wwwdotorg.org>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org
Subject: Re: DT GPIO numbering?
Message-ID: <20120806095805.GA16607@sig21.net>
References: <20120801152240.GA16388@sig21.net>
 <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
 <501F296B.4070004@wwwdotorg.org>
 <CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 08:35:51AM +0200, Linus Walleij wrote:
> On Mon, Aug 6, 2012 at 4:18 AM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
> > I can't comment on the sysfs-vs-dev interface location, but I don't
> > think it addresses Johannes' issue; finding out which GPIO IDs are
> > provided by which devices.
> >
> > Perhaps in each device's sysfs node, there should be some information
> > re: which GPIO range it provides. Right now, perhaps a text file with
> > the GPIO base it it.
> 
> Yes that could work ...

The method used by the gpio-mxs.c driver (of_alias_get_id)
would also work.  The question is which method is preferable.

Ideally I would like to use DT attributes to identify my GPIOs
in the same way as they appear in the schematics.  E.g.
one device may have GPIOs called PORT_A.0 to PORT_A.7,
another one may be EXT.0 to EXT.15.  But a single integer ID
is good enough since GPIO usage is platform specific anyway.
However, the mapping must be static and not depend e.g. on
module load order like now if you use pl061 and some i2c GPIO.
Software must be able to rely on that e.g. GPIO ID 11
always refers to EXT.3.


> > With the new /dev interface you mention above,
> > perhaps a symlink to the /dev file, or a file containing the /dev file's
> > major/minor number. Or, is there such a thing already (other than
> > debugfs's gpio file).
> 
> Nothing I know of, but yes the day we come up with something,
> it needs to be backward-compatible some way.
> 
> The problem is that there is really no reference userspace
> like "lsgpio" or so. Maybe the first step could be to create that.

I don't know much about OpenWrt, but I've seen they have
something:
https://dev.openwrt.org/browser/trunk/target/linux/generic/files/drivers/char/gpio_dev.c
https://dev.openwrt.org/browser/trunk/target/linux/generic/files/include/linux/gpio_dev.h
https://dev.openwrt.org/browser/trunk/package/gpioctl/src/main.c


Johannes

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2HNNHD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Aug 2012 09:07:03 -0400
Received: from bar.sig21.net ([80.81.252.164]:46033 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755355Ab2HNNHB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Aug 2012 09:07:01 -0400
Date: Tue, 14 Aug 2012 15:05:47 +0200
From: Johannes Stezenbach <js@sig21.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mitch Bradley <wmb@firmworks.com>, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Subject: Re: DT GPIO numbering?
Message-ID: <20120814130547.GB14756@sig21.net>
References: <20120801152240.GA16388@sig21.net>
 <CACRpkdZryc95WpSXddCrLvZGDsv4x-ndX9XcVzoxaDCT53AFLw@mail.gmail.com>
 <501F296B.4070004@wwwdotorg.org>
 <CACRpkdZ8AO5SrjJvJxvpauEadQOKMNaW_Pxxzhjk5hWnVB1b+g@mail.gmail.com>
 <20120806095805.GA16607@sig21.net>
 <501FA608.1030805@firmworks.com>
 <20120810093458.GA13192@sig21.net>
 <CACRpkdbQVHFWej=CPv0QOjH7OUr8Jj7wVjG=eRqkM=cbih1vAQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbQVHFWej=CPv0QOjH7OUr8Jj7wVjG=eRqkM=cbih1vAQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-21-Score: -2.9 (--)
X-Spam-21-Report: No, score=-2.9 required=8.0 tests=ALL_TRUSTED=-1,BAYES_00=-1.9 autolearn=ham
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 12:00:23PM +0200, Linus Walleij wrote:
> On Fri, Aug 10, 2012 at 11:34 AM, Johannes Stezenbach <js@sig21.net> wrote:
> 
> > Actually I think the kernel internal GPIO numbers shouldn't be in the
> > sysfs API, instead userspace should use the names.
> 
> This is true, but we cannot remove these numbers because they
> are now in Documentation/ABI/testing/sysfs-gpio
> 
> And while the "testing" ABI is, well for testing, it would probably
> break a lot of stuff it we removed it.
> 
> But we can sure add names. However these would still sit under
> /sys/class/gpio/gpioN/name
> 
> Or do you suggest we simply duplicate all GPIOs which have
> names under /sys/class/gpio/named/<name>
> or something like that?

I'm still not sure.  One idea was to add /proc/gpios which maps
names to numbers, then userspace can look up the number and use that.
But the more I think about it /sys/class/gpio/export is just
a debug hack and shouldn't be used.  Board code should export
the available gpio according to pinctrl setup and schematics.
The only catch here is that board code then needs to know which gpio are
for userspace and which are used by in-kernel drivers.
E.g. a LED could be set by LED Triggers or by userspace
Blinkenlight app.


Johannes

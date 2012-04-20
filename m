Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756071Ab2DTR2y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 13:28:54 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:44985 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752137Ab2DTR2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 13:28:52 -0400
Date: Fri, 20 Apr 2012 19:28:49 +0200
From: Johan Hovold <jhovold@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Richard Purdie <rpurdie@rpsys.net>, Samuel Ortiz <sameo@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Florian Tobias Schandinat <FlorianSchandinat@gmx.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-fbdev@vger.kernel.org
Subject: Re: [PATCH 2/4] misc: add LM3533 ambient light sensor driver
Message-ID: <20120420172849.GB12376@localhost>
References: <1334935826-12527-1-git-send-email-jhovold@gmail.com>
 <1334935826-12527-3-git-send-email-jhovold@gmail.com>
 <20120420155734.GE8327@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120420155734.GE8327@kroah.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 08:57:34AM -0700, Greg Kroah-Hartman wrote:
> On Fri, Apr 20, 2012 at 05:30:24PM +0200, Johan Hovold wrote:
> > Add sub-driver for the ambient light sensor in National Semiconductor /
> > TI LM3533 lighting power chips.
> > 
> > Raw ADC values as well as current ALS zone can be retrieved through
> > sysfs. The ALS zone can also be read using a character device
> > (/dev/lm3533-als) which is updated on zone changes (interrupt driven or
> > polled).
> > 
> > The driver provides a configuration interface through sysfs.
> 
> Which seems to not be documented at all :(

There are the following sysfs entries for configuring ALS control:

boundary0_high
boundary0_low
boundary1_high
boundary1_low
boundary2_high
boundary2_low
boundary3_high
boundary3_low

gain

target1_0
target1_1
target1_2
target1_3
target1_4

target2_0
target2_1
target2_2
target2_3
target2_4

target3_0
target3_1
target3_2
target3_3
target3_4

These define the "five light zones and three sets of corresponding
brightness target levels" mentioned in the Kconfig entry and provides a
gain setting.

Each entry also corresponds to an 8-bit register, which is documented
along with the overall ALS functionality in the datasheets (which will
be published on the TI web page soon). So I think anyone integrating
this IC (or anyone who has access to the datasheets) will have no
problem with this interface, but I'd be happy to write something to put
under Documentation as well.

The end-customer insisted on sysfs configurability, but I'll probably
add these settings to the platform data later as well. 

> What about using the iio interface for this instead?  Doesn't that
> already provide this standard interface you are looking for?

I had a look at iio last fall and decided not to use it at the time. I
can't remember exactly what the reasons were right now, so I'll have
to get back to you on this.

Thanks,
Johan

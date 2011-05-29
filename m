Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1E2LzX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 07:55:23 -0400
Received: from cantor.suse.de ([195.135.220.2]:45873 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752029Ab1E2LzW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 07:55:22 -0400
Date: Sun, 29 May 2011 19:45:17 +0800
From: Greg KH <gregkh@suse.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Cc: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for
 SPI flash ROM
Message-ID: <20110529114517.GA13513@suse.de>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com>
 <4DD6FB9E.2050604@tilera.com>
 <20110521032102.GD19907@suse.de>
 <201105211133.50238.arnd@arndb.de>
 <4DD7C3A7.5010402@tilera.com>
 <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com>
 <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com>
 <20110528212347.GA11303@suse.de>
 <4DE19407.8040407@tilera.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE19407.8040407@tilera.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 08:32:07PM -0400, Chris Metcalf wrote:
> > As you are only using 1 minor device, why not just use a misc device
> > instead?  It's simpler, and you get the sysfs code for free, which you
> > forgot to do, so your device node will never show up in userspace :(
> 
> Interesting; this appears to be a bug.  We use 4 minors (see "srom_devs =
> 4" higher up).  I'll fix this.  We may have some other devices that would
> benefit from being recast as misc devices, so I'll look at our set of
> internal devices.

This kind of implies that you didn't test this code, right?  You might
want to do that next time :)

> Is there a good example of a character device that has multiple minors and
> also is registered with sysfs?

Lots of them, look all over the kernel, and in LDD3 there's even an
outdated example of one I think.

thanks,

greg k-h

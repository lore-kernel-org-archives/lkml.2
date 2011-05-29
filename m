Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754265Ab1E2Ppn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 11:45:43 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:61056 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab1E2Ppm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 11:45:42 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chris Metcalf <cmetcalf@tilera.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for SPI flash ROM
Date: Sun, 29 May 2011 17:45:26 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39-rc4+; KDE/4.5.1; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <20110529114517.GA13513@suse.de> <4DE2399C.9090500@tilera.com>
In-Reply-To: <4DE2399C.9090500@tilera.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201105291745.26468.arnd@arndb.de>
X-Provags-ID: V02:K0:wBIItSTephB11ZSIE/fXfhfpiC2EzwwxsBN/VIy8Bck
 vyw7L4lQfE4tsOXjo9l7idgNCI7s1ZNFS9P2vqU33qBJEURhTJ
 oilxRKrnqLTtBiscX6liW8wGY69ObLpgIJIg5s3Y94m62QK3p/
 hzvWE4l9hlZMMfjQY60WkUc9IUk7HtRGBkb1mTjifOHyr7zr46
 1ngvkbO/GbvMTksdmtLVQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 29 May 2011 14:18:36 Chris Metcalf wrote:
> On 5/29/2011 7:45 AM, Greg KH wrote:
> > On Sat, May 28, 2011 at 08:32:07PM -0400, Chris Metcalf wrote:
> >>> As you are only using 1 minor device, why not just use a misc device
> >>> instead?  It's simpler, and you get the sysfs code for free, which you
> >>> forgot to do, so your device node will never show up in userspace :(
> >> Interesting; this appears to be a bug.  We use 4 minors (see "srom_devs =
> >> 4" higher up).  I'll fix this.  We may have some other devices that would
> >> benefit from being recast as misc devices, so I'll look at our set of
> >> internal devices.
> > This kind of implies that you didn't test this code, right?  You might
> > want to do that next time :)
> 
> No, this bug has been in the code since day one (I just double-checked our
> SCM), and it has always worked fine.  I'm looking into how this is possible
> now, but trust me, we've tested this aspect of the driver the whole time. :-)
> 

AFAICT, the driver just calls cdev_add in a loop, adding one device
add a time. This is actually a correct way to register multiple
character devices, but simply passing the number of devices you
want to add as the third argument would be simpler.

On a related note, the number of devices you add is a module parameter,
which seems a bit backwards, since the hypervisor should actually
know how many devices there are. Can't you just ask the hypervisor?

	Arnd

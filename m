Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753467Ab1E2MTj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 May 2011 08:19:39 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:29074 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab1E2MTh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 May 2011 08:19:37 -0400
Message-ID: <4DE2399C.9090500@tilera.com>
Date: Sun, 29 May 2011 08:18:36 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
        Eric Biederman <ebiederm@aristanetworks.com>,
        Chris Wright <chrisw@sous-sol.org>,
        Benjamin Thery <benjamin.thery@bull.net>,
        Phil Carmody <ext-phil.2.carmody@nokia.com>
Subject: Re: [PATCH v2] arch/tile: add hypervisor-based character driver for
 SPI flash ROM
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <4DD6FB9E.2050604@tilera.com> <20110521032102.GD19907@suse.de> <201105211133.50238.arnd@arndb.de> <4DD7C3A7.5010402@tilera.com> <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com> <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com> <20110528212347.GA11303@suse.de> <4DE19407.8040407@tilera.com> <20110529114517.GA13513@suse.de>
In-Reply-To: <20110529114517.GA13513@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/29/2011 7:45 AM, Greg KH wrote:
> On Sat, May 28, 2011 at 08:32:07PM -0400, Chris Metcalf wrote:
>>> As you are only using 1 minor device, why not just use a misc device
>>> instead?  It's simpler, and you get the sysfs code for free, which you
>>> forgot to do, so your device node will never show up in userspace :(
>> Interesting; this appears to be a bug.  We use 4 minors (see "srom_devs =
>> 4" higher up).  I'll fix this.  We may have some other devices that would
>> benefit from being recast as misc devices, so I'll look at our set of
>> internal devices.
> This kind of implies that you didn't test this code, right?  You might
> want to do that next time :)

No, this bug has been in the code since day one (I just double-checked our
SCM), and it has always worked fine.  I'm looking into how this is possible
now, but trust me, we've tested this aspect of the driver the whole time. :-)

>> Is there a good example of a character device that has multiple minors and
>> also is registered with sysfs?
> Lots of them, look all over the kernel, and in LDD3 there's even an
> outdated example of one I think.

 I didn't actually find many drivers that have both cdev_add with count>1,
and mention sysfs or kobj, but char/raw.c is one that looks pretty clean. 
(I found only four others total: uio/uio.c, s390/char/vmlogrdr.c,
staging/comedi/comedi_fops.c, and staging/vme/devices/vme_user.c.)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



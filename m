Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756440Ab1E2Aca (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 20:32:30 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:39445 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751883Ab1E2Ac2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 20:32:28 -0400
Message-ID: <4DE19407.8040407@tilera.com>
Date: Sat, 28 May 2011 20:32:07 -0400
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
References: <201105042004.p44K4kZx011721@farm-0032.internal.tilera.com> <4DD6FB9E.2050604@tilera.com> <20110521032102.GD19907@suse.de> <201105211133.50238.arnd@arndb.de> <4DD7C3A7.5010402@tilera.com> <BANLkTim-d-8w1_idg4u302aB3MqTo7q4Sg@mail.gmail.com> <201105281516.p4SFGfHg024703@farm-0010.internal.tilera.com> <20110528212347.GA11303@suse.de>
In-Reply-To: <20110528212347.GA11303@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/28/2011 5:23 PM, Greg KH wrote:
> On Sat, May 28, 2011 at 11:13:54AM -0400, Chris Metcalf wrote:
>> + * This source code is derived from code provided in "Linux Device
>> + * Drivers" by Alessandro Rubini and Jonathan Corbet, published by
>> + * O'Reilly & Associates.
>> + */
> LDD version 2?  Wow, this driver is old.

The driver was originally written in 2007. LDD3 came out in 2005, right?  I
guess we were a little behind the curve :-)

>> +MODULE_LICENSE("Dual BSD/GPL");
> Wait, where did the BSD come from?  You just said it was GPL only above
> in the header of the file?

Good point.  We have a boiler-plate auto-generated GPL license comment that
we use for kernel sources.  In general, we've tended toward licenses that
are as available to the community as possible -- for example, the string
code that we've written is under GPL in the kernel (and glibc) but under a
BSD license in newlib, because we wrote it all from scratch and can do
that.  And, since we're hardware vendors, our general goal is to enable
whatever kinds of software will sell chips.  :-)

My guess is that we should be using a consistent GPL-only license for these
kinds of kernel drivers, because frankly, they aren't useful outside the
context of Linux.  I'll double-check with the rest of the software team,
but I think we should probably just switch this over to a straight "GPL"
license.

> As you are only using 1 minor device, why not just use a misc device
> instead?  It's simpler, and you get the sysfs code for free, which you
> forgot to do, so your device node will never show up in userspace :(

Interesting; this appears to be a bug.  We use 4 minors (see "srom_devs =
4" higher up).  I'll fix this.  We may have some other devices that would
benefit from being recast as misc devices, so I'll look at our set of
internal devices.

Is there a good example of a character device that has multiple minors and
also is registered with sysfs?

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



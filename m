Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab1IAMv3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Sep 2011 08:51:29 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:59947 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932160Ab1IAMvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Sep 2011 08:51:25 -0400
Message-ID: <4E5F80B0.9060908@free-electrons.com>
Date: Thu, 01 Sep 2011 14:55:12 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Lightning/1.0b2 Thunderbird/3.1.11
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: dedekind1@gmail.com, linux-embedded <linux-embedded@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Tim Bird <tim.bird@am.sony.com>, David Woodhouse <dwmw2@infradead.org>
Subject: Re: [PATCHv3] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com>	<201108241823.20904.arnd@arndb.de>	<1314256010.18988.18.camel@sauron> <201108251712.40894.arnd@arndb.de>
In-Reply-To: <201108251712.40894.arnd@arndb.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/25/2011 05:12 PM, Arnd Bergmann wrote:
> The cost of a block device node in the kernel is rather low. Nowadays,
> sysfs does not even permanently use inodes for entries, it has a much
> more compact internal representation IIRC.
> 
> The main advantage of this approach is not having to set up the 
> block device at all, it would just be there, which e.g. makes it
> possible to put a root file system on it or do something else without
> requiring a user space tool to issue an ioctl.

Before patch v3, every existing and new UBI volumes were "proxyfied" by
ubiblk and it was, indeed, one of our goal to be able to have a rootfs
on it.  Patch v3 hinders that goal but it could still be achievable by
adding a module parameter that would explicitly create a ubiblk device
for a UBI volume at boot time.

I for one am fine with both solutions (keep the ioctl + add a kernel
parameter and throwing the ioctl away and go back "automatically create
a ubiblk for each UBI volume").  However, I agree that it doesn't make
sense to create a ubiblk device on top of UBI volumes containing, for
instance, a ubifs.

	Best Regards,
	David.

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab0FCMbl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:31:41 -0400
Received: from bamako.nerim.net ([62.4.17.28]:60927 "EHLO bamako.nerim.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752118Ab0FCMbk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:31:40 -0400
Date: Thu, 3 Jun 2010 14:31:36 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
       "Ben Dooks (embedded platforms)" <ben-linux@fluff.org>,
       Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org
Subject: Re: [PATCH 07/12] i2cdev: move compat_ioctl handling into driver
Message-ID: <20100603143136.1ef97b04@hyperion.delvare>
In-Reply-To: <200912141631.46300.arnd@arndb.de>
References: <1258331227-1694-1-git-send-email-arnd@arndb.de>
	<1258331227-1694-8-git-send-email-arnd@arndb.de>
	<20091214152307.5ba3ea4d@hyperion.delvare>
	<200912141631.46300.arnd@arndb.de>
X-Mailer: Claws Mail 3.5.0 (GTK+ 2.14.4; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Arnd,

On Mon, 14 Dec 2009 16:31:45 +0100, Arnd Bergmann wrote:
> On Monday 14 December 2009, Jean Delvare wrote:
> > This patch no longer applies so I can't test it. I do not have any
> > objection about it though.
> 
> The patch is part of a longer series of patches moving code out
> of fs/compat_ioctl.c. If you want to test it, you can just apply the
> half adding it to i2c-dev.c and that version will be used.
> 
> That part has gained a trivial conflict against an #include cleanup.

It was long ago, there are even more conflicts now.

> > I'm also not sure what I am supposed to comment on. As far as I can
> > see, most of this patch is merely moving code from one file to another,
> > so there's little point in reviewing that code. Is there any part in
> > particular which needs my attention?
> 
> No, nothing particular. I was just running the whole series by the
> maintainers (or the closest approximation of that) in order to
> collect Acked-by and/or have people include the patches in their
> trees, especially the ones that I didn't have a test case for.
> The patches I got an Ack for were merged now, and I'll repost
> the rest after -rc1 to prepare them for the next merge window.
> 
> A good way to avoid conflicts would be if you take the i2c-dev.c
> parts into a tree of yours and let me follow up with removing the
> code from fs/compat_ioctl.c once your tree is merged.
> 
> If everyone does that, I can just remove half of fs/compat_ioctl.c
> at once.
> 
> > If you want to test your patch yourself, it is fairly easy using the
> > i2c-stub driver, which is a software-only i2c bus driver. Install the
> > i2c-tools package on your system, and then:
> > 
> > # modprobe i2c-stub chip_addr=0x6d
> > # modprobe i2c-dev
> > # i2cdetect -l
> > # i2cbus=$(i2cdetect -l | grep stub | cut -f1 | cut -d- -f2)
> > # i2cdetect -F $i2cbus
> > Functionalities implemented by /dev/i2c-x:
> > I2C                              no
> > SMBus Quick Command              yes
> > SMBus Send Byte                  yes
> > SMBus Receive Byte               yes
> > SMBus Write Byte                 yes
> > SMBus Read Byte                  yes
> > SMBus Write Word                 yes
> > SMBus Read Word                  yes
> > SMBus Process Call               no
> > SMBus Block Write                no
> > SMBus Block Read                 no
> > SMBus Block Process Call         no
> > SMBus PEC                        no
> > I2C Block Write                  no
> > I2C Block Read                   no
> > # i2cset -y $i2cbus 0x6d 0x00 0x42 b
> > Value 0x42 written, readback matched
> > # i2cget -y $i2cbus 0x6d 0x00 b
> > 0x42
> > #
> > 
> > The last 3 commands will generate i2c-dev ioctls.
> 
> Ok, I'll try that, thanks!

Were you able to perform your tests? What's the status of your patch? I
can't do much without a patch which at least applies and builds.

-- 
Jean Delvare

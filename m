Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753215Ab0LREIZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 23:08:25 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59739 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750886Ab0LREIX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 23:08:23 -0500
From: Rob Landley <rob@landley.net>
Organization: Boundaries Unlimited
To: dedekind1@gmail.com
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
Date: Fri, 17 Dec 2010 22:08:16 -0600
User-Agent: KMail/1.11.2 (Linux/2.6.28-19-generic; KDE/4.2.2; x86_64; ; )
Cc: Jason Lunz <lunz@acm.org>, Denys Vlasenko <vda.linux@googlemail.com>,
        "richard -rw- weinberger" <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com> <201012150031.21417.rob@landley.net> <1292512711.2364.85.camel@localhost>
In-Reply-To: <1292512711.2364.85.camel@localhost>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201012172208.17937.rob@landley.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 December 2010 09:18:31 Artem Bityutskiy wrote:
> On Wed, 2010-12-15 at 00:31 -0600, Rob Landley wrote:
> > That is awesome and I'm not finding any documentation on it...  Ah:
> >
> >  
> > http://wiki.maemo.org/Modifying_the_root_image#Block_device_emulating_an_
> >MTD_device
> >
> > Wow that's awkward.  Let's see, that says...
> >
> >   mknod /tmp/mtdblock0 b 31 0
> >   modprobe loop
> >   losetup /dev/loop0 rootfs.jffs2
> >   modprobe mtdblock
> >   modprobe block2mtd
> >   # Note the ,128KiB is needed (on 2.6.26 at least) to set the
> >   # eraseblock  size.
> >   echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
> >   modprobe jffs2
> >   mount -t jffs2 /tmp/mtdblock0 /media/jffs2
>
> You should not need mtdblock in modern kernels, it is legacy. You should
> be abole to mount jffs2 on top of mtd0 with
>
> mount -t jffs2 mtd0 /media/jffs2

How does one associate the mtd0 with the loopback device?  (I thought mtd0 was 
for actual flash memory.)

Rob
-- 
GPLv3: as worthy a successor as The Phantom Menace, as timely as Duke Nukem 
Forever, and as welcome as New Coke.

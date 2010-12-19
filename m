Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0LSRI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 12:08:29 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:53328 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752390Ab0LSRI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 12:08:28 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=LFkQZvuw9y8OEjThfQ+sn4yv0hP1y7F7GhDpbHU+vkG2+h/oJ4uXCm4zAe2NaVdlhd
         im9zfE44wAmeywyMxov44jcns5SaLSop1J9gI5OlM/atVu5GMITbgQA0DbYM0tYZK3hY
         SGYXatey9dibpuOWry8ViK+67G2l6MGZOrEnc=
Subject: Re: [PATCH] mtd: allow mtd and jffs2 when ARCH=um
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Rob Landley <rob@landley.net>
Cc: Jason Lunz <lunz@acm.org>, Denys Vlasenko <vda.linux@googlemail.com>,
        richard -rw- weinberger <richard.weinberger@gmail.com>,
        Sam Ravnborg <sam@ravnborg.org>, David Woodhouse <dwmw2@infradead.org>,
        atom ota <atomota@sleepyhammer.com>,
        user-mode-linux-devel@lists.sourceforge.net,
        Jeff Dike <jdike@addtoit.com>, lkml <linux-kernel@vger.kernel.org>,
        linux-mtd@lists.infradead.org
In-Reply-To: <201012172208.17937.rob@landley.net>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	 <201012150031.21417.rob@landley.net> <1292512711.2364.85.camel@localhost>
	 <201012172208.17937.rob@landley.net>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 19 Dec 2010 19:08:22 +0200
Message-ID: <1292778502.13362.13.camel@koala>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-12-17 at 22:08 -0600, Rob Landley wrote:
> On Thursday 16 December 2010 09:18:31 Artem Bityutskiy wrote:
> > On Wed, 2010-12-15 at 00:31 -0600, Rob Landley wrote:
> > > That is awesome and I'm not finding any documentation on it...  Ah:
> > >
> > >  
> > > http://wiki.maemo.org/Modifying_the_root_image#Block_device_emulating_an_
> > >MTD_device
> > >
> > > Wow that's awkward.  Let's see, that says...
> > >
> > >   mknod /tmp/mtdblock0 b 31 0
> > >   modprobe loop
> > >   losetup /dev/loop0 rootfs.jffs2
> > >   modprobe mtdblock
> > >   modprobe block2mtd
> > >   # Note the ,128KiB is needed (on 2.6.26 at least) to set the
> > >   # eraseblock  size.
> > >   echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
> > >   modprobe jffs2
> > >   mount -t jffs2 /tmp/mtdblock0 /media/jffs2
> >
> > You should not need mtdblock in modern kernels, it is legacy. You should
> > be abole to mount jffs2 on top of mtd0 with
> >
> > mount -t jffs2 mtd0 /media/jffs2
> 
> How does one associate the mtd0 with the loopback device?  (I thought mtd0 was 
> for actual flash memory.)

You do not need loopback devices, just flash your rootfs.jffs2 directly
to /dev/mtd0, e.g., with nandwrite. You can emulate nand with nandsim.

But your method should also work, I just wanted to point that JFFS2 does
not depend on mtdblock in any way.

-- 
Best Regards,
Artem Bityutskiy (Битюцкий Артём)


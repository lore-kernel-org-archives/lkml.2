Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756356Ab0LPPTK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Dec 2010 10:19:10 -0500
Received: from mail-bw0-f66.google.com ([209.85.214.66]:62827 "EHLO
	mail-bw0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756271Ab0LPPTG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Dec 2010 10:19:06 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:reply-to:to:cc:in-reply-to:references:content-type
         :date:message-id:mime-version:x-mailer:content-transfer-encoding;
        b=HUhcXVee8L3Jov6TO1hUECkF7YSUGcn9DnATYlq3JqxHJGs/2XmgYhZCZgyOiJUYjo
         Zn7G47UzZ1HLjkA9nT9UlQ0filRqdCcoZL46idDm85Un/wGnwbd25gQcMLZqLomc5x4v
         W5DpW6slNE3666k5htY5xwcJxRUII3UzDyuDo=
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
In-Reply-To: <201012150031.21417.rob@landley.net>
References: <22c797d00709272118i33d32b9dy93d5f5ec8f8edd30@mail.gmail.com>
	 <201012141849.03926.rob@landley.net> <20101215011904.GA24292@falooley.org>
	 <201012150031.21417.rob@landley.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 16 Dec 2010 17:18:31 +0200
Message-ID: <1292512711.2364.85.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 (2.32.1-1.fc14) 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-15 at 00:31 -0600, Rob Landley wrote:
> That is awesome and I'm not finding any documentation on it...  Ah:
> 
>   http://wiki.maemo.org/Modifying_the_root_image#Block_device_emulating_an_MTD_device
> 
> Wow that's awkward.  Let's see, that says...
> 
>   mknod /tmp/mtdblock0 b 31 0
>   modprobe loop
>   losetup /dev/loop0 rootfs.jffs2
>   modprobe mtdblock
>   modprobe block2mtd
>   # Note the ,128KiB is needed (on 2.6.26 at least) to set the
>   # eraseblock  size.
>   echo "/dev/loop0,128KiB" > /sys/module/block2mtd/parameters/block2mtd
>   modprobe jffs2
>   mount -t jffs2 /tmp/mtdblock0 /media/jffs2

You should not need mtdblock in modern kernels, it is legacy. You should
be abole to mount jffs2 on top of mtd0 with

mount -t jffs2 mtd0 /media/jffs2

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751864Ab1KBUws (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 16:52:48 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57963 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025Ab1KBUwm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 16:52:42 -0400
Date: Wed, 2 Nov 2011 21:52:40 +0100 (CET)
From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
X-X-Sender: lyakh@axis700.grange
To: Magnus Damm <magnus.damm@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] ARM: mach-shmobile: sh7372 A4R support (v4)
In-Reply-To: <CANqRtoS5KTws7rDoHkxrq8DP+js5xq=YF3zQG4MYmmjHEtv5NA@mail.gmail.com>
Message-ID: <Pine.LNX.4.64.1111022131460.19054@axis700.grange>
References: <201110200012.43840.rjw@sisk.pl> <201110200015.06277.rjw@sisk.pl>
 <Pine.LNX.4.64.1111021132240.19054@axis700.grange>
 <CANqRtoS5KTws7rDoHkxrq8DP+js5xq=YF3zQG4MYmmjHEtv5NA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Provags-ID: V02:K0:t3s14MZvCfT9asv81St8GJiqvQlV0Dk6kD46AanUsnS
 lkd1Q5qDetjIzuK0da0Hrb+tvVuuWvj9vNXIqjbQZzIIzMAyK+
 /xJJPRsfAtZ1jHd+c/s73SAlJha9VYeu11haQ4/d9kHFy37GsN
 8lINmET2z1TZFj6y2ONvHfBq7yw7u2qLalZ6xv+foyWL2jbwu7
 bd0rhI8WwSrX67R0ZGv5q5ErmsLpSnhD/+iDjtdSPJyB2oOwv5
 fKEDkXU6JBZRYXxuplwGDG5piML936foEawtxnaaOqbF5z+gIJ
 tZ6dHlDVO/HT+sOJTEzEfTgzcrAunLr6D2I1CtXR5Z/zoudpcw
 imVZWqVnWM7ekjMnGB1pdJ8bnDBUzDcyiYtVkt9UGSn6vS9nMt
 8el0CQFev4R0w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Magnus

On Wed, 2 Nov 2011, Magnus Damm wrote:

> On Wed, Nov 2, 2011 at 11:38 AM, Guennadi Liakhovetski
> <g.liakhovetski@gmx.de> wrote:
> > On Thu, 20 Oct 2011, Rafael J. Wysocki wrote:
> >
> >> From: Magnus Damm <damm@opensource.se>
> >>
> >> This change adds support for the sh7372 A4R power domain.
> >
> > This version still breaks I2C (#0) on mackerel. Tested with your
> > sh7372-test branch of Oct 18th plus these four patches:
> >
> > 6b29305a PM / Domains: Add default power off governor function (v2)
> > 3d578ae PM / Domains: Add device stop governor function (v2)
> > 6c2cd02 ARM: mach-shmobile: sh7372 A4R support (v4)
> > 9da11f4 ARM: mach-shmobile: sh7372 A3SP support (v4)
> 
> Exactly how does it break IIC0?

We discussed it a couple of weeks ago, remember? Here's a quote:

> > > 3. I2C #0 doesn't work (last worked with some 3.1-rc7 based kernel). It is
> > > needed for the keypad, without which I don't know how the board can be
> > > woken up
> > 
> > That's odd. It worked fine when I tested with Morimoto-san earlier
> > today. Are we using the same code?
> 
> I hope so. I'm using what Rafael suggested in his mail:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/rafael/linux-pm.git sh7372-test
> 
> HEAD currently at commit
> 
> commit 2b7a2158042fbed2dc0c677d24efc2d3c8680186
> Author: Magnus Damm <damm@opensource.se>
> Date:   Sun Oct 16 23:35:59 2011 +0200
> 
>     ARM: mach-shmobile: sh7372 A4R support (v3)
> 
> I2C works with HEAD^

Of course, now testing with v4 of A3SP and A4R patches. As for "exactly 
how":

i2c-sh_mobile i2c-sh_mobile.0: I2C adapter 0 with bus speed 100000 Hz
i2c-sh_mobile i2c-sh_mobile.1: I2C adapter 1 with bus speed 100000 Hz
Linux video capture interface: v2.00
soc-camera-pdrv soc-camera-pdrv.0: Probing soc-camera-pdrv.0
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver attached to camera 0
sh_mobile_ceu sh_mobile_ceu.0: SuperH Mobile CEU driver detached from camera 0
i2c-sh_mobile i2c-sh_mobile.0: Transfer request timed out
i2c-sh_mobile i2c-sh_mobile.0: Polling timed out
tca6416-keypad 0-0020: tca6416_read_reg failed, reg: 1, error: -5
tca6416-keypad: probe of 0-0020 failed with error -5

So, seems just not to be enabled.

> Does the same happen with the code base for upcoming 3.2-rc1 from
> latest linux git?

Good question:

linux-2.6/arch/arm/kernel/entry-armv.S: Assembler messages:
linux-2.6/arch/arm/kernel/entry-armv.S:501: Error: backward ref to unknown label "2:"
linux-2.6/arch/arm/kernel/entry-armv.S:502: Error: backward ref to unknown label "3:"
make[2]: *** [arch/arm/kernel/entry-armv.o] Error 1

So, no, it doesn't;-)

Thanks
Guennadi
---
Guennadi Liakhovetski, Ph.D.
Freelance Open-Source Software Developer
http://www.open-technology.de/

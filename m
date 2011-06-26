Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623Ab1FZSVR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 14:21:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:62509 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753416Ab1FZSUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 14:20:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Sun, 26 Jun 2011 20:20:20 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <201106261913.05752.arnd@arndb.de> <4E076CC6.2070408@redhat.com>
In-Reply-To: <4E076CC6.2070408@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262020.20432.arnd@arndb.de>
X-Provags-ID: V02:K0:qFymacbJqviu56UgDuI0mgH46OCzRVZjU6FtDn7bmHu
 4tlhCJwjR56yuiMDZrul2e4zmJN2R3siANGrTFrlme5McdsB+u
 m1t7S1rnNHAkaflce2FjYI73rV7kC2BfajbQ0bAR2yx3bqxbHL
 19rE2dYr39E+lZ9/5oIe31+M7nUVo7go3PbJkKaSqlgYUF75il
 pWNPp4bTtW2R+0fxIgmlA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 June 2011 19:30:46 Mauro Carvalho Chehab wrote:
> > There was a lot of debate whether undefined ioctls on non-ttys should
> > return -EINVAL or -ENOTTY, including mass-conversions from -ENOTTY to
> > -EINVAL at some point in the pre-git era, IIRC.
> > 
> > Inside of v4l2, I believe this is handled by video_usercopy(), which
> > turns the driver's -ENOIOCTLCMD into -ENOTTY. What cases do you observe
> > where this is not done correctly and we do return ENOIOCTLCMD to
> > vfs_ioctl?
> 
> Well, currently, it is returning -EINVAL maybe due to the mass-conversions
> you've mentioned.

I mean what do you return *to* vfs_ioctl from v4l? The conversions must
have been long before we introduced compat_ioctl and ENOIOCTLCMD.

As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
EINVAL, so changing the vfs functions would not have any effect.

> The point is that -EINVAL has too many meanings at V4L. It currently can be
> either that an ioctl is not supported, or that one of the parameters had
> an invalid parameter. If the userspace can't distinguish between an unimplemented
> ioctl and an invalid parameter, it can't decide if it needs to fall back to
> some different methods of handling a V4L device.
> 
> Maybe the answer would be to return -ENOTTY when an ioctl is not implemented.

That is what a lot of subsystems do these days. But wouldn't that change
your ABI?

	Arnd

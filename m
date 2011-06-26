Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754488Ab1FZTzW (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jun 2011 15:55:22 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:55762 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab1FZTxb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jun 2011 15:53:31 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [PATCH] [media] v4l2 core: return -ENOIOCTLCMD if an ioctl doesn't exist
Date: Sun, 26 Jun 2011 21:52:52 +0200
User-Agent: KMail/1.13.6 (Linux/3.0.0-rc1nosema+; KDE/4.6.3; x86_64; ; )
Cc: Sakari Ailus <sakari.ailus@iki.fi>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
References: <4E0519B7.3000304@redhat.com> <201106262020.20432.arnd@arndb.de> <4E077FB9.7030600@redhat.com>
In-Reply-To: <4E077FB9.7030600@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201106262152.53096.arnd@arndb.de>
X-Provags-ID: V02:K0:fTl1sO+wl+3pMtU2eVPzuOmQO1jye5qJ7OHUEIPhDbi
 JWiYzd3p+ncpEqO883v3ij1BgA0Mb0bj6po2i76oz9ALUmiHyi
 avMM0F5tITUjtmVSyzPHBBVLNyBkG6LcVpGuEr8lpwWeg4sWZv
 hPPeHVytzoKiRlJafzY09sZ/vT6jMALS/NGqy90YQSrd4I3uzD
 zy0IwAjSUFJgWGgIp+pUw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 26 June 2011 20:51:37 Mauro Carvalho Chehab wrote:
> > 
> > I mean what do you return to vfs_ioctl from v4l? The conversions must
> > have been long before we introduced compat_ioctl and ENOIOCTLCMD.
> > 
> > As far as I can tell, video_ioctl2 has always converted ENOIOCTLCMD into
> > EINVAL, so changing the vfs functions would not have any effect.
> 
> Yes.  This discussion was originated by a RFC patch proposing to change 
> video_ioctl2 to return -ENOIOCTLCMD instead of -EINVAL.

Ok, I see. So returning -ENOIOCTLCMD is not an option IMHO, but if you
are confident that it doesn't break anything, returning -ENOTTY would
be possible and doesn't require any core changes.

	Arnd

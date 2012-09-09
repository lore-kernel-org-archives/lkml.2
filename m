Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755297Ab2IIVYi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Sep 2012 17:24:38 -0400
Received: from ares07.inai.de ([5.9.24.206]:49434 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751641Ab2IIVYh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Sep 2012 17:24:37 -0400
Date: Sun, 9 Sep 2012 23:24:35 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Andy Lutomirski <luto@amacapital.net>
cc: Colin Walters <walters@verbum.org>, linux-kernel@vger.kernel.org
Subject: Re: linux-user-chroot 2012.2
In-Reply-To: <CALCETrVOcNxfiAm0QDUjqhn=yx5LTPEKBJw8To-AcOTM3d1UcQ@mail.gmail.com>
Message-ID: <alpine.LNX.2.01.1209092322540.22738@frira.zrqbmnf.qr>
References: <1344632282.9131.5.camel@lenny> <CALCETrVOcNxfiAm0QDUjqhn=yx5LTPEKBJw8To-AcOTM3d1UcQ@mail.gmail.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Monday 2012-08-13 20:10, Andy Lutomirski wrote:
>
>One of these days, I intend to resurrect my unprivileged chroot kernel
>patches.  My current thought is to add a new syscall weak_chroot,
>which should have these properties:
>[...]
>3. Can't be used to break out of chroot jail.
>
>The interface might be:
>
>weak_chroot_at(int fd, const char *path, int flags)
>[...]
>I'm somewhat tempted to add a flag to weak_chroot_at to break out of
>weak_root jail to prevent people from thinking that it's a security
>feature.  I'm not sure about that, though.

An at variant of chroot would seem to be even more open than the
current name-based variant of chroot.

fd1 = open("/", O_DIRECTORY);
fd2 = open("/home/whatever", O_DIRECTORY);
weak_chroot_at(fd2, ".", 0)
weak_chroot_at(fd1, ".", 0)




Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0HBNiG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:38:06 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:57898 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751083Ab0HBNiE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:38:04 -0400
To: Bastien ROUCARIES <roucaries.bastien@gmail.com>
CC: Valdis.Kletnieks@vt.edu, miklos@szeredi.hu, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
In-reply-to: <AANLkTimpYoFmGoy_he0vND9FwixcuhBrz2a8NUbhoO4w@mail.gmail.com>
	(message from Bastien ROUCARIES on Mon, 2 Aug 2010 15:21:48 +0200)
Subject: Re: [PATCH 6/7] vfs: only add " (deleted)" where necessary
References: <20100802111955.025275647@szeredi.hu>
	<20100802112024.851698363@szeredi.hu>
	<215565.1280754056@localhost> <AANLkTimpYoFmGoy_he0vND9FwixcuhBrz2a8NUbhoO4w@mail.gmail.com>
MIME-version: 1.0
Content-type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Message-Id: <E1OfvDK-0003fw-WD@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Aug 2010 15:37:58 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010, Bastien ROUCARIES wrote:
> On Mon, Aug 2, 2010 at 3:00 PM,  <Valdis.Kletnieks@vt.edu> wrote:
> > On Mon, 02 Aug 2010 13:20:01 +0200, Miklos Szeredi said:
> >
> >> Index: linux-2.6/fs/dcache.c
> >> ===================================================================
> >> --- linux-2.6.orig/fs/dcache.c        2010-07-06 18:08:16.000000000 +0200
> >> +++ linux-2.6/fs/dcache.c     2010-07-06 18:08:19.000000000 +0200
> >> @@ -1977,8 +1977,7 @@ global_root:
> >>   * @buffer: buffer to return value in
> >>   * @buflen: buffer length
> >>   *
> >> - * Convert a dentry into an ASCII path name. If the entry has been deleted
> >> - * the string " (deleted)" is appended. Note that this is ambiguous.
> >> + * Convert a dentry into an ASCII path name.
> >>   *
> >>   * Returns a pointer into the buffer or an error code if the
> >>   * path was too long.
> >
> > I'd prefer the comment about it being ambiguous remain.  I'm waiting to see how
> > long it takes for somebody to create a security hole by creating a file called
> > '/etc/some/thing/important (deleted)' and having some software Do The Wrong
> > Thing instead to /etc/some/thing/important.
> >
> 
> In order to close this kind of hole why not creating a deleted
> directory on /proc and redirect symbolic link to this directory.
> And do the same for unreachable. If we use the good permission it will
> work from a backaward compatibily point of view

Unfortunately the "(deleted)" thing is part of the userspace ABI and
can't be changed.

The only thing we can do is make sure new interfaces use a saner
convention.

Thanks,
Miklos

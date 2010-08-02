Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969Ab0HBNf2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 09:35:28 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:52846 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752777Ab0HBNf0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 09:35:26 -0400
To: Valdis.Kletnieks@vt.edu
CC: miklos@szeredi.hu, viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-reply-to: <215565.1280754056@localhost> (Valdis.Kletnieks@vt.edu)
Subject: Re: [PATCH 6/7] vfs: only add " (deleted)" where necessary
References: <20100802111955.025275647@szeredi.hu>
            <20100802112024.851698363@szeredi.hu> <215565.1280754056@localhost>
Message-Id: <E1OfvAm-0003eo-OP@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Mon, 02 Aug 2010 15:35:20 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010, Valdis.Kletnieks@vt.ed wrote:
> On Mon, 02 Aug 2010 13:20:01 +0200, Miklos Szeredi said:
> 
> > Index: linux-2.6/fs/dcache.c
> > ===================================================================
> > --- linux-2.6.orig/fs/dcache.c	2010-07-06 18:08:16.000000000 +0200
> > +++ linux-2.6/fs/dcache.c	2010-07-06 18:08:19.000000000 +0200
> > @@ -1977,8 +1977,7 @@ global_root:
> >   * @buffer: buffer to return value in
> >   * @buflen: buffer length
> >   *
> > - * Convert a dentry into an ASCII path name. If the entry has been deleted
> > - * the string " (deleted)" is appended. Note that this is ambiguous.
> > + * Convert a dentry into an ASCII path name.
> >   *
> >   * Returns a pointer into the buffer or an error code if the
> >   * path was too long.
> 
> I'd prefer the comment about it being ambiguous remain.  I'm waiting
> to see how long it takes for somebody to create a security hole by
> creating a file called '/etc/some/thing/important (deleted)' and
> having some software Do The Wrong Thing instead to
> /etc/some/thing/important.

The same comment is left intact on top of d_path().

It is removed from __d_path() because this function no longer appends
"(deleted)".

Thanks,
Miklos

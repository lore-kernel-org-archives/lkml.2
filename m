Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760186Ab0LNVXq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:23:46 -0500
Received: from www84.your-server.de ([213.133.104.84]:44431 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760113Ab0LNVXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:23:44 -0500
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
From: Stefani Seibold <stefani@seibold.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>
In-Reply-To: <AANLkTinPkGHASWubtUY1aDbnxv8V3uGvV+b+e+TkSiVS@mail.gmail.com>
References: <1292150923-25586-1-git-send-email-stefani@seibold.net>
	 <20101214125143.0ab00c97.akpm@linux-foundation.org>
	 <AANLkTinPkGHASWubtUY1aDbnxv8V3uGvV+b+e+TkSiVS@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 22:24:38 +0100
Message-ID: <1292361878.29621.10.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 14.12.2010, 13:08 -0800 schrieb Linus Torvalds:
> On Tue, Dec 14, 2010 at 12:51 PM, Andrew Morton
> <akpm@linux-foundation.org> wrote:
> >
> > Did you look at using iunique() to generate cramfs inode numbers?
> 
> That breaks the cramfs "hardlinking" (which is just files that have
> the same data pointer), and now a hardlinked file wouldn't have the
> same inode number any more.
> 
> Of course, I'm not sure the hardlinking really matters. cramfs
> hardlinks aren't really traditional hardlinks anyway - since the
> permissions etc are in the directory entry, you can have the data
> hardlinked without having the same permissions, so it's not a "real"
> hardlink even if the inode number were to be the same.
> 

In my opinion hardlinks doesn't matter, because cramfs has no real
hardlinks.

> But this patch seems to roughly approximate the old pseudo-hardlink
> behavior. It used to be that all non-data files showed up with the
> same inode number, now they have separate inode numbers.
> 
> That said, I hate how it moves that "setup_inode" helper function
> inline and then does the "if it's a character device" kinds of tests
> twice. Once for the inode number logic, and once for the inode
> operations structure assignment.
> 
> So I think the approach is fine, but I think the implementation is pretty ugly.
> 

Okay, i will see if i find a better solution. The problem is that the
inode number generation CRAMINO will be called from two different
functions, get_cramfs_inode() and cramfs_readdir(). So it is much more
readable to have one function which creates the inode than an two
optimized implementations.

Stefani



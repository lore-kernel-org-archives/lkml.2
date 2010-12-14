Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760185Ab0LNV1D (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 16:27:03 -0500
Received: from www84.your-server.de ([213.133.104.84]:56965 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760158Ab0LNV1C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 16:27:02 -0500
Subject: Re: [PATCH] cramfs: generate unique inode number for better inode
 cache usage
From: Stefani Seibold <stefani@seibold.net>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>
In-Reply-To: <20101214131204.c263d6a3.akpm@linux-foundation.org>
References: <1292150923-25586-1-git-send-email-stefani@seibold.net>
	 <20101214125143.0ab00c97.akpm@linux-foundation.org>
	 <1292360550.29366.4.camel@wall-e>
	 <20101214131204.c263d6a3.akpm@linux-foundation.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 14 Dec 2010 22:27:53 +0100
Message-ID: <1292362073.29621.13.camel@wall-e>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Dienstag, den 14.12.2010, 13:12 -0800 schrieb Andrew Morton:
> On Tue, 14 Dec 2010 22:02:30 +0100
> Stefani Seibold <stefani@seibold.net> wrote:
> 
> > Am Dienstag, den 14.12.2010, 12:51 -0800 schrieb Andrew Morton:
> > > On Sun, 12 Dec 2010 11:48:42 +0100
> > > stefani@seibold.net wrote:
> > > 
> > > > This patch generates a unique inode numbers for any entries in the cram file
> > > > system. For files which did not contain data's (device nodes, fifos and
> > > > sockets) the offset of the directory entry inside + 1 will be used as the
> > > > inode number.
> > > > 
> > > > The + 1 for the inode will it make possible to distinguish between
> > > > a file which contains no data and files which has data, the later one has
> > > > a inode value where the lower two bits are always 0.
> > > > 
> > > > It also reimplement the behavoir to set the size and the number of block
> > > > to 0 for special file, which is the right value for devices, fifos and
> > > > sockets.
> > > > 
> > > > As a little benefit it will be also more compatible which older
> > > > mkcramfs, because it will never use the cramfs_inode->offset for
> > > > creating a inode number for special files.
> > > 
> > > Did you look at using iunique() to generate cramfs inode numbers?
> > 
> > iunique() will create random inode numbers, depending on the order of
> > the accessed files.
> 
> It generates non-unique inode numbers and uses Weird Nonstandard
> Private Stuff in a place where we could use standard kernel facilities.

Disagree, it will create uniqe inode. And if the "standard" kernel
facilities will not serve right, than it is necessary to do in a better
way. iunique() is not the right facility.

Stefani



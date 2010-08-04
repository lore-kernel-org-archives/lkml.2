Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab0HDOof (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 10:44:35 -0400
Received: from fxip-0047f.externet.hu ([88.209.222.127]:59779 "EHLO
	pomaz-ex.szeredi.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932591Ab0HDOoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 10:44:34 -0400
To: Valerie Aurora <vaurora@redhat.com>
CC: viro@zeniv.linux.org.uk, miklos@szeredi.hu, jblunck@suse.de,
        hch@infradead.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, vaurora@redhat.com, tytso@mit.edu,
        linux-ext4@vger.kernel.org
In-reply-to: <1276627208-17242-15-git-send-email-vaurora@redhat.com> (message
	from Valerie Aurora on Tue, 15 Jun 2010 11:39:44 -0700)
Subject: Re: [PATCH 14/38] fallthru: ext2 fallthru support
References: <1276627208-17242-1-git-send-email-vaurora@redhat.com> <1276627208-17242-15-git-send-email-vaurora@redhat.com>
Message-Id: <E1OgfCU-0000ko-Lu@pomaz-ex.szeredi.hu>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Wed, 04 Aug 2010 16:44:10 +0200
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 15 Jun 2010, Valerie Aurora wrote:
> Add support for fallthru directory entries to ext2.

If a previously used ext2 filesystem with is mounted again then
fallthroughs don't appear to work as expected.  Stat returns ENOENT
for these entries.

Can't see anything obviously wrong with the code.

> 
> XXX What to do for d_ino for fallthrus?  If we return the inode from
> the the underlying file system, it comes from a different inode
> "namespace" and that will produce spurious matches.  This argues for
> implementation of fallthrus as symlinks because they have to allocate
> an inode (and inode number) anyway, and we can later reuse it if we
> copy the file up.

That's an idea, but I guess it won't make everyone happy since it
wastes both disk space and memory.

One of the key differentiators for union mounts concept was that it
doesn't duplicate inodes and dentries from the layers.  With the
directory copyup on lookup that's already partially lost, but that can
be justified by the fact that non-directories usually far outnumber
directories.

Another idea is to use an internal inode and make all fallthroughs be
hard links to that.

I think the same would work for whiteouts as well.  I don't like the
fact that whiteouts are invisible even when not mounted as part of a
union.

Miklos

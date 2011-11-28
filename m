Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753299Ab1K1Jjg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 04:39:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:35661 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751070Ab1K1Jjf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 04:39:35 -0500
MIME-Version: 1.0
X-Originating-IP: [188.143.17.84]
In-Reply-To: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
References: <1321873893-4544-1-git-send-email-miklos@szeredi.hu>
Date: Mon, 28 Nov 2011 10:39:34 +0100
Message-ID: <CAJfpeguawQGYvL+tDD-mgxjyZPVbJs04tug853H0yLn7MyfLig@mail.gmail.com>
Subject: Re: [PATCH 0/4] read-only remount race fix v10
From: Miklos Szeredi <miklos@szeredi.hu>
To: viro@zeniv.linux.org.uk
Cc: hch@infradead.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, jack@suse.cz, akpm@linux-foundation.org,
        toshi.okajima@jp.fujitsu.com, mszeredi@suse.cz
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 21, 2011 at 12:11 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> Al,
>
> Please apply the following patches that fix read-only remount races.
>
> Git tree is here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git read-only-remount-fixes.v10

Ping?


>
> Thanks,
> Miklos
> ---
> Miklos Szeredi (4):
>      vfs: keep list of mounts for each superblock
>      vfs: protect remounting superblock read-only
>      vfs: count unlinked inodes
>      vfs: prevent remount read-only if pending removes
>
> ---
>  fs/file_table.c       |   23 -------------
>  fs/inode.c            |   85 +++++++++++++++++++++++++++++++++++++++++++++++++
>  fs/internal.h         |    1 +
>  fs/namespace.c        |   57 ++++++++++++++++++++++++++++++++-
>  fs/super.c            |   20 +++++++++--
>  include/linux/fs.h    |   67 ++++++--------------------------------
>  include/linux/mount.h |    1 +
>  7 files changed, 170 insertions(+), 84 deletions(-)
>
>

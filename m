Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933840Ab2GDKaN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jul 2012 06:30:13 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41263 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932623Ab2GDKaH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jul 2012 06:30:07 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Steven J. Magnani" <steve@digidescorp.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] fat (exportfs): drop ineffective get_parent code
References: <1341342576-15394-1-git-send-email-steve@digidescorp.com>
	<1341342576-15394-2-git-send-email-steve@digidescorp.com>
Date: Wed, 04 Jul 2012 19:30:04 +0900
In-Reply-To: <1341342576-15394-2-git-send-email-steve@digidescorp.com> (Steven
	J. Magnani's message of "Tue, 3 Jul 2012 14:09:35 -0500")
Message-ID: <878vezq0nn.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Steven J. Magnani" <steve@digidescorp.com> writes:

> This patch reorganizes existing code for reuse by the next patch in the series.

Please separate cleanup and logic change. This patch seems to be almost
all changes are cleanup.

Maybe it would be the cleanup and nfs improvement patches.

> The only functional change is to remove ineffective code from 
> fat_get_dotdot_entry() and limit fat_get_parent() to immediate children of the
> root (the only disconnected directory case that can be handled without a 
> search). The limitation will be removed in the next patch in the series.
>
> These changes are a slight improvement over the current situation, in that they
> allow reconnection of immediate subdirectories of the root, and reporting of
> ESTALE for other cases.

I can't see why we need the limited get_parent(). I guess, it is better
to just do in next patch at once.

> The reason the i_pos code in fat_get_dotdot_entry() is ineffective is
> because the value is the on-disk position of a ".." directory entry.
> What is needed in order to map NFS file handles back to objects is the on-disk
> position of the named entry to which ".." refers.

[...]

> +/**
> + * Create inode from specified directory entry.
> + * Do not call this directly unless intentionally bypassing the FAT dir cache.
> + */
> +static struct inode *fat_build_unhashed_inode(struct super_block *sb,
> +			struct msdos_dir_entry *de)

fat_new_inode() would be better name.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

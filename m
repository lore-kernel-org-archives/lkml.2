Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754299Ab2IVLbe (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 07:31:34 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:41621 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753676Ab2IVLbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 07:31:33 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, bfields@fieldses.org, viro@zeniv.linux.org.uk,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v3 2/5] fat: allocate persistent inode numbers
References: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com>
Date: Sat, 22 Sep 2012 20:31:31 +0900
In-Reply-To: <1347798148-2660-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 16 Sep 2012 08:22:28 -0400")
Message-ID: <87lig28fak.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> -	inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
> +	if (MSDOS_SB(sb)->options.nfs == FAT_NFS_LIMITED)
> +		inode->i_ino = i_pos;
> +	else
> +		inode->i_ino = iunique(sb, MSDOS_ROOT_INO);
>  	inode->i_version = 1;
>  	err = fat_fill_inode(inode, de);
>  	if (err) {

I think we don't need this. Because FH and ino is not necessary to have
relation.

Can we re-introduce ->encode_fh() handler, and export i_pos again?  With
this, I think we can get i_pos correctly. Otherwise, ino may not contain
all bits of i_pos.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

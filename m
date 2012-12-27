Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753042Ab2L0TPd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Dec 2012 14:15:33 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57382 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2L0TPb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Dec 2012 14:15:31 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: "Darrick J. Wong" <darrick.wong@oracle.com>
Cc: axboe@kernel.dk, lucho@ionkov.net, jack@suse.cz, ericvh@gmail.com,
        viro@zeniv.linux.org.uk, rminnich@sandia.gov, tytso@mit.edu,
        martin.petersen@oracle.com, neilb@suse.de, david@fromorbit.com,
        Zheng Liu <gnehzuil.liu@gmail.com>, linux-kernel@vger.kernel.org,
        hch@infradead.org, linux-fsdevel@vger.kernel.org,
        adilger.kernel@dilger.ca, bharrosh@panasas.com, jlayton@samba.org,
        v9fs-developer@lists.sourceforge.net, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] block: Optionally snapshot page contents to provide stable pages during write
References: <20121213080740.23360.16346.stgit@blackbox.djwong.org>
	<20121213080811.23360.98131.stgit@blackbox.djwong.org>
Date: Fri, 28 Dec 2012 04:14:49 +0900
In-Reply-To: <20121213080811.23360.98131.stgit@blackbox.djwong.org> (Darrick
	J. Wong's message of "Thu, 13 Dec 2012 00:08:11 -0800")
Message-ID: <877go3z4ra.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Darrick J. Wong" <darrick.wong@oracle.com> writes:

> diff --git a/include/uapi/linux/fs.h b/include/uapi/linux/fs.h
> index 780d4c6..0144fbb 100644
> --- a/include/uapi/linux/fs.h
> +++ b/include/uapi/linux/fs.h
> @@ -69,6 +69,7 @@ struct inodes_stat_t {
>  #define MS_REMOUNT	32	/* Alter flags of a mounted FS */
>  #define MS_MANDLOCK	64	/* Allow mandatory locks on an FS */
>  #define MS_DIRSYNC	128	/* Directory modifications are synchronous */
> +#define MS_SNAP_STABLE	256	/* Snapshot pages during writeback, if needed */
>  #define MS_NOATIME	1024	/* Do not update access times. */
>  #define MS_NODIRATIME	2048	/* Do not update directory access times */
>  #define MS_BIND		4096

I think this flag should be separated into "FS provide stable page" and
"FS needs bounce buffer for stable page".

My fs (I guess btrfs also) provides stable page by better way, and
doesn't need to wait writeback flags too. What needs is just to avoid
those stable page stuff.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754336Ab2LCJyR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Dec 2012 04:54:17 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:44250 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753528Ab2LCJyP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Dec 2012 04:54:15 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH v5 8/8] Documentation: update nfs option in filesystem/vfat.txt
References: <1353504328-6054-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 03 Dec 2012 18:54:13 +0900
In-Reply-To: <1353504328-6054-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Wed, 21 Nov 2012 22:25:28 +0900")
Message-ID: <87d2yr5um2.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> From: Namjae Jeon <namjae.jeon@samsung.com>
>
> update nfs option in filesystem/vfat.txt
>
> Signed-off-by: Namjae Jeon <namjae.jeon@samsung.com>
> Signed-off-by: Ravishankar N <ravi.n1@samsung.com>
> Signed-off-by: Amit Sahrawat <a.sahrawat@samsung.com>
> ---
>  Documentation/filesystems/vfat.txt |   23 ++++++++++++++++++-----
>  1 file changed, 18 insertions(+), 5 deletions(-)
>
> diff --git a/Documentation/filesystems/vfat.txt b/Documentation/filesystems/vfat.txt
> index d230dd9..f663c70 100644
> --- a/Documentation/filesystems/vfat.txt
> +++ b/Documentation/filesystems/vfat.txt
> @@ -150,13 +150,26 @@ discard       -- If set, issues discard/TRIM commands to the block
>  		 device when blocks are freed. This is useful for SSD devices
>  		 and sparse/thinly-provisoned LUNs.
>  
> -nfs           -- This option maintains an index (cache) of directory
> -		 inodes by i_logstart which is used by the nfs-related code to
> -		 improve look-ups.
> -
> -		 Enable this only if you want to export the FAT filesystem
> +nfs= stale_rw|nostale_ro
> +	      -- Enable this only if you want to export the FAT filesystem
>  		 over NFS
>  
> +		 stale_rw:This option maintains an index (cache) of directory
> +		 inodes by i_logstart which is used by the nfs-related code to
> +		 improve look-ups.Full file operations (read/write) over NFS is supported
> +		 but with cache eviction at NFS server, this could result in ESTALE issues.
> +
> +		 nostale_ro:This option bases the inode number and filehandle on the on-disk
> +		 location of a file in the MS-DOS directory entry.This ensures that ESTALE
> +		 will not be returned after a file is evicted from the inode cache. However,
> +		 it means that operations such as rename, create and unlink could cause
> +		 filehandles that previously pointed at one file to point at a different file,
> +		 potentially causing data corruption. For this reason, this option also mounts
> +		 the filesystem readonly.
> +
> +		 To maintain backward compatibility, '-o nfs' is also accepted, defaulting to
> +		 stale_rw

Please add whitespace after ":" and ".". And please care 80 columns.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

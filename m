Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754955Ab0ESUA1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 16:00:27 -0400
Received: from one.firstfloor.org ([213.235.205.2]:33725 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755152Ab0ESUAW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 16:00:22 -0400
To: Steven Liu <lingjiujianke@gmail.com>
Cc: chris.mason@oracle.com, linux-btrfs@vger.kernel.org,
       linux-kernel@vger.kernel.org, liuqi@thunderst.com
Subject: Re: [PATCH] btrfs: check alloc return value before use handle and struct
From: Andi Kleen <andi@firstfloor.org>
References: <AANLkTimupBIpsY_YtwIw75-ZdilsiFabaaTSs-AJv0Ad@mail.gmail.com>
Date: Wed, 19 May 2010 22:00:20 +0200
In-Reply-To: <AANLkTimupBIpsY_YtwIw75-ZdilsiFabaaTSs-AJv0Ad@mail.gmail.com> (Steven Liu's message of "Wed\, 19 May 2010 17\:38\:45 +0800")
Message-ID: <87r5l7wtkb.fsf@basil.nowhere.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Liu <lingjiujianke@gmail.com> writes:
> diff --git a/fs/btrfs/dir-item.c b/fs/btrfs/dir-item.c
> index e9103b3..230a131 100644
> --- a/fs/btrfs/dir-item.c
> +++ b/fs/btrfs/dir-item.c
> @@ -142,6 +142,8 @@ int btrfs_insert_dir_item(struct
> btrfs_trans_handle *trans, struct btrfs_root
>  	key.offset = btrfs_name_hash(name, name_len);
>
>  	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;


The big problem is handling state unwind in all the callers, not adding
it to the low level code. I attempted it some time ago but it's hard.

Just spewing BUG_ON() all over on memory allocation failure is not
helpful imho, that's not better than simply having clean NULL pointer
faults.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.

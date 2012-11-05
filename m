Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139Ab2KEM1H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 07:27:07 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:57577 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab2KEM1F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 07:27:05 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Subject: Re: [PATCH 1/5] fat: remove parent_logstart check in fat_get_parent
References: <1351389156-2484-1-git-send-email-linkinjeon@gmail.com>
Date: Mon, 05 Nov 2012 21:27:02 +0900
In-Reply-To: <1351389156-2484-1-git-send-email-linkinjeon@gmail.com> (Namjae
	Jeon's message of "Sun, 28 Oct 2012 10:52:36 +0900")
Message-ID: <87sj8okzft.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

> +		blknr = fat_clus_to_blknr(sbi, parent_logstart);
> +		parent_bh = sb_bread(sb, blknr);
> +		if (!parent_bh) {
> +			fat_msg(sb, KERN_ERR,
> +				"NFS:unable to read cluster of parent directory");
> +			goto out;
>  		}
> +		de = (struct msdos_dir_entry *) parent_bh->b_data;
> +		clus_to_match = fat_get_start(sbi, &de[0]);
> +		search_clus = fat_get_start(sbi, &de[1]);
> +		if (!search_clus)
> +			search_clus = sbi->root_cluster;
> +		brelse(parent_bh);
> +		do {
> +			parent_inode =  fat_traverse_cluster(sb,
> +					search_clus, clus_to_match);
> +			if (IS_ERR(parent_inode) || parent_inode)
> +				break;
> +			search_clus = fat_read_next_clus(sb,
> +							search_clus);
> +			if (search_clus < 0)
> +				break;
> +		} while (search_clus != FAT_ENT_EOF);
>  	}
>  out:
>  	brelse(dotdot_bh);

I started to understand what is doing this with cleanup. It is really
strange and duplicates many codes with bugs.

So, please replace whole FAT nfs patches in -mm to review whole at next
patchset. And sorry, but please think whole more carefully.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

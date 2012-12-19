Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755554Ab2LSP5b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:57:31 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:54561 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113Ab2LSP51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:57:27 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Ravishankar N <cyberax82@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namjae Jeon <linkinjeon@gmail.com>
Subject: Re: [PATCH 1/1] fat:fix incorrect function comment
References: <1355849419-26403-1-git-send-email-cyberax82@gmail.com>
Date: Thu, 20 Dec 2012 00:57:24 +0900
In-Reply-To: <1355849419-26403-1-git-send-email-cyberax82@gmail.com>
	(Ravishankar N.'s message of "Tue, 18 Dec 2012 22:20:19 +0530")
Message-ID: <87ehimdogr.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ravishankar N <cyberax82@gmail.com> writes:

>  /*
> - * Return values: negative -> error, 0 -> not found, positive -> found,
> - * value is the total amount of slots, including the shortname entry.
> + * Return values: negative -> error/not found, 0 -> found.
>   */
>  int fat_search_long(struct inode *inode, const unsigned char *name,
>  		    int name_len, struct fat_slot_info *sinfo)
> @@ -1176,7 +1175,7 @@ static int fat_add_new_entries(struct inode *dir, void *slots, int nr_slots,
>  
>  	/*
>  	 * The minimum cluster size is 512bytes, and maximum entry
> -	 * size is 32*slots (672bytes).  So, iff the cluster size is
> +	 * size is 32*slots (672bytes).  So, if the cluster size is

iff is right here. iff == if and only if

> -//		fat_cache_add(inode, new_fclus, new_dclus);

I guess this still worth to keep as FIXME. This meant the following.

/*
 * FIXME: Although we can add this cache, fat_cache_add() is assuming to
 * be called after liner search with fat_cache_id.
 */

>  	} else {
>  		MSDOS_I(inode)->i_start = new_dclus;
>  		MSDOS_I(inode)->i_logstart = new_dclus;

Other parts looks fine.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932328Ab2HVK1p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 06:27:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:59288 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753363Ab2HVK1l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 06:27:41 -0400
MIME-Version: 1.0
In-Reply-To: <20120822100826.GB20640@quack.suse.cz>
References: <1345283903-7960-1-git-send-email-linkinjeon@gmail.com>
	<20120821090810.GC7537@quack.suse.cz>
	<CAKYAXd_odZxzXqn91Q517BuRRFHP3O4pkVgN8uK6QTeFEqaEdg@mail.gmail.com>
	<20120822100826.GB20640@quack.suse.cz>
Date: Wed, 22 Aug 2012 19:27:40 +0900
Message-ID: <CAKYAXd8EWxS7WVZ3sOpspDrRVkqT18yz0U+_xvfQPidSQBE9ag@mail.gmail.com>
Subject: Re: [PATCH RESEND] udf: extent cache implementation for manipulating
 block map
From: Namjae Jeon <linkinjeon@gmail.com>
To: Jan Kara <jack@suse.cz>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Namjae Jeon <namjae.jeon@samsung.com>,
        Ashish Sangwan <a.sangwan@samsung.com>,
        Bonggil Bak <bgbak@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/22, Jan Kara <jack@suse.cz>:
> On Wed 22-08-12 19:02:26, Namjae Jeon wrote:
>> 2012/8/21, Jan Kara <jack@suse.cz>:
>> Hi. Jan.
>> Okay, We are trying to do it from your comment.
>> 1. Change udf_ext_cache structure to following which would also include
>> *bh.
>> struct udf_ext_cache {
>>
>> /* Position of the cached extent */
>> struct extent_position epos;
>>
>> /* Logical block where cached extent starts */
>> sector_t block;
>> };
>   OK.
>
>> 2. Remove call to brelse(epos.bh) from all the callers of inode_bmap()
>> and move it to udf_evict_inode()
>   It might be easier to keep brelse() where it is and add get_bh() to
> udf_add_extent_cache() and brelse() to udf_clear_extent_cache(). It is then
> easier to audit we don't leak bh references...
Good point. I will~
>
>> 3. As now we are not caching elen, etype and eloc, we have to change
>> the cache_hit logic in inode_bmap.
>> The call to function udf_next_aext is now necessary from inode_bmap.
>   Yes.
>
>> 4. Remove call to udf_clear_extent_cache() from udf_get_block as with
>> new scheme, it is not required.
>   You still need this when you write before the cached location (e.g. when
> the file has holes, and you write into them, extents will shift).
Okay, I see.
I will send v2 patch soon.
Thanks for your advice.
>
>
> 								Honza
> --
> Jan Kara <jack@suse.cz>
> SUSE Labs, CR
>

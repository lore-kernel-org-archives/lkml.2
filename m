Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753516Ab2KFEQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 23:16:06 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:35792 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753012Ab2KFEQE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 23:16:04 -0500
MIME-Version: 1.0
In-Reply-To: <87sj8okzft.fsf@devron.myhome.or.jp>
References: <1351389156-2484-1-git-send-email-linkinjeon@gmail.com>
	<87sj8okzft.fsf@devron.myhome.or.jp>
Date: Tue, 6 Nov 2012 13:16:00 +0900
Message-ID: <CAKYAXd_bEmLtXA4HXaBMNJrwLLnyPNHT4o+s2VcisDdEsphuvA@mail.gmail.com>
Subject: Re: [PATCH 1/5] fat: remove parent_logstart check in fat_get_parent
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>,
        Ravishankar N <ravi.n1@samsung.com>,
        Amit Sahrawat <a.sahrawat@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/11/5, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>> +		blknr = fat_clus_to_blknr(sbi, parent_logstart);
>> +		parent_bh = sb_bread(sb, blknr);
>> +		if (!parent_bh) {
>> +			fat_msg(sb, KERN_ERR,
>> +				"NFS:unable to read cluster of parent directory");
>> +			goto out;
>>  		}
>> +		de = (struct msdos_dir_entry *) parent_bh->b_data;
>> +		clus_to_match = fat_get_start(sbi, &de[0]);
>> +		search_clus = fat_get_start(sbi, &de[1]);
>> +		if (!search_clus)
>> +			search_clus = sbi->root_cluster;
>> +		brelse(parent_bh);
>> +		do {
>> +			parent_inode =  fat_traverse_cluster(sb,
>> +					search_clus, clus_to_match);
>> +			if (IS_ERR(parent_inode) || parent_inode)
>> +				break;
>> +			search_clus = fat_read_next_clus(sb,
>> +							search_clus);
>> +			if (search_clus < 0)
>> +				break;
>> +		} while (search_clus != FAT_ENT_EOF);
>>  	}
>>  out:
>>  	brelse(dotdot_bh);
>
> I started to understand what is doing this with cleanup. It is really
> strange and duplicates many codes with bugs.
>
> So, please replace whole FAT nfs patches in -mm to review whole at next
> patchset. And sorry, but please think whole more carefully.
Hi OGAWA.
Okay, I will rework all of patches as your comment.
Thanks for review.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

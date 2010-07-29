Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756862Ab0G2KrJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:47:09 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:57002 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756819Ab0G2KrH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:47:07 -0400
Message-ID: <4C515C34.9090005@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 18:47:16 +0800
From: Miao Xie <miaox@cn.fujitsu.com>
Reply-To: miaox@cn.fujitsu.com
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Yan, Zheng" <zheng.yan@oracle.com>
CC: Chris Mason <chris.mason@oracle.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 7/7] btrfs: fix a wrong error check in add_ra_bio_pages()
References: <4C513C95.3080403@cn.fujitsu.com> <AANLkTim+U2s5-vHhmPqam9wj0+0_=01bq3JjnR=xB8T2@mail.gmail.com>
In-Reply-To: <AANLkTim+U2s5-vHhmPqam9wj0+0_=01bq3JjnR=xB8T2@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 18:38:39 +0800, Yan, Zheng wrote:
> 2010/7/29 Miao Xie<miaox@cn.fujitsu.com>:
>> From: Liu Bo<liubo2009@cn.fujitsu.com>
>>
>> Only when a page is not found by page_index, we'll go to the error check.
>>
>> Signed-off-by: Liu Bo<liubo2009@cn.fujitsu.com>
>> Signed-off-by: Miao Xie<miaox@cn.fujitsu.com>
>> ---
>>   fs/btrfs/compression.c |    2 +-
>>   1 files changed, 1 insertions(+), 1 deletions(-)
>>
>> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
>> index cb3877c..8458840 100644
>> --- a/fs/btrfs/compression.c
>> +++ b/fs/btrfs/compression.c
>> @@ -467,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>>                 rcu_read_lock();
>>                 page = radix_tree_lookup(&mapping->page_tree, page_index);
>>                 rcu_read_unlock();
>> -               if (page) {
>> +               if (!page) {
>>   check_misses:
>>                         misses++;
>>                         if (misses>  4)
>
> This patch is wrong. The word "miss" here means "miss for read-ahead because
> the page is already in the page cache"

Oh, my mistake. Sorry!
Please ignore this patch.

Thanks for your review! How about the others?
Miao

>
> Yan, Zheng
>
>


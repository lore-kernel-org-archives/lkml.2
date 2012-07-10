Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2GJCHy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 22:07:54 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:47786 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752867Ab2GJCHw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 22:07:52 -0400
Date: Tue, 10 Jul 2012 10:07:21 +0800
From: Wanpeng Li <liwp.linux@gmail.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        William Irwin <wli@holomorphy.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/hugetlb: fix error code in hugetlbfs_alloc_inode
Message-ID: <20120710020721.GC2457@kernel>
Reply-To: Wanpeng Li <liwp.linux@gmail.com>
References: <1341882774-4772-1-git-send-email-liwp.linux@gmail.com>
 <alpine.DEB.2.00.1207091901210.25143@chino.kir.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1207091901210.25143@chino.kir.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 07:02:39PM -0700, David Rientjes wrote:
>On Tue, 10 Jul 2012, Wanpeng Li wrote:
>
>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>> index c4b85d0..79a0f33 100644
>> --- a/fs/hugetlbfs/inode.c
>> +++ b/fs/hugetlbfs/inode.c
>> @@ -696,7 +696,7 @@ static struct inode *hugetlbfs_alloc_inode(struct super_block *sb)
>>  	p = kmem_cache_alloc(hugetlbfs_inode_cachep, GFP_KERNEL);
>>  	if (unlikely(!p)) {
>>  		hugetlbfs_inc_free_inodes(sbinfo);
>> -		return NULL;
>> +		return ERR_PTR(-ENOMEM);
>>  	}
>>  	return &p->vfs_inode;
>>  }
>
>So now you've removed Gavin Shan who already told you that it was correct 
>as written and propose yet another bogus patch which will break.  This 
>isn't professional.
>
>alloc_inode() tests for a NULL return value, not for PTR_ERR(), so you 
>would be introducing a bug if this patch were merged.  It's completely 
>correct the way it's written.

Thank you for your comments David, please ignore the patch.

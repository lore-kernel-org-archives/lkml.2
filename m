Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756771Ab2IDJWS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 05:22:18 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:35902 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756661Ab2IDJWQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 05:22:16 -0400
MIME-Version: 1.0
In-Reply-To: <50456F2E.6060408@gmail.com>
References: <1346681648-21427-1-git-send-email-clouds.yan@gmail.com>
	<1346681648-21427-2-git-send-email-clouds.yan@gmail.com>
	<50456F2E.6060408@gmail.com>
Date: Tue, 4 Sep 2012 17:22:15 +0800
Message-ID: <CAH+=+MG=9189mS7+Cb85-PV51EX1Df-zGmZ3u4YtSsEfmphYUQ@mail.gmail.com>
Subject: Re: [PATCH 1/3] proc: return -ENOMEM when inode allocation failed
From: yan yan <clouds.yan@gmail.com>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/9/4 Cong Wang <xiyou.wangcong@gmail.com>:
> On 09/03/2012 10:14 PM, yan wrote:
>>
>> Signed-off-by: yan <clouds.yan@gmail.com>
>
>
> Please provide a changelog to explain why we need this patch.

I think the title is self explained.


>> ---
>>   fs/proc/generic.c |    2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/fs/proc/generic.c b/fs/proc/generic.c
>> index b3647fe..9e8f631 100644
>> --- a/fs/proc/generic.c
>> +++ b/fs/proc/generic.c
>> @@ -427,7 +427,7 @@ struct dentry *proc_lookup_de(struct proc_dir_entry
>> *de, struct inode *dir,
>>                 if (!memcmp(dentry->d_name.name, de->name, de->namelen)) {
>>                         pde_get(de);
>>                         spin_unlock(&proc_subdir_lock);
>> -                       error = -EINVAL;
>> +                       error = -ENOMEM;
>
>
> Why the !memcmp() case is related with ENOMEM ??

We are presetting 'error' here. The following proc_get_inode() will try
to get an inode, either from inode cache or allocate a new one (and fill it).

If we get a NULL inode, that means allocation failed. That's how
ENOMEM involved.

Thank you for your reply.

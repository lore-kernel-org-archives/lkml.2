Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756800Ab0G2Kim (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 06:38:42 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:55869 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756722Ab0G2Kik convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 06:38:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=gClXp51pcxgT3/K/doK3fOWGsPnLPQvPy+9RTscOcEq/vEtFUwqOJj06tofc1lwVUW
         EJbsnTHIzv/NnJPFD0tceaQNzzOtaXQ/6SAVoCaAmI/W2eQWLQaP3p0NsbOD5jP2HAk5
         9gtHfgr4muZ93tJUxdGyLUM3tgXAWwQQ5AjZ8=
MIME-Version: 1.0
In-Reply-To: <4C513C95.3080403@cn.fujitsu.com>
References: <4C513C95.3080403@cn.fujitsu.com>
Date: Thu, 29 Jul 2010 18:38:39 +0800
X-Google-Sender-Auth: PDYFe29IRqdBFfETPA46GnqePWE
Message-ID: <AANLkTim+U2s5-vHhmPqam9wj0+0_=01bq3JjnR=xB8T2@mail.gmail.com>
Subject: Re: [PATCH 7/7] btrfs: fix a wrong error check in add_ra_bio_pages()
From: "Yan, Zheng" <zheng.yan@oracle.com>
To: miaox@cn.fujitsu.com
Cc: Chris Mason <chris.mason@oracle.com>,
        Linux Btrfs <linux-btrfs@vger.kernel.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/29 Miao Xie <miaox@cn.fujitsu.com>:
> From: Liu Bo <liubo2009@cn.fujitsu.com>
>
> Only when a page is not found by page_index, we'll go to the error check.
>
> Signed-off-by: Liu Bo <liubo2009@cn.fujitsu.com>
> Signed-off-by: Miao Xie <miaox@cn.fujitsu.com>
> ---
>  fs/btrfs/compression.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
> index cb3877c..8458840 100644
> --- a/fs/btrfs/compression.c
> +++ b/fs/btrfs/compression.c
> @@ -467,7 +467,7 @@ static noinline int add_ra_bio_pages(struct inode *inode,
>                rcu_read_lock();
>                page = radix_tree_lookup(&mapping->page_tree, page_index);
>                rcu_read_unlock();
> -               if (page) {
> +               if (!page) {
>  check_misses:
>                        misses++;
>                        if (misses > 4)

This patch is wrong. The word "miss" here means "miss for read-ahead because
the page is already in the page cache"

Yan, Zheng

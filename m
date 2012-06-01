Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932225Ab2FAIvj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 04:51:39 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:54482 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752810Ab2FAIvi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 04:51:38 -0400
Message-ID: <4FC88299.1040707@gmail.com>
Date: Fri, 01 Jun 2012 04:51:37 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, kosaki.motohiro@gmail.com
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
References: <20120530163317.GA13189@redhat.com> <20120531005739.GA4532@redhat.com> <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
In-Reply-To: <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>   	mlock_migrate_page(newpage, page);
> --- 3.4.0+/mm/page-writeback.c	2012-05-29 08:09:58.304806782 -0700
> +++ linux/mm/page-writeback.c	2012-06-01 00:23:43.984116973 -0700
> @@ -1987,7 +1987,10 @@ int __set_page_dirty_nobuffers(struct pa
>   		mapping2 = page_mapping(page);
>   		if (mapping2) { /* Race with truncate? */
>   			BUG_ON(mapping2 != mapping);
> -			WARN_ON_ONCE(!PagePrivate(page)&&  !PageUptodate(page));
> +			if (WARN_ON(!PagePrivate(page)&&  !PageUptodate(page)))
> +				print_symbol(KERN_WARNING
> +				    "mapping->a_ops->writepage: %s\n",
> +				    (unsigned long)mapping->a_ops->writepage);

type mismatch? I guess you want %pf or %pF.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753709Ab3AGVXo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 16:23:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:38005 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab3AGVXn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 16:23:43 -0500
Date: Mon, 7 Jan 2013 13:23:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Lin Feng <linfeng@cn.fujitsu.com>
Cc: tj@kernel.org, mingo@kernel.org, yinghai@kernel.org,
        liwanp@linux.vnet.ibm.com, benh@kernel.crashing.org,
        tangchen@cn.fujitsu.com, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm: memblock: fix wrong memmove size in
 memblock_merge_regions()
Message-Id: <20130107132341.c8ca0060.akpm@linux-foundation.org>
In-Reply-To: <1357530096-28548-1-git-send-email-linfeng@cn.fujitsu.com>
References: <1357530096-28548-1-git-send-email-linfeng@cn.fujitsu.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 Jan 2013 11:41:36 +0800
Lin Feng <linfeng@cn.fujitsu.com> wrote:

> The memmove span covers from (next+1) to the end of the array, and the index
> of next is (i+1), so the index of (next+1) is (i+2). So the size of remaining
> array elements is (type->cnt - (i + 2)).

What are the user-visible effects of this bug?

> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -314,7 +314,8 @@ static void __init_memblock memblock_merge_regions(struct memblock_type *type)
>  		}
>  
>  		this->size += next->size;
> -		memmove(next, next + 1, (type->cnt - (i + 1)) * sizeof(*next));
> +		/* move forward from next + 1, index of which is i + 2 */
> +		memmove(next, next + 1, (type->cnt - (i + 2)) * sizeof(*next));
>  		type->cnt--;
>  	}
>  }
> -- 
> 1.7.11.7

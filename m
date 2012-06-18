Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753005Ab2FRTgH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 15:36:07 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65380 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751986Ab2FRTgF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 15:36:05 -0400
Date: Mon, 18 Jun 2012 12:36:00 -0700
From: Tejun Heo <tj@kernel.org>
To: Greg Pearson <greg.pearson@hp.com>
Cc: hpa@linux.intel.com, akpm@linux-foundation.org, shangw@linux.vnet.ibm.com,
        mingo@elte.hu, yinghai@kernel.org, benh@kernel.crashing.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] mm/memblock: fix overlapping allocation when
 doubling reserved array
Message-ID: <20120618193600.GA30670@google.com>
References: <1340044127-13864-1-git-send-email-greg.pearson@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340044127-13864-1-git-send-email-greg.pearson@hp.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Greg.

Tricky one.  Nice catch.

> diff --git a/mm/memblock.c b/mm/memblock.c
> index 952123e..3a61e74 100644
> --- a/mm/memblock.c
> +++ b/mm/memblock.c
> @@ -184,7 +184,9 @@ static void __init_memblock memblock_remove_region(struct memblock_type *type, u
>  	}
>  }
>  
> -static int __init_memblock memblock_double_array(struct memblock_type *type)
> +static int __init_memblock memblock_double_array(struct memblock_type *type,
> +						phys_addr_t exclude_start,
> +						phys_addr_t exclude_size)

I find @exclude_start and size a bit misleading mostly because
memblock_double_array() would then proceed to ignore the specified
area.  Wouldn't it be better to use names which signify that they're
the reason why the array is being doubled instead?  e.g. sth like
@new_area_start, @new_area_size.  Can you please also add /** function
comment explaning the subtlety?

Thanks.

-- 
tejun

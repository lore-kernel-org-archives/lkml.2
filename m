Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab2ILUj0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 16:39:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64839 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752467Ab2ILUjZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 16:39:25 -0400
Date: Wed, 12 Sep 2012 13:39:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Cyril Chemparathy <cyril@ti.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        akpm@linux-foundation.org, davem@davemloft.net, eric.dumazet@gmail.com,
        hannes@cmpxchg.org, shangw@linux.vnet.ibm.com, vitalya@ti.com
Subject: Re: [PATCH] mm: bootmem: use phys_addr_t for physical addresses
Message-ID: <20120912203920.GU7677@google.com>
References: <1347466008-7231-1-git-send-email-cyril@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347466008-7231-1-git-send-email-cyril@ti.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Sep 12, 2012 at 12:06:48PM -0400, Cyril Chemparathy wrote:
>  static void * __init alloc_bootmem_core(unsigned long size,
>  					unsigned long align,
> -					unsigned long goal,
> -					unsigned long limit)
> +					phys_addr_t goal,
> +					phys_addr_t limit)

So, a function which takes phys_addr_t for goal and limit but returns
void * doesn't make much sense unless the function creates directly
addressable mapping somewhere.

The right thing to do would be converting to nobootmem (ie. memblock)
and use the memblock interface.  Have no idea at all whether that
would be a realistic short-term solution for arm.

Thanks.

-- 
tejun

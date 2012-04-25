Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758705Ab2DYUMw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 16:12:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48054 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758558Ab2DYUMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 16:12:51 -0400
Date: Wed, 25 Apr 2012 13:12:46 -0700
From: Tejun Heo <tj@kernel.org>
To: David Miller <davem@davemloft.net>
Cc: linux-kernel@vger.kernel.org, yinghai@kernel.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH] mm: nobootmem: Correct alloc_bootmem semantics.
Message-ID: <20120425201246.GB8989@google.com>
References: <20120425.161050.1011838269798884593.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120425.161050.1011838269798884593.davem@davemloft.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 25, 2012 at 04:10:50PM -0400, David Miller wrote:
> 
> The comments above __alloc_bootmem_node() claim that the code will
> first try the allocation using 'goal' and if that fails it will
> try again but with the 'goal' requirement dropped.
> 
> Unfortunately, this is not what the code does, so fix it to do so.
> 
> This is important for nobootmem conversions to architectures such
> as sparc where MAX_DMA_ADDRESS is infinity.
> 
> On such architectures all of the allocations done by generic spots,
> such as the sparse-vmemmap implementation, will pass in:
> 
> 	__pa(MAX_DMA_ADDRESS)
> 
> as the goal, and with the limit given as "-1" this will always fail
> unless we add the appropriate fallback logic here.
> 
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

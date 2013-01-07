Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3AGPPA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 10:15:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:64809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752225Ab3AGPO6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 10:14:58 -0500
Message-ID: <50EAE66B.1020804@redhat.com>
Date: Mon, 07 Jan 2013 10:14:51 -0500
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Shaohua Li <shli@kernel.org>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, mingo@redhat.com, hpa@zytor.com
Subject: Re: [RFC]x86: clearing access bit don't flush tlb
References: <20130107081213.GA21779@kernel.org>
In-Reply-To: <20130107081213.GA21779@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/07/2013 03:12 AM, Shaohua Li wrote:
>
> We use access bit to age a page at page reclaim. When clearing pte access bit,
> we could skip tlb flush for the virtual address. The side effect is if the pte
> is in tlb and pte access bit is unset, when cpu access the page again, cpu will
> not set pte's access bit. So next time page reclaim can reclaim hot pages
> wrongly, but this doesn't corrupt anything. And according to intel manual, tlb
> has less than 1k entries, which coverers < 4M memory. In today's system,
> several giga byte memory is normal. After page reclaim clears pte access bit
> and before cpu access the page again, it's quite unlikely this page's pte is
> still in TLB. Skiping the tlb flush for this case sounds ok to me.

Agreed. In current systems, it can take a minute to write
all of memory to disk, while context switch (natural TLB
flush) times are in the dozens-of-millisecond timeframes.

> And in some workloads, TLB flush overhead is very heavy. In my simple
> multithread app with a lot of swap to several pcie SSD, removing the tlb flush
> gives about 20% ~ 30% swapout speedup.
>
> Signed-off-by: Shaohua Li <shli@fusionio.com>

Reviewed-by: Rik van Riel <riel@redhat.com>


-- 
All rights reversed

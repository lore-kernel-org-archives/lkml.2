Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753117Ab2FRQqv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 12:46:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:35277 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751646Ab2FRQqu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 12:46:50 -0400
Message-ID: <4FDF5B3C.1000007@redhat.com>
Date: Mon, 18 Jun 2012 12:45:48 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-mm@kvack.org, akpm@linux-foundation.org, aarcange@redhat.com,
        peterz@infradead.org, minchan@gmail.com, kosaki.motohiro@gmail.com,
        hnaz@cmpxchg.org, mel@csn.ul.ie, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@surriel.com>
Subject: Re: [PATCH -mm 3/6] Fix the x86-64 page colouring code to take pgoff
 into account and use that code as the basis for a generic page colouring
 code.
References: <1340029878-7966-1-git-send-email-riel@redhat.com> <1340029878-7966-4-git-send-email-riel@redhat.com> <m2k3z48twb.fsf@firstfloor.org>
In-Reply-To: <m2k3z48twb.fsf@firstfloor.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 12:30 PM, Andi Kleen wrote:
> Rik van Riel<riel@redhat.com>  writes:
>
>> From: Rik van Riel<riel@surriel.com>
>>
>> Teach the generic arch_get_unmapped_area(_topdown) code to call the
>> page colouring code.
>
> What tree is that against? I cannot find x86 page colouring code in next
> or mainline.

This is against mainline.

See align_addr in arch/x86/kernel/sys_x86_64.c and the
call sites in arch_get_unmapped_area(_topdown).

On certain AMD chips, Linux tries to get certain
allocations aligned to avoid cache aliasing issues.

-- 
All rights reversed

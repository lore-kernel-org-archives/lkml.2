Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755307Ab1KWNCs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 08:02:48 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53261 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754214Ab1KWNCr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 08:02:47 -0500
Message-ID: <4ECCEEA8.3030002@gmail.com>
Date: Wed, 23 Nov 2011 21:01:28 +0800
From: Wang Sheng-Hui <shhuiw@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cleanup: convert the int cnt to unsigned long in
 mm/memblock.c
References: <4EB9DF0B.7050004@gmail.com>	<4EBA0D3D.1090808@gmail.com> <20111122155901.e7b23dce.akpm@linux-foundation.org>
In-Reply-To: <20111122155901.e7b23dce.akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011年11月23日 07:59, Andrew Morton wrote:
> On Wed, 09 Nov 2011 13:18:53 +0800
> Wang Sheng-Hui <shhuiw@gmail.com> wrote:
> 
>> @@ -111,7 +112,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
>>  static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
>>  			phys_addr_t align, phys_addr_t start, phys_addr_t end)
>>  {
>> -	long i;
>> +	unsigned long i;
>>  
>>  	BUG_ON(0 == size);
> 
> This change to memblock_find_base() can cause this loop:
> 
> 	for (i = memblock.memory.cnt - 1; i >= 0; i--) {
> 
> to become infinite under some circumstances.
> 
> I stopped reading at that point.  Changes like this require much care.
> 

Got it.

Thanks for your instructions. 
I'll review the code and may resubmit the right patches later.


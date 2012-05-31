Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933280Ab2EaUf6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 16:35:58 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:43496 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932262Ab2EaUf4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 16:35:56 -0400
Message-ID: <4FC7D629.3090801@gmail.com>
Date: Thu, 31 May 2012 16:35:53 -0400
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        Nathan Zimmer <nzimmer@sgi.com>, hughd@google.com, npiggin@gmail.com,
        cl@linux.com, lee.schermerhorn@hp.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org, riel@redhat.com
Subject: Re: [PATCH v2] tmpfs not interleaving properly
References: <20120531143916.GA16162@gulag1.americas.sgi.com> <4FC7CFEB.5040009@gmail.com> <20120531132515.6af60152.akpm@linux-foundation.org>
In-Reply-To: <20120531132515.6af60152.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(5/31/12 4:25 PM), Andrew Morton wrote:
> On Thu, 31 May 2012 16:09:15 -0400
> KOSAKI Motohiro<kosaki.motohiro@gmail.com>  wrote:
>
>>> --- a/mm/shmem.c
>>> +++ b/mm/shmem.c
>>> @@ -929,7 +929,7 @@ static struct page *shmem_alloc_page(gfp_t gfp,
>>>    	/*
>>>    	 * alloc_page_vma() will drop the shared policy reference
>>>    	 */
>>> -	return alloc_page_vma(gfp,&pvma, 0);
>>> +	return alloc_page_vma(gfp,&pvma, info->node_offset<<   PAGE_SHIFT );
>>
>> 3rd argument of alloc_page_vma() is an address. This is type error.
>
> Well, it's an unsigned long...
>
> But yes, it is conceptually wrong and *looks* weird.  I think we can
> address that by overcoming our peculair aversion to documenting our
> code, sigh.  This?

Sorry, no.

addr agrument of alloc_pages_vma() have two meanings.

1) interleave node seed
2) look-up key of shmem policy

I think this patch break (2). shmem_get_policy(pol, addr) assume caller honor to
pass correct address.

Oh, yes. *NOW*, we are discussing shmem policy removing. but it haven't be removed.
Please don't break.


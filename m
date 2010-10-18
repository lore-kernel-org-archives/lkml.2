Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751409Ab0JRFSy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 01:18:54 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:40978 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750718Ab0JRFSx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 01:18:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FopXb1Htlgg9Q66d6m4XmuIGfmUuPhQI9SWrHyYMw5wwZwTvmi2kYzYWECiLqZSJ1U
         oUpqdAlUKxTwKWT2UAjGe9bYCc71+X+i+CtuU6GFa/dKwBQkIy9R3fnIE6v2ZVaflDCn
         3zxUS9fxdgqxxYpN7e/hevsbg5CPwRRYx73QY=
MIME-Version: 1.0
In-Reply-To: <20101018093533.abd4c8ee.kamezawa.hiroyu@jp.fujitsu.com>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<20101013121829.c3320944.kamezawa.hiroyu@jp.fujitsu.com>
	<AANLkTingNmxT6ww_VB_K=rjsgR+dHANLnyNkwV1Myvnk@mail.gmail.com>
	<20101018093533.abd4c8ee.kamezawa.hiroyu@jp.fujitsu.com>
Date: Mon, 18 Oct 2010 14:18:52 +0900
Message-ID: <AANLkTikt+kq2LHZNSJAN3EQwYALdYtGuOAXfVghN-7oY@mail.gmail.com>
Subject: Re: [RFC][PATCH 3/3] alloc contig pages with migration.
From: Minchan Kim <minchan.kim@gmail.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 9:35 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
>> > + * @node:       the node from which memory is allocated. "-1" means anywhere.
>> > + * @no_search: if true, "hint" is not a hint, requirement.
>>
>> As I said previous, how about "strict" or "ALLOC_FIXED" like MAP_FIXED?
>>
>
> If "range" is an argument, ALLOC_FIXED is not necessary. I'll add "range".

Sounds good.

>
>> > + *
>> > + * Search an area of @size in the physical memory map and checks wheter
>>
>> Typo
>> whether
>>
>> > + * we can create a contigous free space. If it seems possible, try to
>> > + * create contigous space with page migration. If no_search==true, we just try
>> > + * to allocate [hint, hint+size) range of pages as contigous block.
>> > + *
>> > + * Returns a page of the beginning of contiguous block. At failure, NULL
>> > + * is returned. Each page in the area is set to page_count() = 1. Because
>>
>> Why do you mention page_count() = 1?
>> Do users of this function have to know it?
>
> A user can free any page within the range for his purpose.

I think it's not a good idea if we allow handling of page by page, not
for page-chunk requested by user.
By mistake, free_contig_pages could have a trouble to free pages.
Why do you support the feature?  Do you have any motivation?


-- 
Kind regards,
Minchan Kim

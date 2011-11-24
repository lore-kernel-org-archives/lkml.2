Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753360Ab1KXEz5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 23:55:57 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:38410 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752605Ab1KXEz4 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 23:55:56 -0500
MIME-Version: 1.0
In-Reply-To: <CABexPfEa-kTdH3=7pa=geVE5rUSiuj2Gzt6Zbjz_-cwXJVYGFA@mail.gmail.com>
References: <CABexPfF-31f1vcJpqdsDHKUHfes1230vwGMtm6ETZXVQQf4bcA@mail.gmail.com>
	<alpine.DEB.2.00.1111221847320.30008@chino.kir.corp.google.com>
	<CABexPfEte8U5pVBJ=LvRKMY5=oW7F2vRjw_d9893Yy8W88hfDg@mail.gmail.com>
	<CABexPfHxM=NpwrrbFrTJUVZHzORpVaqAwoh1yC7d=RTfwnQWwg@mail.gmail.com>
	<alpine.DEB.2.00.1111231501030.24794@chino.kir.corp.google.com>
	<CABexPfFFiNf8gj9EHnnWABmcK_wCiRkhxQObUnr0_oY2Dkp+JA@mail.gmail.com>
	<CABexPfEa-kTdH3=7pa=geVE5rUSiuj2Gzt6Zbjz_-cwXJVYGFA@mail.gmail.com>
Date: Thu, 24 Nov 2011 12:55:55 +0800
Message-ID: <CABexPfGSdUAfwFC2HBtVTZe=EbSj8Q2Pt_AiaoAOB+ms7rftwQ@mail.gmail.com>
Subject: Re: Slub Allocator: Why get_order(size * MAX_OBJS_PER_PAGE) - 1 in
 function slab_order()?
From: zhihua che <zhihua.che@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/24 zhihua che <zhihua.che@gmail.com>:
> 2011/11/24 David Rientjes <rientjes@google.com>:
>> On Wed, 23 Nov 2011, zhihua che wrote:
>>
>>> I know what you mean, that is, a slab can only store no more than
>>> MAX_OBJS_PER_PAGE, actually 0x7FFF, objects.
>>>
>>> But  get_order(size * MAX_OBJS_PER_PAGE) already returns the order
>>> which reserves no_more_than size * MAX_OBJS_PER_PAGE memory.  Right?
>>>
>>
>> Yes, but it reserves too much memory if the conditional is true.
>>
>>> So I think there is no need to subtract one.
>>>
>>
>> If we didn't subtract one, then the order of a slab page would allow for
>> _more_ than MAX_OBJS_PER_PAGE to be allocated and that's not allowed
>> because of the restrictions in struct page.
>>
>> Consider a page size of 4K and an object size of 8 bytes.
>> get_order(8 * 32767) would be 6, so that's a 4K * 2^6 = 256K slab page
>> without the subtraction and could allocate (256K * 1024 / 8) = 32768 which
>> is greater than MAX_OBJS_PER_PAGE and not allowed.
>>
>> So we subtract one so the compound slab page is guaranteed to allocate
>> less than MAX_OBJS_PER_PAGE.
>
> Oh, sorry to bother you ... I guess I calculated a wrong result. I
> repeat your and my example carefully and you're right.
>
> Thanks very much for your patience :)
>

I guess I find what I'm wrong with. I pick a 0x8000 instead of 0x7FFF
as my example, because I though it's convenient.
But the 0x8000, as a power of two, turned out to be a proper order 7,
which can store 0x8000 objects without subtracting one.

Whatever, I made a stupid mistake.

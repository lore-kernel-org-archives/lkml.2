Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754624Ab2K2CIV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 21:08:21 -0500
Received: from mail-lb0-f174.google.com ([209.85.217.174]:65023 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753912Ab2K2CIU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 21:08:20 -0500
MIME-Version: 1.0
In-Reply-To: <50B6BE34.2010109@vflare.org>
References: <1354001167-24878-1-git-send-email-ngupta@vflare.org>
	<20121128051505.GD23136@blaptop>
	<20121129013320.GA24077@blaptop>
	<50B6BE34.2010109@vflare.org>
Date: Thu, 29 Nov 2012 11:08:18 +0900
X-Google-Sender-Auth: Ru1noDF39y2PoR4CMX6e4QbZGTg
Message-ID: <CAEwNFnC_fzg8Tv1qZy4QACXD_tpFazkfFCwRf8FUforErWXUFg@mail.gmail.com>
Subject: Re: [PATCH] zram: Prevent use of unmapped buffer
From: Minchan Kim <minchan@kernel.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 10:45 AM, Nitin Gupta <ngupta@vflare.org> wrote:
> On 11/28/2012 05:33 PM, Minchan Kim wrote:
>>
>> On Wed, Nov 28, 2012 at 02:15:05PM +0900, Minchan Kim wrote:
>>>
>>> Hi Nitin,
>>>
>>> On Mon, Nov 26, 2012 at 11:26:07PM -0800, Nitin Gupta wrote:
>>>>
>>>> The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
>>>> introduced a bug which caused a kunmap()'ed buffer to be used in case
>>>
>>> I got confused by the descripton. :(
>>> The descripton is not right.
>>> The problem is to access freed memory, not accessing to kunmaped buffer.
>>>
>>> partial I/O write.
>>>
>>> 1. uncmem = kmalloc
>>> 2. zram_decompress_page(uncmem)
>>> 3. memcpy(uncmem, user_mem)
>>> 4. lzo1x_1_compress(uncmem)
>>> 5. kfree(uncmem)
>>> 6. src = uncmem
>>> 7. memcpy(cmem, src, clen) <----- HIT
>>>
>>>> of partial writes where the data was found to be incompressible.
>>>>
>> I got it. You shouldn't mention partial write for proper description
>> because it was usecase for swap-over-zram so it can't make partial write.
>> Without partial write mention, your description is right but the problem
>> I mentioned above is another problem for partial write so we need a
>> another
>> patch. I will cook.
>
>
> I will include explanation of both the cases: use of unmapped buffer
> and freed buffer, when I resend these patches.
>

As you know, I am going to solve lockdep problem and disksize setting problem.
Apparently, it conflict with your diet series.
So I would like to order our patches following as.

1. bug fix patch of unmapped/freed buffer - Nitin
2. diet patch based on 1 - Nitin
3. disksize setting and lockdep problem - Minchan

I will wait your two patchsets.
If you have some trouble to hold the time to make the patch, please tell me.
I will send 1 and 3 ahead so you can send 2 based on it.

-- 
Kind regards,
Minchan Kim

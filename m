Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754402Ab2K2Bp2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:45:28 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:54309 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752564Ab2K2Bp1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:45:27 -0500
Message-ID: <50B6BE34.2010109@vflare.org>
Date: Wed, 28 Nov 2012 17:45:24 -0800
From: Nitin Gupta <ngupta@vflare.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Greg KH <greg@kroah.com>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Sam Hansen <solid.se7en@gmail.com>, Tomas M <tomas@slax.org>,
        Mihail Kasadjikov <hamer.mk@gmail.com>,
        Linux Driver Project <devel@linuxdriverproject.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] zram: Prevent use of unmapped buffer
References: <1354001167-24878-1-git-send-email-ngupta@vflare.org> <20121128051505.GD23136@blaptop> <20121129013320.GA24077@blaptop>
In-Reply-To: <20121129013320.GA24077@blaptop>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/28/2012 05:33 PM, Minchan Kim wrote:
> On Wed, Nov 28, 2012 at 02:15:05PM +0900, Minchan Kim wrote:
>> Hi Nitin,
>>
>> On Mon, Nov 26, 2012 at 11:26:07PM -0800, Nitin Gupta wrote:
>>> The commit c8f2f0db1 ("zram: Fix handling of incompressible pages")
>>> introduced a bug which caused a kunmap()'ed buffer to be used in case
>> I got confused by the descripton. :(
>> The descripton is not right.
>> The problem is to access freed memory, not accessing to kunmaped buffer.
>>
>> partial I/O write.
>>
>> 1. uncmem = kmalloc
>> 2. zram_decompress_page(uncmem)
>> 3. memcpy(uncmem, user_mem)
>> 4. lzo1x_1_compress(uncmem)
>> 5. kfree(uncmem)
>> 6. src = uncmem
>> 7. memcpy(cmem, src, clen) <----- HIT
>>
>>> of partial writes where the data was found to be incompressible.
>>>
> I got it. You shouldn't mention partial write for proper description
> because it was usecase for swap-over-zram so it can't make partial write.
> Without partial write mention, your description is right but the problem
> I mentioned above is another problem for partial write so we need a another
> patch. I will cook.

I will include explanation of both the cases: use of unmapped buffer
and freed buffer, when I resend these patches.

>
>>> This fixes bug 50081:
>>> https://bugzilla.kernel.org/show_bug.cgi?id=50081
>>>
>>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
>>> Reported-by: Mihail Kasadjikov <hamer.mk@gmail.com>
>>> Reported-by: Tomas M <tomas@slax.org>
>> Good catch! Shame on me. I should have reivewed more carefully. :(
>> Please resend it with revised descrption and title.
>> I will rebase mh patchset just sent on top of this bug fix patch.
>>
>> P.S) Sigh, Now code isn't clean due to partial read/write path handling.
>>       IMHO, sooner or later, we need refactoring.
>>
>> -- 
>> Kind regards,
>> Minchan Kim
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/


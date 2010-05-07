Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab0EGJYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 05:24:54 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:34240 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab0EGJYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 05:24:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GGb/NcINHvHKwcSe6RHurkcux1F4ATRfc2GroKkWDdkmORMWlcdKH0famSNf5UUpp+
         1bd925CZhuO4H20h09FSlbbXIfxdXwUuVcuTzA3OwyIVFQzcVyKRqxC6Ax2KqSL57cSm
         0HF0GXh/EQp3vJhu/Rl+snr/1TiRM5P9oULWo=
MIME-Version: 1.0
In-Reply-To: <h2m1b68c6791005070156g9c6be892y852fa52e865a8314@mail.gmail.com>
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org>
	 <1273217107-2023-2-git-send-email-ngupta@vflare.org>
	 <y2m1b68c6791005070103q8cabf3afx22af4a28c6ecf747@mail.gmail.com>
	 <4BE3CC6B.2080008@vflare.org>
	 <h2m1b68c6791005070156g9c6be892y852fa52e865a8314@mail.gmail.com>
Date: Fri, 7 May 2010 12:24:50 +0300
X-Google-Sender-Auth: 82ec9c5657e78ff6
Message-ID: <t2m84144f021005070224x3c111494t3b7193396e02d73@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: jassi brar <jassisinghbrar@gmail.com>
Cc: ngupta@vflare.org, Greg KH <greg@kroah.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, linux-kernel@vger.kernel.org,
       Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 7, 2010 at 5:16 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> On 05/07/2010 01:33 PM, jassi brar wrote:
>>> On Fri, May 7, 2010 at 4:25 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>>>> Added SWP_BLKDEV flag to distinguish block and regular file backed
>>>> swap devices. We could also check if a swap is entire block device,
>>>> rather than a file, by:
>>>> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
>>>> but, I think, simply checking this flag is more convenient.
>>> This might make it convenient for now but is likely to increase complexity and
>>> redundancy. Why not define a macro/inline to figure that out?
>>>
>>
>> Accessing such long pointer chain is maybe not good thing to do for
>> every swap_entry_free() call? Simple checking a flag is perhaps slightly
>> faster? I also can't see how this flag can later increase complexity
>> compared to creating new macro for this check.
>
>  I am not sure about effects on the speed, that needs to be seen.
>  But here are points against using a new flag....

On Fri, May 7, 2010 at 11:56 AM, jassi brar <jassisinghbrar@gmail.com> wrote:
> a) Defining a new flag hogs up precious real-estate of remaining just 2 bits
>   (apparently the new flags are to go before SWP_SCANNING)
>
> b) Over time, some dependent code might evolve to depend upon this flag, while
>     others might use the indirection to deduct if it is block device
> or not. That
>    will make it complicated to make any relevant change in future as we'll have
>    to keep track of more than one way to check the status. Creating a new
>   macro doesn't create a new path to reach the status, but a FLAG does.

I think the flag is cleaner and I'm not convinced by the above
speculative arguments that we should switch to a static inline
function.

Hugh, Linus, would you mind voicing your opinion which way to go here?

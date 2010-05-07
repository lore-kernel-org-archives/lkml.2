Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753842Ab0EGKkS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 06:40:18 -0400
Received: from crca.org.au ([74.207.252.120]:55673 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754107Ab0EGKkQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 06:40:16 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BE3EE08.7000508@tuxonice.net>
Date: Fri, 07 May 2010 20:40:08 +1000
From: Nigel Cunningham <nigel@tuxonice.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: ngupta@vflare.org
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       Minchan Kim <minchan.kim@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
       Christoph Hellwig <hch@infradead.org>,
       Jens Axboe <jens.axboe@oracle.com>, Andi Kleen <andi@firstfloor.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add swap slot free callback to block_device_operations
References: <1273217107-2023-1-git-send-email-ngupta@vflare.org> <1273217107-2023-3-git-send-email-ngupta@vflare.org> <4BE3DBD6.7070707@tuxonice.net> <4BE3E208.1020002@vflare.org>
In-Reply-To: <4BE3E208.1020002@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 07/05/10 19:48, Nitin Gupta wrote:
>>> +        if ((p->flags&   SWP_BLKDEV)&&
>>> +                disk->fops->swap_slot_free_notify)
>>> +            disk->fops->swap_slot_free_notify(p->bdev, offset);
>>
>> Is this p->flags&  SWP_BLKDEV logic reversed? (Don't you want the
>> notifier called for devices that aren't backed by a block device?)
>>
>
> No, the logic here is correct: ramzswap is a block device for which
> we want this callback. Though its a RAM backed, it is still a block
> device.
>
> (I hope it answers your question in the other mail also).

It does; thanks.

>> I also wonder whether leaving the p->flags&  SWP_BLKDEV part out might
>> be a good idea. Other potential notifier users?
>>
>
> For regular files, 'offset' used here makes little sense. For block devices,
> its simply offset in real device. Also, I doubt if *files* would ever
> like to have such a callback.

Okay.

Entire series Acked-by: Nigel Cunningham <nigel@tuxonice.net>

Thanks.

Nigel

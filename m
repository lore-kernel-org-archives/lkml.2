Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754062Ab0ERDfS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 23:35:18 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:48734 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752338Ab0ERDfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 23:35:15 -0400
Message-ID: <4BF20A1C.6030507@vflare.org>
Date: Tue, 18 May 2010 09:01:40 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] Add swap slot free callback to block_device_operations
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>	 <1274074364-8838-3-git-send-email-ngupta@vflare.org> <AANLkTilc3XVXFgNHf3gBTwjamO7cR6bO6ZBTw_j8DECq@mail.gmail.com>
In-Reply-To: <AANLkTilc3XVXFgNHf3gBTwjamO7cR6bO6ZBTw_j8DECq@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 05:31 PM, Minchan Kim wrote:
> On Mon, May 17, 2010 at 2:32 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> This callback is required when RAM based devices are used as swap disks.
>> One such device is ramzswap which is used as compressed in-memory swap
>> disk.  For such devices, we need a callback as soon as a swap slot is no
>> longer used to allow freeing memory allocated for this slot.  Without this
>> callback, stale data can quickly accumulate in memory defeating the whole
>> purpose of such devices.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> Looks good to me about code. so I added my review sign.
> But I have some comments.
> 
> last time I said, I don't like there is a swap specific function in
> block_device_operations.
> It doesn't need many memory but it's not good about design sine
> block_device_operations have common functions about block device.
> 
> But I don't have any good idea now where I put swap specific function.
> And Linus already acked this idea. Hmm.
> 
> If there isn't any objection, I don't insist on my thought.
> 
> Nitpick :
> AFAIR, Nitin introduced SWP_BLKDEV since he think access of long
> pointers isn't good.  ex)
> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
> 
> But now, we have to access  p->bdev->bd_disk->fops->swap_slot_free_notify.
> Isn't it all right?
> 

I'm also not sure about this point but accessing yet another very long
pointer chain just to check if its a block device seems weird.

Anyways, its trivial to remove this swap flag if its later decided that
its not really needed.

Thanks,
Nitin

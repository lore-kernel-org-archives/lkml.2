Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564Ab0EQMBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 08:01:53 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:34286 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753350Ab0EQMBv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 08:01:51 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=cyeJxi3LFHzbnCy/8zqmWKnc1J067/wiMqpUTr9lg/6l9fCImYZpUJKRt7H89N+kgM
         5jp/V/N4FhSHIZOQIy3BswSOprEtvNk6JWuCK2rmNgevlOCWuNzDl8unNJPk+46wffnn
         6u8UXxJ3O2fhJx82WxN4kEQEsaFBwVXI5gZC8=
MIME-Version: 1.0
In-Reply-To: <1274074364-8838-3-git-send-email-ngupta@vflare.org>
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
	 <1274074364-8838-3-git-send-email-ngupta@vflare.org>
Date: Mon, 17 May 2010 21:01:51 +0900
Message-ID: <AANLkTilc3XVXFgNHf3gBTwjamO7cR6bO6ZBTw_j8DECq@mail.gmail.com>
Subject: Re: [PATCH 2/3] Add swap slot free callback to block_device_operations
From: Minchan Kim <minchan.kim@gmail.com>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Greg KH <greg@kroah.com>, Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 2:32 PM, Nitin Gupta <ngupta@vflare.org> wrote:
> This callback is required when RAM based devices are used as swap disks.
> One such device is ramzswap which is used as compressed in-memory swap
> disk.  For such devices, we need a callback as soon as a swap slot is no
> longer used to allow freeing memory allocated for this slot.  Without this
> callback, stale data can quickly accumulate in memory defeating the whole
> purpose of such devices.
>
> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
Reviewed-by: Minchan Kim <minchan.kim@gmail.com>

Looks good to me about code. so I added my review sign.
But I have some comments.

last time I said, I don't like there is a swap specific function in
block_device_operations.
It doesn't need many memory but it's not good about design sine
block_device_operations have common functions about block device.

But I don't have any good idea now where I put swap specific function.
And Linus already acked this idea. Hmm.

If there isn't any objection, I don't insist on my thought.

Nitpick :
AFAIR, Nitin introduced SWP_BLKDEV since he think access of long
pointers isn't good.  ex)
S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)

But now, we have to access  p->bdev->bd_disk->fops->swap_slot_free_notify.
Isn't it all right?

-- 
Kind regards,
Minchan Kim

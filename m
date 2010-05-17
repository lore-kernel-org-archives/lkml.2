Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755999Ab0EQTfw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 15:35:52 -0400
Received: from smtp-out.google.com ([216.239.44.51]:4749 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755963Ab0EQTft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 15:35:49 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=mime-version:in-reply-to:references:date:message-id:subject:from:to:
	cc:content-type:x-system-of-record;
	b=RRLc4HB6KlECwVLSFh9QyL2KnwnO3uvQ/j6gEJP6WKuCAs4T8xKmQ074EkJ3/UcD/
	y8jif4CFUcWTm3FdpoD0Q==
MIME-Version: 1.0
In-Reply-To: <AANLkTikvu85a6Ckl-iJaF_iHlCCsK9tMRYoT21EeZ_CV@mail.gmail.com>
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org>
	 <1274074364-8838-2-git-send-email-ngupta@vflare.org>
	 <AANLkTikvu85a6Ckl-iJaF_iHlCCsK9tMRYoT21EeZ_CV@mail.gmail.com>
Date: Mon, 17 May 2010 12:35:20 -0700
Message-ID: <AANLkTilt8st_RJryMPJ7aqqi5T04xOjBH8_mZbanSprs@mail.gmail.com>
Subject: Re: [PATCH 1/3] Add flag to identify block swap devices
From: Hugh Dickins <hughd@google.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Nitin Gupta <ngupta@vflare.org>, Greg KH <greg@kroah.com>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 17, 2010 at 4:50 AM, Minchan Kim <minchan.kim@gmail.com> wrote:
> On Mon, May 17, 2010 at 2:32 PM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Added SWP_BLKDEV flag to distinguish block and regular file backed
>> swap devices. We could also check if a swap is entire block device,
>> rather than a file, by:
>> S_ISBLK(swap_info_struct->swap_file->f_mapping->host->i_mode)
>> but, I think, simply checking this flag is more convenient.
>>
>> Signed-off-by: Nitin Gupta <ngupta@vflare.org>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
>
> We can enhance swap_show by the flag as further patch.

You mean, make swap_show() decide partition or file by SWP_BLKDEV
instead of its own test?

Actually, I'd prefer we don't embed SWP_BLKDEV further, because it's
a bit of a hack and not really necessary.  What ought to happen (though
perhaps it's silly to be expending code over an imaginary case) is a
map_swap_entry() call to convert the swap offset to physical page
within partition - no-op in the partition case, but correcting the file case.

But I wouldn't want to write that patch without testing it,
which I won't be doing for a while.

Hugh

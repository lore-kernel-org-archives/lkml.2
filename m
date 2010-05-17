Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754571Ab0EQItN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 04:49:13 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:37815 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754197Ab0EQItM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 04:49:12 -0400
Message-ID: <4BF1022F.2030307@vflare.org>
Date: Mon, 17 May 2010 14:15:35 +0530
From: Nitin Gupta <ngupta@vflare.org>
Reply-To: ngupta@vflare.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc11 Thunderbird/3.0.4
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: Greg KH <greg@kroah.com>, Linus Torvalds <torvalds@linux-foundation.org>,
       Nigel Cunningham <nigel@tuxonice.net>,
       Andrew Morton <akpm@linux-foundation.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>, Cyp <cyp561@gmail.com>,
       driverdev <devel@driverdev.osuosl.org>,
       linux-kernel <linux-kernel@vger.kernel.org>, hughd@google.com
Subject: Re: [PATCH 0/3] ramzswap: Eliminate stale data from compressed memory
 	(v2 resend)
References: <1274074364-8838-1-git-send-email-ngupta@vflare.org> <AANLkTinopOldGl3K648tnwmtMT3KhERIW8grokd45O3C@mail.gmail.com>
In-Reply-To: <AANLkTinopOldGl3K648tnwmtMT3KhERIW8grokd45O3C@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/17/2010 11:40 AM, Pekka Enberg wrote:
> On Mon, May 17, 2010 at 8:32 AM, Nitin Gupta <ngupta@vflare.org> wrote:
>> Resending as Greg wanted.
>>
>> (tested on mainline but should apply to linux-next cleanly)
>>
>>
>>  * Changelog: v2 vs initial patches
>>   - directly add swap free callback to block_device_operations
>>     instead of using 'notifiers' for various swap events.
>>
>> ramzswap driver creates RAM based block devices which can be
>> used (only) as swap disks. Pages swapped to these disks are
>> compressed and stored in memory itself.
>>
>> However, these devices do not get any notification when a swap
>> slot is freed (swap_map[i] reaches 0). So, we cannot free memory
>> allocated corresponding to this swap slot. Such stale data can
>> quickly accumulate in (compressed) memory defeating the whole
>> purpose of such devices.
>>
>> To overcome this problem, we now add a callback in struct
>> block_device_operations which is called as soon as a swap
>> slot is freed.
>>
>> Nitin Gupta (3):
>>  Add flag to identify block swap devices
>>  Add swap slot free callback to block_device_operations
>>  ramzswap: Handler for swap slot free callback
>>
>>  drivers/staging/ramzswap/TODO           |    5 -----
>>  drivers/staging/ramzswap/ramzswap_drv.c |   22 +++++++++++++---------
>>  include/linux/blkdev.h                  |    2 ++
>>  include/linux/swap.h                    |    1 +
>>  mm/swapfile.c                           |    5 +++++
>>  5 files changed, 21 insertions(+), 14 deletions(-)
>>  delete mode 100644 drivers/staging/ramzswap/TODO
> 
> Nitin, please retain ACKs when resending patches.
> 
> Acked-by: Pekka Enberg <penberg@cs.helsinki.fi>
> 
> for the whole series.

Sorry, I forgot to include Ack lines. Here are the remaining Acks:

Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
Acked-by: Nigel Cunningham <nigel@tuxonice.net>

Thanks you all for reviews.
Nitin

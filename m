Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0EPHtT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 May 2010 03:49:19 -0400
Received: from crca.org.au ([74.207.252.120]:35083 "EHLO crca.org.au"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751238Ab0EPHtS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 May 2010 03:49:18 -0400
X-Bogosity: Ham, spamicity=0.000000
Message-ID: <4BEFA375.7030404@crca.org.au>
Date: Sun, 16 May 2010 17:49:09 +1000
From: Nigel Cunningham <ncunningham@crca.org.au>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@sisk.pl>
CC: Alan Stern <stern@rowland.harvard.edu>, Jens Axboe <jens.axboe@oracle.com>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Matt Reimer <mattjreimer@gmail.com>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while
 userspace is frozen?
References: <Pine.LNX.4.44L0.1005142231390.11498-100000@netrider.rowland.org> <201005152230.10230.rjw@sisk.pl>
In-Reply-To: <201005152230.10230.rjw@sisk.pl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi.

On 16/05/10 06:30, Rafael J. Wysocki wrote:
> On Saturday 15 May 2010, Alan Stern wrote:
>> On Thu, 13 May 2010, Matt Reimer wrote:
>>
>>>> I don't see anything wrong with the patch itself, but I dislike the
>>>> description.  Devices can come and go from any hotpluggable bus, not
>>>> just MMC/SD.  That just happens to be the first place the problem was
>>>> observed.
>>>
>>> Good point. How about this?
>>>
>>> Matt
>>>
>>>  From 813bd223e5a2fa577b9e64ddf12654a93d0aab8b Mon Sep 17 00:00:00 2001
>>> From: Matt Reimer<mreimer@sdgsystems.com>
>>> Date: Thu, 13 May 2010 14:36:54 -0700
>>> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
>>>
>>> Devices can come and go bus during suspend or resume, when the
>>> writeback thread is frozen, resulting in a hang. Prevent the hang
>>> by thawing the writeback thread in del_gendisk().
>>
>> I would have said "the block layer's writeback thread", but this is
>> okay.
>
> OK, so now I have a question who's going to take the patch.

I object to the patch.

Tell the patch it ought to exit once thawed, by all means.

Make the patch unfreezeable to begin with, by all means.

But don't go down the path of having $random_code_path unfreeze a 
thread. That will lead to unpredictability, confusion and bugs.

If you know a disk is going to be unregistered during resume, use the 
hooks early in the suspend / hibernate process to block new I/O and 
flush what's already there so that there's no need to block on the 
writeback thread, and/or no need to have the writeback thread frozen.

Regards,

Nigel

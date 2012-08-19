Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab2HSKmL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 06:42:11 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:45766 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2HSKmK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 06:42:10 -0400
Message-ID: <5030C17E.5050906@gmail.com>
Date: Sun, 19 Aug 2012 12:35:42 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: Fengguang Wu <fengguang.wu@intel.com>
CC: Namjae Jeon <linkinjeon@gmail.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 2/3] writeback: fix incorrect return value type of bdi_dirty_limit
References: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com> <20120819021757.GB16796@localhost> <5030BE93.50909@gmail.com>
In-Reply-To: <5030BE93.50909@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 19/08/2012 12:23, Marco Stornelli ha scritto:
> Il 19/08/2012 04:17, Fengguang Wu ha scritto:
>> On Sat, Aug 18, 2012 at 05:49:21AM -0400, Namjae Jeon wrote:
>>> unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned
>>> long dirty)
>>>
>>> Above function return type is unsigned long, but return value is
>>> kept in "u64 bdi_dirty".
>>> It can return incorrect value by type casting.
>>
>> I don't see how the cast can return wrong value.
>> The u64 is necessary for the intermediate calculations.
>>
>> Thanks,
>> Fengguang
>>
>
> We are sure u64 is 8byte long, but unsigned long is 4byte long on 32-bit
> machine, so if bdi_dirty can assume values bigger than 2^32 there is an
> implicit truncate of its value, isn't it?
>
> Marco

Sorry but I didn't see the code, it seems not possible so the wrong 
situation can't happen. Maybe we can simply add a comment, nothing more.

Marco

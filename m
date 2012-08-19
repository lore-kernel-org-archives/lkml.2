Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752443Ab2HSXtg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 19:49:36 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44981 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751616Ab2HSXte (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 19:49:34 -0400
MIME-Version: 1.0
In-Reply-To: <5030BE93.50909@gmail.com>
References: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com>
	<20120819021757.GB16796@localhost>
	<5030BE93.50909@gmail.com>
Date: Mon, 20 Aug 2012 08:49:33 +0900
Message-ID: <CAKYAXd_+=s+A4GN0Sgmbb9RO94SQFkAvdLDwuZgRu4LFPLsgQA@mail.gmail.com>
Subject: Re: [PATCH 2/3] writeback: fix incorrect return value type of bdi_dirty_limit
From: Namjae Jeon <linkinjeon@gmail.com>
To: Marco Stornelli <marco.stornelli@gmail.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/19, Marco Stornelli <marco.stornelli@gmail.com>:
> Il 19/08/2012 04:17, Fengguang Wu ha scritto:
>> On Sat, Aug 18, 2012 at 05:49:21AM -0400, Namjae Jeon wrote:
>>> unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long
>>> dirty)
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
Yes, right.
Thanks.
>
> Marco
>

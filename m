Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab2HTAJp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 20:09:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:52396 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751787Ab2HTAJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 20:09:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120819021757.GB16796@localhost>
References: <1345283361-7802-1-git-send-email-linkinjeon@gmail.com>
	<20120819021757.GB16796@localhost>
Date: Mon, 20 Aug 2012 09:09:42 +0900
Message-ID: <CAKYAXd8pEYcnLf7+YWF8i4ytO2dhUvt2+85VyC2sttmedPkf_Q@mail.gmail.com>
Subject: Re: [PATCH 2/3] writeback: fix incorrect return value type of bdi_dirty_limit
From: Namjae Jeon <linkinjeon@gmail.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/8/19, Fengguang Wu <fengguang.wu@intel.com>:
> On Sat, Aug 18, 2012 at 05:49:21AM -0400, Namjae Jeon wrote:
>> unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long
>> dirty)
>>
>> Above function return type is unsigned long, but return value is
>> kept in "u64 bdi_dirty".
>> It can return incorrect value by type casting.
>
> I don't see how the cast can return wrong value.
> The u64 is necessary for the intermediate calculations.
>
> Thanks,
> Fengguang
Hi Wu.
I understand.
Thanks for your reply.
>
>> Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
>> ---
>>  mm/page-writeback.c |    2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/mm/page-writeback.c b/mm/page-writeback.c
>> index 49133b6..73a7a06 100644
>> --- a/mm/page-writeback.c
>> +++ b/mm/page-writeback.c
>> @@ -546,7 +546,7 @@ static unsigned long hard_dirty_limit(unsigned long
>> thresh)
>>   */
>>  unsigned long bdi_dirty_limit(struct backing_dev_info *bdi, unsigned long
>> dirty)
>>  {
>> -	u64 bdi_dirty;
>> +	unsigned long bdi_dirty;
>>  	long numerator, denominator;
>>
>>  	/*
>> --
>> 1.7.9.5
>

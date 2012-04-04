Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757384Ab2DDX7A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 19:59:00 -0400
Received: from mail-qa0-f42.google.com ([209.85.216.42]:61137 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab2DDX67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 19:58:59 -0400
MIME-Version: 1.0
In-Reply-To: <4F7CD6C9.4060509@kernel.dk>
References: <1325254651-15379-1-git-send-email-glorioustao@gmail.com>
 <20120404144656.7b2a06ec.akpm@linux-foundation.org> <CAAV8rn+T7FM7bG+Q6fyoUrVtzOkYOx94Nh87Rg12UqCdk9HhWQ@mail.gmail.com>
 <4F7CD6C9.4060509@kernel.dk>
From: Tao Guo <glorioustao@gmail.com>
Date: Wed, 4 Apr 2012 16:58:37 -0700
Message-ID: <CAAV8rn+s__Uap1_nx8w4USGtAsg0Y=cbo_mUyCWnX2EFNzH3Eg@mail.gmail.com>
Subject: Re: [PATCH] umem: fix up unplugging.
To: Jens Axboe <axboe@kernel.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        neilb@suse.de, axboe@fusionio.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 4, 2012 at 4:18 PM, Jens Axboe <axboe@kernel.dk> wrote:
> On 2012-04-04 16:20, Tao Guo wrote:
>> Hi Andrew,
>>
>> Thanks for your reply.
>>
>> Yes, without this patch the umem driver just doesn't work.
>> It is a bug introduced by commit 7eaceaccab5f40bbfda044629a6298616aeaed50.
>> In that patch, Jens removed the whole mm_unplug_device() function,
>> which used to be
>> the trigger to make umem start to work.
>
> Hmm indeed, that's isn't terribly useful. Why aren't we just calling
> activate_card() on addition of a bio?
>
It is the original design idea, the umem driver also wants to do batch
IO the same as
hard disk drive to fully utilize the IO bandwidth.

Thanks,
-Tao
> But your patch looks fine too, if it's tested it beats what we have.
>
> --
> Jens Axboe
>

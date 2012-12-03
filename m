Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754333Ab2LCAKE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 19:10:04 -0500
Received: from mail-ob0-f174.google.com ([209.85.214.174]:64029 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2LCAKC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 19:10:02 -0500
MIME-Version: 1.0
In-Reply-To: <20121201183929.GA6568@mwanda>
References: <1354297557-24486-1-git-send-email-js1304@gmail.com>
	<20121201183929.GA6568@mwanda>
Date: Mon, 3 Dec 2012 09:09:59 +0900
Message-ID: <CAAmzW4NM5prCnVeaGXGzkvZzg=oQMMC2oKpjEcXuDgfebZe_Pw@mail.gmail.com>
Subject: Re: [RFC PATCH] staging, android, ashmem: invalidate pin/unpin ioctl
 for private map
From: JoonSoo Kim <js1304@gmail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org, Robert Love <rlove@google.com>,
        Brian Swetland <swetland@google.com>, linux-kernel@vger.kernel.org,
        Dima Zavin <dima@android.com>,
        =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>,
        John Stultz <john.stultz@linaro.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Dan.

2012/12/2 Dan Carpenter <dan.carpenter@oracle.com>:
> On Sat, Dec 01, 2012 at 02:45:57AM +0900, Joonsoo Kim wrote:
>> @@ -614,21 +616,35 @@ static int ashmem_pin_unpin(struct ashmem_area *asma, unsigned long cmd,
>>       pgstart = pin.offset / PAGE_SIZE;
>>       pgend = pgstart + (pin.len / PAGE_SIZE) - 1;
>>
>> -     mutex_lock(&ashmem_mutex);
>> +     if (asma->shared_mapping) {
>> +             mutex_lock(&ashmem_mutex);
>
> Wouldn't we need to hold the mutex while we check the
> ->shared_mapping?

I doesn't fully understand ashmem's lock semantic.
Code for retrieving some value of asma instance doesn't hold the mutex, now.
For example, in ashmem_ioctl(), asma->size, asma->prot_mask.
And in ashmem_pin_unpin(), there is asma->file, asma->size which is
retrieved without the mutex.
According to this semantic, the mutex doesn't need for checking
asma->shared_mapping.

Thanks for review!

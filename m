Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab2GILOx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 07:14:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:52709 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753071Ab2GILOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 07:14:52 -0400
MIME-Version: 1.0
In-Reply-To: <871uklp5j7.fsf@devron.myhome.or.jp>
References: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
	<87sjd2766n.fsf@devron.myhome.or.jp>
	<CAKYAXd9mDfDpUj1T1NrY2LUKfwvk94CTXUh5xrEGq8b_rW41rA@mail.gmail.com>
	<871uklp5j7.fsf@devron.myhome.or.jp>
Date: Mon, 9 Jul 2012 20:14:50 +0900
Message-ID: <CAKYAXd-OD_3Z8=6mBQMvBApje9sN0EiPX8drMXc6pSeMgG8Nnw@mail.gmail.com>
Subject: Re: [PATCH] fat: Support fallocate on fat.
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/7/9, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>>> +	/*
>>>> +	 * calculate i_blocks and mmu_private from the actual number of
>>>> +	 * allocated clusters instead of doing it from file size.This ensures
>>>> +	 * that the preallocated disk space using FALLOC_FL_KEEP_SIZE is
>>>> +	 * persistent across remounts and writes go into the allocated
>>>> clusters.
>>>> +	 */
>>>> +	fat_calc_dir_size(inode);
>>>
>>> Looks like the wrong. If you didn't initialize preallocated space, the
>>> data never be exposed to userland. It is security bug.
>> As explained above, if we do append write instead of seeking into a
>> random offset, there is no security risk.
>
> So it means? - if we didn't, there is.
Yes, right.
>
>> The main disadvantage with initializing the preallocated space (as is
>> done in case of without FALLOC_FL_KEEP_SIZE ) is it takes long time
>> for bigger allocation sizes. It took ~70 seconds to preallocate 2GB on
>> our target if FALLOC_FL_KEEP_SIZE is not set.
>
> It doesn't become the reason to expose uninitialized data.
I agree.. If I try to change code for initializing the preallocated
space, Is this patch acceptable ?

Thanks Ogawa.
>
> Thanks.
> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>

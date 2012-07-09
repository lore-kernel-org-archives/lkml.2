Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753243Ab2GIK4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:56:00 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:42972 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab2GIKz7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:55:59 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH] fat: Support fallocate on fat.
References: <1341716859-6768-1-git-send-email-linkinjeon@gmail.com>
	<87sjd2766n.fsf@devron.myhome.or.jp>
	<CAKYAXd9mDfDpUj1T1NrY2LUKfwvk94CTXUh5xrEGq8b_rW41rA@mail.gmail.com>
Date: Mon, 09 Jul 2012 19:55:56 +0900
In-Reply-To: <CAKYAXd9mDfDpUj1T1NrY2LUKfwvk94CTXUh5xrEGq8b_rW41rA@mail.gmail.com>
	(Namjae Jeon's message of "Mon, 9 Jul 2012 15:43:04 +0900")
Message-ID: <871uklp5j7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>>> +	/*
>>> +	 * calculate i_blocks and mmu_private from the actual number of
>>> +	 * allocated clusters instead of doing it from file size.This ensures
>>> +	 * that the preallocated disk space using FALLOC_FL_KEEP_SIZE is
>>> +	 * persistent across remounts and writes go into the allocated
>>> clusters.
>>> +	 */
>>> +	fat_calc_dir_size(inode);
>>
>> Looks like the wrong. If you didn't initialize preallocated space, the
>> data never be exposed to userland. It is security bug.
> As explained above, if we do append write instead of seeking into a
> random offset, there is no security risk.

So it means? - if we didn't, there is.

> The main disadvantage with initializing the preallocated space (as is
> done in case of without FALLOC_FL_KEEP_SIZE ) is it takes long time
> for bigger allocation sizes. It took ~70 seconds to preallocate 2GB on
> our target if FALLOC_FL_KEEP_SIZE is not set.

It doesn't become the reason to expose uninitialized data.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

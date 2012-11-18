Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752535Ab2KRA6K (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Nov 2012 19:58:10 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:48608 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496Ab2KRA6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Nov 2012 19:58:08 -0500
Message-ID: <50A83289.6020108@gmail.com>
Date: Sun, 18 Nov 2012 08:57:45 +0800
From: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121028 Thunderbird/16.0.2
MIME-Version: 1.0
To: Hugh Dickins <hughd@google.com>
CC: Dave Jones <davej@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tmpfs: fix shmem_getpage_gfp VM_BUG_ON
References: <20121025023738.GA27001@redhat.com> <alpine.LNX.2.00.1210242121410.1697@eggly.anvils> <20121101191052.GA5884@redhat.com> <alpine.LNX.2.00.1211011546090.19377@eggly.anvils> <20121101232030.GA25519@redhat.com> <alpine.LNX.2.00.1211011627120.19567@eggly.anvils> <20121102014336.GA1727@redhat.com> <alpine.LNX.2.00.1211021606580.11106@eggly.anvils> <alpine.LNX.2.00.1211051729590.963@eggly.anvils> <20121106135402.GA3543@redhat.com> <alpine.LNX.2.00.1211061521230.6954@eggly.anvils> <50A30ADD.9000209@gmail.com> <alpine.LNX.2.00.1211131935410.30540@eggly.anvils> <50A49C46.9040406@gmail.com> <alpine.LNX.2.00.1211151126440.9273@eggly.anvils> <50A6089B.7010708@gmail.com> <alpine.LNX.2.00.1211162018010.1164@eggly.anvils>
In-Reply-To: <alpine.LNX.2.00.1211162018010.1164@eggly.anvils>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2012 12:48 PM, Hugh Dickins wrote:
> Further offtopic..

Thanks for your explanation, Hugh. :-)

>
> On Fri, 16 Nov 2012, Jaegeuk Hanse wrote:
>> Some questions about your shmem/tmpfs: misc and fallocate patchset.
>>
>> - Since shmem_setattr can truncate tmpfs files, why need add another similar
>> codes in function shmem_fallocate? What's the trick?
> I don't know if I understand you.  In general, hole-punching is different
> from truncation.  Supporting the hole-punch mode of the fallocate system
> call is different from supporting truncation.  They're closely related,
> and share code, but meet different specifications.

What's the different between shmem/tmpfs hole-punching and 
truncate_setsize/truncate_pagecache?
Do you mean one is punch hole in the file and the other one is shrink or 
extent the size of a file?

>> - in tmpfs: support fallocate preallocation patch changelog:
>>    "Christoph Hellwig: What for exactly?  Please explain why preallocating on
>> tmpfs would make any sense.
>>    Kay Sievers: To be able to safely use mmap(), regarding SIGBUS, on files on
>> the /dev/shm filesystem.  The glibc fallback loop for -ENOSYS [or
>> -EOPNOTSUPP] on fallocate is just ugly."
>>    Could shmem/tmpfs fallocate prevent one process truncate the file which the
>> second process mmap() and get SIGBUS when the second process access mmap but
>> out of current size of file?
> Again, I don't know if I understand you.  fallocate does not prevent
> truncation or races or SIGBUS.  I believe that Kay meant that without
> using fallocate to allocate the memory in advance, systemd found it hard
> to protect itself from the possibility of getting a SIGBUS, if access to
> a shmem mapping happened to run out of memory/space in the middle.

IIUC, it will return VM_xxx_OOM instead of SIGBUS if run out of memory. 
Then how can get SIGBUS in this scene?

Regards,
Jaegeuk

> I never grasped why writing the file in advance was not good enough:
> fallocate happened to be what they hoped to use, and it was hard to
> deny it, given that tmpfs already supported hole-punching, and was
> about to convert to the fallocate interface for that.
> Hugh


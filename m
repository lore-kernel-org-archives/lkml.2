Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754157Ab1C2H2h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 03:28:37 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:43079 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751376Ab1C2H2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 03:28:36 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Kyungmin Park <kmpark@infradead.org>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: Re: [PATCH v6] fat: Batched discard support for fat
References: <20110328103431.GA22323@july> <87k4fi4iwq.fsf@devron.myhome.or.jp>
	<AANLkTinGPxxTaCzDUfgK7QX6C-AWim5ZJUub1BgCw4YC@mail.gmail.com>
	<87d3la4ele.fsf@devron.myhome.or.jp>
	<AANLkTinMK8oXEJdYEqjRSfC348xnGx9Fmc8mRXOVN0AZ@mail.gmail.com>
Date: Tue, 29 Mar 2011 16:28:33 +0900
In-Reply-To: <AANLkTinMK8oXEJdYEqjRSfC348xnGx9Fmc8mRXOVN0AZ@mail.gmail.com>
	(Kyungmin Park's message of "Tue, 29 Mar 2011 15:42:03 +0900")
Message-ID: <878vvy4c7y.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kyungmin Park <kmpark@infradead.org> writes:

>> I looked at fstrim.c. It is lowlevel tools to just issue FITRIM - it
>> doesn't use the result at all.
>>
>> Um. Honestly I'd like to see more or wait until real user for now,
>> instead of providing unclear design.
>
> You can find the testcase xfs251(?)
>
> and it's our our usage. After UMS support finished, execute the trim
> command from 0 to MAXINT.
> and periodically call the trim FAT partitions.

It seems to be using fstrim. So state is same with fstrim.
More detail is,

1) This means to trim 0-ULLONG

   fstrim mntpoint

2) step for each 1GB

   while all blocks; do
       fstrim -s start -l step mntpoint
   done

Those bring the real problem up on this example. What is right behavior
if start + len is outside the end of FS? Also I think other issues on
this thread are same state.

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

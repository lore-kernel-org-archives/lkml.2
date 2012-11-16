Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751876Ab2KPNrf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 08:47:35 -0500
Received: from mail.parknet.co.jp ([210.171.160.6]:60760 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751428Ab2KPNre (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 08:47:34 -0500
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Amit Sahrawat <amit.sahrawat83@gmail.com>
Subject: Re: [PATCH 2/3] fat: fix time updates for create and delete
References: <1352642278-2730-1-git-send-email-linkinjeon@gmail.com>
	<874nkw86jz.fsf@devron.myhome.or.jp>
	<CAKYAXd_HBP1ToGunoPwut18v+hwdG=QdfeXyJVSrLUGEt6beSQ@mail.gmail.com>
	<87sj8f5k4m.fsf@devron.myhome.or.jp>
	<87obj35k3a.fsf@devron.myhome.or.jp>
	<CAKYAXd_=wCLo5RZhOaur7Yjw+6MYk-DhRPTjy148Yo0z6z9BcQ@mail.gmail.com>
	<87k3tr5g8v.fsf@devron.myhome.or.jp>
	<87fw4f5g70.fsf@devron.myhome.or.jp>
	<CAKYAXd84jVdb99qAqda_NGEDUg1G1F9aLGQV+Kj3xcTBN=FxwQ@mail.gmail.com>
	<87txsr49m8.fsf@devron.myhome.or.jp>
	<CAKYAXd-4LeGC1o-VbhCWxHxefDV-9YVBoecBuan0Vh2gKS98Kw@mail.gmail.com>
Date: Fri, 16 Nov 2012 22:47:28 +0900
In-Reply-To: <CAKYAXd-4LeGC1o-VbhCWxHxefDV-9YVBoecBuan0Vh2gKS98Kw@mail.gmail.com>
	(Namjae Jeon's message of "Fri, 16 Nov 2012 19:12:57 +0900")
Message-ID: <87r4nt1wy7.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> You have to think about compatibility with other FAT, not unix fs.
>
> Agreed, ctime is creation time, and there are comptability issues with
> the patch.
>
> But there is confusion about 'ctime' usage in the default code. When
> referring the code I found many instances except 'fat_fill_inode'
> where 'ctime' is updated as if it is 'change time' instead of
> 'creation time' like in functions: fat_write_end(), fat_cont_expend(),
> fat_free(), vfat_add_entry().
>
> As a case when I check using a simple case:
> dd if=/dev/zero of=./samplefile bs=4096 count=10
> => check file timings
> wait for 2minutes
> Now, append to this file
> echo "this is simple string to be appended" >> samplefile
> => check file timings
>
> I can see - it resulted in change in 'ctime' and 'mtime'.
> Now, when Connecting this Drive to Windows - it shows the time of
> 'second write' as the CREATION time as well as "Modification time".
> If you agree that this is a strange/problem. I can try to fix the
> timestamp of linux FAT checking this compatability pattern to the
> nearest.
> Let me know your opinion.

Yes. It is strange behavior, and it is what I was calling historical.
If we changed this behavior now, user can be notice to change of
historical behavior.  Also, if we didn't change this, it is strange as
FAT-fs compatibility.

If I can design from scratch, probably I will choose FAT-fs
compatibility at first. But we can't, and I don't have strong opinion to
change current behavior.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

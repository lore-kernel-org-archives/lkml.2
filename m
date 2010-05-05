Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757813Ab0EESaQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:30:16 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:49691 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757767Ab0EESaM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:30:12 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: John Kacur <jkacur@redhat.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Arnd Bergmann <arnd@arndb.de>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 3/6] fat: BKL ioctl pushdown
References: <1273065339-21669-1-git-send-email-jkacur@redhat.com>
	<1273065339-21669-4-git-send-email-jkacur@redhat.com>
	<8739y6xrl6.fsf@devron.myhome.or.jp>
	<alpine.LFD.2.00.1005051927210.6285@localhost.localdomain>
Date: Thu, 06 May 2010 03:30:07 +0900
In-Reply-To: <alpine.LFD.2.00.1005051927210.6285@localhost.localdomain> (John
	Kacur's message of "Wed, 5 May 2010 19:34:27 +0200 (CEST)")
Message-ID: <87wrvitd5c.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.93 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Kacur <jkacur@redhat.com> writes:

> On Thu, 6 May 2010, OGAWA Hirofumi wrote:
>
>> John Kacur <jkacur@redhat.com> writes:
>> 
>> > Convert fat_generic_ioctl and fat_dir_ioctl to unlocked_ioctls
>> > and push down the bkl into those functions.
>> 
>> I guess this is the part of batch ioctl conversion stuff though, those
>> ioctl of FAT don't need BKL at all. Because all of those should already
>> be protected by inode->i_mutex.
>> 
>> Removing BKL and then cleanup after this patch would be almost same with
>> reverting this patch. So, could you just convert to unlocked_ioctl
>> instead?
>
> That's probably not a good idea, without a little bit more analysis, 
> otherwise it's quite easy to introduce subtle bugs.

What analysis? Who do it? I thought about removing BKL of FAT from
several years ago. I was reviewing FAT multiple times, and I'm always
testing FAT without BKL.

If you are going to do, could you do it instead of this patch?

Thanks.
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>

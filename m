Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756127Ab0KNPe4 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Nov 2010 10:34:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23983 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756004Ab0KNPez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Nov 2010 10:34:55 -0500
Message-ID: <4CE00194.3070601@redhat.com>
Date: Sun, 14 Nov 2010 17:34:44 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.6
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Ian Kent <raven@themaw.net>, autofs@linux.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: autofs4 hang in 2.6.37-rc1
References: <4CDFDC2B.6040205@redhat.com> <4CDFE948.4020709@redhat.com> <201011141615.32166.arnd@arndb.de>
In-Reply-To: <201011141615.32166.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2010 05:15 PM, Arnd Bergmann wrote:
> On Sunday 14 November 2010 14:51:04 Avi Kivity wrote:
> >  automount     S ffff88012a28a680     0   399      1 0x00000000
> >    ffff88012a07bd08 0000000000000082 0000000000000000 0000000000000000
> >    ffff88012a07a010 ffff88012a07bfd8 0000000000011800 ffff88012693c260
> >    ffff88012693c5d0 ffff88012693c5c8 0000000000011800 0000000000011800
> >  Call Trace:
> >    [<ffffffff81056197>] ? prepare_to_wait+0x67/0x74
> >    [<ffffffff811b23eb>] autofs4_wait+0x5a4/0x6d5
> >    [<ffffffff81055f25>] ? autoremove_wake_function+0x0/0x34
> >    [<ffffffff811b2ba5>] autofs4_do_expire_multi+0x5b/0xa3
> >    [<ffffffff811b2c39>] autofs4_expire_multi+0x4c/0x54
> >    [<ffffffff811b1750>] autofs4_root_ioctl_unlocked+0x23e/0x252
> >    [<ffffffff811b1808>] autofs4_root_ioctl+0x39/0x53
> >    [<ffffffff810f5e5c>] do_vfs_ioctl+0x557/0x5bb
> >    [<ffffffff810ca644>] ? remove_vma+0x6e/0x76
> >    [<ffffffff810cb6a2>] ? do_munmap+0x31c/0x33e
> >    [<ffffffff810f5f02>] sys_ioctl+0x42/0x65
> >    [<ffffffff81002b42>] system_call_fastpath+0x16/0x1b
> >
> >
> >  Shouldn't we drop autofs4_ioctl_mutex while we wait?
>
> If the ioctl can sleep for multiple seconds, the mutex should
> indeed be dropped, and that would be safe because we used to
> do the same with the BKL.
>
> The question is why this would sleep for more than 120 seconds.
>

Let's fix first and ask questions later.

-- 
error compiling committee.c: too many arguments to function


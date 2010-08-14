Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756895Ab0HNVzy (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:55:54 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:38674 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756645Ab0HNVzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:55:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=jf7FR8AmSYK8Kn0U8HjhjVf6mHM1fIpQGFpVQuadaEnN6FMcaSu0x3QHk4q7Ao6uUz
         483scetaBo3YSjiutgO+8mNoJf4eN4ho1UhcPU7kzp/INC4QCTjflanJM1c4VziCO56C
         AKRkJQucM4yH6eLbpp9/yZ0pl5bFvEjDMhb7g=
Message-ID: <4C6710E5.9000100@gmail.com>
Date: Sat, 14 Aug 2010 22:55:49 +0100
From: Andrew Benton <b3nton@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:2.0b4pre) Gecko/20100808 Shredder/3.2a1pre
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: reiserfs bug?
References: <4C668D3F.9040900@gmail.com> <20100814142212.GB5343@nowhere>
In-Reply-To: <20100814142212.GB5343@nowhere>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/08/10 15:22, Frederic Weisbecker wrote:
> On Sat, Aug 14, 2010 at 01:34:07PM +0100, Andrew Benton wrote:
>> Hello World!
>> I've just recompiled my kernel (current Linus tree), rebooted into it,
>> everything seems to work Ok. I wanted to change 1 option so I
>> recompiled again. Right at the end of the build Xorg server died and on
>> the screen was printed:
>>
>> ------------[ cut here ]------------
>> kernel BUG at /home/andy/save/src/linux-2.6/fs/inode.c:298!
>> invalid opcode: 0000 [#1] SMP
>> last sysfs file: /sys/devices/virtual/vc/vcsa2/uevent
>> CPU 0
>> Pid: 17243, comm: mv Not tainted 2.6.35+ #1 MS-7521/MS-7521
>> RIP: 0010:[<ffffffff810b325b>]  [<ffffffff810b325b>] end_writeback+0x5b/0x70
>> RSP: 0018:ffff880114d7dcf8  EFLAGS: 00010202
>> RAX: 0000000000000060 RBX: ffff88013fab00f8 RCX: 0000000000000000
>> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: ffff88013fab00f8
>> RBP: 00000000ffffffff R08: 0000000000000f36 R09: 0000000000000f36
>> R10: 0000000000000bac R11: 0000000000000000 R12: ffff88013f9ac540
>> R13: 0000000000000000 R14: ffff88010fd31500 R15: ffff88010fd31440
>> FS:  00007f306e5be700(0000) GS:ffff880001a00000(0000) knlGS:0000000000000000
>> CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
>> CR2: 00007f306debb080 CR3: 000000013d730000 CR4: 00000000000406f0
>> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
>> DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
>> Process mv (pid: 17243, threadinfo ffff880114d7c000, task ffff88013cf73430)
>> Stack:
>>   ffff88013fab00f8 ffffffff810f57a7 ffff88013e608400 0000000000000000
>> <0>  0000000000000000 0000000000000000 0000000000000000 0000000000000000
>> <0>  0000000000000000 0000000000000000 ffff88010fd31500 ffff88013fab00f8
>> Call Trace:
>>   [<ffffffff810f57a7>] ? reiserfs_evict_inode+0x47/0x130
>>   [<ffffffff810b328a>] ? evict+0x1a/0xa0
>>   [<ffffffff810b3f6c>] ? iput+0x19c/0x280
>>   [<ffffffff810afdb7>] ? d_kill+0x47/0x80
>>   [<ffffffff810b0dbf>] ? dput+0x9f/0x180
>>   [<ffffffff810abb1b>] ? sys_renameat+0x21b/0x270
>>   [<ffffffff81088449>] ? handle_mm_fault+0x1b9/0x940
>>   [<ffffffff8102118f>] ? do_page_fault+0x1cf/0x320
>>   [<ffffffff810021ab>] ? system_call_fastpath+0x16/0x1b
>> Code: 1d 48 8d bf d0 01 00 00 b9 02 00 00 00 48 c7 c2 70 2b 0b 81 be 07 00 00 00 e8 42 b0 49 00 48 c7 83 d0 01 00 00 60 00 00 00 5b c3<0f>  0b 0f 0b 0f 0b 0f 0b 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
>> RIP  [<ffffffff810b325b>] end_writeback+0x5b/0x70
>>   RSP<ffff880114d7dcf8>
>> ---[ end trace fdd5f8a966d540a4 ]---
>>
>> The Opps mentions reiserfs. The only reiserfs partition I have is /boot
>> (grub won't boot from btrfs) and the script I use to recompile the
>> kernel copies it into /boot when the new kernel is ready.
>>
>> Andy
>
>
> Oh, looks like a return has been forgotten.
>
> Does that patch fix your issue?
>
> Thanks.
>
>
> reiserfs.diff
>
>
> diff --git a/fs/reiserfs/inode.c b/fs/reiserfs/inode.c
> index ae35413..5b18f93 100644
> --- a/fs/reiserfs/inode.c
> +++ b/fs/reiserfs/inode.c
> @@ -84,6 +84,8 @@ void reiserfs_evict_inode(struct inode *inode)
>   	inode->i_blocks = 0;
>   	reiserfs_write_unlock_once(inode->i_sb, depth);
>
> +	return;
> +
>   no_delete:
>   	end_writeback(inode);
>   	dquot_drop(inode);

Yes, thankyou, it seems to be working properly. I've only been using it 
for a couple of minutes but I can delete files on my boot partition 
without an oops so it seems to be working.
Thanks!

Andy

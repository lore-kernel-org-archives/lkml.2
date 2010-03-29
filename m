Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752094Ab0C2NQw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 09:16:52 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:46219 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752011Ab0C2NQu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 09:16:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=bPOm5QeweK3Sy2IRxYEOE60u7rI4XAhRvF3b2HsbDmE0mb35IJWoqIQd4M5EL7rcEM
         wolRJfeWu98sCWQdBkrArSGXB8uuKjeNxXsY6vcHju4Ebhx+odzryASKmfJlPSrJWroU
         8iSXYCCsV0aZrHuuDRe+XRTW/0x4/gsiQAhmA=
MIME-Version: 1.0
In-Reply-To: <d45a3acc1003282126uc8da45avaa641c0a2276c413@mail.gmail.com>
References: <5bdc1c8b1003282044s23347905mfca7c41c37db6f18@mail.gmail.com>
	 <d45a3acc1003282126uc8da45avaa641c0a2276c413@mail.gmail.com>
Date: Mon, 29 Mar 2010 06:16:49 -0700
Message-ID: <5bdc1c8b1003290616x75aacecdieb01898a8f9160be@mail.gmail.com>
Subject: Re: 100%wa for long periods of time
From: Mark Knecht <markknecht@gmail.com>
To: andrew hendry <andrew.hendry@gmail.com>
Cc: Linux Kernel List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 28, 2010 at 9:26 PM, andrew hendry <andrew.hendry@gmail.com> wrote:
> Hi,
>
> Do you know what is causing the wait?
> Probably not the best way, but I have used something like the
> following for a similar case before:
> echo "1" > /proc/sys/vm/block_dump
> ... wait a short while ...
> echo "0" > /proc/sys/vm/block_dump
> Then have a look at dmesg | egrep "READ|WRITE|dirtied"
>
> Andrew.
>
> On Mon, Mar 29, 2010 at 2:44 PM, Mark Knecht <markknecht@gmail.com> wrote:
>> Hi all,
>>   Long time lurker. Seldom post here. I'm not a programmer.
>>
>>   OK, so I'm bring up new hardware - Intel i7 920, Intel DX58SO
>> motherboard, 6GB Crucial triple channel DRAM. Using both the Gentoo
>> install CD (2.6.32 based) as well as 2.6.33-gentoo after booting the
>> install I am running into long periods of time - sometimes 30 seconds,
>> sometimes lasting minutes, where the machine appears to hang or slow
>> down very drastically. The only thing I've noticed so far is that
>> there are 100% waiting periods showing up in top. No messages in dmesg
>> or /var/log/messages. Just long periods where the the compiler acts
>> like the system has really slowed down and sometimes appears almost
>> completely dead.
>>
>>   When this clears up then the system screams along building
>> software. When it happens is see things like the following where CPU's
>> 1 & 5 sit at 100% waiting which lasted 2 or 3 minutes before clearing
>> up. The CPU that goes to 100% does move around but it does seem to
>> land on #5 more than others.
<SNIP>

OK, that catches some info. Here I was doing an emerge --sync and went
to 100% for a little while

flush-8:0(3365): WRITE block 33555792 on sda3
flush-8:0(3365): WRITE block 33555800 on sda3
flush-8:0(3365): WRITE block 33701984 on sda3
flush-8:0(3365): WRITE block 33720128 on sda3
flush-8:0(3365): WRITE block 33721496 on sda3
flush-8:0(3365): WRITE block 33816576 on sda3
flush-8:0(3365): WRITE block 33816584 on sda3
flush-8:0(3365): WRITE block 33816592 on sda3
flush-8:0(3365): WRITE block 33817664 on sda3
flush-8:0(3365): WRITE block 33817672 on sda3
flush-8:0(3365): WRITE block 33817680 on sda3
flush-8:0(3365): WRITE block 33817688 on sda3
flush-8:0(3365): WRITE block 33817696 on sda3
flush-8:0(3365): WRITE block 33817728 on sda3
keeper ~ #

When I first started building this machine 2 days ago I wanted to set
up RAID. I was using the Gentoo install CD at the time. In the process
of loading software I caught a couple error messages so I backed away
from RAID at the time. However since those messages report things
being 'blocked' for more than 120 second it's probably related. Again,
this hasn't happened since I disable RAID, but I do want to go back to
RAID as this is a low-end home file server.

File system type is ext3 if it matters.

INFO: task kjournald:17466 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
kjournald     D ffff8800280bbe00     0 17466      2 0x00000000
 ffff8801adf9d890 0000000000000046 0000000000000000 0000000000000000
 ffff8801adcbde44 0000000000004000 000000000000fe00 000000000000c878
 0000000800000050 ffff88017a99aa40 ffff8801af90a150 ffff8801adf9db08
Call Trace:
 [<ffffffff812dd063>] ? md_make_request+0xb6/0xf1
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a4fc>] ? io_schedule+0x2d/0x3a
 [<ffffffff8109c283>] ? sync_buffer+0x3b/0x40
 [<ffffffff8137a879>] ? __wait_on_bit+0x41/0x70
 [<ffffffff8109c248>] ? sync_buffer+0x0/0x40
 [<ffffffff8137a913>] ? out_of_line_wait_on_bit+0x6b/0x77
 [<ffffffff810438b2>] ? wake_bit_function+0x0/0x23
 [<ffffffff8109c637>] ? sync_dirty_buffer+0x72/0xaa
 [<ffffffff81131b8e>] ? journal_commit_transaction+0xa74/0xde2
 [<ffffffff8103abcc>] ? lock_timer_base+0x26/0x4b
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134804>] ? kjournald+0xe3/0x206
 [<ffffffff81043884>] ? autoremove_wake_function+0x0/0x2e
 [<ffffffff81134721>] ? kjournald+0x0/0x206
 [<ffffffff81043591>] ? kthread+0x8b/0x93
 [<ffffffff8100bd3a>] ? child_rip+0xa/0x20
 [<ffffffff81043506>] ? kthread+0x0/0x93
 [<ffffffff8100bd30>] ? child_rip+0x0/0x20
livecd ~ #

Thanks,
Mark

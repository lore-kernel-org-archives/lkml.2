Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754296Ab0DWOfk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 10:35:40 -0400
Received: from e1.ny.us.ibm.com ([32.97.182.141]:34326 "EHLO e1.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753848Ab0DWOfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 10:35:38 -0400
Message-ID: <4BD1B033.8000900@us.ibm.com>
Date: Fri, 23 Apr 2010 07:35:31 -0700
From: Darren Hart <dvhltc@us.ibm.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Jiri Kosina <jkosina@suse.cz>
CC: Yong Zhang <yong.zhang@windriver.com>,
       "lkml, " <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
Subject: Re: Lockdep usage
References: <4BCFEBFF.4090505@us.ibm.com> <20100422070625.GA17515@windriver.com> <4BD063E4.5030400@us.ibm.com> <alpine.LRH.2.00.1004230234000.28179@twin.jikos.cz>
In-Reply-To: <alpine.LRH.2.00.1004230234000.28179@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina wrote:
> On Thu, 22 Apr 2010, Darren Hart wrote:
> 
>> dmesg includes the following during bootup, but nothing new while running the
>> tests:
>>
>> BUG: key ffff88024e657858 not in .data!
>> ------------[ cut here ]------------
>> WARNING: at kernel/lockdep.c:2706 lockdep_init_map+0x226/0x5c0()
>> Hardware name: BladeCenter LS21 -[7971AC1]-
>> Pid: 1, comm: swapper Not tainted 2.6.34-rc1dvhv4ls #32
>> Call Trace:
>>  [<ffffffff81078446>] ? lockdep_init_map+0x226/0x5c0
>>  [<ffffffff81048687>] warn_slowpath_common+0x87/0xb0
>>  [<ffffffff810486c4>] warn_slowpath_null+0x14/0x20
>>  [<ffffffff81078446>] lockdep_init_map+0x226/0x5c0
>>  [<ffffffff81077f53>] ? lock_release_holdtime+0x83/0xf0
>>  [<ffffffff8115e5a1>] sysfs_add_file_mode+0x71/0xd0
>>  [<ffffffff8115e611>] sysfs_add_file+0x11/0x20
>>  [<ffffffff8115e650>] sysfs_create_file+0x30/0x40
>>  [<ffffffff814995d9>] device_create_file+0x19/0x20
>>  [<ffffffff813afe55>] ipmi_register_smi+0xba5/0xfc0
>>  [<ffffffff81498877>] ? put_device+0x17/0x20
>>  [<ffffffff810670d0>] ? autoremove_wake_function+0x0/0x40
>>  [<ffffffff813b3a12>] try_smi_init+0x5d2/0xa20
>>  [<ffffffff818d5b72>] init_ipmi_si+0x432/0xb80
>>  [<ffffffff818d5740>] ? init_ipmi_si+0x0/0xb80
>>  [<ffffffff810001dd>] do_one_initcall+0x3d/0x180
>>  [<ffffffff822d5a6c>] kernel_init+0x16c/0x200
>>  [<ffffffff81003c14>] kernel_thread_helper+0x4/0x10
>>  [<ffffffff822d5900>] ? kernel_init+0x0/0x200
>>  [<ffffffff81003c10>] ? kernel_thread_helper+0x0/0x10
>> ---[ end trace 30838b0dc5ec48e4 ]---
>>
>> Several more "BUG: key fffXXXXXXXXXXXX not in .data!" lines show up throughout
>> the boot process.
> 
> This should be fixed by commit c7df670b (contained first in 2.6.34-rc2). 
> Do you still see this even with this patch applied?

After updating to the latest linus git lockstats started working as 
expected. Thanks for the pointer.

-- 
Darren Hart
IBM Linux Technology Center
Real-Time Linux Team

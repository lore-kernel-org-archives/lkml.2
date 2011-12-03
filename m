Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019Ab1LCGzc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 Dec 2011 01:55:32 -0500
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:36166 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326Ab1LCGzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 Dec 2011 01:55:31 -0500
Message-ID: <4ED9C7D7.5030300@linux.vnet.ibm.com>
Date: Sat, 03 Dec 2011 12:25:19 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Miles Lane <miles.lane@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Len Brown <len.brown@intel.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Tejun Heo <tj@kernel.org>,
        Linux PM mailing list <linux-pm@vger.kernel.org>
Subject: Re: 3.2.0-rc4+ (Linus GIT af968e29acd91ebeb4224e899202c46c93171ecd)
 -- Freezing of tasks failed after 20.01 seconds (1 tasks refusing to freeze,
 wq_busy=0):
References: <CAHFgRy_ae70MZOgY8q3i36NJh42=GK=XP=EA=ktxgXiFzjY49w@mail.gmail.com>
In-Reply-To: <CAHFgRy_ae70MZOgY8q3i36NJh42=GK=XP=EA=ktxgXiFzjY49w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120306-4790-0000-0000-00000040699E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2011 09:22 AM, Miles Lane wrote:

> While reading a file in sysfs, I suspended tried to suspend the machine and got:
> 
> [ 1058.644957] PM: Syncing filesystems ... done.
> [ 1059.670167] Freezing user space processes ...
> [ 1079.681175] Freezing of tasks failed after 20.01 seconds (1 tasks
> refusing to freeze, wq_busy=0):
> [ 1079.682077] head            D ffff88013a753680  5328  9761   9402 0x00800004
> [ 1079.682086]  ffff88011b15fd28 0000000000000046 0000000000000006
> ffffffff8160d020
> [ 1079.682095]  ffff880100000000 ffff88013a7532d0 ffff88011b15ffd8
> ffff88011b15ffd8
> [ 1079.682102]  0000000000010bc0 ffff88013a7532d0 ffffffff81372d96
> 000000013a7532d0
> [ 1079.682110] Call Trace:
> [ 1079.682120]  [<ffffffff81372d96>] ? __mutex_lock_common+0x26e/0x41e
> [ 1079.682126]  [<ffffffff8137241a>] schedule+0x55/0x57
> [ 1079.682131]  [<ffffffff81372dbf>] __mutex_lock_common+0x297/0x41e
> [ 1079.682137]  [<ffffffff810c675d>] ? lock_memory_hotplug+0x20/0x22
> [ 1079.682142]  [<ffffffff810c675d>] ? lock_memory_hotplug+0x20/0x22
> [ 1079.682149]  [<ffffffff8137302d>] mutex_lock_nested+0x36/0x3b
> [ 1079.682153]  [<ffffffff810c675d>] lock_memory_hotplug+0x20/0x22


                                        ^^^^^^^^^^^^^^^^^^
Wow! There, Tejun, did you see that? That is just what we fixed in
https://lkml.org/lkml/2011/11/21/334 !! :-)

But since Rafael kept it for the next merge window, we hit this failure
in 3.2-rc4.

Well, atleast for once I am feeling extremely happy that we *actually*
fixed a problem _before_ hitting it! :-)

Miles, thanks for the report. Can you please try the patch given in the
above link?

> [ 1079.682160]  [<ffffffff810c53e7>] show_slab_objects+0xfc/0x1e5
> [ 1079.682166]  [<ffffffff810c550e>] partial_show+0xe/0x10
> [ 1079.682171]  [<ffffffff810c23b7>] slab_attr_show+0x1d/0x21
> [ 1079.682177]  [<ffffffff811235c9>] sysfs_read_file+0xb7/0x13c
> [ 1079.682183]  [<ffffffff810ccdd3>] vfs_read+0xa0/0xc7
> [ 1079.682188]  [<ffffffff810ce0d3>] ? fget_light+0x35/0x97
> [ 1079.682194]  [<ffffffff810cce3f>] sys_read+0x45/0x69
> [ 1079.682199]  [<ffffffff81378d3b>] system_call_fastpath+0x16/0x1b
> 


Regards,
Srivatsa S. Bhat
IBM Linux Technology Center


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759904Ab0JZMpV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 08:45:21 -0400
Received: from nbd.name ([88.198.39.176]:52055 "EHLO ds10.nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757820Ab0JZMpT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 08:45:19 -0400
X-Greylist: delayed 976 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Oct 2010 08:45:19 EDT
Message-ID: <4CC6C988.4070706@openwrt.org>
Date: Tue, 26 Oct 2010 14:28:56 +0200
From: Felix Fietkau <nbd@openwrt.org>
User-Agent: Mozilla/5.0 (Macintosh; U; Intel Mac OS X 10.6; en-US; rv:1.9.2.11) Gecko/20101013 Thunderbird/3.1.5
MIME-Version: 1.0
To: Jaswinder Singh <jaswinderlinux@gmail.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, ath9k-devel@venema.h4ckr.net,
        Linus Torvalds <torvalds@linux-foundation.org>,
        shafi.wireless@gmail.com, "John W. Linville" <linville@tuxdriver.com>
Subject: Re: ath9k crashing the kernel
References: <AANLkTim=jD-C4DwDS2=KuQnhPOyP+Cnd-hUTdaZ7Opth@mail.gmail.com> <AANLkTikHTgoJyxm80MuXM9oTvCPTFAPM12zVih1RsTfy@mail.gmail.com>
In-Reply-To: <AANLkTikHTgoJyxm80MuXM9oTvCPTFAPM12zVih1RsTfy@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-26 9:09 AM, Jaswinder Singh wrote:
>> ath9k is crashing the kernel :
>>
>> [   21.276554] BUG: spinlock bad magic on CPU#1, NetworkManager/1056
>> [   21.277015]  lock: f5be80a8, .magic: 00000000, .owner: <none>/-1,
>> .owner_cpu: 0
>> [   21.277015] Pid: 1056, comm: NetworkManager Not tainted 2.6.36-netbook+ #20
>> [   21.277015] Call Trace:
>> [   21.277015]  [<c14767a7>] ? printk+0xf/0x11
>> [   21.277015]  [<c117b823>] spin_bug+0x7c/0x87
>> [   21.301365]  [<c117b8bd>] do_raw_spin_lock+0x1e/0x125
>> [   21.301365]  [<c1478d0a>] ? _raw_spin_unlock_bh+0x1a/0x1c
>> [   21.301365]  [<c1478dc3>] _raw_spin_lock_irqsave+0x17/0x1c
>> [   21.318857]  [<c1288a74>] ath9k_config+0x255/0x38b
>> [   21.318857]  [<c1447bdb>] ieee80211_hw_config+0x10a/0x114
>> [...]
>>
>> Linux 2.6.36 f6f94e2ab1 is good
>> and
>> 229aebb873e2972 is bad
>>
> 
> After further investigation bad commit is :
> 
> 3430098ae463e31ab16926ac3eb295368a3ca5d9 is the first bad commit
> commit 3430098ae463e31ab16926ac3eb295368a3ca5d9
> Author: Felix Fietkau <nbd@openwrt.org>
> Date:   Sun Oct 10 18:21:52 2010 +0200
> 
>     ath9k: implement channel utilization stats for survey
> 

This should already be fixed in wireless-testing by the following commit

commit 20b25744d1366762c6878d3254f93973cafe1f8e
Author: Ben Greear <greearb@candelatech.com>
Date:   Fri Oct 15 15:04:09 2010 -0700

    ath9k: Properly initialize ath_common->cc_lock.


- Felix

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab2CRRmi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 13:42:38 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755691Ab2CRRmh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 13:42:37 -0400
Message-ID: <4F661E89.5050000@gmail.com>
Date: Sun, 18 Mar 2012 10:42:33 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
References: <4F6600FA.7050005@gmail.com> <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com>
In-Reply-To: <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2012 08:54 AM, Tejun Heo wrote:
> On Sun, Mar 18, 2012 at 08:36:26AM -0700, Justin P. Mattock wrote:
>> with the current linux-next I am seeing this in dmesg..:
>>
>> [    3.643089] isapnp: No Plug&  Play device found
>> [    3.643690] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
>> [    3.673061]
>> [    3.699307] ===============================
>> [    3.725757] [ INFO: suspicious RCU usage. ]
>> [    3.752134] 3.3.0-rc7-next-20120316 #1 Not tainted
>> [    3.778508] -------------------------------
>> [    3.778510] kernel/cgroup.c:1719 suspicious
>> rcu_dereference_check() usage!
>> [    3.778512]
>> [    3.778512] other info that might help us debug this:
>> [    3.778513]
>> [    3.778515]
>> [    3.778515] rcu_scheduler_active = 1, debug_locks = 1
>> [    3.778517] no locks held by swapper/0/1.
>> [    3.778517]
>> [    3.778518] stack backtrace:
>> [    3.778519] Pid: 1, comm: swapper/0 Not tainted
>> 3.3.0-rc7-next-20120316 #1
>> [    3.778521] Call Trace:
>> [    3.778528]  [<c158cc21>] ? printk+0x1d/0x1f
>> [    3.778534]  [<c10a822a>] lockdep_rcu_suspicious+0xca/0x100
>> [    3.778536]  [<c10bedea>] cgroup_path+0x17a/0x1c0
>
> Known problem.  The following pending patchset should fix the problem.
>
>    http://thread.gmane.org/gmane.linux.kernel/1263989
>
> Jens?
>
> Thakns.
>

cool thanks for the info..
I went and applied your patches(all 5) and there is fuzz, and some 
errors with linux-next.
seems the suspicious message is still there, but the system boots up 
just fine with the patches in.
  maybe manually applying them by hand is what I need to do for -next so 
I dont miss anything important with the patch that takes care of the 
suspicious message.

Justin P. Mattock

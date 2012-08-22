Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab2HVFrU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 01:47:20 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:48409 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754009Ab2HVFrR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 01:47:17 -0400
From: "Kim, Milo" <Milo.Kim@ti.com>
To: Bryan Wu <bryan.wu@canonical.com>
CC: Tejun Heo <tj@kernel.org>, Richard Purdie <rpurdie@rpsys.net>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Subject: RE: [PATCH 2/4] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
Thread-Topic: [PATCH 2/4] leds-lp5523: set the brightness to 0 forcely on
 removing the driver
Thread-Index: Ac1/e9/2sjm/1CnHR7+HKaHWZOWZZAAWIBmAABUskjA=
Date: Wed, 22 Aug 2012 05:46:21 +0000
Message-ID: <A874F61F95741C4A9BA573A70FE3998F41EF0BFF@DQHE02.ent.ti.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF0AEB@DQHE02.ent.ti.com>
 <CAK5ve-LoER0X36JMBjY4Dqgts5FapAs=2w01J05YgJ8tmYHMkg@mail.gmail.com>
In-Reply-To: <CAK5ve-LoER0X36JMBjY4Dqgts5FapAs=2w01J05YgJ8tmYHMkg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.16.34.32]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Hmmm, I think we still should use cancel_work() here based on your
> idea. Please find the patch from Tejun and add him to this loop
> [PATCH 4/6] workqueue: deprecate flush[_delayed]_work_sync()
> ---
> Before this patchset,
> 
>  flush_work()
> 
>         flush the last queued instance of the work item.  If it got
>         queued on multple CPUs, it only considers the last queued
>         instance.  The work item could still be executing on other
>         CPUs and the flush might become noop if there are competing
>         queueing operation on another CPU.
> 
>  flush_work_sync()
> 
>         flush_work() + wait for executing instances on all CPUs.  The
>         flush_work() part may still become noop if there's competing
>         queueing operation.
> 
>  cancel_work()
> 
>         Dequeue the work item if it's pending.  Doesn't care about
>         whether it's executing or not.
> 
>  cancel_work_sync()
> 
>         cancel_work() + flush_work_sync().
> 
> 
> After this patchset,
> 
>  flush_work()
> 
>         flush the work item.  Any queueing happened previously is
>         guaranteed to have finished execution on return.  If no
>         further queueing happened after flush started, the work item
>         is guaranteed to be idle on return.
> 
>  cancel_work()
> 
>         Same as before.
> 
>  cancel_work_sync()
> 
>         cancel_work() followed by flush_work().  The same semantics as
>         del_timer_sync().
> ---
> 
> cancel_work_sync() won't execute the work item at all just cancel
> them, but flush will execute them and return.
> 

Thanks a lot for the updates!

Then, I think flush_work() should be used for executing remaining brightness work
rather than cancel_work_sync().

Best Regards,
Milo




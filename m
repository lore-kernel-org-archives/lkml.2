Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584Ab0H3O4S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Aug 2010 10:56:18 -0400
Received: from hera.kernel.org ([140.211.167.34]:60972 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752510Ab0H3O4H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Aug 2010 10:56:07 -0400
Message-ID: <4C7BC675.8050506@kernel.org>
Date: Mon, 30 Aug 2010 16:55:49 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: CAI Qian <caiqian@redhat.com>
CC: kexec <kexec@lists.infradead.org>, linux-next@vger.kernel.org,
        torvalds@linux-foundation.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: kdump regression compared to v2.6.35
References: <1706089082.1537331283179884183.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
In-Reply-To: <1706089082.1537331283179884183.JavaMail.root@zmail06.collab.prod.int.phx2.redhat.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 30 Aug 2010 14:55:51 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/30/2010 04:51 PM, CAI Qian wrote:
> kintegrityd   R  running task        0    13      2 0x00000008
>  ffffffffffffff10 ffffffff81078e25 0000000000000010 0000000000000206
>  ffff88046dcf1e40 0000000000000018 ffff88046dc9a440 ffff88046dc9a440
>  ffff88088e231f00 ffff88088e239300 ffff88046dcf1ee0 ffffffff810796e8
> Call Trace:
>  [<ffffffff81078e25>] ? worker_maybe_bind_and_lock+0x55/0xf0
>  [<ffffffff810796e8>] ? rescuer_thread+0x108/0x1d0
>  [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
>  [<ffffffff810795e0>] ? rescuer_thread+0x0/0x1d0
>  [<ffffffff8107fc06>] ? kthread+0x96/0xa0
>  [<ffffffff8100be84>] ? kernel_thread_helper+0x4/0x10
>  [<ffffffff8107fb70>] ? kthread+0x0/0xa0
>  [<ffffffff8100be80>] ? kernel_thread_helper+0x0/0x10
...
> runnable tasks:
>             task   PID         tree-key  switches  prio     exec-runtime         sum-exec        sum-sleep
> ----------------------------------------------------------------------------------------------------------
>          swapper     1       296.512617        23   120       296.512617       282.090606         0.046441 /
>      sync_supers    11       293.512617         2   120       293.512617         0.002502      5354.887736 /
> R    kintegrityd    13      2382.377879         1   100      2382.377879    180846.751167         0.001076 /

Looks like kintegrityd went bonkers.  Maybe it has some busy wait
which doesn't quite work well with how cmwq schedules works.  I'll
look into it.  Can you please attach your .config?

Thanks.

-- 
tejun

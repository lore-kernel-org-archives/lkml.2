Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab2CRPyJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Mar 2012 11:54:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41462 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755532Ab2CRPyH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Mar 2012 11:54:07 -0400
Date: Sun, 18 Mar 2012 08:54:01 -0700
From: Tejun Heo <tj@kernel.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: INFO: suspicious RCU usage. on 3.3.0-rc7-next-20120316
Message-ID: <20120318155401.GA8045@dhcp-172-17-108-109.mtv.corp.google.com>
References: <4F6600FA.7050005@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F6600FA.7050005@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 18, 2012 at 08:36:26AM -0700, Justin P. Mattock wrote:
> with the current linux-next I am seeing this in dmesg..:
> 
> [    3.643089] isapnp: No Plug & Play device found
> [    3.643690] Serial: 8250/16550 driver, 32 ports, IRQ sharing enabled
> [    3.673061]
> [    3.699307] ===============================
> [    3.725757] [ INFO: suspicious RCU usage. ]
> [    3.752134] 3.3.0-rc7-next-20120316 #1 Not tainted
> [    3.778508] -------------------------------
> [    3.778510] kernel/cgroup.c:1719 suspicious
> rcu_dereference_check() usage!
> [    3.778512]
> [    3.778512] other info that might help us debug this:
> [    3.778513]
> [    3.778515]
> [    3.778515] rcu_scheduler_active = 1, debug_locks = 1
> [    3.778517] no locks held by swapper/0/1.
> [    3.778517]
> [    3.778518] stack backtrace:
> [    3.778519] Pid: 1, comm: swapper/0 Not tainted
> 3.3.0-rc7-next-20120316 #1
> [    3.778521] Call Trace:
> [    3.778528]  [<c158cc21>] ? printk+0x1d/0x1f
> [    3.778534]  [<c10a822a>] lockdep_rcu_suspicious+0xca/0x100
> [    3.778536]  [<c10bedea>] cgroup_path+0x17a/0x1c0

Known problem.  The following pending patchset should fix the problem.

  http://thread.gmane.org/gmane.linux.kernel/1263989

Jens?

Thakns.

-- 
tejun

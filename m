Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932281Ab1ALRnL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Jan 2011 12:43:11 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:42726 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754691Ab1ALRnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Jan 2011 12:43:07 -0500
Date: Wed, 12 Jan 2011 17:43:00 +0000
From: Russell King <rmk@arm.linux.org.uk>
To: Linux Kernel List <linux-kernel@vger.kernel.org>
Subject: INFO: task rcu_kthread:6 blocked for more than 120 seconds.
Message-ID: <20110112174300.GA6504@flint.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm seeing rcu_kthread get stuck from time to time on ARM Versatile PB
(ARM926).  Kernel is based upon commit 9e9bc973 (immediately prior to
the merge of the OMAP tree.)

~ # ps aux|grep rcu
root         6  0.0  0.0      0     0 ?        S    02:31   0:01 [rcu_kthread]
root       502  9.0  0.3   3740   472 ttyAMA0  S+   02:59   0:00 grep rcu
~ # ps aux|grep rcu
root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
root       504  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
~ # ps aux|grep rcu
root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
root       506  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
~ # ps aux|grep rcu
root         6  0.0  0.0      0     0 ?        D    02:31   0:01 [rcu_kthread]
root       508  0.0  0.3   3740   472 ttyAMA0  S+   03:00   0:00 grep rcu
~ # cat /proc/6/wchan
rcu_kthread
~ # INFO: task rcu_kthread:6 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcu_kthread     D c02c6684     0     6      2 0x00000000
Backtrace:
[<c02c6388>] (schedule+0x0/0x354) from [<c00836a0>] (rcu_kthread+0x78/0xf4)
[<c0083628>] (rcu_kthread+0x0/0xf4) from [<c00633ac>] (kthread+0x88/0x90)
[<c0063324>] (kthread+0x0/0x90) from [<c004d12c>] (do_exit+0x0/0x5f8)
 r7:00000013 r6:c004d12c r5:c0063324 r4:c181df28
no locks held by rcu_kthread/6.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

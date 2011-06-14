Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750980Ab1FNEC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 00:02:26 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:35499 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750747Ab1FNECZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 00:02:25 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=so5EfB94y3ibOD4qeRAaXs0h/jErGjZjYj+bbmAu/bqkomdl1Z/q8xrGRHhbCZVr1M
         Hb0n16/qlj4QUktTlhu1cC/lSr1IS3f2v70D/NqNsVB+i94ndRAqVyjG7cUQTipALUEF
         ENNRaYq2gsvvPtG60BwTbxcpAyMgGf+iexU68=
MIME-Version: 1.0
Date: Tue, 14 Jun 2011 12:02:24 +0800
Message-ID: <BANLkTin2osfkSiu8maGmJAnzv4O5ODK0dw@mail.gmail.com>
Subject: [3.0-rc3] tree RCU boost vs hang notifier...
From: Daniel J Blueman <daniel.blueman@gmail.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With 3.0-rc3 configured with CONFIG_TREE_PREEMPT_RCU, CONFIG_RCU_BOOST
and CONFIG_DETECT_HUNG_TASK, we see frequent task hung reports [1],
possibly as the tree RCU boost kthreads sleep uninterruptably.

It looks like tinyRCU sleeps interruptably, so won't trigger the hangcheck.

Thanks,
  Daniel

--- [1]

INFO: task rcub0:9 blocked for more than 120 seconds.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
rcub0           D ffffffff81c29c80  6768     9      2 0x00000000
 ffff880221713ea0 0000000000000046 ffff880221713db0 ffffffff8171b825
 ffff880221712000 0000000000004000 ffff8802214d0000 ffff88022170c060
 ffff88022ec00000 0000000000010ac0 0000000000000001 ffff88022ec10ac0
Call Trace:
 [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
 [<ffffffff8171822a>] ? preempt_schedule+0x3a/0x50
 [<ffffffff8171b825>] ? _raw_spin_unlock_irqrestore+0x75/0x80
 [<ffffffff810cec90>] ? rcu_boost+0x120/0x120
 [<ffffffff8107e1a3>] kthread+0x93/0xc0
 [<ffffffff81098bad>] ? trace_hardirqs_on_caller+0x13d/0x180
 [<ffffffff8171d4d4>] kernel_thread_helper+0x4/0x10
 [<ffffffff81048ad7>] ? finish_task_switch+0x77/0x100
 [<ffffffff8171bc04>] ? retint_restore_args+0xe/0xe
 [<ffffffff8107e110>] ? __init_kthread_worker+0x70/0x70
 [<ffffffff8171d4d0>] ? gs_change+0xb/0xb
no locks held by rcub0/9.

-- 
Daniel J Blueman

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755562Ab2DQInL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 04:43:11 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48488 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755347Ab2DQInJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 04:43:09 -0400
MIME-Version: 1.0
From: Sasha Levin <levinsasha928@gmail.com>
Date: Tue, 17 Apr 2012 10:42:47 +0200
Message-ID: <CA+1xoqdJjTe+BMe_ebMBSg57gs2FA60T_0WKhrHvfDoE8AvCuw@mail.gmail.com>
Subject: New RCU related warning due to rcu_preempt_depth() changes
To: Paul McKenney <paulmck@linux.vnet.ibm.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org List" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

It looks like commit 7298b03 ("rcu: Move __rcu_read_lock() and
__rcu_read_unlock() to per-CPU variables") is causing the following
warning (I've added the extra fields on the second line):

[   77.330920] BUG: sleeping function called from invalid context at
mm/memory.c:3933
[   77.336571] in_atomic(): 0, irqs_disabled(): 0, preempt count: 0,
preempt offset: 0, rcu depth: 1, pid: 5669, name: trinity
[   77.344135] no locks held by trinity/5669.
[   77.349644] Pid: 5669, comm: trinity Tainted: G        W
3.4.0-rc3-next-20120417-sasha-dirty #83
[   77.354401] Call Trace:
[   77.355956]  [<ffffffff810e83f3>] __might_sleep+0x1f3/0x210
[   77.358811]  [<ffffffff81198eaf>] might_fault+0x2f/0xa0
[   77.361997]  [<ffffffff810e3228>] schedule_tail+0x88/0xb0
[   77.364671]  [<ffffffff826a01d3>] ret_from_fork+0x13/0x80

As you can see, rcu_preempt_depth() returns 1 when running in that
context, which looks pretty odd.

Thanks.

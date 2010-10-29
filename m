Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753099Ab0J2FWe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 01:22:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:36318 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752581Ab0J2FW3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 01:22:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=syT8+giLovYbATCqXifNFQgjjpCSXe2FbE/Qtpwk3h9vWb/NfrOFGbshNzuucyCm8y
         Od0I1kNCKfTsA6itqYPzenX83/lV5iBgmSQ0NCi2lXJNjfdDbVkIzNmijtBm9ks5DAMu
         jqen13aRl20BHYMHVXHuy8PnHJyJSXPbfMKfs=
MIME-Version: 1.0
Date: Fri, 29 Oct 2010 01:22:28 -0400
Message-ID: <AANLkTimGgzOZb8EwUQO16cZcL+ycveKTYzg_AAX+D+Kw@mail.gmail.com>
Subject: 2.6.36-git11 -- kernel/pid.c:419 invoked rcu_dereference_check()
 without protection!
From: Miles Lane <miles.lane@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ INFO: suspicious rcu_dereference_check() usage. ]
---------------------------------------------------
kernel/pid.c:419 invoked rcu_dereference_check() without protection!

other info that might help us debug this:


rcu_scheduler_active = 1, debug_locks = 1
1 lock held by ureadahead/943:
 #0:  (tasklist_lock){.+.+..}, at: [<ffffffff810ec497>]
sys_ioprio_set+0x8e/0x2aa

stack backtrace:
Pid: 943, comm: ureadahead Not tainted 2.6.36-git11 #8
Call Trace:
 [<ffffffff8105d335>] lockdep_rcu_dereference+0x9d/0xa5
 [<ffffffff8104c825>] find_task_by_pid_ns+0x3f/0x58
 [<ffffffff8104c85b>] find_task_by_vpid+0x1d/0x1f
 [<ffffffff810ec4c6>] sys_ioprio_set+0xbd/0x2aa
 [<ffffffff813547a3>] ? trace_hardirqs_on_thunk+0x3a/0x3f
 [<ffffffff81002aab>] system_call_fastpath+0x16/0x1b

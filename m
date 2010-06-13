Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751929Ab0FMG77 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jun 2010 02:59:59 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46257 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751263Ab0FMG75 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jun 2010 02:59:57 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:cc:content-type;
        b=aaglsKGgqzXinVG593eGALHI7O9jNM8Gq3P1Mqv0uvPbRDHD7eyY6Iml4n9OBmeJmU
         az3jfZli1beVqLw1tVFJO8S1Be5asZtm0Z0uElEnbWMQB4/f75LxBReWdA7coysDbuC4
         SIbSSGj4lQVza8S/KT4keNi9BwG/6SGb6ltew=
MIME-Version: 1.0
Date: Sun, 13 Jun 2010 02:36:03 -0400
Message-ID: <AANLkTikBziddf8Z88WnMiuIk2AEeHxI6k6K9tiisSyLc@mail.gmail.com>
Subject: 2.6.35-rc3 - include/linux/fdtable.h:85 invoked rcu_dereference_check() 
	without protection!
From: Miles Lane <miles.lane@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[ 2074.377176] [ INFO: suspicious rcu_dereference_check() usage. ]
[ 2074.377180] ---------------------------------------------------
[ 2074.377185] include/linux/fdtable.h:85 invoked
rcu_dereference_check() without protection!
[ 2074.377189]
[ 2074.377190] other info that might help us debug this:
[ 2074.377191]
[ 2074.377195]
[ 2074.377196] rcu_scheduler_active = 1, debug_locks = 1
[ 2074.377200] no locks held by gvfsd/4402.
[ 2074.377203]
[ 2074.377204] stack backtrace:
[ 2074.377209] Pid: 4402, comm: gvfsd Not tainted 2.6.35-rc3 #1
[ 2074.377213] Call Trace:
[ 2074.377226]  [<ffffffff8106f2c5>] lockdep_rcu_dereference+0x9d/0xa5
[ 2074.377235]  [<ffffffff810e9104>] fcheck_files+0x5c/0xc9
[ 2074.377242]  [<ffffffff810e91c9>] fget_light+0x35/0x96
[ 2074.377250]  [<ffffffff810f77b0>] do_sys_poll+0x1ff/0x3e5
[ 2074.377257]  [<ffffffff810f6eb2>] ? __pollwait+0x0/0xc7
[ 2074.377264]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
[ 2074.377271]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
[ 2074.377277]  [<ffffffff810f6f79>] ? pollwake+0x0/0x4f
[ 2074.377285]  [<ffffffff812d2f18>] ? __sock_recvmsg_nosec+0x65/0x6e
[ 2074.377292]  [<ffffffff812d4401>] ? __sock_recvmsg+0x49/0x54
[ 2074.377299]  [<ffffffff812d6842>] ? sock_aio_read+0xc2/0xd6
[ 2074.377307]  [<ffffffff810e7faf>] ? do_sync_read+0xc6/0x103
[ 2074.377316]  [<ffffffff8119ec0c>] ? security_file_permission+0x11/0x13
[ 2074.377324]  [<ffffffff8100877a>] ? sysret_check+0x2e/0x69
[ 2074.377331]  [<ffffffff810f7b2a>] sys_poll+0x50/0xbb
[ 2074.377338]  [<ffffffff81008742>] system_call_fastpath+0x16/0x1b

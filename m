Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab0HQEMA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 00:12:00 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:49149
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750945Ab0HQEL7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 00:11:59 -0400
Date: Mon, 16 Aug 2010 21:12:18 -0700 (PDT)
Message-Id: <20100816.211218.189709876.davem@davemloft.net>
To: linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org
Subject: tasks getting stuck on mmap_sem?
From: David Miller <davem@davemloft.net>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


I just started seeing this with current GIT, is it related
to the page table locking shuffle of a few days ago?

[21029.265646] INFO: task git:16643 blocked for more than 120 seconds.
[21029.267054] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[21029.268412] git           D 000000000072f804     0 16643  16273 0x210001101000080
[21029.269809] Call Trace:
[21029.271062]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
[21029.272390]  [000000000072f804] __down_read+0x30/0x40
[21029.273689]  [0000000000731148] do_sparc64_fault+0x238/0x788
[21029.274996]  [00000000004079e8] sparc64_realfault_common+0x10/0x20
[21029.276347] INFO: task git:16644 blocked for more than 120 seconds.
[21029.277655] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[21029.278993] git           D 000000000072f874     0 16644  16273 0x210041101000080
[21029.280348] Call Trace:
[21029.281542]  [000000000072f778] rwsem_down_failed_common+0x90/0xb8
[21029.282818]  [000000000072f874] __down_write+0x34/0x44
[21029.284057]  [00000000004d9c44] SyS_mmap_pgoff+0xc8/0x118
[21029.285293]  [0000000000406154] linux_sparc_syscall32+0x34/0x40
 ...

etc.  it's a set of git threads computing deltas for a remote pull
request to the machine.

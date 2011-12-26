Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754021Ab1LZJrA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Dec 2011 04:47:00 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37594 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752647Ab1LZJqz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Dec 2011 04:46:55 -0500
Message-ID: <1324892810.31721.0.camel@lappy>
Subject: WARNING: at block/blk-ioc.c:234 exit_io_context+0x40/0x92()
From: Sasha Levin <levinsasha928@gmail.com>
To: tj@kernel.org, Jens Axboe <jaxboe@fusionio.com>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Date: Mon, 26 Dec 2011 11:46:50 +0200
Content-Type: text/plain; charset="us-ascii"
X-Mailer: Evolution 3.2.2 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Commit 6e736be7 ("block: make ioc get/put interface more conventional
and fix race on alloction") added a warning to exit_io_context() which
is triggered by failed clone() syscall.

Here is the warning;
[  294.417656] ------------[ cut here ]------------
[  294.418897] WARNING: at block/blk-ioc.c:234 exit_io_context+0x40/0x92()
[  294.420538] Pid: 17090, comm: trinity Not tainted 3.2.0-rc6-next-20111222-sasha-dirty #77
[  294.422231] Call Trace:
[  294.422701]  [<ffffffff8181a7a2>] ? exit_io_context+0x40/0x92
[  294.423842]  [<ffffffff8181a7a2>] ? exit_io_context+0x40/0x92
[  294.424919]  [<ffffffff810b69a3>] warn_slowpath_common+0x8f/0xb2
[  294.426036]  [<ffffffff810b6a77>] warn_slowpath_null+0x18/0x1a
[  294.427114]  [<ffffffff8181a7a2>] exit_io_context+0x40/0x92
[  294.428121]  [<ffffffff810b58c9>] copy_process+0x126f/0x1453
[  294.429131]  [<ffffffff810891f6>] ? do_page_fault+0x48a/0x4a4
[  294.430162]  [<ffffffff810b5c1b>] do_fork+0x120/0x3e9
[  294.431160]  [<ffffffff82421b57>] ? mutex_unlock+0x9/0xb
[  294.432150]  [<ffffffff8110f999>] ? lock_release_holdtime+0xc6/0xd4
[  294.433296]  [<ffffffff82424bdd>] ? retint_swapgs+0x13/0x1b
[  294.434336]  [<ffffffff8106242f>] sys_clone+0x26/0x28
[  294.435277]  [<ffffffff82425803>] stub_clone+0x13/0x20
[  294.436230]  [<ffffffff82425479>] ? system_call_fastpath+0x16/0x1b
[  294.437381] ---[ end trace a2e4eb670b375238 ]---

-- 

Sasha.



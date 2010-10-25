Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758515Ab0JYXkc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 19:40:32 -0400
Received: from bld-mail15.adl6.internode.on.net ([150.101.137.100]:50193 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757170Ab0JYXka (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 19:40:30 -0400
Date: Tue, 26 Oct 2010 10:40:26 +1100
From: Dave Chinner <david@fromorbit.com>
To: linux-kernel@vger.kernel.org
Subject: [bug 2.6.37-git] lockdep: invalid subclass in mousedev_create()
Message-ID: <20101025234026.GX32255@dastard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

Just got this booting a VM on a 2.6.37-git tree from a couple of days ago:

[    1.547497] BUG: looking up invalid subclass: 31
[    1.548238] turning off the locking correctness validator.
[    1.548923] Pid: 1, comm: swapper Not tainted 2.6.36-dgc+ #580
[    1.549637] Call Trace:
[    1.550024]  [<ffffffff810b88b0>] register_lock_class+0x540/0x550
[    1.550880]  [<ffffffff810baded>] ? trace_hardirqs_on+0xd/0x10
[    1.552001]  [<ffffffff810b8925>] ? lockdep_init_map+0x65/0x150
[    1.553564]  [<ffffffff810b8990>] lockdep_init_map+0xd0/0x150
[    1.554980]  [<ffffffff8197c7a7>] mousedev_create+0x247/0x2e0
[    1.556461]  [<ffffffff821af4ee>] ? mousedev_init+0x0/0x61
[    1.557857]  [<ffffffff821af50a>] mousedev_init+0x1c/0x61
[    1.559343]  [<ffffffff810001e3>] do_one_initcall+0x43/0x190
[    1.560724]  [<ffffffff8217a75d>] kernel_init+0x15d/0x1e7
[    1.562117]  [<ffffffff81037e64>] kernel_thread_helper+0x4/0x10
[    1.563693]  [<ffffffff81afe690>] ? restore_args+0x0/0x30
[    1.565150]  [<ffffffff8217a600>] ? kernel_init+0x0/0x1e7
[    1.566647]  [<ffffffff81037e60>] ? kernel_thread_helper+0x0/0x10

Looks like it does:

#define MOUSEDEV_MIX 31
....
	lockdep_set_subclass(&mousedev->mutex,
                             minor == MOUSEDEV_MIX ? MOUSEDEV_MIX : 0);

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com

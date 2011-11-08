Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab1KHIdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 03:33:52 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60093 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753682Ab1KHIdu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 03:33:50 -0500
Message-ID: <4EB8E969.6010502@suse.cz>
Date: Tue, 08 Nov 2011 09:33:45 +0100
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: "Rafael J. Wysocki" <rjw@suse.com>
CC: linux-pm@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Jiri Slaby <jirislaby@gmail.com>, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: khugepaged doesn't want to freeze
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

yesterday my machine refused to suspend several times. It was always due
to khugepaged refusing to freeze. It's with 3.1.0-next-20111025.

In the end, after several tries, it finally did. But it's indeed
bothering me.

PM: Syncing filesystems ... done.
PM: Preparing system for mem sleep
Freezing user space processes ... (elapsed 0.01 seconds) done.
Freezing remaining freezable tasks ...
Freezing of tasks failed after 20.01 seconds (1 tasks refusing to
freeze, wq_busy=0):
khugepaged      S 0000000000000001     0   634      2 0x00800000
 ffff8801c11cbc90 0000000000000046 0000000000000003 0000000000000000
 ffff8801c16f73e0 ffff8801c11cbfd8 ffff8801c11cbfd8 ffff8801c11cbfd8
 ffffffff81a0d020 ffff8801c16f73e0 ffff8801c11cbd08 0000000100000001
Call Trace:
 [<ffffffff8161e3aa>] schedule+0x3a/0x50
 [<ffffffff8161e83e>] schedule_timeout+0x14e/0x220
 [<ffffffff81079710>] ? init_timer_deferrable_key+0x20/0x20
 [<ffffffff8161e969>] schedule_timeout_interruptible+0x19/0x20
 [<ffffffff8110eda0>] khugepaged_alloc_hugepage+0xc0/0xf0
 [<ffffffff8108a0d0>] ? add_wait_queue+0x60/0x60
 [<ffffffff8110f455>] khugepaged+0x85/0x1280
 [<ffffffff8108a0d0>] ? add_wait_queue+0x60/0x60
 [<ffffffff8110f3d0>] ? collect_mm_slot+0xa0/0xa0
 [<ffffffff81089937>] kthread+0x87/0x90
 [<ffffffff81621834>] kernel_thread_helper+0x4/0x10
 [<ffffffff810898b0>] ? kthread_worker_fn+0x1a0/0x1a0
 [<ffffffff81621830>] ? gs_change+0xb/0xb

Restarting tasks ... done.

thanks,
-- 
js
suse labs

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab0EYGAO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 02:00:14 -0400
Received: from smtp.nokia.com ([192.100.122.230]:52924 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755225Ab0EYGAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 02:00:11 -0400
Subject: BUG: using smp_processor_id() in preemptible
From: Artem Bityutskiy <dedekind1@gmail.com>
Reply-To: dedekind1@gmail.com
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-fsdevel <linux-fsdevel@vger.kernel.org>,
       LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 25 May 2010 08:57:42 +0300
Message-ID: <1274767062.2106.6.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 25 May 2010 05:58:41.0988 (UTC) FILETIME=[5404C040:01CAFBCF]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I get tons of these debugging complaints with the latest Linus' tree:

BUG: using smp_processor_id() in preemptible [00000000] code: sync/2503
caller is dqstats_inc+0x19/0x2c
Pid: 2503, comm: sync Tainted: G      D     2.6.34-misc-2.6 #9
Call Trace:
 [<ffffffff811ad1a2>] debug_smp_processor_id+0xc2/0xdc
 [<ffffffff81134c7e>] dqstats_inc+0x19/0x2c
 [<ffffffff8113786e>] vfs_quota_sync+0x1bd/0x2a5
 [<ffffffff8111252b>] ? sync_one_sb+0x0/0x1d
 [<ffffffff811124e7>] __sync_filesystem+0x3a/0x7e
 [<ffffffff81112546>] sync_one_sb+0x1b/0x1d
 [<ffffffff810f4d70>] iterate_supers+0x6d/0xb2
 [<ffffffff81112477>] sync_filesystems+0x1b/0x1d
 [<ffffffff81112564>] sys_sync+0x1c/0x2e
 [<ffffffff81002a6b>] system_call_fastpath+0x16/0x1b

and git blame points to you.

-- 
Best Regards,
Artem Bityutskiy (Артём Битюцкий)


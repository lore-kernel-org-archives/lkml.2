Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876Ab2INNBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 09:01:30 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:40810 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753104Ab2INNBZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 09:01:25 -0400
From: "Justin Piszcz" <jpiszcz@lucidpixels.com>
To: <linux-kernel@vger.kernel.org>
Subject: kernel 3.4.0 (i686): pagevec_lookup_tag+0x21/0x30
Date: Fri, 14 Sep 2012 09:01:20 -0400
Message-ID: <013f01cd9279$0950c9c0$1bf25d40$@lucidpixels.com>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 14.0
Thread-Index: Ac2SeQYjqNyvYXYwT/u4n77N1Wf2OQ==
Content-Language: en-us
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Was curious why this occurs with postfix's cleanup every so often?

[562320.275125] INFO: task cleanup:5921 blocked for more than 120 seconds.
[562320.275127] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables
this message.
[562320.275129] cleanup         D 0000000d     0  5921   2437 0x00000000
[562320.275132]  f2986080 00000086 ca379ed4 0000000d 00000001 c16ca000
c1078521 0000000e
[562320.275137]  ca379edc ffffffff c106f3c6 00000001 0000000e 00000001
ce0a965c 00000000
[562320.275141]  f5a84070 00000003 00000001 f5a8406c 00000292 00000000
f5a84014 c1043c5e
[562320.275146] Call Trace:
[562320.275148]  [<c1078521>] ? pagevec_lookup_tag+0x21/0x30
[562320.275151]  [<c106f3c6>] ? filemap_fdatawait_range+0x86/0x140
[562320.275154]  [<c1043c5e>] ? __wake_up+0x3e/0x60
[562320.275156]  [<c103cead>] ? prepare_to_wait+0x1d/0x70
[562320.275159]  [<c113b6e5>] ? jbd2_log_wait_commit+0x95/0x100
[562320.275162]  [<c103d080>] ? abort_exclusive_wait+0x90/0x90
[562320.275164]  [<c11033cc>] ? ext4_sync_file+0x13c/0x2c0
[562320.275167]  [<c1097574>] ? chmod_common+0x74/0x90
[562320.275169]  [<c1099706>] ? vfs_write+0x106/0x140
[562320.275172]  [<c1103290>] ? ext4_flush_completed_IO+0x90/0x90
[562320.275175]  [<c10bae6b>] ? vfs_fsync+0x2b/0x40
[562320.275177]  [<c10bb190>] ? sys_fsync+0x20/0x40
[562320.275180]  [<c14de410>] ? sysenter_do_call+0x12/0x26

Justin.


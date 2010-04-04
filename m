Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752176Ab0DDILF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Apr 2010 04:11:05 -0400
Received: from ns.dcl.info.waseda.ac.jp ([133.9.216.194]:55363 "EHLO
	ns.dcl.info.waseda.ac.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751537Ab0DDILA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Apr 2010 04:11:00 -0400
Message-ID: <4BB84991.5080301@dcl.info.waseda.ac.jp>
Date: Sun, 04 Apr 2010 17:10:57 +0900
From: Hitoshi Mitake <mitake@dcl.info.waseda.ac.jp>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.5) Gecko/20091211 Shredder/3.0
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@redhat.com>
CC: Ingo Molnar <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Floating point exception by perf record
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Arnaldo,

I suffered a mysterious floating point exception when executing perf
on current tip/master.

For example,

% sudo ./perf lock record ./perf bench sched messaging
# Running sched/messaging benchmark...
# 20 sender and receiver processes per group
# 10 groups == 400 processes run

      Total time: 1.375 [sec]
[ perf record: Woken up 0 times to write data ]
[ perf record: Captured and wrote 160.002 MB perf.data (~6990599 samples) ]
[1]    26348 floating point exception  sudo ./perf lock record ./perf 
bench sched messaging

dmesg says that

[10212.752490] perf[26348] trap divide error ip:7fade8564310 
sp:7fff46d926e8 error:0 in libnewt.so.0.52.2[7fade8556000+15000]

Example is of perf lock, but this is not a special phenomenon of perf lock,
other users of perf record, like perf sched, caused the same problem.

I found that this might be caused by the line 283 of perf.c

	if (fclose(stdout)) # <- closing stdout!
		die("close failed on standard output: %s", strerror(errno));

I don't know well about libnewt, do you know something like cause?

The version of libnewt I'm using is 0.52.2 (default of Debian lenny)

Thanks,
	Hitoshi

Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932968Ab2AFIBv (ORCPT <rfc822;list-kernel77@spinics.net>);
	Fri, 6 Jan 2012 03:01:51 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:59070 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754024Ab2AFIBs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jan 2012 03:01:48 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Fri, 06 Jan 2012 12:01:45 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f06aa69274cf6.26578607@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > >  > :) no problem. i hope for you can recreate the issue consistently ,
 > >  > can you please test with the attached patch and another debug patch.
 >>  > please let me know if there is no panic but there are warnings (or)
 >if
 > >  > there are no warnings (or) the issue still appears(also the trace
 > >  > thanks) , also if you need any help
 > > Should I apply the patch to Linux 3.2-rc7 or 3.2 release?
 >Oh, I see. 3.2 release has this fix already. I will build it with 
debugging
 > patch and report warnings now.

I have some unpleasant news: it looks like it takes slightly longer with the 
fix, but the crash still managed to occur with 3.2 and I lack ESP to check 
for warnings immediately before that. I thought that 8 hours is enough 
testing, heh. It simply took 9 and a half under nigh-ideal conditions 
(stable signal from fixed AP with notebook also steadily in one place).

Good news is that I remembered to decrease console font size before the 
crash. So now I could see that the long stack trace was just a decoy to 
ensure that the first Oops scrolls too far up. I now have photos of the 
first one, too.

Process: kworker/u:2 (pid: 1419, threadinfo ffff88013dc38000, task 
ffff8800891020d0)
Stack:
  ffff88013dc39c10 ffff880136111ae0 ffff880136110460 0000000000000040
  ffff880136114000 0000000000000000 ffff88013dc39d20 ffffffffa0560a35
  0000000000000001 0000000000000202 ffff8801361140f0 ffff88013ed3ea48
Call trace:
  ath9k_config+0x115/0x780 [ath9k]
  ? queue_work+0x1a/0x20
  ? queue_delayed_work+0x25/0x30
  ? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
  ? ath9k_flush+0x155/0x1d0 [ath9k]
  ieee80211_hw_config+0xe2/0x160 [mac80211]
  ieee80211_scan_work+0x243/0x5c0 [mac80211]
  ? __schedule+0x2d7/0x7b0
  ? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
  process_one_work+0x111/0x390

Only after this happens "unable to complete kernel paging request" in 
ath_update_survey_stats
  worker_thread+0x162/0x340
  ? manage_workers.clone.26+0x240/0x240
  kthread+0x96/0xa0
  kernel_thread_helper+0x4/0x10
  ? kthread_worker_fn+0x190/0x190
  ? gs_change+0x13/0x13



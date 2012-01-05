Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751869Ab2AEG7e (ORCPT <rfc822;list-kernel77@spinics.net>);
	Thu, 5 Jan 2012 01:59:34 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:38605 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750904Ab2AEG7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 01:59:32 -0500
To: =?koi8-r?B?TW9oYW1tZWQgU2hhZmk=?= <shafi.wireless@gmail.com>,
        =?koi8-r?B?Sm9obiBXLiBMaW52aWxsZQ==?= <linville@tuxdriver.com>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
CC: linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: =?koi8-r?B?UmU6IGF0aDlrIGNyYXNoIDMuMi1yYzc=?=
Date: Thu, 05 Jan 2012 10:59:29 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.178.216.22
Message-ID: <NEXT-4f054a51a74772.60877329@nextmail.ru>
Mime-Version: 1.0
Content-type: text/plain;
	 charset="koi8-r"
Content-transfer-encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 > Hi John,

I am the stupid original submitter who only sent this to linux-kernel 
initially.
 
 > we will take a look at this.
 > 
 > i can later come up with few debug patches to narrow down the panic.
 > looks like a problem in ath_update_survey_stats(survey pointer). full
 > stack trace will be helpful
 > thanks.
 
What I have posted is the full call trace. Right above this is the stack 
trace in hex:

Process kworker/u:2 (pid: 6668, threadinfo ffff880027cd4000, task 
ffff880076a38000)
Stack:
  ffff880027cd5808 ffffffff81064830 ffff880027cd5808 ffff880147c51c80
  ffff880027cd58b8 ffffffff8135a117 ffff880076a38620 0000000000011c80
  0000000000011c80 ffff880076a38000 0000000000011c80 ffff880027cd5fd8

Currently I have booted Linux 3.0 kernel to check whether the problem is 
already there. Unfortunately, with Linux 3.1 and 3.0 I often get the 
following in dmesg (this is at module load; sometimes the driver just stops 
working - then I get this on reloading the module):

ath9k 0000:03:00.0: enabling device (0000 -> 0002)
ath9k 0000:03:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
ath9k 0000:03:00.0: setting latency timer to 64
ath9k 0000:03:00.0: Failed to initialize device
ath9k 0000:03:00.0: PCI INT A disabled
ath9k: probe of 0000:03:00.0 failed with error -5

As far as I understood, some similar problem was fixed after Linux 3.1. 

 > >> My card is (as lspci says):
 > >>
 > >> 03:00.0 Network controller: Atheros Communications Inc. AR9285 
Wireless
 > >> Network Adapter (PCI-Express) (rev 01)
 > >> š š š š Subsystem: Device 1a3b:1089

 > >> wq_worker_sleeping+0x10/0xa0
 > >> __schedule+0x427/0x7b0
 > >> ? call_rcu_sched+0x10/0x20
 > >> schedule+0x3a/0x50
 > >> do_exit+0x57c/0x840
 > >> ? kmsg_dump+0x45/0xe0
 > >> oops_end+0xa5/0xf0
 > >> no_context+0xf2/0x270
 > >> __bad_area_no_semaphore+0xe/0x10
 > >> do_page_fault+0x2ba/0x450
 > >> ? up+0x2d/0x50
 > >> ? console_unlock+0x1df/0x250
 > >> ? select_task_rq_fair+0x5be/0x970
 > >> page_fault+0x25/0x30
 > >> ? ath_update_survey_stats+0xb7/0x1c0 [ath9k]
 > >> ath9k_config+0x115/0x780 [ath9k]
 > >> ? queue_work+0x1a/0x20
 > >> ? queue_delayed_work+0x25/0x30
 > >> ? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
 > >> ? ath9k_flush+0x155/0x1d0 [ath9k]
 > >> ieee80211_hw_config+0xe2/0x160 [mac80211]
 > >> ieee80211_scan_work+0x243/0x5c0 [mac80211]
 > >> ? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
 > >> process_one_work+0x111/0x390
 > >> worker_thread+0x162/0x340
 > >> manage_workers.clone.26+0x240/0x240
 > >> kthread+0x96/0xa0
 > >> kernel_thread_helper+0x4/0x10
 > >> ? kthread_worker_fn+0x190/0x190
 > >> ? gs_change+0x13/0x13



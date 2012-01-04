Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756979Ab2ADVYz (ORCPT <rfc822;list-kernel77@spinics.net>);
	Wed, 4 Jan 2012 16:24:55 -0500
Received: from h118.nextmail.ru ([194.67.36.118]:37022 "EHLO h118.nextmail.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756952Ab2ADVYw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 16:24:52 -0500
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Wed, 04 Jan 2012 16:24:51 EST
To: <linux-kernel@vger.kernel.org>
From: =?koi8-r?B?TVI=?= <g7af0ec1e3ea1e7b1@nextmail.ru>
Subject: =?koi8-r?B?YXRoOWsgY3Jhc2ggMy4yLXJjNw==?=
Date: Thu, 05 Jan 2012 01:18:09 +0400
X-Mailer: NextMail.Ru
X-RemoteAddr: 195.91.224.225
Message-ID: <NEXT-4f04c2111e5f83.17805410@nextmail.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I have noticed a complete crash (forced switch to console and Alt-SysRq-B 
doesn't work) when I use ath9k driver for my WiFi card. The problem is that 
the crash occurs after a few hours of use, so blind bissecting doesn't look 
like a short-term plan.

My card is (as lspci says):

03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless 
Network Adapter (PCI-Express) (rev 01)
        Subsystem: Device 1a3b:1089
        Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- ParErr- 
Stepping- SERR- FastB2B- DisINTx-
        Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
        Latency: 0, Cache Line Size: 64 bytes
        Interrupt: pin A routed to IRQ 17
        Region 0: Memory at d7400000 (64-bit, non-prefetchable) [size=64K]

I use an Asus N53JN notebook, if that matters.

I have photos of two instances of the crash. The backtrace goes as follows (I 
typed this in, so maybe there is a typo somewhere - I hope there is none, 
though):

wq_worker_sleeping+0x10/0xa0
__schedule+0x427/0x7b0
? call_rcu_sched+0x10/0x20
schedule+0x3a/0x50
do_exit+0x57c/0x840
? kmsg_dump+0x45/0xe0
oops_end+0xa5/0xf0
no_context+0xf2/0x270
__bad_area_no_semaphore+0xe/0x10
do_page_fault+0x2ba/0x450
? up+0x2d/0x50
? console_unlock+0x1df/0x250
? select_task_rq_fair+0x5be/0x970
page_fault+0x25/0x30
? ath_update_survey_stats+0xb7/0x1c0 [ath9k]
ath9k_config+0x115/0x780 [ath9k]
? queue_work+0x1a/0x20
? queue_delayed_work+0x25/0x30
? ieee80211_queue_delayed_work+0x46/0x60 [mac80211]
? ath9k_flush+0x155/0x1d0 [ath9k]
ieee80211_hw_config+0xe2/0x160 [mac80211]
ieee80211_scan_work+0x243/0x5c0 [mac80211]
? ieee80211_scan_rx+0x1c0/0x1c0 [mac80211]
process_one_work+0x111/0x390
worker_thread+0x162/0x340
manage_workers.clone.26+0x240/0x240
kthread+0x96/0xa0
kernel_thread_helper+0x4/0x10
? kthread_worker_fn+0x190/0x190
? gs_change+0x13/0x13





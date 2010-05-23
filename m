Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754317Ab0EWRHN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 13:07:13 -0400
Received: from mail-qy0-f183.google.com ([209.85.221.183]:39321 "EHLO
	mail-qy0-f183.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753817Ab0EWRHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 13:07:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:subject:message-id:mime-version
         :content-type;
        b=vj/jGzqL+egvciMWiowotoq/Sbz7K9wfnPy5hggjgsMkGLZXrwcM4G78rHLif3mYr7
         N2yvWum/3Pv4H71Iy5n1gSeYDB8bG9HLC4tdxBsN/rcYu1bxoe7oqHKHgVRp3pRFYVQX
         +NQTSrILA9gfIK6Y0twvJPyhtm9qxqVNhr5zs=
Date: Mon, 24 May 2010 01:07:13 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Johannes Berg <johannes.berg@intel.com>,
       Arjan van de Ven <arjan@linux.intel.com>,
       "johnstul@us.ibm.com" <johnstul@us.ibm.com>,
       Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
       Thomas Gleixner <tglx@linutronix.de>,
       Intel Linux Wireless <ilw@linux.intel.com>,
       "John W. Linville" <linville@tuxdriver.com>,
       Frans Pop <elendil@planet.nl>,
       ", Chatre, Reinette" <reinette.chatre@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       lkml <linux-kernel@vger.kernel.org>
Subject: Re: Wireless IBSS on Linux-2.6.34 broken by commit
 3bbb9ec946428b96657126768f65487a48dd090c
Message-ID: <Pine.LNX.4.64.1005240053470.2649@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Sun, May 23, 2010 at 5:49 PM, Johannes Berg <johannes.berg@intel.com> 
wrote:
> On Sun, 2010-05-23 at 05:58 +0100, Jeff Chua wrote:
>> Wireless IBSS on Linux-2.6.34 is broken. Reverting commit
>> 3bbb9ec946428b96657126768f65487a48dd090c makes it work again. This was
>> tested by bisecting the kernel.


Arjan, Johannes,

Here's the demsg with debug enabled ...


1) with bad commit reverted ...

2010-05-23T21:24:23.656671+08:00 boston kernel: cfg80211: Calling CRDA to 
update world regulatory domain
2010-05-23T21:24:23.720182+08:00 boston kernel: iwlagn: Intel(R) Wireless 
WiFi Link AGN driver for Linux, in-tree:
2010-05-23T21:24:23.720211+08:00 boston kernel: iwlagn: Copyright(c) 
2003-2010 Intel Corporation
2010-05-23T21:24:23.720215+08:00 boston kernel: iwlagn 0000:02:00.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
2010-05-23T21:24:23.720218+08:00 boston kernel: iwlagn 0000:02:00.0: 
setting latency timer to 64
2010-05-23T21:24:23.720222+08:00 boston kernel: iwlagn 0000:02:00.0: 
Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
2010-05-23T21:24:23.732171+08:00 boston kernel: iwlagn 0000:02:00.0: 
Tunable channels: 13 802.11bg, 24 802.11a channels
2010-05-23T21:24:23.732181+08:00 boston kernel: iwlagn 0000:02:00.0: irq 
46 for MSI/MSI-X
2010-05-23T21:24:23.820182+08:00 boston kernel: iwlagn 0000:02:00.0: 
loaded firmware version 9.193.4.1 build 19710
2010-05-23T21:24:23.848169+08:00 boston kernel: phy0: Selected rate 
control algorithm 'iwl-agn-rs'
2010-05-23T21:24:24.335667+08:00 boston kernel: phy0: device now idle
2010-05-23T21:24:24.340162+08:00 boston kernel: phy0: device no longer 
idle - in use
2010-05-23T21:24:24.384668+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:24.384678+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:24.384682+08:00 boston kernel: wlan0: Trigger new scan to 
find an IBSS to join
2010-05-23T21:24:24.400170+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:24.400187+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:26.687669+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:26.687691+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:26.687695+08:00 boston kernel: wlan0: Trigger new scan to 
find an IBSS to join
2010-05-23T21:24:26.707658+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:26.707666+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:28.703660+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:28.703668+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:30.703668+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:30.703687+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:30.703691+08:00 boston kernel: wlan0: Trigger new scan to 
find an IBSS to join
2010-05-23T21:24:30.723659+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:30.723666+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:32.703664+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:24:32.703675+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:24:32.703679+08:00 boston kernel: wlan0: Creating new IBSS 
network, BSSID 06:a5:c6:42:20:80
2010-05-23T21:24:32.712163+08:00 boston kernel: iwlagn 0000:02:00.0: 
Unable to find TIM Element in beacon
2010-05-23T21:24:32.712172+08:00 boston kernel: iwlagn 0000:02:00.0: 
Unable to find TIM Element in beacon



2) Still with bad-commit in the kernel

2010-05-23T21:47:28.498041+08:00 boston kernel: cfg80211: Calling CRDA to 
update world regulatory domain
2010-05-23T21:47:28.535052+08:00 boston kernel: iwlagn: Intel(R) Wireless 
WiFi Link AGN driver for Linux, in-tree:
2010-05-23T21:47:28.535078+08:00 boston kernel: iwlagn: Copyright(c) 
2003-2010 Intel Corporation
2010-05-23T21:47:28.535082+08:00 boston kernel: iwlagn 0000:02:00.0: PCI 
INT A -> GSI 16 (level, low) -> IRQ 16
2010-05-23T21:47:28.535085+08:00 boston kernel: iwlagn 0000:02:00.0: 
setting latency timer to 64
2010-05-23T21:47:28.535089+08:00 boston kernel: iwlagn 0000:02:00.0: 
Detected Intel(R) Centrino(R) Advanced-N 6200 AGN, REV=0x74
2010-05-23T21:47:28.551036+08:00 boston kernel: iwlagn 0000:02:00.0: 
Tunable channels: 13 802.11bg, 24 802.11a channels
2010-05-23T21:47:28.551048+08:00 boston kernel: iwlagn 0000:02:00.0: irq 
46 for MSI/MSI-X
2010-05-23T21:47:28.571054+08:00 boston kernel: iwlagn 0000:02:00.0: 
loaded firmware version 9.193.4.1 build 19710
2010-05-23T21:47:28.574286+08:00 boston kernel: phy0: Selected rate 
control algorithm 'iwl-agn-rs'
2010-05-23T21:47:29.406045+08:00 boston kernel: phy0: device now idle
2010-05-23T21:47:29.413564+08:00 boston kernel: phy0: device no longer 
idle - in use
2010-05-23T21:47:29.486081+08:00 boston kernel: wlan0: sta_find_ibss 
(active_ibss=0)
2010-05-23T21:47:29.486099+08:00 boston kernel:   did not try to join ibss
2010-05-23T21:47:29.486103+08:00 boston kernel: wlan0: Trigger new scan to 
find an IBSS to join



So, the difference are these messages when it's working ...

wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: Trigger new scan to find an IBSS to join
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: Trigger new scan to find an IBSS to join
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: Trigger new scan to find an IBSS to join
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: sta_find_ibss (active_ibss=0)
     did not try to join ibss
wlan0: Creating new IBSS network, BSSID 62:c8:0e:ff:7e:69
iwlagn 0000:02:00.0: Unable to find TIM Element in beacon
iwlagn 0000:02:00.0: Unable to find TIM Element in beacon



I modified one line in the bad commit to set the default "timer->slack = 
0" and that fixed the problem of IBSS not working. Below is the patch.

I don't know how this impacts others, but it seems better to default to 
the previous behavior rather than introducing "slacks" that other 
subsystems are not just ready to handle.


Thanks,
Jeff

diff --git a/kernel/timer.c b/kernel/timer.c
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -549,7 +567,7 @@ static void __init_timer(struct timer_list *timer,
   {
   	timer->entry.next = NULL;
   	timer->base = __raw_get_cpu_var(tvec_bases);
-	timer->slack = -1;
+	timer->slack = 0;
   #ifdef CONFIG_TIMER_STATS
   	timer->start_site = NULL;
   	timer->start_pid = -1;

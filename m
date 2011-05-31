Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab1EaRZB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 13:25:01 -0400
Received: from lo.gmane.org ([80.91.229.12]:44160 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757794Ab1EaRY7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 13:24:59 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Tim Blechmann <tim@klingt.org>
Subject: [3.0-rc1] nouveau lockup
Followup-To: gmane.linux.kernel
Date: Tue, 31 May 2011 19:24:45 +0200
Message-ID: <is388t$ji2$1@dough.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 85-127-90-20.dynamic.xdsl-line.inode.at
User-Agent: KNode/4.4.10
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

running 3.0-rc1, i experienced a lockup of my machine, which is related to
nouveau:

after using chromium for some time, the x server crashed and the machine was
hardly responding any more: however i was able to log into the terminal, and 
dump the system log, which tells me:

[15993.183701] [drm] nouveau 0000:02:00.0: PGRAPH - DATA_ERROR INVALID_ENUM
[15993.183706] [drm] nouveau 0000:02:00.0: PGRAPH - DATA_ERROR
[15993.183710] [drm] nouveau 0000:02:00.0: PGRAPH - ch 5 (0x000d510000) subc 6 class 0x502d mthd 0x17b0 data 0x00000000
[15993.183717] [drm] nouveau 0000:02:00.0: PGRAPH - DATA_ERROR INVALID_VALUE
[15993.183719] [drm] nouveau 0000:02:00.0: PGRAPH - DATA_ERROR
[15993.183722] [drm] nouveau 0000:02:00.0: PGRAPH - ch 5 (0x000d510000) subc 6 class 0x502d mthd 0x1420 data 0x00000000
[16000.923008] [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_CCACHE FAULT
[16000.923019] [drm] nouveau 0000:02:00.0: PGRAPH - TRAP_CCACHE 00000080 00000000 00000000 00000000 00000000 00000004 00080000
[16000.923021] [drm] nouveau 0000:02:00.0: PGRAPH - TRAP
[16000.923024] [drm] nouveau 0000:02:00.0: PGRAPH - ch 2 (0x0000a30000) subc 5 class 0x8297 mthd 0x0f04 data 0x00000000
[16000.923033] [drm] nouveau 0000:02:00.0: VM: trapped read at 0x002000f000 on ch 2 [0x00000a30] PFIFO/PFIFO_READ/SEMAPHORE reason: DMAOBJ_LIMIT
[16002.548678] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16004.169350] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16005.790022] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16007.410696] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16008.325449] ieee80211 phy0: wlan%d: No probe response from AP 00:24:fe:09:94:18 after 500ms, disconnecting.
[16009.031369] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16010.652040] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16012.272712] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16013.893383] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16015.514054] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16017.134725] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16018.755396] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16020.376068] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16021.996740] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16023.617414] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16023.620766] cfg80211: All devices are disconnected, going to restore regulatory settings
[16023.620770] cfg80211: Restoring regulatory settings
[16023.620774] cfg80211: Calling CRDA to update world regulatory domain
[16025.238086] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16025.244737] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
[16025.244740] cfg80211: 2402000 KHz - 2472000 KHz @  KHz), (300 mBi, 2000 mBm)
[16025.244742] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
[snip some cfg80211 messages]
[16026.858760] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16028.479433] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16030.100105] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16031.720776] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16033.341447] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16034.962120] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16036.582792] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16038.203464] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16039.824138] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16041.444812] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16043.065484] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16044.686332] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16046.307463] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16046.525924] [drm] nouveau 0000:02:00.0: GPU lockup - switching to software fbcon
[16048.150234] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16049.772210] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16050.165951] wlan%d: authenticate with 00:24:fe:09:94:18 (try 1)
[16050.167354] wlan%d: authenticated
[16050.167372] wlan%d: associate with 00:24:fe:09:94:18 (try 1)
[16050.169528] wlan%d: RX AssocResp from 00:24:fe:09:94:18 (capab=0x401 status=0 aid=1)
[16050.169530] wlan%d: associated
[16056.681585] chromium-browse[16337]: segfault at 0 ip 00007fe3c275e240 sp 00007fe3b46336c0 error 6 in chromium-browser[7fe3c1bd7000+35cf000]
[16059.685075] [drm] nouveau 0000:02:00.0: Failed to idle channel 5.
[16061.305839] [drm] nouveau 0000:02:00.0: Ctxprog is still running
[16062.926967] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16064.547681] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16066.168397] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16067.789110] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16069.409824] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000
[16071.030538] [drm] nouveau 0000:02:00.0: PGRAPH TLB flush idle timeout fail: 0x00000701 0x00000009 0x00000000 0x00000000

... continuing until i reboot the machine ...

tim

-- 
tim@klingt.org
http://tim.klingt.org

You can play a shoestring if you're sincere
  John Coltrane



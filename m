Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757298Ab2DIV0N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 17:26:13 -0400
Received: from serv04.lahn.de ([213.239.197.57]:59654 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750940Ab2DIV0K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 17:26:10 -0400
Date: Mon, 9 Apr 2012 23:21:27 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Sujith Manoharan <c_manoha@qca.qualcomm.com>
Cc: Ben Greear <greearb@candelatech.com>,
        Kelly Anderson <kelly@silka.with-linux.com>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <casteyde.christian@free.fr>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: [ath9k-devel] 3.4-rc ath9k regression (Re: 3.3.1 ath9k
 regression)
Message-ID: <20120409232127.41c698d1@xenia.leun.net>
In-Reply-To: <20355.13473.382563.281929@gargle.gargle.HOWL>
References: <4F7A8EB7.4060200@silka.with-linux.com>
	<4F7A923D.5000002@candelatech.com>
	<CAD2nsn0vKPEOFp08WGYAGh0vEHPbShP4yMo5HzEGc8SrTmTZmQ@mail.gmail.com>
	<4F7A9D5C.8040402@silka.with-linux.com>
	<CAD2nsn2ONstURLWBSPkNrDfFOeePWMWGQeGrEUkU3Wh4kUo+sg@mail.gmail.com>
	<4F7AAAD9.2040307@silka.with-linux.com>
	<CAD2nsn0G8_vDQug-u=4PRWMwRLPX-zp1z0X5gOVNaxk=V+daWw@mail.gmail.com>
	<CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
	<4F7AB6FE.3080009@silka.with-linux.com>
	<20120403200306.0afbb48b@xenia.leun.net>
	<CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
	<CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
	<20120404235104.682cfad3@xenia.leun.net>
	<4F7DE3A4.1040705@candelatech.com>
	<CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
	<4F7F52BD.7060906@candelatech.com>
	<20120409010816.36244f17@xenia.leun.net>
	<20355.13473.382563.281929@gargle.gargle.HOWL>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Apr 2012 00:42:33 +0530
Sujith Manoharan <c_manoha@qca.qualcomm.com> wrote:

> Michael Leun wrote:
> > After an suspend to disk / resume cycle (in kernel suspend to disk,
> > openSuSE) with 3.4-rc2 my ath9k wireless does not ping
> > anymore.
> > 
> > Output of iwconfig wlan0 looks just as usual (associated to AP).
> > 
> > iwconfig wlan0 essid <myssid> fixes this (causes an
> > deauthenticate/authenticate with AP) - then connectivity is there
> > again.
> > 
> > Guess what: "Of course" does not happen when reverting
> > c1afdaff90538ef085b756454f12b29575411214 ath9k: fix going to
> > full-sleep on PS idle.
> > 
> > So, in my opinion it should be seriously considered to revert that
> > patch until it is fully understood what is going on and why.
> > 
> > It may look theoretically correct (I've no knowledge that would
> > enable me assess that), but it seems to have caused 3 more or less
> > different problems to various people.
> 
> The patch in question should just be reverted for 3.3.1-stable. It
> would mean that power-saving would take a hit on that kernel - but
> it's impact would be much lesser than a broken driver, one that fails
> in basic connection. I'll send a patch reverting
> c1afdaff90538ef085b756454f12b29575411214.
> 
> For 3.4, can you build the driver with debugging enabled [1] , load
> the driver with debug=0x801 and post the log here (before/after
> resume) ?
> 
> Thanks.
> 
> [1] : http://linuxwireless.org/en/users/Drivers/ath9k/debug

I've randomly thrown away a few messages not related to wireless (for
example the USB stuff - for some other reason I unload and reload some
modules) but left some others. But all messages related to hibernate
and net/wireless/ath should be there.

After 

[...]
Apr  9 22:58:01 jill kernel: [  908.592792] Restarting tasks ... done.
Apr  9 22:58:02 jill kernel: [  910.037065] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:02 jill kernel: [  910.045038] ath: phy4: NETWORK SLEEP -> AWAKE
[...]

it does NOT ping.

Here the whole thing:

Apr  9 22:55:16 jill kernel: [  870.273741] ath: phy4: UNDEFINED -> AWAKE
Apr  9 22:55:16 jill kernel: [  870.273805] ath: phy4: serialize_regmode is 0
Apr  9 22:55:16 jill kernel: [  870.708733] ath: EEPROM regdomain: 0x37
Apr  9 22:55:16 jill kernel: [  870.708737] ath: EEPROM indicates we should expect a direct regpair map
Apr  9 22:55:16 jill kernel: [  870.708742] ath: Country alpha2 being used: AW
Apr  9 22:55:16 jill kernel: [  870.708744] ath: Regpair used: 0x37
Apr  9 22:55:16 jill kernel: [  870.715655] ieee80211 phy4: Selected rate control algorithm 'ath9k_rate_control'
Apr  9 22:55:16 jill kernel: [  870.716080] cfg80211: Calling CRDA for country: AW
Apr  9 22:55:16 jill kernel: [  870.717590] Registered led device: ath9k-phy4
Apr  9 22:55:16 jill kernel: [  870.717603] ieee80211 phy4: Atheros AR9280 Rev:2 mem=0xffffc90004140000, irq=19
Apr  9 22:55:16 jill kernel: [  870.724795] cfg80211: Regulatory domain changed to country: AW
Apr  9 22:55:16 jill kernel: [  870.724801] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr  9 22:55:16 jill kernel: [  870.724806] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr  9 22:55:16 jill kernel: [  870.724810] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr  9 22:55:16 jill kernel: [  870.724815] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr  9 22:55:16 jill kernel: [  870.724819] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Apr  9 22:55:16 jill ifup[8452]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr  9 22:55:16 jill ifup[8452]:     wlan0     is controlled by ifplugd
Apr  9 22:55:17 jill ifup[8543]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr  9 22:55:17 jill ifup-wireless[8593]:     wlan0     starting wpa_supplicant
Apr  9 22:55:17 jill kernel: [  871.146283] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.149338] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.154201] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.156663] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.156701] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.158631] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Apr  9 22:55:17 jill kernel: [  871.159532] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.159545] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.162356] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.179036] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.182565] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.193210] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.199519] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.267646] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.271171] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:55:17 jill kernel: [  871.271185] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:55:17 jill kernel: [  871.278884] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.347901] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.414962] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.481936] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.548958] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.615907] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.682932] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.749943] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.816964] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.883871] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:17 jill kernel: [  871.950972] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.017952] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.084934] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.151891] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.218985] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.285961] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.352933] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.419903] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.551955] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.683957] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.816933] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:18 jill kernel: [  872.948940] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.081955] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.213956] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.346933] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.478944] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.611926] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.743959] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:19 jill kernel: [  873.875908] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.007970] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.139979] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.272918] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.400602] wlan0: authenticate with xx:xx:xx:xx:xx:xx
Apr  9 22:55:20 jill kernel: [  874.404947] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.412935] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.415355] wlan0: send auth to xx:xx:xx:xx:xx:xx (try 1/3)
Apr  9 22:55:20 jill kernel: [  874.417776] wlan0: authenticated
Apr  9 22:55:20 jill kernel: [  874.422721] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.426127] wlan0: associate with xx:xx:xx:xx:xx:xx (try 1/3)
Apr  9 22:55:20 jill kernel: [  874.429756] wlan0: RX AssocResp from xx:xx:xx:xx:xx:xx (capab=0x411 status=0 aid=2)
Apr  9 22:55:20 jill kernel: [  874.429763] wlan0: associated
Apr  9 22:55:20 jill kernel: [  874.434527] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.436698] ath: phy4: ah->misc_mode 0x4
Apr  9 22:55:20 jill kernel: [  874.438676] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Apr  9 22:55:20 jill kernel: [  874.438743] cfg80211: Calling CRDA for country: DE
Apr  9 22:55:20 jill kernel: [  874.440595] ath: phy4: Reconfigure Beacon timers based on timestamp from the AP
Apr  9 22:55:20 jill kernel: [  874.444587] cfg80211: Regulatory domain changed to country: DE
Apr  9 22:55:20 jill kernel: [  874.444593] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr  9 22:55:20 jill kernel: [  874.444599] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr  9 22:55:20 jill kernel: [  874.444604] cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr  9 22:55:20 jill kernel: [  874.444609] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Apr  9 22:55:31 jill kernel: [  885.202090] wlan0: no IPv6 routers present
Apr  9 22:58:01 jill kernel: [  904.687949] Syncing filesystems ... done.
Apr  9 22:58:01 jill kernel: [  904.691672] Freezing user space processes ... (elapsed 0.01 seconds) done.
Apr  9 22:58:01 jill kernel: [  904.704662] PM: Preallocating image memory... done (allocated 228541 pages)
Apr  9 22:58:01 jill kernel: [  905.063030] PM: Allocated 914164 kbytes in 0.35 seconds (2611.89 MB/s)
Apr  9 22:58:01 jill kernel: [  905.063035] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Apr  9 22:58:01 jill kernel: [  905.074634] Suspending console(s) (use no_console_suspend to debug)
Apr  9 22:58:01 jill kernel: [  905.079525] ath: phy4: ah->misc_mode 0x4
Apr  9 22:58:01 jill kernel: [  905.081590] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:58:01 jill kernel: [  905.082371] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:58:01 jill kernel: [  905.085376] ath: phy4: AWAKE -> FULL-SLEEP
Apr  9 22:58:01 jill kernel: [  905.285278] ACPI handle has no context!
Apr  9 22:58:01 jill kernel: [  905.387111] ata6: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  905.389107] ata5: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  905.391137] ata2: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  905.402321] PM: freeze of devices complete after 327.678 msecs
Apr  9 22:58:01 jill kernel: [  905.402482] PM: late freeze of devices complete after 0.154 msecs
Apr  9 22:58:01 jill kernel: [  905.403254] PM: noirq freeze of devices complete after 0.766 msecs
Apr  9 22:58:01 jill kernel: [  905.403695] ACPI: Preparing to enter system sleep state S4
Apr  9 22:58:01 jill kernel: [  905.408152] PM: Saving platform NVS memory
Apr  9 22:58:01 jill kernel: [  905.409898] Disabling non-boot CPUs ...
Apr  9 22:58:01 jill kernel: [  905.411486] CPU 1 is now offline
Apr  9 22:58:01 jill kernel: [  905.412216] PM: Creating hibernation image:
Apr  9 22:58:01 jill kernel: [  905.413016] PM: Need to copy 228222 pages
Apr  9 22:58:01 jill kernel: [  905.413016] PM: Restoring platform NVS memory
Apr  9 22:58:01 jill kernel: [  905.413016] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
Apr  9 22:58:01 jill kernel: [  905.422060] Enabling non-boot CPUs ...
Apr  9 22:58:01 jill kernel: [  905.424272] Booting Node 0 Processor 1 APIC 0x1
Apr  9 22:58:01 jill kernel: [  905.436926] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
Apr  9 22:58:01 jill kernel: [  905.447043] CPU1 is up
Apr  9 22:58:01 jill kernel: [  905.449521] ACPI: Waking up from system sleep state S4
Apr  9 22:58:01 jill kernel: [  905.485551] PM: noirq restore of devices complete after 31.294 msecs
Apr  9 22:58:01 jill kernel: [  905.485703] PM: early restore of devices complete after 0.109 msecs
Apr  9 22:58:01 jill kernel: [  905.616864] pci 0000:00:1e.0: setting latency timer to 64
Apr  9 22:58:01 jill kernel: [  905.616881] ahci 0000:00:1f.2: setting latency timer to 64
Apr  9 22:58:01 jill kernel: [  905.923137] ata2: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  905.924135] ata6: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  905.925132] ata5: SATA link down (SStatus 0 SControl 300)
Apr  9 22:58:01 jill kernel: [  906.077052] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr  9 22:58:01 jill kernel: [  906.089698] ata1.00: configured for UDMA/133
Apr  9 22:58:01 jill kernel: [  906.100104] sd 0:0:0:0: [sda] Starting disk
Apr  9 22:58:01 jill kernel: [  908.526367] ath: phy4: FULL-SLEEP -> AWAKE
Apr  9 22:58:01 jill kernel: [  908.534440] ath: phy4: ah->misc_mode 0x4
Apr  9 22:58:01 jill kernel: [  908.536945] ath: phy4: ah->misc_mode 0x4
Apr  9 22:58:01 jill kernel: [  908.541672] ath: phy4: ah->misc_mode 0x4
Apr  9 22:58:01 jill kernel: [  908.543667] ath: phy4: ah->misc_mode 0x4
Apr  9 22:58:01 jill kernel: [  908.543845] PM: restore of devices complete after 2931.774 msecs
Apr  9 22:58:01 jill kernel: [  908.592610] Restarting kernel threads ... done.
Apr  9 22:58:01 jill kernel: [  908.592792] Restarting tasks ... done.
Apr  9 22:58:02 jill kernel: [  910.037065] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:02 jill kernel: [  910.045038] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:02 jill kernel: [  910.050325] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:02 jill kernel: [  910.147433] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:02 jill kernel: [  910.152746] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:02 jill kernel: [  910.249893] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:02 jill kernel: [  910.255162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:02 jill kernel: [  910.352251] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:02 jill kernel: [  910.357535] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.454645] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.459954] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.557039] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.562404] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.659508] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.664804] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.761899] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.767163] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.864320] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.869597] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  910.966708] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  910.972001] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  911.069096] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  911.074395] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  911.171519] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  911.176800] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  911.273906] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  911.279161] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:03 jill kernel: [  911.376234] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:03 jill kernel: [  911.381535] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.478711] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.483997] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.581019] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.586343] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.683433] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.688747] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.785850] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.791164] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.888306] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.893597] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  911.990690] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  911.995997] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  912.093109] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  912.098398] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  912.195502] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  912.200800] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  912.297888] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  912.303166] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:04 jill kernel: [  912.400309] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:04 jill kernel: [  912.405592] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  912.502696] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  912.507991] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  912.605027] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  912.610395] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  912.707430] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  912.712731] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  912.809895] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  912.815166] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  912.912314] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  912.917593] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  913.014640] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  913.019996] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  913.117088] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  913.122392] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  913.219508] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  913.224796] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:05 jill kernel: [  913.321899] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:05 jill kernel: [  913.327161] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.424284] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.429591] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.526704] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.531989] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.629093] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.634394] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.712140] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.712223] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.731488] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.736793] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.833904] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.839129] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  913.936292] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  913.941535] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  914.038679] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  914.043931] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  914.141039] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  914.146392] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  914.243489] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  914.248791] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:06 jill kernel: [  914.345876] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:06 jill kernel: [  914.351162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.448295] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.453533] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.550662] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.555992] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.653108] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.658392] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.755493] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.760794] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.857842] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.863140] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  914.960304] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  914.965589] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  915.062634] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  915.067932] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  915.165011] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  915.170326] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  915.267501] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  915.272733] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:07 jill kernel: [  915.369889] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:07 jill kernel: [  915.375162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.472277] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.477584] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.574693] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.579988] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.677089] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.682386] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.779476] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.784788] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.881892] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.887163] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  915.984284] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  915.989591] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  916.086705] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  916.091988] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  916.189073] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  916.194381] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  916.291481] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  916.296785] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:08 jill kernel: [  916.393903] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:08 jill kernel: [  916.399164] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  916.496294] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  916.501531] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  916.598623] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  916.603984] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  916.701104] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  916.706384] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  916.803492] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  916.808784] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  916.905883] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  916.911162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  917.008297] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  917.013527] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  917.110687] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  917.115982] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  917.213077] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  917.218384] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:09 jill kernel: [  917.315495] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:09 jill kernel: [  917.320786] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.417881] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.423162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.520272] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.525582] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.622692] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.627979] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.632549] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.744211] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.827473] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.832780] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  917.929892] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  917.935163] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  918.032277] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  918.037579] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  918.134669] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  918.139975] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  918.237085] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  918.242376] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:10 jill kernel: [  918.339473] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:10 jill kernel: [  918.344782] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  918.441832] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  918.447163] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  918.544286] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  918.549579] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  918.646675] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  918.759230] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  918.851485] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  918.856783] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  918.953874] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  918.959168] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  919.056290] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  919.061573] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  919.158681] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  919.163977] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  919.261066] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  919.266377] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:11 jill kernel: [  919.363485] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:11 jill kernel: [  919.368775] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.465875] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.471162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.568267] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.573574] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.665100] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.665185] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.665219] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.772244] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.773066] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.778369] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.875463] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.880779] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  919.977882] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  919.983163] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  920.080271] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  920.085577] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  920.182690] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  920.187974] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  920.285079] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  920.290378] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:12 jill kernel: [  920.387467] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:12 jill kernel: [  920.392774] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.489886] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.495164] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.592279] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.597574] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.677102] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.677188] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.677221] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.779186] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.797089] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.802372] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  920.899475] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  920.904777] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  921.001865] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  921.007147] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  921.104285] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  921.109575] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  921.206672] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  921.211973] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  921.309059] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:13 jill kernel: [  921.314372] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:13 jill kernel: [  921.411476] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.416773] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  921.513871] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.519167] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  921.616290] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.621509] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  921.633473] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.741153] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  921.821068] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.826369] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  921.923487] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  921.928769] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  922.025875] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  922.031166] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  922.128267] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  922.133569] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  922.230685] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  922.235966] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:14 jill kernel: [  922.333071] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:14 jill kernel: [  922.338370] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.435460] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.440768] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.537883] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.543162] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.640269] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.747250] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.747819] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.747911] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.845079] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.850368] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  922.947467] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  922.952704] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  923.049857] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  923.055164] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  923.152275] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  923.157566] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  923.254663] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  923.259962] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:15 jill kernel: [  923.357084] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:15 jill kernel: [  923.362364] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.459471] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.464768] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.561863] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.567164] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.638172] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.740238] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.766672] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.771964] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.869059] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.874364] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  923.971479] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  923.976765] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  924.073868] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  924.079160] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  924.176221] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  924.181566] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  924.278675] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  924.283962] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:16 jill kernel: [  924.381063] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:16 jill kernel: [  924.386361] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.483458] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  924.488765] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.585875] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  924.591160] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.688227] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  924.693562] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.790652] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  924.795962] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.893072] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  924.898360] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  924.995462] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  925.000763] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  925.097849] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  925.103160] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  925.200268] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  925.205559] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  925.302657] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  925.307959] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:17 jill kernel: [  925.405075] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:17 jill kernel: [  925.410364] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  925.507467] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  925.512763] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  925.609856] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  925.615160] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  925.634475] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  925.736249] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  925.814667] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  925.819958] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  925.917051] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  925.922357] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  926.019472] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  926.024762] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  926.121862] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  926.127158] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  926.224213] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  926.229558] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:18 jill kernel: [  926.326670] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:18 jill kernel: [  926.331957] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  926.429063] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  926.434361] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  926.531449] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  926.536764] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  926.633870] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  926.738253] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  926.838645] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  926.843954] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  926.941065] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  926.946355] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  927.043454] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  927.048757] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  927.145875] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  927.151153] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  927.248225] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  927.253554] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:19 jill kernel: [  927.350651] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:19 jill kernel: [  927.355955] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.453078] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.458353] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.555458] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.560756] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.638141] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.740243] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.760270] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.765554] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.862658] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.867952] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  927.965045] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  927.970350] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  928.067464] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  928.072754] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  928.169856] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  928.175153] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  928.272205] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  928.277550] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:20 jill kernel: [  928.374664] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:20 jill kernel: [  928.379953] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.477051] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.482351] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.579442] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.584753] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.681861] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.687152] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.704145] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.704227] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.784213] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.789551] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.886671] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.891947] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  928.989062] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  928.994309] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  929.091389] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  929.096761] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  929.193871] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  929.199149] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  929.296224] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  929.301549] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:21 jill kernel: [  929.398648] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:21 jill kernel: [  929.403949] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  929.501065] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  929.506351] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  929.603452] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  929.608748] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  929.705841] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  929.711153] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  929.808225] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  929.813547] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  929.910652] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  929.915943] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  930.013037] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  930.018346] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  930.115460] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  930.120747] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  930.217845] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  930.223145] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:22 jill kernel: [  930.320199] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:22 jill kernel: [  930.325546] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.422660] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.427944] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.525046] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.530346] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.627465] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.632746] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.729853] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.735146] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.832205] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.837539] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  930.934660] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  930.939944] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  931.037049] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  931.042341] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  931.139442] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  931.144744] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  931.241856] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  931.247142] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:23 jill kernel: [  931.344214] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:23 jill kernel: [  931.349541] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.446638] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.451940] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.549060] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.554345] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.651446] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.656744] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.753833] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.759081] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.856220] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.861542] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  931.958642] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  931.963937] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  932.061031] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  932.066341] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  932.163452] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  932.168739] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  932.265838] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  932.271138] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:24 jill kernel: [  932.368199] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:24 jill kernel: [  932.373540] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.470649] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.475936] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.573042] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.578337] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.675458] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.680741] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.777845] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.783138] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.880200] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.885540] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  932.982653] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  932.987937] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  933.085042] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  933.090337] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  933.187433] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  933.192739] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  933.289852] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  933.295140] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:25 jill kernel: [  933.392207] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:25 jill kernel: [  933.397538] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.494630] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.499933] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.597049] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.602337] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.699440] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.704737] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.712127] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.712208] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.801827] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.807136] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  933.904212] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  933.909534] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  934.006635] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  934.011936] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  934.109054] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  934.114336] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  934.211443] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  934.216735] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:26 jill kernel: [  934.313838] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:26 jill kernel: [  934.319133] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.416219] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.421533] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.518644] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.523936] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.621032] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.626336] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.723452] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.728738] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.825839] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.831127] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  934.928176] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  934.933531] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  935.030648] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  935.035929] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  935.133035] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  935.138332] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  935.235423] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  935.240733] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:27 jill kernel: [  935.337852] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:27 jill kernel: [  935.343129] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.440200] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.445534] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.542627] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.547930] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.645044] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.650333] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.747431] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.752736] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.849853] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.855133] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  935.952202] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  935.957531] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  936.054627] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  936.059933] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  936.157049] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  936.162327] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  936.259435] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  936.264732] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:28 jill kernel: [  936.361831] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:28 jill kernel: [  936.367127] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.464208] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.469528] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.566638] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.571929] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.669024] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.674329] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.771443] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.776731] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.873834] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.879128] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  936.976166] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  936.981527] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  937.078639] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  937.083926] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  937.181030] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  937.186329] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  937.283420] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  937.288730] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:29 jill kernel: [  937.385842] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:29 jill kernel: [  937.391129] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  937.488172] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  937.493523] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  937.590621] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  937.595922] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  937.693038] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  937.698325] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  937.795423] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  937.800726] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  937.897847] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  937.903125] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  938.000193] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  938.005523] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  938.102623] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  938.107921] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  938.205040] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  938.210325] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  938.307434] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:30 jill kernel: [  938.312724] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:30 jill kernel: [  938.409826] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.415072] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  938.512201] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.517526] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  938.614628] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.619876] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  938.717018] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.722324] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  938.819436] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.824725] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  938.921827] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  938.927125] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  939.024159] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  939.029520] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  939.126632] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  939.131920] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  939.229022] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  939.234321] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:31 jill kernel: [  939.331415] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:31 jill kernel: [  939.336724] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.433835] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.439120] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.536166] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.541520] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.638639] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.643921] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.741027] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.746317] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.843419] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.848718] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  939.945839] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  939.951120] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  940.048171] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  940.053516] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  940.150615] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  940.155917] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  940.253032] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  940.258315] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:32 jill kernel: [  940.355423] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:32 jill kernel: [  940.360718] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.457812] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.463118] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.560198] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.565517] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.662621] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.667918] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.765008] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.770316] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.867431] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.872721] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  940.969816] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  940.975119] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  941.072151] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  941.077519] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  941.174627] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  941.179912] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  941.277019] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  941.282319] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:33 jill kernel: [  941.379439] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:33 jill kernel: [  941.384716] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.481825] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.487114] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.584161] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.589515] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.686633] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.691914] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.789020] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.794312] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.891412] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.896715] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  941.993828] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  941.999113] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  942.096167] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  942.101515] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  942.198608] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  942.203913] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  942.301031] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  942.306313] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:34 jill kernel: [  942.403420] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:34 jill kernel: [  942.408716] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  942.505806] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  942.511113] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  942.608169] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  942.613514] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  942.710613] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  942.715910] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  942.813002] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  942.818273] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  942.915426] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  942.920712] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  943.017809] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  943.023109] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  943.120148] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  943.125510] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  943.222619] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  943.227910] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:35 jill kernel: [  943.325012] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:35 jill kernel: [  943.330269] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.427432] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.432712] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.529817] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.535113] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.632145] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.637511] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.712128] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.712210] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.734628] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.739911] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.837013] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.842270] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  943.939405] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  943.944711] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  944.041821] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  944.047107] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  944.144159] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  944.149507] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  944.246602] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  944.251905] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:36 jill kernel: [  944.349023] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:36 jill kernel: [  944.354268] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.451410] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.456706] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.553804] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.559106] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.656163] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.661509] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.758605] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.763905] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.860998] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.866268] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  944.963413] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  944.968709] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  945.065803] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  945.071105] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  945.168169] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  945.173508] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  945.270614] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  945.275906] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:37 jill kernel: [  945.373005] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:37 jill kernel: [  945.378266] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.475422] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.480709] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.577813] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.583102] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.680145] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.685504] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.782616] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.787900] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.885009] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.891191] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  945.987339] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  945.992646] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  946.089816] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  946.095106] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  946.192153] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  946.197502] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  946.294598] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  946.299903] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:38 jill kernel: [  946.397016] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:38 jill kernel: [  946.402266] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  946.499403] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  946.504706] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  946.601789] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  946.607113] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  946.704144] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  946.709500] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  946.806599] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  946.811899] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  946.909020] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  946.914261] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  947.011407] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  947.016703] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  947.113797] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  947.119096] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  947.216166] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  947.221500] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:39 jill kernel: [  947.318609] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:39 jill kernel: [  947.323897] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.421000] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.426261] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.523413] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.528700] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.625805] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.631100] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.728136] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.733497] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.830611] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.835897] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  947.933004] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  947.938259] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  948.035387] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  948.040697] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  948.137809] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  948.143095] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  948.240142] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  948.245497] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:40 jill kernel: [  948.342590] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:40 jill kernel: [  948.347896] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.445006] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.450258] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.547395] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.552696] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.649816] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.655097] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.704103] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.704185] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.752152] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.757499] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.854591] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.859894] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  948.957011] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  948.962257] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  949.059399] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  949.064693] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  949.161790] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  949.167095] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  949.264155] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  949.269492] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:41 jill kernel: [  949.366602] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:41 jill kernel: [  949.371890] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.468987] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.474259] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.571410] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.576691] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.673796] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.679094] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.776131] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.781492] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.878608] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.883890] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  949.980992] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  949.986256] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  950.083380] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  950.088692] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  950.185804] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  950.191092] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  950.288138] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  950.293492] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:42 jill kernel: [  950.390580] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:42 jill kernel: [  950.395892] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  950.492999] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  950.498253] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  950.595388] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  950.600692] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  950.697810] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  950.703031] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  950.800141] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  950.805487] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  950.902587] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  950.907886] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  951.005005] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  951.010249] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  951.107394] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  951.112688] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  951.209784] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  951.215087] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:43 jill kernel: [  951.312149] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:43 jill kernel: [  951.317487] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.414595] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.419886] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.516980] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.522251] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.619400] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.624690] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.721787] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.727089] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.824127] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.829487] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  951.926599] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  951.931886] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  952.028984] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  952.034252] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  952.131407] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  952.136687] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  952.233795] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  952.239084] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:44 jill kernel: [  952.336130] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:44 jill kernel: [  952.341485] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:45 jill kernel: [  952.438606] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:45 jill kernel: [  952.443887] ath: phy4: AWAKE -> NETWORK SLEEP
Apr  9 22:58:45 jill kernel: [  952.540995] ath: phy4: NETWORK SLEEP -> AWAKE
Apr  9 22:58:45 jill kernel: [  952.546250] ath: phy4: AWAKE -> NETWORK SLEEP

-- 
MfG,

Michael Leun


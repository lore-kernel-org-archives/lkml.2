Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934501Ab2DLQBp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 12:01:45 -0400
Received: from serv04.lahn.de ([213.239.197.57]:60903 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932965Ab2DLQBn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 12:01:43 -0400
X-Greylist: delayed 1487 seconds by postgrey-1.27 at vger.kernel.org; Thu, 12 Apr 2012 12:01:43 EDT
Date: Thu, 12 Apr 2012 17:35:18 +0200
From: Michael Leun <ml@elektra.leun.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Michael Leun <lkml20120218@newton.leun.net>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k
 regression)
Message-ID: <20120412173518.2ecd8418@xenia.leun.net>
In-Reply-To: <CAMP44s1t+kVdRi_zhR1Qt045KEwco_PQhpa-cC9zMWc5QOFA8Q@mail.gmail.com>
References: <4F7A8EB7.4060200@silka.with-linux.com>
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
	<CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
	<20120409122549.7469543a@xenia.leun.net>
	<20120409160322.6b7b8c67@xenia.leun.net>
	<CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com>
	<20120409172933.4ca4775a@xenia.leun.net>
	<4F86DCB1.20507@openwrt.org>
	<CAMP44s1t+kVdRi_zhR1Qt045KEwco_PQhpa-cC9zMWc5QOFA8Q@mail.gmail.com>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 16:58:34 +0300
Felipe Contreras <felipe.contreras@gmail.com> wrote:

> On Thu, Apr 12, 2012 at 4:46 PM, Felix Fietkau <nbd@openwrt.org>
> wrote:
> > On 2012-04-09 5:29 PM, Michael Leun wrote:
> >> On Mon, 9 Apr 2012 19:52:45 +0530
> 
> >> Seems obvious to me, that this line
> >>
> >> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
> >>
> >> makes the real difference.
> > Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it fixes
> > this issue:
> 
> Nope, not here (3.3.1).

Also negative for 3.4-rc2, but that SLEEP<>AWAKE noise at the end
stopped. Still need "iwconfig wlan0 essid <myssid>" to make it ping
again (that not included in log below).

Due to Felipes result and 3.4-rc2 didn't repeat my test with 3.3.1, if
you think it would add useful information I could.

Apr 12 17:14:23 jill kernel: [  112.050654] ath: phy2: UNDEFINED -> AWAKE
Apr 12 17:14:23 jill kernel: [  112.050718] ath: phy2: serialize_regmode is 0
Apr 12 17:14:23 jill kernel: [  112.484482] ath: EEPROM regdomain: 0x37
Apr 12 17:14:23 jill kernel: [  112.484487] ath: EEPROM indicates we should expect a direct regpair map
Apr 12 17:14:23 jill kernel: [  112.484491] ath: Country alpha2 being used: AW
Apr 12 17:14:23 jill kernel: [  112.484494] ath: Regpair used: 0x37
Apr 12 17:14:23 jill kernel: [  112.491420] ieee80211 phy2: Selected rate control algorithm 'ath9k_rate_control'
Apr 12 17:14:23 jill kernel: [  112.491856] cfg80211: Calling CRDA for country: DE
Apr 12 17:14:23 jill kernel: [  112.491917] Registered led device: ath9k-phy2
Apr 12 17:14:23 jill kernel: [  112.491937] ieee80211 phy2: Atheros AR9280 Rev:2 mem=0xffffc90004140000, irq=19
Apr 12 17:14:23 jill kernel: [  112.499003] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 17:14:23 jill kernel: [  112.504355] cfg80211: World regulatory domain updated:
Apr 12 17:14:23 jill kernel: [  112.504360] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:23 jill kernel: [  112.504366] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.504370] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.504375] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.504380] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.504384] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.505411] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 17:14:23 jill kernel: [  112.511576] cfg80211: World regulatory domain updated:
Apr 12 17:14:23 jill kernel: [  112.511582] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:23 jill kernel: [  112.511587] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.511592] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.511597] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.511602] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.511606] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.511632] cfg80211: Calling CRDA for country: AW
Apr 12 17:14:23 jill kernel: [  112.517260] cfg80211: Regulatory domain changed to country: AW
Apr 12 17:14:23 jill kernel: [  112.517267] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:23 jill kernel: [  112.517272] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.517277] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.517281] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.517285] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Apr 12 17:14:23 jill kernel: [  112.517312] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 17:14:23 jill kernel: [  112.523269] cfg80211: World regulatory domain updated:
Apr 12 17:14:23 jill kernel: [  112.523274] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:23 jill kernel: [  112.523280] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.523285] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.523289] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.523294] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.523299] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:23 jill kernel: [  112.523325] cfg80211: Calling CRDA for country: 97
Apr 12 17:14:23 jill ifup[4023]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr 12 17:14:23 jill ifup[4023]:     wlan0     is controlled by ifplugd
Apr 12 17:14:23 jill ifup[4115]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr 12 17:14:23 jill ifup-wireless[4165]:     wlan0     starting wpa_supplicant
Apr 12 17:14:23 jill kernel: [  112.922810] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:23 jill kernel: [  112.925814] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:23 jill kernel: [  112.930646] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:23 jill kernel: [  112.933057] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  112.933089] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:23 jill kernel: [  112.934926] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Apr 12 17:14:23 jill kernel: [  112.935933] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  112.935948] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:23 jill kernel: [  112.938772] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  112.954578] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:23 jill kernel: [  112.958174] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  112.972352] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:23 jill kernel: [  112.975936] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  113.043989] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:23 jill kernel: [  113.047551] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:14:23 jill kernel: [  113.047567] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:14:24 jill kernel: [  113.055181] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.062439] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.129648] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.197652] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.264706] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.331712] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.398657] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.466662] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.533678] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.600689] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.667706] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.735064] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.802684] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.869665] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  113.936704] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:24 jill kernel: [  114.003657] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.070700] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.137680] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.204599] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.336653] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.468656] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.600668] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.732617] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.864643] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:25 jill kernel: [  114.996648] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.128652] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.260697] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.392609] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.524645] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.656636] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.672835] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 17:14:26 jill kernel: [  115.678140] cfg80211: World regulatory domain updated:
Apr 12 17:14:26 jill kernel: [  115.678145] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:26 jill kernel: [  115.678151] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:26 jill kernel: [  115.678156] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:26 jill kernel: [  115.678161] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:26 jill kernel: [  115.678166] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:26 jill kernel: [  115.678172] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 17:14:26 jill kernel: [  115.788650] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:26 jill kernel: [  115.921656] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.053669] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.182331] wlan0: authenticate with f4:ec:38:e9:6a:e6
Apr 12 17:14:27 jill kernel: [  116.186678] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.193951] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.196330] wlan0: send auth to f4:ec:38:e9:6a:e6 (try 1/3)
Apr 12 17:14:27 jill kernel: [  116.199787] wlan0: authenticated
Apr 12 17:14:27 jill kernel: [  116.204686] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.207753] wlan0: associate with f4:ec:38:e9:6a:e6 (try 1/3)
Apr 12 17:14:27 jill kernel: [  116.211390] wlan0: RX AssocResp from f4:ec:38:e9:6a:e6 (capab=0x411 status=0 aid=2)
Apr 12 17:14:27 jill kernel: [  116.211397] wlan0: associated
Apr 12 17:14:27 jill kernel: [  116.216149] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.218220] ath: phy2: ah->misc_mode 0x4
Apr 12 17:14:27 jill kernel: [  116.220204] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Apr 12 17:14:27 jill kernel: [  116.220291] cfg80211: Calling CRDA for country: DE
Apr 12 17:14:27 jill kernel: [  116.225593] cfg80211: Regulatory domain changed to country: DE
Apr 12 17:14:27 jill kernel: [  116.225599] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 17:14:27 jill kernel: [  116.225604] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 17:14:27 jill kernel: [  116.225609] cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 17:14:27 jill kernel: [  116.225614] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Apr 12 17:14:27 jill kernel: [  116.299782] ath: phy2: Reconfigure Beacon timers based on timestamp from the AP
Apr 12 17:14:36 jill kernel: [  125.510012] EXT4-fs (dm-9): re-mounted. Opts: acl,user_xattr,commit=0
Apr 12 17:14:36 jill kernel: [  125.514931] EXT4-fs (sda1): re-mounted. Opts: commit=0
Apr 12 17:14:36 jill kernel: [  125.646231] EXT4-fs (dm-11): re-mounted. Opts: data=ordered,commit=0
Apr 12 17:14:37 jill kernel: [  126.946681] wlan0: no IPv6 routers present
Apr 12 17:17:46 jill kernel: [  130.274886] Syncing filesystems ... done.
Apr 12 17:17:46 jill kernel: [  130.279453] Freezing user space processes ... (elapsed 0.01 seconds) done.
Apr 12 17:17:46 jill kernel: [  130.291870] PM: Preallocating image memory... done (allocated 218689 pages)
Apr 12 17:17:46 jill kernel: [  130.646523] PM: Allocated 874756 kbytes in 0.35 seconds (2499.30 MB/s)
Apr 12 17:17:46 jill kernel: [  130.646526] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Apr 12 17:17:46 jill kernel: [  130.658041] Suspending console(s) (use no_console_suspend to debug)
Apr 12 17:17:46 jill kernel: [  130.662919] ath: phy2: ah->misc_mode 0x4
Apr 12 17:17:46 jill kernel: [  130.664981] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:17:46 jill kernel: [  130.665441] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Apr 12 17:17:46 jill kernel: [  130.665665] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:17:46 jill kernel: [  130.668671] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 17:17:46 jill kernel: [  130.868779] ACPI handle has no context!
Apr 12 17:17:46 jill kernel: [  130.879647] PM: freeze of devices complete after 221.598 msecs
Apr 12 17:17:46 jill kernel: [  130.879824] PM: late freeze of devices complete after 0.171 msecs
Apr 12 17:17:46 jill kernel: [  130.880472] PM: noirq freeze of devices complete after 0.644 msecs
Apr 12 17:17:46 jill kernel: [  130.880941] ACPI: Preparing to enter system sleep state S4
Apr 12 17:17:46 jill kernel: [  130.885692] PM: Saving platform NVS memory
Apr 12 17:17:46 jill kernel: [  130.887440] Disabling non-boot CPUs ...
Apr 12 17:17:46 jill kernel: [  130.888929] CPU 1 is now offline
Apr 12 17:17:46 jill kernel: [  130.889728] PM: Creating hibernation image:
Apr 12 17:17:46 jill kernel: [  130.889917] PM: Need to copy 218169 pages
Apr 12 17:17:46 jill kernel: [  130.889917] PM: Restoring platform NVS memory
Apr 12 17:17:46 jill kernel: [  130.889917] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
Apr 12 17:17:46 jill kernel: [  130.899599] Enabling non-boot CPUs ...
Apr 12 17:17:46 jill kernel: [  130.902755] Booting Node 0 Processor 1 APIC 0x1
Apr 12 17:17:46 jill kernel: [  130.915432] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
Apr 12 17:17:46 jill kernel: [  130.926329] CPU1 is up
Apr 12 17:17:46 jill kernel: [  130.928840] ACPI: Waking up from system sleep state S4
Apr 12 17:17:46 jill kernel: [  131.165333] PM: noirq restore of devices complete after 231.434 msecs
Apr 12 17:17:46 jill kernel: [  131.165485] PM: early restore of devices complete after 0.108 msecs
Apr 12 17:17:46 jill kernel: [  131.289931] i915 0000:00:02.0: setting latency timer to 64
Apr 12 17:17:46 jill kernel: [  131.294075] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
Apr 12 17:17:46 jill kernel: [  131.294654] pci 0000:00:1e.0: setting latency timer to 64
Apr 12 17:17:46 jill kernel: [  131.294677] ahci 0000:00:1f.2: setting latency timer to 64
Apr 12 17:17:46 jill kernel: [  131.601146] ata6: SATA link down (SStatus 0 SControl 300)
Apr 12 17:17:46 jill kernel: [  131.603114] ata2: SATA link down (SStatus 0 SControl 300)
Apr 12 17:17:46 jill kernel: [  131.605108] ata5: SATA link down (SStatus 0 SControl 300)
Apr 12 17:17:46 jill kernel: [  131.754089] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr 12 17:17:46 jill kernel: [  131.766709] ata1.00: configured for UDMA/133
Apr 12 17:17:46 jill kernel: [  131.777111] sd 0:0:0:0: [sda] Starting disk
Apr 12 17:17:46 jill kernel: [  134.206347] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 17:17:46 jill kernel: [  134.214406] ath: phy2: ah->misc_mode 0x4
Apr 12 17:17:46 jill kernel: [  134.216885] ath: phy2: ah->misc_mode 0x4
Apr 12 17:17:46 jill kernel: [  134.221626] ath: phy2: ah->misc_mode 0x4
Apr 12 17:17:46 jill kernel: [  134.223608] ath: phy2: ah->misc_mode 0x4
Apr 12 17:17:46 jill kernel: [  134.223779] PM: restore of devices complete after 2933.955 msecs
Apr 12 17:17:46 jill kernel: [  134.271168] Restarting kernel threads ... done.
Apr 12 17:17:46 jill kernel: [  134.271463] Restarting tasks ... done.
Apr 12 17:17:46 jill kernel: [  134.335596] video LNXVIDEO:00: Restoring backlight state
Apr 12 17:17:46 jill kernel: [  134.532000] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Apr 12 17:17:47 jill kernel: [  135.876879] EXT4-fs (dm-9): re-mounted. Opts: acl,user_xattr,commit=0
Apr 12 17:17:48 jill kernel: [  136.217096] EXT4-fs (dm-11): re-mounted. Opts: data=ordered,commit=0
Apr 12 17:17:48 jill kernel: [  136.221083] EXT4-fs (sda1): re-mounted. Opts: commit=0


-- 
MfG,

Michael Leun


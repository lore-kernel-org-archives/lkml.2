Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966095Ab2DLWCR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 18:02:17 -0400
Received: from serv04.lahn.de ([213.239.197.57]:55129 "EHLO serv04.lahn.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S964932Ab2DLWCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 18:02:14 -0400
Date: Fri, 13 Apr 2012 00:01:46 +0200
From: Michael Leun <lkml20120218@newton.leun.net>
To: Felix Fietkau <nbd@openwrt.org>
Cc: Felipe Contreras <felipe.contreras@gmail.com>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>,
        Sergio Correia <lists@uece.net>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k
 regression)
Message-ID: <20120413000146.1321b560@xenia.leun.net>
In-Reply-To: <4F871AB8.3070302@openwrt.org>
References: <4F7A8EB7.4060200@silka.with-linux.com>
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
 <20120412173518.2ecd8418@xenia.leun.net>
 <4F871AB8.3070302@openwrt.org>
Organization: Not Organized
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.7; i586-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Apr 2012 20:11:04 +0200
Felix Fietkau <nbd@openwrt.org> wrote:

> On 2012-04-12 5:35 PM, Michael Leun wrote:
> > On Thu, 12 Apr 2012 16:58:34 +0300
> > Felipe Contreras <felipe.contreras@gmail.com> wrote:
> > 
> >> On Thu, Apr 12, 2012 at 4:46 PM, Felix Fietkau <nbd@openwrt.org>
> >> wrote:
> >> > On 2012-04-09 5:29 PM, Michael Leun wrote:
> >> >> On Mon, 9 Apr 2012 19:52:45 +0530
> >> 
> >> >> Seems obvious to me, that this line
> >> >>
> >> >> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
> >> >>
> >> >> makes the real difference.
> >> > Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it
> >> > fixes this issue:
> >> 
> >> Nope, not here (3.3.1).
> > 
> > Also negative for 3.4-rc2, but that SLEEP<>AWAKE noise at the end
> > stopped. Still need "iwconfig wlan0 essid <myssid>" to make it ping
> > again (that not included in log below).
> OK, so my fix is definitely worth submitting, since it gets rid of
> some unnecessary sleep mode transitions. About the iwconfig command:

I fear, it is not that easy. Tried to reproduce that and was not able
to. Until I noticed the difference: I had ac power disconnected this
time. Find log with ac power disconnected below.

I even can turn the storm of SLEEP<>AWAKE on and off with disconnecting
and connecting ac power.

Please do not ask me, if ac power was connected or not, when I reported
the original issue with 3.4.0-rc2, I cannot remember.

> are you not using wpa_supplicant?

I use wpa_supplicant. I do not know what that iwconfig command triggers
that it makes it work, but it does.

It isn't, that ssid is not set - it is, actually, as reported iwconfig
wlan0 looks as usual when it does not ping, ssid is there and AP is
shown.

> > Due to Felipes result and 3.4-rc2 didn't repeat my test with 3.3.1,
> > if you think it would add useful information I could.
> Maybe it would be useful to get some more detailed logs from that.

Both testcases I had with 3.3.1 (hibernate/resume and ifconfig wlan0
down / up) work with your patch for me. Do not have 3.3.1 with ath
debug support compiled in yet, should I?

Apr 12 23:16:05 jill kernel: [  101.452631] ath: phy2: UNDEFINED -> AWAKE
Apr 12 23:16:05 jill kernel: [  101.452695] ath: phy2: serialize_regmode is 0
Apr 12 23:16:05 jill kernel: [  101.886898] ath: EEPROM regdomain: 0x37
Apr 12 23:16:05 jill kernel: [  101.886902] ath: EEPROM indicates we should expect a direct regpair map
Apr 12 23:16:05 jill kernel: [  101.886906] ath: Country alpha2 being used: AW
Apr 12 23:16:05 jill kernel: [  101.886909] ath: Regpair used: 0x37
Apr 12 23:16:05 jill kernel: [  101.893850] ieee80211 phy2: Selected rate control algorithm 'ath9k_rate_control'
Apr 12 23:16:05 jill kernel: [  101.894307] cfg80211: Calling CRDA for country: DE
Apr 12 23:16:05 jill kernel: [  101.894365] Registered led device: ath9k-phy2
Apr 12 23:16:05 jill kernel: [  101.894385] ieee80211 phy2: Atheros AR9280 Rev:2 mem=0xffffc90004140000, irq=19
Apr 12 23:16:05 jill kernel: [  101.900690] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 23:16:05 jill kernel: [  101.906443] cfg80211: World regulatory domain updated:
Apr 12 23:16:05 jill kernel: [  101.906448] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:05 jill kernel: [  101.906454] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.906458] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.906463] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.906468] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.906473] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.906497] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 23:16:05 jill kernel: [  101.914739] cfg80211: World regulatory domain updated:
Apr 12 23:16:05 jill kernel: [  101.914744] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:05 jill kernel: [  101.914749] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.914754] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.914759] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.914764] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.914768] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.914791] cfg80211: Calling CRDA for country: AW
Apr 12 23:16:05 jill kernel: [  101.921471] cfg80211: Regulatory domain changed to country: AW
Apr 12 23:16:05 jill kernel: [  101.921477] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:05 jill kernel: [  101.921482] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.921487] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.921491] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.921495] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Apr 12 23:16:05 jill kernel: [  101.921521] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 23:16:05 jill kernel: [  101.927552] cfg80211: World regulatory domain updated:
Apr 12 23:16:05 jill kernel: [  101.927557] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:05 jill kernel: [  101.927563] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.927568] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.927572] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.927577] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.927582] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:05 jill kernel: [  101.927606] cfg80211: Calling CRDA for country: 97
Apr 12 23:16:05 jill ifup[4030]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr 12 23:16:06 jill ifup[4030]:     wlan0     is controlled by ifplugd
Apr 12 23:16:06 jill ifup[4124]:     wlan0     device: Atheros Communications Inc. AR928X Wireless Network Adapter (PCI-Express) (rev 01)
Apr 12 23:16:06 jill ifup-wireless[4174]:     wlan0     starting wpa_supplicant
Apr 12 23:16:06 jill kernel: [  102.324936] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.327933] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.332796] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.335234] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.335264] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.336011] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Apr 12 23:16:06 jill kernel: [  102.338114] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.338129] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.340952] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.357809] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.361362] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.376073] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.379616] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.447260] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.450821] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:16:06 jill kernel: [  102.450836] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:16:06 jill kernel: [  102.458448] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.465710] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.534254] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.601927] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.668940] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.735947] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.803878] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.870889] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  102.938019] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:06 jill kernel: [  103.005018] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.072846] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.138005] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.205020] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.272014] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.339898] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.406929] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.474017] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.541015] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.608011] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.740948] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  103.871907] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:07 jill kernel: [  104.002940] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.133933] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.264899] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.396875] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.528885] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.660881] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.791886] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:08 jill kernel: [  104.923890] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.054875] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.073020] cfg80211: Calling CRDA to update world regulatory domain
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211: World regulatory domain updated:
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.078005] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.185881] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.317887] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.448867] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.576537] wlan0: authenticate with f4:ec:38:e9:6a:e6
Apr 12 23:16:09 jill kernel: [  105.580907] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.588603] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.591063] wlan0: send auth to f4:ec:38:e9:6a:e6 (try 1/3)
Apr 12 23:16:09 jill kernel: [  105.594938] wlan0: authenticated
Apr 12 23:16:09 jill kernel: [  105.599921] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.604029] wlan0: associate with f4:ec:38:e9:6a:e6 (try 1/3)
Apr 12 23:16:09 jill kernel: [  105.607656] wlan0: RX AssocResp from f4:ec:38:e9:6a:e6 (capab=0x411 status=0 aid=1)
Apr 12 23:16:09 jill kernel: [  105.607662] wlan0: associated
Apr 12 23:16:09 jill kernel: [  105.612398] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.614407] ath: phy2: ah->misc_mode 0x4
Apr 12 23:16:09 jill kernel: [  105.616334] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Apr 12 23:16:09 jill kernel: [  105.616403] cfg80211: Calling CRDA for country: DE
Apr 12 23:16:09 jill kernel: [  105.617094] ath: phy2: Reconfigure Beacon timers based on timestamp from the AP
Apr 12 23:16:09 jill kernel: [  105.621931] cfg80211: Regulatory domain changed to country: DE
Apr 12 23:16:09 jill kernel: [  105.621937] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Apr 12 23:16:09 jill kernel: [  105.621943] cfg80211:   (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.621948] cfg80211:   (5150000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Apr 12 23:16:09 jill kernel: [  105.621952] cfg80211:   (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 2698 mBm)
Apr 12 23:16:19 jill kernel: [  115.730821] wlan0: no IPv6 routers present
Apr 12 23:16:21 jill kernel: [  117.554280] EXT4-fs (dm-9): re-mounted. Opts: acl,user_xattr,commit=0
Apr 12 23:16:21 jill kernel: [  117.559290] EXT4-fs (sda1): re-mounted. Opts: commit=0
Apr 12 23:16:22 jill kernel: [  118.300215] EXT4-fs (dm-11): re-mounted. Opts: commit=600,data=ordered,commit=0
Apr 12 23:19:29 jill kernel: [  123.583390] Syncing filesystems ... done.
Apr 12 23:19:29 jill kernel: [  123.586332] Freezing user space processes ... (elapsed 0.01 seconds) done.
Apr 12 23:19:29 jill kernel: [  123.598082] PM: Preallocating image memory... done (allocated 223652 pages)
Apr 12 23:19:29 jill kernel: [  123.972245] PM: Allocated 894608 kbytes in 0.37 seconds (2417.85 MB/s)
Apr 12 23:19:29 jill kernel: [  123.972250] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
Apr 12 23:19:29 jill kernel: [  123.984311] Suspending console(s) (use no_console_suspend to debug)
Apr 12 23:19:29 jill kernel: [  123.989183] ath: phy2: ah->misc_mode 0x4
Apr 12 23:19:29 jill kernel: [  123.991238] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:19:29 jill kernel: [  123.991702] sd 0:0:0:0: [sda] Synchronizing SCSI cache
Apr 12 23:19:29 jill kernel: [  123.991902] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:19:29 jill kernel: [  123.994907] ath: phy2: AWAKE -> FULL-SLEEP
Apr 12 23:19:29 jill kernel: [  124.193986] ACPI handle has no context!
Apr 12 23:19:29 jill kernel: [  124.204878] PM: freeze of devices complete after 220.556 msecs
Apr 12 23:19:29 jill kernel: [  124.205039] PM: late freeze of devices complete after 0.155 msecs
Apr 12 23:19:29 jill kernel: [  124.205690] PM: noirq freeze of devices complete after 0.646 msecs
Apr 12 23:19:29 jill kernel: [  124.206167] ACPI: Preparing to enter system sleep state S4
Apr 12 23:19:29 jill kernel: [  124.211878] PM: Saving platform NVS memory
Apr 12 23:19:29 jill kernel: [  124.213615] Disabling non-boot CPUs ...
Apr 12 23:19:29 jill kernel: [  124.215097] CPU 1 is now offline
Apr 12 23:19:29 jill kernel: [  124.215889] PM: Creating hibernation image:
Apr 12 23:19:29 jill kernel: [  124.216087] PM: Need to copy 223136 pages
Apr 12 23:19:29 jill kernel: [  124.216087] PM: Restoring platform NVS memory
Apr 12 23:19:29 jill kernel: [  124.216087] microcode: CPU0 updated to revision 0xa0b, date = 2010-09-28
Apr 12 23:19:29 jill kernel: [  124.225759] Enabling non-boot CPUs ...
Apr 12 23:19:29 jill kernel: [  124.228914] Booting Node 0 Processor 1 APIC 0x1
Apr 12 23:19:29 jill kernel: [  124.241595] microcode: CPU1 updated to revision 0xa0b, date = 2010-09-28
Apr 12 23:19:29 jill kernel: [  124.252328] CPU1 is up
Apr 12 23:19:29 jill kernel: [  124.254816] ACPI: Waking up from system sleep state S4
Apr 12 23:19:29 jill kernel: [  124.491065] PM: noirq restore of devices complete after 231.409 msecs
Apr 12 23:19:29 jill kernel: [  124.491218] PM: early restore of devices complete after 0.109 msecs
Apr 12 23:19:29 jill kernel: [  124.616080] i915 0000:00:02.0: setting latency timer to 64
Apr 12 23:19:29 jill kernel: [  124.620190] snd_hda_intel 0000:00:1b.0: irq 44 for MSI/MSI-X
Apr 12 23:19:29 jill kernel: [  124.624754] pci 0000:00:1e.0: setting latency timer to 64
Apr 12 23:19:29 jill kernel: [  124.624775] ahci 0000:00:1f.2: setting latency timer to 64
Apr 12 23:19:29 jill kernel: [  124.929122] ata2: SATA link down (SStatus 0 SControl 300)
Apr 12 23:19:29 jill kernel: [  124.933135] ata5: SATA link down (SStatus 0 SControl 300)
Apr 12 23:19:29 jill kernel: [  124.935131] ata6: SATA link down (SStatus 0 SControl 300)
Apr 12 23:19:29 jill kernel: [  125.087061] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
Apr 12 23:19:29 jill kernel: [  125.099685] ata1.00: configured for UDMA/133
Apr 12 23:19:29 jill kernel: [  125.110148] sd 0:0:0:0: [sda] Starting disk
Apr 12 23:19:29 jill kernel: [  127.536379] ath: phy2: FULL-SLEEP -> AWAKE
Apr 12 23:19:29 jill kernel: [  127.544427] ath: phy2: ah->misc_mode 0x4
Apr 12 23:19:29 jill kernel: [  127.546924] ath: phy2: ah->misc_mode 0x4
Apr 12 23:19:29 jill kernel: [  127.551648] ath: phy2: ah->misc_mode 0x4
Apr 12 23:19:29 jill kernel: [  127.553632] ath: phy2: ah->misc_mode 0x4
Apr 12 23:19:29 jill kernel: [  127.553808] PM: restore of devices complete after 2937.833 msecs
Apr 12 23:19:29 jill kernel: [  127.601219] Restarting kernel threads ... done.
Apr 12 23:19:29 jill kernel: [  127.601514] Restarting tasks ... done.
Apr 12 23:19:29 jill acpid: 1 client rule loaded
Apr 12 23:19:29 jill kernel: [  127.670865] video LNXVIDEO:00: Restoring backlight state
Apr 12 23:19:29 jill kernel: [  127.916959] hub 3-0:1.0: USB hub found
Apr 12 23:19:29 jill kernel: [  127.916968] hub 3-0:1.0: 2 ports detected
Apr 12 23:19:29 jill kernel: [  127.921478] hub 4-0:1.0: USB hub found
Apr 12 23:19:29 jill kernel: [  127.921486] hub 4-0:1.0: 2 ports detected
Apr 12 23:19:29 jill kernel: [  127.922039] hub 5-0:1.0: USB hub found
Apr 12 23:19:29 jill kernel: [  127.922048] hub 5-0:1.0: 2 ports detected
Apr 12 23:19:29 jill kernel: [  127.928488] hub 6-0:1.0: USB hub found
Apr 12 23:19:29 jill kernel: [  127.928497] hub 6-0:1.0: 2 ports detected
Apr 12 23:19:29 jill kernel: [  127.928898] hub 7-0:1.0: USB hub found
Apr 12 23:19:29 jill kernel: [  127.928905] hub 7-0:1.0: 2 ports detected
Apr 12 23:19:29 jill kernel: [  128.020203] EXT4-fs (sda1): mounted filesystem with ordered data mode. Opts: (null)
Apr 12 23:19:32 jill kernel: [  130.465439] EXT4-fs (dm-9): re-mounted. Opts: acl,user_xattr,commit=600
Apr 12 23:19:32 jill kernel: [  130.781515] EXT4-fs (dm-11): re-mounted. Opts: data=ordered,commit=600
Apr 12 23:19:32 jill kernel: [  130.785518] EXT4-fs (sda1): re-mounted. Opts: commit=600
Apr 12 23:19:32 jill kernel: [  130.950210] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:32 jill kernel: [  131.040139] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:32 jill kernel: [  131.045458] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:32 jill kernel: [  131.142587] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:32 jill kernel: [  131.147837] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.245012] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.250235] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.347347] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.352639] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.449731] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.455039] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.552210] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.557459] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.654598] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.659892] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.756985] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.762294] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.859355] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.864695] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  131.961794] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  131.967093] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  132.064183] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  132.069456] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:33 jill kernel: [  132.166603] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:33 jill kernel: [  132.171896] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.268997] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.274295] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.371332] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.376696] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.473801] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.479090] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.576195] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.581456] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.678611] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.683891] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.704084] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.704166] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.780928] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.786298] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.883318] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.888692] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  132.985785] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  132.991112] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  133.088196] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  133.093453] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:34 jill kernel: [  133.190590] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:34 jill kernel: [  133.195889] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.293008] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.298288] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.395342] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.400688] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.497782] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.503093] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.600137] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.605455] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.702593] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.707891] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.804976] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.810291] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  133.907344] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  133.912687] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  134.009787] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  134.015028] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  134.112138] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:35 jill kernel: [  134.117453] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:35 jill kernel: [  134.214597] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.219888] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.316984] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.322262] ath: phy2: Received DTIM beacon indicating buffered broadcast/multicast frame(s)
Apr 12 23:19:36 jill kernel: [  134.324757] ath: phy2: All PS CAB frames received, back to sleep
Apr 12 23:19:36 jill kernel: [  134.324775] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.419332] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.424689] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.521794] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.527034] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.624113] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.629431] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.726533] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.731845] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.828929] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.834290] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  134.931324] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  134.936633] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  135.033798] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  135.039089] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:36 jill kernel: [  135.136127] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:36 jill kernel: [  135.141450] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.238578] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.243886] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.340996] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.346231] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.443330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.448685] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.545775] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.551082] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.648193] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.653447] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.750581] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.755881] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.852960] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.858282] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  135.955336] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  135.960681] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  136.057729] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  136.063084] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:37 jill kernel: [  136.160205] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:37 jill kernel: [  136.165446] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.262591] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.267884] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.364981] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.370283] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.398145] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.506272] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.569790] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.575086] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.672175] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.677448] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.774596] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.779881] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.876983] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.882279] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  136.979329] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  136.984679] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  137.081795] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  137.087081] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:38 jill kernel: [  137.184186] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:38 jill kernel: [  137.189447] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.286575] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.291878] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.388991] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.394281] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.411107] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.411197] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.411231] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.518267] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.593803] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.599081] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.696188] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.701424] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.712055] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.712139] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.798579] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.803881] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  137.901000] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  137.906280] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  138.003333] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  138.008675] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  138.105779] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  138.111076] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:39 jill kernel: [  138.208194] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:39 jill kernel: [  138.213423] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.310591] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.315879] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.412909] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.418214] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.423042] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.423123] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.423167] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.532217] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.617781] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.623020] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.720172] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.725424] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.822589] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.827875] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  138.924983] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  138.930276] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  139.027330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  139.032676] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:40 jill kernel: [  139.129790] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:40 jill kernel: [  139.135076] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.232176] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.237423] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.334567] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.339877] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.436981] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.542246] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.641791] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.647075] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.744111] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.749421] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.846578] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.851871] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  139.948992] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  139.954273] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  140.051330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  140.056671] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:41 jill kernel: [  140.153769] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:41 jill kernel: [  140.159070] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.256186] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.261418] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.358577] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.363872] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.451126] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.451211] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.451244] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.553280] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.563324] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.568664] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.665773] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.671070] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.768163] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.773418] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.870584] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.875872] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  140.972972] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  140.978270] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  141.075332] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  141.080668] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:42 jill kernel: [  141.177780] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:42 jill kernel: [  141.183067] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.280171] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.285415] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.382587] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.387867] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.398134] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.500147] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.587330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.592668] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.689784] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.695009] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.792176] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.797414] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.894565] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  141.899869] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  141.996984] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  142.002269] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  142.099330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  142.104671] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:43 jill kernel: [  142.201761] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:43 jill kernel: [  142.207069] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.304180] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.309415] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.398145] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.500280] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.508951] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.514259] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.611330] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.616606] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.713765] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.719064] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.720066] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.720148] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.816157] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.821415] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  142.918577] ath: phy2: NETWORK SLEEP -> AWAKE
Apr 12 23:19:44 jill kernel: [  142.923864] ath: phy2: AWAKE -> NETWORK SLEEP
Apr 12 23:19:44 jill kernel: [  143.020965] ath: phy2: NETWORK SLEEP -> AWAKE


-- 
MfG,

Michael Leun


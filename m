Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934621Ab2DLT3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 15:29:21 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:57626 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757317Ab2DLT3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 15:29:19 -0400
MIME-Version: 1.0
X-Originating-IP: [69.196.158.137]
In-Reply-To: <4F871AB8.3070302@openwrt.org>
References: <4F7A8EB7.4060200@silka.with-linux.com> <CAD2nsn0kogfuMhCN7tNNkiKF4PN-mG2Fa3gu0CGfw01qj-MWyg@mail.gmail.com>
 <4F7AB6FE.3080009@silka.with-linux.com> <20120403200306.0afbb48b@xenia.leun.net>
 <CAD2nsn2k3mKMm3gK=fXqDYcOeKBwkyqGz9RWz1KOe=6=CDyhHA@mail.gmail.com>
 <CAD2nsn1AshPTYd-FcydV-5HpiXPb0FfqLQPTqFYyw3kJX+fXEA@mail.gmail.com>
 <20120404235104.682cfad3@xenia.leun.net> <4F7DE3A4.1040705@candelatech.com>
 <CAD2nsn16AozFF2QhiY063-48bKiXdyQLmSqJLLHPpsZ3H3JtHQ@mail.gmail.com>
 <4F7F52BD.7060906@candelatech.com> <20120409010816.36244f17@xenia.leun.net>
 <CAD2nsn3-C8ZLmUpTDeA6HuPr-+=V5KkPJb6h5e7ZJsGi4v9p0g@mail.gmail.com>
 <20120409122549.7469543a@xenia.leun.net> <20120409160322.6b7b8c67@xenia.leun.net>
 <CAD2nsn0n-VQ8ZOm69BNrbFv5HK3cdm+22yKrYprwoeFz-E2Uew@mail.gmail.com>
 <20120409172933.4ca4775a@xenia.leun.net> <4F86DCB1.20507@openwrt.org>
 <CAMP44s1t+kVdRi_zhR1Qt045KEwco_PQhpa-cC9zMWc5QOFA8Q@mail.gmail.com>
 <20120412173518.2ecd8418@xenia.leun.net> <4F871AB8.3070302@openwrt.org>
From: Sergio Correia <lists@uece.net>
Date: Thu, 12 Apr 2012 15:28:56 -0400
Message-ID: <CAJyhjX3W6LiTihWC5bRx6ShpKA8JUCSdJ+ry2gDE+=rpF5MytQ@mail.gmail.com>
Subject: Re: 3.4-rc ath9k regression (Re: [ath9k-devel] 3.3.1 ath9k regression)
To: Felix Fietkau <nbd@openwrt.org>
Cc: Michael Leun <ml@elektra.leun.net>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Michael Leun <lkml20120218@newton.leun.net>,
        Mohammed Shafi <shafi.wireless@gmail.com>,
        Ben Greear <greearb@candelatech.com>, casteyde.christian@free.fr,
        Kelly Anderson <kelly@silka.with-linux.com>,
        "ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-wireless Mailing List <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Felix,

On Thu, Apr 12, 2012 at 2:11 PM, Felix Fietkau <nbd@openwrt.org> wrote:
> On 2012-04-12 5:35 PM, Michael Leun wrote:
>> On Thu, 12 Apr 2012 16:58:34 +0300
>> Felipe Contreras <felipe.contreras@gmail.com> wrote:
>>
>>> On Thu, Apr 12, 2012 at 4:46 PM, Felix Fietkau <nbd@openwrt.org>
>>> wrote:
>>> > On 2012-04-09 5:29 PM, Michael Leun wrote:
>>> >> On Mon, 9 Apr 2012 19:52:45 +0530
>>>
>>> >> Seems obvious to me, that this line
>>> >>
>>> >> if (sc->ps_idle && (sc->ps_flags & PS_WAIT_FOR_TX_ACK))
>>> >>
>>> >> makes the real difference.
>>> > Please try this patch with plain 3.3.1 or 3.4-rc2 to see if it fixes
>>> > this issue:
>>>
>>> Nope, not here (3.3.1).
>>
>> Also negative for 3.4-rc2, but that SLEEP<>AWAKE noise at the end
>> stopped. Still need "iwconfig wlan0 essid <myssid>" to make it ping
>> again (that not included in log below).
> OK, so my fix is definitely worth submitting, since it gets rid of some
> unnecessary sleep mode transitions. About the iwconfig command: are you
> not using wpa_supplicant?
>
>> Due to Felipes result and 3.4-rc2 didn't repeat my test with 3.3.1, if
>> you think it would add useful information I could.
> Maybe it would be useful to get some more detailed logs from that.
>

your patch seems to work for me, with 3.3.1:

this is the log after I disable/re-enable the interface:

[  216.202405] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  219.054925] wlan0: authenticate with 00:26:44:68:e0:6f (try 1)
[  219.057190] wlan0: authenticated
[  219.069573] wlan0: associate with 00:26:44:68:e0:6f (try 1)
[  219.074450] wlan0: RX AssocResp from 00:26:44:68:e0:6f (capab=0x411
status=0 aid=2)
[  219.074454] wlan0: associated
[  219.074456] wlan0: moving STA 00:26:44:68:e0:6f to state 1
[  219.074458] wlan0: moving STA 00:26:44:68:e0:6f to state 2
[  219.075217] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  219.081856] wlan0: moving STA 00:26:44:68:e0:6f to state 3
[  229.108248] wlan0: no IPv6 routers present

and here, after a suspend/resume cycle (whole log):

[  369.398982] wlan0: deauthenticating from 00:26:44:68:e0:6f by local
choice (reason=3)
[  369.399147] wlan0: moving STA 00:26:44:68:e0:6f to state 2
[  369.399150] wlan0: moving STA 00:26:44:68:e0:6f to state 1
[  369.399152] wlan0: moving STA 00:26:44:68:e0:6f to state 0
[  369.401292] cfg80211: Calling CRDA to update world regulatory domain
[  369.405877] cfg80211: World regulatory domain updated:
[  369.405880] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  369.405883] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  369.405885] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  369.405887] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[  369.405889] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  369.405891] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  369.406014] cfg80211: Calling CRDA for country: CA
[  369.407613] cfg80211: Regulatory domain changed to country: CA
[  369.407616] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[  369.407619] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2700 mBm)
[  369.407621] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 1700 mBm)
[  369.407623] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  369.407625] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[  369.407627] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 3000 mBm)
[  371.731744] EXT4-fs (sda6): re-mounted. Opts: user_xattr,commit=0
[  372.488279] PM: Syncing filesystems ... done.
[  372.489375] PM: Preparing system for mem sleep
[  372.564163] Freezing user space processes ... (elapsed 0.01 seconds) done.
[  372.577275] Freezing remaining freezable tasks ... (elapsed 0.01
seconds) done.
[  372.590611] PM: Entering mem sleep
[  372.590679] Suspending console(s) (use no_console_suspend to debug)
[  372.591562] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  372.665867] sd 0:0:0:0: [sda] Stopping disk
[  373.066866] PM: suspend of devices complete after 476.357 msecs
[  373.067057] r8169 0000:05:00.0: wake-up capability enabled by ACPI
[  373.080184] xhci_hcd 0000:04:00.0: wake-up capability enabled by ACPI
[  373.106870] ehci_hcd 0000:00:1d.0: wake-up capability enabled by ACPI
[  373.120272] ehci_hcd 0000:00:1a.0: wake-up capability enabled by ACPI
[  373.146778] PM: late suspend of devices complete after 79.995 msecs
[  373.147102] ACPI: Preparing to enter system sleep state S3
[  373.340070] PM: Saving platform NVS memory
[  373.341546] Disabling non-boot CPUs ...
[  373.343704] CPU 1 is now offline
[  373.446348] CPU 2 is now offline
[  373.448352] CPU 3 is now offline
[  373.450654] CPU 4 is now offline
[  373.552894] CPU 5 is now offline
[  373.656106] CPU 6 is now offline
[  373.657742] CPU 7 is now offline
[  373.657974] Extended CMOS year: 2000
[  373.658347] ACPI: Low-level resume complete
[  373.658391] PM: Restoring platform NVS memory
[  373.658795] Extended CMOS year: 2000
[  373.658818] Enabling non-boot CPUs ...
[  373.658902] Booting Node 0 Processor 1 APIC 0x2
[  373.658904] smpboot cpu 1: start_ip = 99000
[  373.670044] Calibrating delay loop (skipped) already calibrated this CPU
[  373.690386] NMI watchdog enabled, takes one hw-pmu counter.
[  373.690509] CPU1 is up
[  373.690861] Booting Node 0 Processor 2 APIC 0x4
[  373.690863] smpboot cpu 2: start_ip = 99000
[  373.701999] Calibrating delay loop (skipped) already calibrated this CPU
[  373.722383] NMI watchdog enabled, takes one hw-pmu counter.
[  373.722585] CPU2 is up
[  373.722955] Booting Node 0 Processor 3 APIC 0x6
[  373.722957] smpboot cpu 3: start_ip = 99000
[  373.734093] Calibrating delay loop (skipped) already calibrated this CPU
[  373.754545] NMI watchdog enabled, takes one hw-pmu counter.
[  373.754777] CPU3 is up
[  373.755142] Booting Node 0 Processor 4 APIC 0x1
[  373.755144] smpboot cpu 4: start_ip = 99000
[  373.766279] Calibrating delay loop (skipped) already calibrated this CPU
[  373.786723] NMI watchdog enabled, takes one hw-pmu counter.
[  373.786910] CPU4 is up
[  373.787280] Booting Node 0 Processor 5 APIC 0x3
[  373.787282] smpboot cpu 5: start_ip = 99000
[  373.798418] Calibrating delay loop (skipped) already calibrated this CPU
[  373.819008] NMI watchdog enabled, takes one hw-pmu counter.
[  373.819222] CPU5 is up
[  373.819584] Booting Node 0 Processor 6 APIC 0x5
[  373.819586] smpboot cpu 6: start_ip = 99000
[  373.830621] Calibrating delay loop (skipped) already calibrated this CPU
[  373.851273] NMI watchdog enabled, takes one hw-pmu counter.
[  373.851474] CPU6 is up
[  373.851848] Booting Node 0 Processor 7 APIC 0x7
[  373.851850] smpboot cpu 7: start_ip = 99000
[  373.862985] Calibrating delay loop (skipped) already calibrated this CPU
[  373.883756] NMI watchdog enabled, takes one hw-pmu counter.
[  373.883991] CPU7 is up
[  373.891785] ACPI: Waking up from system sleep state S3
[  374.729481] power_supply BAT0: parent PNP0C0A:00 should not be sleeping
[  374.859815] ehci_hcd 0000:00:1a.0: wake-up capability disabled by ACPI
[  374.860133] ehci_hcd 0000:00:1d.0: wake-up capability disabled by ACPI
[  374.860443] xhci_hcd 0000:04:00.0: wake-up capability disabled by ACPI
[  374.860714] PM: early resume of devices complete after 1.101 msecs
[  374.860806] i915 0000:00:02.0: setting latency timer to 64
[  374.860853] ehci_hcd 0000:00:1a.0: setting latency timer to 64
[  374.860925] mei 0000:00:16.0: irq 46 for MSI/MSI-X
[  374.860946] ehci_hcd 0000:00:1d.0: setting latency timer to 64
[  374.860956] ahci 0000:00:1f.2: setting latency timer to 64
[  374.860966] snd_hda_intel 0000:00:1b.0: irq 47 for MSI/MSI-X
[  374.860990] r8169 0000:05:00.0: wake-up capability disabled by ACPI
[  374.861026] usb usb2: root hub lost power or was reset
[  374.861028] usb usb4: root hub lost power or was reset
[  375.168783] usb 1-1.1: reset full-speed USB device number 6 using ehci_hcd
[  375.185288] ata3: SATA link up 1.5 Gbps (SStatus 113 SControl 300)
[  375.187053] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  375.187063] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[  375.189720] ata3.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  375.189730] ata3.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[  375.190353] ata3.00: configured for UDMA/100
[  375.252053] usb 1-1.1: device firmware changed
[  376.623683] ata1: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
[  376.624603] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[  376.624869] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  376.624879] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[  376.626710] ata1.00: ACPI cmd f5/00:00:00:00:00:a0 (SECURITY FREEZE
LOCK) filtered out
[  376.626901] ata1.00: ACPI cmd ef/10:06:00:00:00:a0 (SET FEATURES) succeeded
[  376.626908] ata1.00: ACPI cmd ef/10:03:00:00:00:a0 (SET FEATURES)
filtered out
[  376.627738] ata1.00: configured for UDMA/133
[  376.640442] sd 0:0:0:0: [sda] Starting disk
[  376.664962] PM: resume of devices complete after 1806.201 msecs
[  376.665192] PM: Finishing wakeup.
[  376.665194] Restarting tasks ...
[  376.665590] usb 1-1.1: USB disconnect, device number 6
[  376.668280] done.
[  376.670324] video LNXVIDEO:00: Restoring backlight state
[  376.670620] video LNXVIDEO:01: Restoring backlight state
[  376.733756] usb 1-1.1: new full-speed USB device number 7 using ehci_hcd
[  377.163777] usb 1-1.1: USB disconnect, device number 7
[  377.606044] usb 1-1.1: new full-speed USB device number 8 using ehci_hcd
[  378.303702] EXT4-fs (sda6): re-mounted. Opts: user_xattr,commit=0
[  378.352672] delay: estimated 89, actual 0
[  378.376651] delay: estimated 90, actual 1
[  378.383106] ADDRCONF(NETDEV_UP): wlan0: link is not ready
[  378.525263] r8169 0000:05:00.0: eth0: link down
[  378.525835] ADDRCONF(NETDEV_UP): eth0: link is not ready
[  381.363952] wlan0: authenticate with 00:26:44:68:e0:6f (try 1)
[  381.366409] wlan0: authenticated
[  381.378693] wlan0: associate with 00:26:44:68:e0:6f (try 1)
[  381.381696] wlan0: RX AssocResp from 00:26:44:68:e0:6f (capab=0x411
status=0 aid=2)
[  381.381699] wlan0: associated
[  381.381703] wlan0: moving STA 00:26:44:68:e0:6f to state 1
[  381.381704] wlan0: moving STA 00:26:44:68:e0:6f to state 2
[  381.382379] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
[  381.389476] wlan0: moving STA 00:26:44:68:e0:6f to state 3
[  392.289757] wlan0: no IPv6 routers present


> - Felix

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753024Ab2B0IhG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 03:37:06 -0500
Received: from mx.logic.tuwien.ac.at ([128.130.175.19]:59348 "EHLO
	mx.logic.tuwien.ac.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751704Ab2B0IhE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 03:37:04 -0500
Date: Mon, 27 Feb 2012 17:36:12 +0900
From: Norbert Preining <preining@logic.at>
To: Emmanuel Grumbach <egrumbach@gmail.com>, Pekka Enberg <penberg@kernel.org>
Cc: linux-kernel@vger.kernel.org, ipw3945-devel@lists.sourceforge.net,
        "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        Dave Jones <davej@redhat.com>
Subject: Re: iwlagn is getting even worse with 3.3-rc1
Message-ID: <20120227083612.GA5648@gamma.logic.tuwien.ac.at>
References: <20120125002250.GA20431@gamma.logic.tuwien.ac.at> <CANUX_P0UREz_jZABu+Y_QYOh9tx_sKZSSkZpYHBEVtcU4QQdSA@mail.gmail.com> <20120126003735.GA2346@gamma.logic.tuwien.ac.at> <CANUX_P0H_WaWwnpjoBcMpZQY4xH=cbVhAKxWKXmz-HwFMcWS6w@mail.gmail.com> <CANUX_P3XSCsWUJ9M55qeaK-DuPEMXODFPJiNk+BgnHN-=WECqw@mail.gmail.com> <20120126232555.GB16330@gamma.logic.tuwien.ac.at> <20120127015015.GA23291@gamma.logic.tuwien.ac.at> <CANUX_P3F58upbrw48AiMTV4DDZWsfveYp=mANAD9CQ2bPps0cA@mail.gmail.com> <20120222003747.GA9808@gamma.logic.tuwien.ac.at> <CANUX_P1CN0Ud5ZO4AMcvMSUsrsEABRHkgy42Di45n96mB64Ynw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="huq684BweRXVnRxX"
Content-Disposition: inline
In-Reply-To: <CAOJsxLHoX2WU7xJ8etXsz32B=QhOADvMzBYzsuBR2YXvv44PyA@mail.gmail.com> <CANUX_P1CN0Ud5ZO4AMcvMSUsrsEABRHkgy42Di45n96mB64Ynw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Emmanuel,

sorry for the silence, I wasn't at the university for a few days so
I couldn't test.

Now I did:
kernel 3.3-rc5

On Mi, 22 Feb 2012, Emmanuel Grumbach wrote:
> From the log, I can see that we have a lot of "passive channel
> failures". Can you try to disable 11n (module_parameter) ?
> Please also try with debug=0xc0000000

Disabling 11n and adding this parameter created loads of output, but
still makes the connection break down and reconnection does not work
anymore. I attach a (small) part of the syslog file. I had 
loads *LOADS* (200000+) of messages
	Feb 27 12:58:04 mithrandir kernel: [ 1447.835281] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx Next reclaimed packet:3333
	Feb 27 12:58:04 mithrandir kernel: [ 1447.835294] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 2 | AC 2] 213 -> 214 (470)
in the log. Then there is something about "TX on passive channel"
and from then on everything goes off.

> network. Is the patch supposed to fix Norbert's issue as well?

Apparently not.

Best wishes

Norbert
------------------------------------------------------------------------
Norbert Preining            preining@{jaist.ac.jp, logic.at, debian.org}
JAIST, Japan                                 TeX Live & Debian Developer
DSA: 0x09C5B094   fp: 14DF 2E6C 0307 BE6D AD76  A9C0 D2BF 4AA3 09C5 B094
------------------------------------------------------------------------
FRADDAM (n.)
The small awkward-shaped piece of cheese which remains after grating a
large regular-shaped piece of cheese and enables you to cut your
fingers.
			--- Douglas Adams, The Meaning of Liff

--huq684BweRXVnRxX
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=syslog

Feb 27 12:58:04 mithrandir kernel: [ 1447.835281] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx Next reclaimed packet:3333
Feb 27 12:58:04 mithrandir kernel: [ 1447.835294] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 2 | AC 2] 213 -> 214 (470)
Feb 27 12:58:05 mithrandir kernel: [ 1449.314491] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx Next reclaimed packet:3334
Feb 27 12:58:05 mithrandir kernel: [ 1449.314506] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 2 | AC 2] 214 -> 215 (471)
Feb 27 12:58:06 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:e0 (SSID='JAISTALL' freq=2412 MHz)
Feb 27 12:58:06 mithrandir kernel: [ 1449.501156] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 0 | AC 0] 145 -> 146 (146)
Feb 27 12:58:06 mithrandir kernel: [ 1449.508991] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 0 | AC 0] 146 -> 147 (147)
Feb 27 12:58:06 mithrandir kernel: [ 1449.510261] wlan0: authenticate with 00:24:c4:ab:bd:e0 (try 1)
Feb 27 12:58:06 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: completed -> authenticating
Feb 27 12:58:06 mithrandir kernel: [ 1449.513053] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 0 | AC 0] 147 -> 148 (148)
Feb 27 12:58:06 mithrandir kernel: [ 1449.513071] wlan0: authenticated
Feb 27 12:58:06 mithrandir wpa_supplicant[2113]: Trying to associate with 00:24:c4:ab:bd:e0 (SSID='JAISTALL' freq=2412 MHz)
Feb 27 12:58:06 mithrandir kernel: [ 1449.517823] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 0 | AC 0] 148 -> 149 (149)
Feb 27 12:58:06 mithrandir kernel: [ 1449.517828] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 0 ac 0 stop count 1. Tx on passive channel
Feb 27 12:58:06 mithrandir kernel: [ 1449.517833] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090) rate_n_flags 0x8003 retries 0
Feb 27 12:58:06 mithrandir kernel: [ 1449.517836] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx FrameCnt = 1, idx=148
Feb 27 12:58:06 mithrandir kernel: [ 1449.522519] iwlwifi 0000:06:00.0: U iwl_trans_pcie_wake_any_queue Queue Status: Q[0] stopped
Feb 27 12:58:06 mithrandir kernel: [ 1449.522533] iwlwifi 0000:06:00.0: U iwl_wake_queue Wake hwq 0 ac 0. Disassoc: flush queue
Feb 27 12:58:06 mithrandir kernel: [ 1449.522536] iwlwifi 0000:06:00.0: U iwl_trans_pcie_wake_any_queue Queue Status: Q[1] awake
Feb 27 12:58:06 mithrandir kernel: [ 1449.522539] iwlwifi 0000:06:00.0: U iwl_trans_pcie_wake_any_queue Queue Status: Q[2] awake
Feb 27 12:58:06 mithrandir kernel: [ 1449.522542] iwlwifi 0000:06:00.0: U iwl_trans_pcie_wake_any_queue Queue Status: Q[3] awake
Feb 27 12:58:06 mithrandir kernel: [ 1449.522792] iwlwifi 0000:06:00.0: I iwl_trans_pcie_reclaim [Q 0 | AC 0] 149 -> 150 (150)
Feb 27 12:58:06 mithrandir kernel: [ 1449.522796] iwlwifi 0000:06:00.0: I iwl_stop_queue Stop hwq 0 ac 0 stop count 1. Tx on passive channel
Feb 27 12:58:06 mithrandir kernel: [ 1449.522799] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx TXQ 0 status PASSIVE_NO_RX (0x00000090) rate_n_flags 0x8003 retries 0
Feb 27 12:58:06 mithrandir kernel: [ 1449.522803] iwlwifi 0000:06:00.0: I iwlagn_rx_reply_tx FrameCnt = 1, idx=149
Feb 27 12:58:06 mithrandir kernel: [ 1449.523260] wlan0: moving STA 00:24:c4:ab:bd:ef to state 2
Feb 27 12:58:06 mithrandir kernel: [ 1449.523262] wlan0: moving STA 00:24:c4:ab:bd:ef to state 1
Feb 27 12:58:06 mithrandir kernel: [ 1449.523264] wlan0: moving STA 00:24:c4:ab:bd:ef to state 0
Feb 27 12:58:06 mithrandir kernel: [ 1449.541708] wlan0: associate with 00:24:c4:ab:bd:e0 (try 1)
Feb 27 12:58:06 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: authenticating -> associating
Feb 27 12:58:06 mithrandir kernel: [ 1449.740142] wlan0: associate with 00:24:c4:ab:bd:e0 (try 2)
Feb 27 12:58:06 mithrandir kernel: [ 1449.940086] wlan0: associate with 00:24:c4:ab:bd:e0 (try 3)
Feb 27 12:58:06 mithrandir kernel: [ 1450.140107] wlan0: association with 00:24:c4:ab:bd:e0 timed out
Feb 27 12:58:06 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: associating -> disconnected
Feb 27 12:58:10 mithrandir NetworkManager[2062]: <info> (wlan0): roamed from BSSID 00:24:C4:AB:BD:EF (JAISTALL) to (none) ((none))
Feb 27 12:58:11 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Feb 27 12:58:14 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:58:14 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Feb 27 12:58:14 mithrandir kernel: [ 1457.529919] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:58:14 mithrandir kernel: [ 1457.728113] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:58:14 mithrandir kernel: [ 1457.928111] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:58:14 mithrandir kernel: [ 1458.128084] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <warn> (wlan0): link timed out.
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: activated -> disconnected (reason 'supplicant-timeout') [100 30 11]
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): deactivating device (reason 'supplicant-timeout') [11]
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): canceled DHCP transaction, DHCP client pid 2580
Feb 27 12:58:21 mithrandir dbus[2053]: [system] Activating service name='org.freedesktop.nm_dispatcher' (using servicehelper)
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Auto-activating connection 'Auto JAISTALL'.
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) starting connection 'Auto JAISTALL'
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0/wireless): connection 'Auto JAISTALL' requires no security.  No secrets needed.
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Config: added 'ssid' value 'JAISTALL'
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Config: added 'scan_ssid' value '1'
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Config: added 'key_mgmt' value 'NONE'
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> Config: set interface ap_scan to 1
Feb 27 12:58:21 mithrandir wpa_supplicant[2113]: Failed to initiate AP scan.
Feb 27 12:58:21 mithrandir dbus[2053]: [system] Successfully activated service 'org.freedesktop.nm_dispatcher'
Feb 27 12:58:21 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:58:21 mithrandir kernel: [ 1465.492154] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:58:21 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: disconnected -> authenticating
Feb 27 12:58:22 mithrandir kernel: [ 1465.692131] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:58:22 mithrandir kernel: [ 1465.892106] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:58:22 mithrandir kernel: [ 1466.092096] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:58:23 mithrandir ntpd[3410]: Deleting interface #2 wlan0, 150.65.206.149#123, interface stats: received=95, sent=97, dropped=0, active_time=1394 secs
Feb 27 12:58:23 mithrandir ntpd[3410]: 59.106.180.168 interface 150.65.206.149 -> (none)
Feb 27 12:58:23 mithrandir ntpd[3410]: 133.27.94.149 interface 150.65.206.149 -> (none)
Feb 27 12:58:23 mithrandir ntpd[3410]: 64.73.32.134 interface 150.65.206.149 -> (none)
Feb 27 12:58:23 mithrandir ntpd[3410]: 130.54.208.201 interface 150.65.206.149 -> (none)
Feb 27 12:58:23 mithrandir ntpd[3410]: peers refreshed
Feb 27 12:58:29 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:e0 (SSID='JAISTALL' freq=2412 MHz)
Feb 27 12:58:29 mithrandir kernel: [ 1473.476094] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
Feb 27 12:58:30 mithrandir kernel: [ 1473.676075] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
Feb 27 12:58:30 mithrandir kernel: [ 1473.876092] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
Feb 27 12:58:30 mithrandir kernel: [ 1474.076098] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
Feb 27 12:58:37 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:58:37 mithrandir kernel: [ 1481.475855] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:58:38 mithrandir kernel: [ 1481.672049] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:58:38 mithrandir kernel: [ 1481.872065] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:58:38 mithrandir kernel: [ 1482.072103] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:58:45 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:e0 (SSID='JAISTALL' freq=2412 MHz)
Feb 27 12:58:45 mithrandir kernel: [ 1489.493280] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
Feb 27 12:58:46 mithrandir kernel: [ 1489.692126] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
Feb 27 12:58:46 mithrandir kernel: [ 1489.892101] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <warn> Activation (wlan0/wireless): association took too long, failing activation.
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: config -> failed (reason 'supplicant-timeout') [50 120 11]
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed for access point (JAISTALL)
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed.
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0]
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <info> (wlan0): deactivating device (reason 'none') [0]
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Feb 27 12:58:46 mithrandir NetworkManager[2062]: <warn> Couldn't disconnect supplicant interface: This interface is not connected.
Feb 27 12:58:46 mithrandir kernel: [ 1490.092088] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Auto-activating connection 'Auto JAISTALL'.
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) starting connection 'Auto JAISTALL'
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0/wireless): connection 'Auto JAISTALL' requires no security.  No secrets needed.
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Config: added 'ssid' value 'JAISTALL'
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Config: added 'scan_ssid' value '1'
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Config: added 'key_mgmt' value 'NONE'
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Feb 27 12:58:49 mithrandir NetworkManager[2062]: <info> Config: set interface ap_scan to 1
Feb 27 12:58:51 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Feb 27 12:58:53 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:e0 (SSID='JAISTALL' freq=2412 MHz)
Feb 27 12:58:53 mithrandir kernel: [ 1497.491880] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 1/3)
Feb 27 12:58:53 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Feb 27 12:58:54 mithrandir kernel: [ 1497.688100] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 2/3)
Feb 27 12:58:54 mithrandir kernel: [ 1497.888099] wlan0: direct probe to 00:24:c4:ab:bd:e0 (try 3/3)
Feb 27 12:58:54 mithrandir kernel: [ 1498.088102] wlan0: direct probe to 00:24:c4:ab:bd:e0 timed out
Feb 27 12:59:01 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:01 mithrandir kernel: [ 1505.480761] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:02 mithrandir kernel: [ 1505.680107] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:02 mithrandir kernel: [ 1505.880052] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:02 mithrandir kernel: [ 1506.080094] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:59:09 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:09 mithrandir kernel: [ 1513.472263] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:10 mithrandir kernel: [ 1513.672108] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:10 mithrandir kernel: [ 1513.872102] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:10 mithrandir kernel: [ 1514.072058] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <warn> Activation (wlan0/wireless): association took too long, failing activation.
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: config -> failed (reason 'supplicant-timeout') [50 120 11]
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed for access point (JAISTALL)
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed.
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0]
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <info> (wlan0): deactivating device (reason 'none') [0]
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Feb 27 12:59:14 mithrandir NetworkManager[2062]: <warn> Couldn't disconnect supplicant interface: This interface is not connected.
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Auto-activating connection 'Auto JAISTALL'.
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) starting connection 'Auto JAISTALL'
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0/wireless): connection 'Auto JAISTALL' requires no security.  No secrets needed.
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Config: added 'ssid' value 'JAISTALL'
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Config: added 'scan_ssid' value '1'
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Config: added 'key_mgmt' value 'NONE'
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> Config: set interface ap_scan to 1
Feb 27 12:59:17 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Feb 27 12:59:19 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:19 mithrandir kernel: [ 1523.389933] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:19 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Feb 27 12:59:20 mithrandir kernel: [ 1523.588036] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:20 mithrandir kernel: [ 1523.788073] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:20 mithrandir kernel: [ 1523.988088] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:59:27 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:27 mithrandir kernel: [ 1531.372573] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:28 mithrandir kernel: [ 1531.572044] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:28 mithrandir kernel: [ 1531.772076] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:28 mithrandir kernel: [ 1531.972108] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:59:35 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:35 mithrandir kernel: [ 1539.320474] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:36 mithrandir kernel: [ 1539.520090] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:36 mithrandir kernel: [ 1539.720116] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:36 mithrandir kernel: [ 1539.920106] wlan0: authentication with 00:24:c4:ab:bd:ef timed out
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <warn> Activation (wlan0/wireless): association took too long, failing activation.
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: config -> failed (reason 'supplicant-timeout') [50 120 11]
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed for access point (JAISTALL)
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <warn> Activation (wlan0) failed.
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: failed -> disconnected (reason 'none') [120 30 0]
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <info> (wlan0): deactivating device (reason 'none') [0]
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: authenticating -> disconnected
Feb 27 12:59:42 mithrandir NetworkManager[2062]: <warn> Couldn't disconnect supplicant interface: This interface is not connected.
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Auto-activating connection 'Auto JAISTALL'.
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) starting connection 'Auto JAISTALL'
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: disconnected -> prepare (reason 'none') [30 40 0]
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) scheduled...
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) started...
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) scheduled...
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 1 of 5 (Device Prepare) complete.
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) starting...
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> (wlan0): device state change: prepare -> config (reason 'none') [40 50 0]
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0/wireless): connection 'Auto JAISTALL' requires no security.  No secrets needed.
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Config: added 'ssid' value 'JAISTALL'
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Config: added 'scan_ssid' value '1'
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Config: added 'key_mgmt' value 'NONE'
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Activation (wlan0) Stage 2 of 5 (Device Configure) complete.
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> Config: set interface ap_scan to 1
Feb 27 12:59:45 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: disconnected -> scanning
Feb 27 12:59:47 mithrandir wpa_supplicant[2113]: Trying to authenticate with 00:24:c4:ab:bd:ef (SSID='JAISTALL' freq=5200 MHz)
Feb 27 12:59:47 mithrandir kernel: [ 1551.383928] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 1)
Feb 27 12:59:47 mithrandir NetworkManager[2062]: <info> (wlan0): supplicant interface state: scanning -> authenticating
Feb 27 12:59:48 mithrandir kernel: [ 1551.580048] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 2)
Feb 27 12:59:48 mithrandir kernel: [ 1551.780080] wlan0: authenticate with 00:24:c4:ab:bd:ef (try 3)
Feb 27 12:59:48 mithrandir kernel: [ 1551.980072] wlan0: authentication with 00:24:c4:ab:bd:ef timed out

--huq684BweRXVnRxX--

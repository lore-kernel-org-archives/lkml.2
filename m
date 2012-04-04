Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756179Ab2DDKko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Apr 2012 06:40:44 -0400
Received: from plane.gmane.org ([80.91.229.3]:42329 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756037Ab2DDKkm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Apr 2012 06:40:42 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: "Mantas M." <grawity@gmail.com>
Subject: Re: 3.3.1 ath9k regression
Date: Wed, 04 Apr 2012 13:40:39 +0300
Message-ID: <jlh8eg$gqs$1@dough.gmane.org>
References: <4F7A8EB7.4060200@silka.with-linux.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: 78-60-211-195.static.zebra.lt
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120321 Thunderbird/12.0
In-Reply-To: <4F7A8EB7.4060200@silka.with-linux.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Kelly - use `journalctl -a` or just `dmesg` to get full logs.]

I have a similar bug with Atheros AR9285 on a ASUS K52JT laptop. The
device appears, but refuses to connect to any AP, timing out in less
than a second. (3.3-ARCH did not have this bug.)

dmesg output while trying to connect to an open AP follows.

> # modprobe ath9k
> [  213.662569] ath: EEPROM regdomain: 0x60
> [  213.662574] ath: EEPROM indicates we should expect a direct regpair map
> [  213.662580] ath: Country alpha2 being used: 00
> [  213.662583] ath: Regpair used: 0x60
> [  213.664533] ieee80211 phy1: Selected rate control algorithm 'ath9k_rate_control'
> [  213.666228] Registered led device: ath9k-phy1
> [  213.666255] ieee80211 phy1: Atheros AR9285 Rev:2 mem=0xffffc90022d60000, irq=17

> # ip link set wlan0 up
> [  215.577316] ADDRCONF(NETDEV_UP): wlan0: link is not ready

> # iw wlan0 connect -w cloud
> [  217.667382] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 1)
> [  217.864456] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 2)
> [  218.063975] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 3)
> [  218.263514] wlan0: authentication with 00:23:8e:e1:6c:c8 timed out

> # iw wlan0 connect -w cloud
> [  276.603232] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 1)
> [  276.802003] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 2)
> [  277.001461] wlan0: authenticate with 00:23:8e:e1:6c:c8 (try 3)
> [  277.200945] wlan0: authentication with 00:23:8e:e1:6c:c8 timed out

Using "debug=0xe01" with rmmod/modprobe causes no visible difference.
"pcie_aspm=off" did not help.

`lspci -v` shows the device as:

> 
> 03:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)
>         Subsystem: AzureWave AW-NE785 / AW-NE785H 802.11bgn Wireless Full or Half-size Mini PCIe Card
>         Flags: bus master, fast devsel, latency 0, IRQ 17
>         Memory at d2a00000 (64-bit, non-prefetchable) [size=64K]
>         Capabilities: [40] Power Management version 3
>         Capabilities: [50] MSI: Enable- Count=1/1 Maskable- 64bit-
>         Capabilities: [60] Express Legacy Endpoint, MSI 00
>         Capabilities: [100] Advanced Error Reporting
>         Capabilities: [140] Virtual Channel
>         Capabilities: [160] Device Serial Number 00-15-17-ff-ff-24-14-12
>         Capabilities: [170] Power Budgeting <?>
>         Kernel driver in use: ath9k

-- 
Mantas M. <grawity@gmail.com


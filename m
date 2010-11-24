Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754734Ab0KXNN0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 08:13:26 -0500
Received: from mail.sysgo.com ([195.145.229.155]:54581 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754315Ab0KXNNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 08:13:23 -0500
Date: Wed, 24 Nov 2010 14:13:20 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org
Cc: rudolf.marek@sysgo.com, cko@sysgo.com, mfa@sysgo.com, anl@sysgo.com
Subject: Re: working usb wifi card, that is still possible to buy
Message-ID: <20101124131320.GA2611@pma.sysgo.com>
References: <20101103092431.GA21138@pma.sysgo.com>
 <20101124081616.GA30595@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101124081616.GA30595@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

So, if someone is interested:

"AirLive Wl-1600 USB" & "Netgear wg111" can still be bought, no
firmware needed, rtl8187 driver. 802.11g only.

Bunch of rt2800usb cards is available now, "MSI WLAN 11N US300EX Lite"
does not need staging driver, hardware should support 802.11n, and it
works in 2.6.37-rc3 on i386. I suspect endianness problems in
GET_FIELD(), see below.

I'll try to get the Realtek and Atheros to work.
									Pavel


-*- org -*-

| Marketing name            | USB ID    | driver              | remark                                   |
| -                         |           |                     |                                          |
| DLink DWA-160             | 07d1:3a09 | carl9170 or others  | disconnects randomly under load          |
| AirLive wt-2000usb        | 148f:2573 | rt2500usb+rt73usb   | needs firmware, can not be bought, works |
| AirLive Wl-1600 USB       | 1b75:8187 | rtl8187             | works on fc9, mpc5200b                   |
| Netgear wg111             | 05e3:4260 | rtl8187             | works on fc9, mpc5200b                   |
| PEGATRON WL166N11         | 1d4d:000c | rt2800usb           | works on d37                             | n-lite
| TP-LINK TL-WN321G         | 148f:2070 | rt2800usb           | 802.11g, d32 detects, d37 scans          |
| MSI WLAN 11N US300EX Lite | 148f:3070 | rt2800usb           | works on d37                             | hopefully full 802.11n, 300mbps
| Tenda w311U               | 148f:3070 | rt2800usb+rt2870sta | d32 detects it                           | same as usb IDs as MSI
| edimax ew-7711UMn         | 7392:7711 | rt2800usb+rt2870sta | d32 detects it                           | 5GHz, n-draft
| Canyon CNP-WF518N2        | 0bda:8171 | realtek?            |                                          | mini, 802.11n
| EMTEC Wi350               | 0bda:8172 | realtek?            |                                          |              
| D-Link DWA-131            | 07d1:3303 | realtek?            |                                          |              
| Netgear WPN111            | 1385:5f01 | atheros?            |                                          |              
| TP-Link TL-WN721N         | 0cf3:9271 | atheros?            |                                          |              
| TP-Link TL-WN322G         | 0cf3:1006 | atheros?            |                                          |              

fc9: 2.6.27.25-78.2.56.fc9.i686
mpc5200b: ppc based devel board on 2.6.34-7
d32: Debian 2.6.32-trunk-686
	- rt2800usb driver does not seem to be able to scan on it
d37: Debian with 2.6.37-rc3+ kernel

* DLink DWA-160

DLink with carl9170 driver:

- only supported in 2.6.36-wireless-testing and 2.6.37-rc1
- self disconnect

* AirLive wt-2000usb

- ping sometimes goes to 500msec range (even on same table)

64 bytes from 192.168.2.2: seq=114 ttl=64 time=27.2 ms
64 bytes from 192.168.2.2: seq=115 ttl=64 time=1023.2 ms
64 bytes from 192.168.2.2: seq=116 ttl=64 time=32.2 ms

- long term seems to work ok: 

So far (during single bulk transfer)

--- 192.168.2.3 ping statistics ---
559 packets transmitted, 513 received, 8% packet loss, time 558863ms
rtt min/avg/max/mdev = 11.301/480.135/26952.502/2615.430 ms, pipe 27

64 bytes from 192.168.2.3: icmp_req=891 ttl=64 time=238 ms
64 bytes from 192.168.2.3: icmp_req=892 ttl=64 time=218 ms
^C
--- 192.168.2.3 ping statistics ---
894 packets transmitted, 854 received, 4% packet loss, time 893929ms
rtt min/avg/max/mdev = 1.266/197.493/1169.791/86.623 ms, pipe 2
pavel@pma:~$ 

--- 192.168.2.3 ping statistics ---
340 packets transmitted, 302 received, 11% packet loss, time 339531ms
rtt min/avg/max/mdev = 10.079/196.275/1020.862/82.172 ms, pipe 2

- survived overnight test:

64 bytes from 192.168.2.3: icmp_req=63549 ttl=64 time=216 ms
64 bytes from 192.168.2.3: icmp_req=63550 ttl=64 time=174 ms
^C
--- 192.168.2.3 ping statistics ---
63550 packets transmitted, 59911 received, +212 errors, 5% packet loss, time 63623758ms
rtt min/avg/max/mdev = 1.246/490.418/102617.256/3307.015 ms, pipe 103
pavel@pma:~$ 

* AirLive Wl-1600 USB

- strangely disconnected once
- survived 30 min test

* Tenda w311U
  - claims 802.11n (Draft 2.0)
  - staging driver
    
[509571.148021] usb 3-2: new high speed USB device using ehci_hcd and address 15
[509571.297285] usb 3-2: New USB device found, idVendor=148f, idProduct=3070
[509571.297290] usb 3-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[509571.297293] usb 3-2: Product: 802.11 n WLAN
[509571.297294] usb 3-2: Manufacturer: Ralink
[509571.297296] usb 3-2: SerialNumber: 1.0
[509571.297394] usb 3-2: configuration #1 chosen from 1 choice
[509571.747583] phy1: Selected rate control algorithm 'minstrel'
[509571.748329] Registered led device: rt2800usb-phy1::radio
[509571.748346] Registered led device: rt2800usb-phy1::assoc
[509571.748364] Registered led device: rt2800usb-phy1::quality
[509571.748679] usbcore: registered new interface driver rt2800usb
[509571.780200] rt2870sta: module is from the staging directory, the quality is unknown, you have been warned.
[509571.785834] rtusb init --->

   - GPL firmware?  2010_0709_RT2870_Linux_STA_v2.4.0.1, http://www.ralinktech.com/support.php?s=2
   - mam dobry fw?

  - mpc5200b says:

usb 1-1: new full speed USB device using ppc-of-ohci and address 2
phy0: Selected rate control algorithm 'pid'
phy0: hwaddr 00:4f:78:01:0d:b3, RTL8187vB (default) V1 + rtl8225z2, rfkill mask 2
rtl8187: Customer ID is 0xFF
Registered led device: rtl8187-phy0::radio
Registered led device: rtl8187-phy0::tx
Registered led device: rtl8187-phy0::rx
rtl8187: wireless switch is on
warning: `proftpd' uses 32-bit capabilities (legacy support in use)
phy0: device now idle
phy0: device no longer idle - scanning
PHY: f0003000:00 - Link is Up - 100/Full
phy0: device now idle
usb 1-1: USB disconnect, address 2
usb 1-1: new full speed USB device using ppc-of-ohci and address 3
usb 1-1: USB disconnect, address 3
usb 1-1: new full speed USB device using ppc-of-ohci and address 4
phy1 -> rt2800_init_eeprom: Error - Invalid RF chipset detected.
phy1 -> rt2x00lib_probe_dev: Error - Failed to allocate device.

     


  
* TP-LINK TL-WN321G

   mpc5200b:
-sh-4.1# 
-sh-4.1# usb 1-1: USB disconnect, address 5
usb 1-1: new full speed USB device using ppc-of-ohci and address 6
phy3 -> rt2800_init_eeprom: Error - Invalid RF chipset detected.
phy3 -> rt2x00lib_probe_dev: Error - Failed to allocate device.

Hmm... is byte swapping neccessary?

#define GET_FIELD(__reg, __type, __field)       \
({                                              \
        typecheck(__type, __field);             \
        ((__reg) & ((__field).bit_mask)) >>     \
            ((__field).bit_offset);             \
})

drivers/net/wireless/rt2x00$ less rt2x00reg.h

Works with d37:

[  329.545082] udev[13420]: starting version 164
[  333.030536] lp: driver loaded but no devices found
[  365.598290] usb 2-2: USB disconnect, address 2
[  367.484022] usb 2-2: new high speed USB device using ehci_hcd and address 3
[  367.633390] usb 2-2: New USB device found, idVendor=148f, idProduct=2070
[  367.633442] usb 2-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
[  367.633490] usb 2-2: Product: 802.11 g WLAN
[  367.633535] usb 2-2: Manufacturer: Ralink
[  367.633579] usb 2-2: SerialNumber: 1.0
[  367.652799] cfg80211: Calling CRDA to update world regulatory domain
[  367.699944] ieee80211 phy0: Selected rate control algorithm 'minstrel_ht'
[  367.700495] Registered led device: rt2800usb-phy0::radio
[  367.700515] Registered led device: rt2800usb-phy0::assoc
[  367.700534] Registered led device: rt2800usb-phy0::quality
[  367.700777] usbcore: registered new interface driver rt2800usb
[  367.701332] rt2870sta: module is from the staging directory, the quality is unknown, you have been warned.
[  367.706312] rtusb init --->
[  367.706622] usbcore: registered new interface driver rt2870
[  367.764544] udev[13528]: renamed network interface wlan0 to wlan2
[  416.882482] ADDRCONF(NETDEV_UP): wlan2: link is not ready
pavel@pma:~/bb/trunk/report$ 

...but kills machine after unplug.

* How to test

To test:

nc 192.168.2.2 chargen > /dev/null
ping 192.168.2.3

Compile tests with 2.6.34:

Atmel at76c50x chipset  802.11b support
Atmel at76c503/at76c505/at76c505a USB cards
USB ZD1201 based Wireless device support
Wireless RNDIS USB support
Realtek 8187 and 8187B USB support
Atheros AR9170 802.11n USB support 
	- we know it does not work at all on powerpc
Marvell Libertas 8388 USB 802.11b/g cards
Prism54 USB support
Ralink rt2501/rt73 (USB) support 
       - already tested
Ralink rt2800 (USB) support (EXPERIMENTAL)
rt2800usb - Include support for rt30xx (USB) devices
rt2800usb - Include support for rt35xx (USB) devices
rt2800usb - Include support for unknown (USB) devices
ZyDAS ZD1211/ZD1211B USB-wireless support

...all compile ok.

* ALZA shopping

Tryed to buy 13 cards, one was unavailable:

http://www.alza.cz/msi-us300ex-lite-d135883.htm  (ralink chipset, ??? driver)
http://www.alza.cz/edimax-nmax-ew-7711umn-v3-d166741.htm (nLite, ??? driver)
http://www.alza.cz/edimax-nmax-ew-7717un-d100390.htm (ndraft 2, ??? driver)
http://www.alza.cz/emtec-ekcowi350-mini-d164593.htm (mini, ??? driver)
http://www.alza.cz/w311u-d139111.htm  (???driver)
http://www.alza.cz/bezdratovy-usb-adapter-netgear-wg111-d87276.htm
(netgear, g only, p54usb driver)
http://www.alza.cz/bezdratovy-usb-adapter-netgear-wpn111-rangemax-d87278.htm
(netgear, g only, ??? driver
http://www.alza.cz/prestigio-ion-pc-wifi-dongle-bily-d148563.htm (??? driver)

http://www.alza.cz/d-link-dwa-131-d154446.htm (dlink, mini, ?? driver)
http://www.alza.cz/tp-link-tl-wn721n-lite-d155290.htm (tplink, ath9k_htc driver)
http://www.alza.cz/tp-link-tl-wn322g-d185161.htm (tplink, g only, ?? driver)
http://www.alza.cz/ovislink-airlive-wl-1600usb-d118619.htm (ovislink
airlive, g only, ?? driver)
http://www.alza.cz/canyon-cnp-wf518n2-d158786.htm (mini, zd121rw
driver)
http://www.alza.cz/tp-link-tl-wn321g-d155287.htm (this one should have
same chipset as AirLive wt-2000USB and thus should work reasonably).

Ta chodici airlive:
rt2500usb driver
	  0x148f 0x2573

http://www.alza.cz/tp-link-tl-wn321g-d155287.htm:



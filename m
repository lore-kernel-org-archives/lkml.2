Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0KXJmW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 04:42:22 -0500
Received: from ns.hanzlici.cz ([212.158.159.56]:52784 "EHLO hanzlici.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752576Ab0KXJmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 04:42:20 -0500
Message-ID: <4CECDDF0.8080500@hanzlici.cz>
Date: Wed, 24 Nov 2010 10:42:08 +0100
From: Frantisek Hanzlik <franta@hanzlici.cz>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0b8pre) Gecko/20101122 Firefox/4.0b8pre SeaMonkey/2.1b2pre
MIME-Version: 1.0
To: Dan Carpenter <error27@gmail.com>, LKML <linux-kernel@vger.kernel.org>,
        Andrea Merello <andreamrl@tiscali.it>,
        Michael Wu <flamingice@sourmilk.net>, linux-wireless@vger.kernel.org
Subject: Re: rtl8180 freeze some i386 systems
References: <4CEBA51C.5010604@hanzlici.cz> <20101123122500.GD8882@bicker>
In-Reply-To: <20101123122500.GD8882@bicker>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.5 (hanzlici.cz [192.168.1.254]); Wed, 24 Nov 2010 10:42:09 +0100 (CET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan Carpenter wrote:
> I added linux-wireless to the CC list.
> 
> If you're on the terminal is anything printed to the screen when the
> system hangs?  echo 7 7 7 7 > /proc/sys/kernel/printk first to get more
> messages.
> 
> If you create a bugzilla entry then you can take a digital photo of
> the messages and attach it to your bug report.  (Although bugzilla is
> crapping out today so you probably can't do that actually).
> 
> regards,
> dan carpenter
> 
> On Tue, Nov 23, 2010 at 12:27:24PM +0100, Frantisek Hanzlik wrote:
>> On two PCs with Fedora 14/i386 these systems freezes just after command
>> "ip link set wlan0 up" was entered.
>> "freezes" meant system is totally unuseable, ping to LAN interface
>> hasn't reply, kbd/mouse not work, only way is HW reset/power off.
>>
>> This hang occurs always independently on system runlevel: when switch to
>> runlevel 1, when only kernel threads + udev + root bash are active,
>> system still hangs.
>> Systems hangs on all tested kernels 2.6.34, 2.6.35.9 and 2.6.36.
>> Systems hangs with implicit cmdline and too when using "nomodeset",
>> "acpi=noirq", "acpi=off", "pci=biosirq", "pci=routeirq", "pci=noacpi"
>> parameters.
>>
>> I have two Zyxel "G-302 v3" wifi adapters reported as RTL 8185 rev 20
>> (10ec:8185), which on other two PCs with F1{3,4}/i386 and same config
>> works well.
>>
>> Can someone help with? Is some general method for solving this issue?
>>
>> Thank in advance, Franta Hanzlik

Hello Dan,
thank for recommendations. Unfortunately I have no output on terminal
(even if printk is set to "7 7 7 7"), systems hangs without any signs.

Some more refines:
- both PCs are older machines:
1) Gigabyte GA-8SQ800 Ultra MB SiS655 and  SiS 963 chipset/1GB DDR
266/P4 2.4GHz family 15 model 2/Award BIOS from 2003 year
2) Fujitsu SCENIC T, D1381 MB 845G and 801(ICH4) chipset/512MG DDR
400/P4 2.0GHz family 15 model 2/Phoenix BIOS from 2003 yr

- iwconfig commands (mode,essid,txpower,channel) seems working

- rmmod rtl8180 && modprobe rtl8180 seems working too (in one case PC
hung, but it was in runlevel 5, therefore may be some interaction with
NetworkManager? etc.) with output as (dmesg part):
[   15.598635] cfg80211: Calling CRDA for country: CZ
[   15.605476] cfg80211: Regulatory domain changed to country: CZ
[   15.605643]     (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[   15.605916]     (2400000 KHz - 2483500 KHz @ 40000 KHz), (N/A, 2000 mBm)
[   15.606096]     (5150000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   15.606258]     (5250000 KHz - 5350000 KHz @ 40000 KHz), (N/A, 2301 mBm)
[   15.606416]     (5470000 KHz - 5725000 KHz @ 40000 KHz), (N/A, 3000 mBm)
[   17.339649] EXT4-fs (sda2): re-mounted. Opts: acl,user_xattr
[   18.546096] Adding 767996k swap on /dev/sda1.  Priority:-1 extents:1
across:767996k
[   19.281947] p4-clockmod: P4/Xeon(TM) CPU On-Demand Clock Modulation
available
[   30.188301] rtl8180 0000:02:05.0: PCI INT A disabled
[   40.025122] rtl8180 0000:02:05.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   40.144551] phy1: Selected rate control algorithm 'minstrel_ht'
[   40.145706] phy1: hwaddr 0023f86f0a39, RTL8185vD + rtl8225
[   54.872309] rtl8180 0000:02:05.0: PCI INT A disabled
[   59.033193] rtl8180 0000:02:05.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[   59.152603] phy2: Selected rate control algorithm 'minstrel_ht'
[   59.153739] phy2: hwaddr 0023f86f0a39, RTL8185vD + rtl8225
[   70.972359] rtl8180 0000:02:05.0: PCI INT A disabled
[  234.268155] rtl8180 0000:02:05.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[  234.387605] phy3: Selected rate control algorithm 'minstrel_ht'
[  234.388820] phy3: hwaddr 0023f86f0a39, RTL8185vD + rtl8225
[  306.957133] rtl8180 0000:02:05.0: PCI INT A disabled
[  312.642921] rtl8180 0000:02:05.0: PCI INT A -> GSI 17 (level, low) ->
IRQ 17
[  312.762513] phy4: Selected rate control algorithm 'minstrel_ht'
[  312.763656] phy4: hwaddr 0023f86f0a39, RTL8185vD + rtl8225



- "ip link show wlan0" probably always work, with output as
3: wlan0: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
    link/ether 00:23:f8:6f:0a:39 brd ff:ff:ff:ff:ff:ff

- "ip link set wlan0 up" cause system freeze - on FSC HW at 2) above it
freeze always. Surprisingly on HW 1) is this command sometimes
successful and machine isn't locking - but it occurs cca in one case
from ten tries, in nine cases PC hang too. And in case when PC outlive,
subsequent command "ip link set wlan0 down" freeze machine (probably always)

- put wlan card into other PCI slot not solve anything
- clear CMOS or reset ESCD PNP data in BIOS not solve anything

- when i tried several Ethernet LAN cards in PCI slots, they was working

- PCI Linksys WMP600N WiFi card (RaLink RT2800 chipset, rt2800pci
driver) work on there two PCs.

Please any suggestion? Can I send any other important information or do
some other things?

Thanks, Franta Hanzlik

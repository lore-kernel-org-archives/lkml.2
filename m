Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759366Ab2GMDSL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 23:18:11 -0400
Received: from rtits2.realtek.com ([60.250.210.242]:35907 "EHLO
	rtits2.realtek.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752538Ab2GMDSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 23:18:09 -0400
X-SpamFilter-By: BOX Solutions SpamTrap 5.19 with qID q6D3I10f001347, This message is released by code: ctlocs8528
From: hayeswang <hayeswang@realtek.com>
To: "'Francois Romieu'" <romieu@fr.zoreil.com>
CC: <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <1342009916-1519-1-git-send-email-hayeswang@realtek.com> <20120711220045.GA8913@electric-eye.fr.zoreil.com> <20120712221453.GA1982@electric-eye.fr.zoreil.com>
Subject: RE: [PATCH net-next] r8169: Remove rtl_ocpdr_cond
Date: Fri, 13 Jul 2012 11:17:59 +0800
Message-ID: <33C8D1BCFFFF487FB7BC207EA9087C2E@realtek.com.tw>
MIME-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPart_000_000C_01CD60E9.28EEAF70"
X-Mailer: Microsoft Office Outlook 11
Thread-Index: Ac1gfXa8y8MnV3ZwRE2PYFPteaTXyAAIjJAg
In-Reply-To: <20120712221453.GA1982@electric-eye.fr.zoreil.com>
X-MimeOLE: Produced By Microsoft MimeOLE V6.00.2900.6157
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

------=_NextPart_000_000C_01CD60E9.28EEAF70
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

 Francois Romieu [mailto:romieu@fr.zoreil.com] 
[...]
> 
> W/o firmware does not seem to make a difference.
> 
> # ping -qf -l 4 -s 81 -c 60 10.0.3.1
> PING 10.0.3.1 (10.0.3.1) 81(109) bytes of data.
> 
> --- 10.0.3.1 ping statistics ---
> 60 packets transmitted, 60 received, 0% packet loss, time 153ms
> rtt min/avg/max/mdev = 0.047/0.064/0.117/0.016 ms, pipe 4, 
> ipg/ewma 2.607/0.058 ms

# ping -qf -l 4 -s 81 -c 60 192.168.94.20
PING 192.168.94.20 (192.168.94.20) 81(109) bytes of data.

--- 192.168.94.20 ping statistics ---
60 packets transmitted, 57 received, 5% packet loss, time 1ms
rtt min/avg/max/mdev = 0.028/0.040/0.101/0.011 ms, pipe 4, ipg/ewma 0.021/0.035
ms

> # ping -qf -l 4 -s 82 -c 60 10.0.3.1                          
>                            
> PING 10.0.3.1 (10.0.3.1) 82(110) bytes of data.
> 
> --- 10.0.3.1 ping statistics ---
> 60 packets transmitted, 60 received, 0% packet loss, time 3ms
> rtt min/avg/max/mdev = 0.195/0.210/0.281/0.018 ms, pipe 4, 
> ipg/ewma 0.057/0.205 ms

# ping -qf -l 4 -s 82 -c 60 192.168.94.20
PING 192.168.94.20 (192.168.94.20) 82(110) bytes of data.

--- 192.168.94.20 ping statistics ---
60 packets transmitted, 60 received, 0% packet loss, time 2ms
rtt min/avg/max/mdev = 0.151/0.173/0.247/0.020 ms, pipe 4, ipg/ewma 0.048/0.168
ms

> It would translate into a 127/128 cutoff after inclusion of the FCS.
> 
> Any idea ?
> 

The attatched file is my log. It seems fine.

------=_NextPart_000_000C_01CD60E9.28EEAF70
Content-Type: application/octet-stream; name="a.log"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment; filename="a.log"

# ifconfig p33p1=0A=
p33p1: flags=3D4163<UP,BROADCAST,RUNNING,MULTICAST>  mtu 1500=0A=
        inet 192.168.94.33  netmask 255.255.255.0  broadcast =
192.168.94.255=0A=
        inet6 fe80::2e0:4cff:fe68:ee1c  prefixlen 64  scopeid 0x20<link>=0A=
        ether 00:e0:4c:68:ee:1c  txqueuelen 1000  (Ethernet)=0A=
        RX packets 190  bytes 23670 (23.1 KiB)=0A=
        RX errors 0  dropped 0  overruns 0  frame 0=0A=
        TX packets 226  bytes 28381 (27.7 KiB)=0A=
        TX errors 0  dropped 0 overruns 0  carrier 0  collisions 0=0A=
=0A=
# ethtool -i p33p1=0A=
driver: r8169=0A=
version: 2.3LK-NAPI=0A=
firmware-version: =0A=
bus-info: 0000:04:00.0=0A=
supports-statistics: yes=0A=
supports-test: no=0A=
supports-eeprom-access: no=0A=
supports-register-dump: yes=0A=
supports-priv-flags: no=0A=
=0A=
# dmesg | tail -n 20=0A=
[   15.091451] NET: Registered protocol family 31=0A=
[   15.091454] Bluetooth: HCI device and connection manager initialized=0A=
[   15.091457] Bluetooth: HCI socket layer initialized=0A=
[   15.091460] Bluetooth: L2CAP socket layer initialized=0A=
[   15.091466] Bluetooth: SCO socket layer initialized=0A=
[   15.132905] Bluetooth: BNEP (Ethernet Emulation) ver 1.3=0A=
[   15.132910] Bluetooth: BNEP filters: protocol multicast=0A=
[   25.106009] em1: no IPv6 routers present=0A=
[   45.489144] r8169 Gigabit Ethernet driver 2.3LK-NAPI loaded=0A=
[   45.491423] r8169 0000:04:00.0: irq 47 for MSI/MSI-X=0A=
[   45.491854] r8169 0000:04:00.0: eth0: RTL8168g/8111g at 0xf7e86000, =
00:e0:4c:68:ee:1c, XID 0c000800 IRQ 47=0A=
[   45.491859] r8169 0000:04:00.0: eth0: jumbo features [frames: 9200 =
bytes, tx checksumming: ko]=0A=
[   45.767173] udevd[400]: renamed network interface eth0 to p33p1=0A=
[   45.849390] r8169 0000:04:00.0: p33p1: unable to load firmware patch =
rtl_nic/rtl8168g-1.fw (-2)=0A=
[   45.852564] r8169 0000:04:00.0: p33p1: link down=0A=
[   45.852602] r8169 0000:04:00.0: p33p1: link down=0A=
[   45.852743] ADDRCONF(NETDEV_UP): p33p1: link is not ready=0A=
[   48.719667] r8169 0000:04:00.0: p33p1: link up=0A=
[   48.719803] ADDRCONF(NETDEV_CHANGE): p33p1: link becomes ready=0A=
[   59.330009] p33p1: no IPv6 routers present=0A=
=0A=
# ping -qf -l 4 -s 81 -c 60 192.168.94.20=0A=
PING 192.168.94.20 (192.168.94.20) 81(109) bytes of data.=0A=
=0A=
--- 192.168.94.20 ping statistics ---=0A=
60 packets transmitted, 57 received, 5% packet loss, time 1ms=0A=
rtt min/avg/max/mdev =3D 0.028/0.040/0.101/0.011 ms, pipe 4, ipg/ewma =
0.021/0.035 ms=0A=
=0A=
# ping -qf -l 4 -s 82 -c 60 192.168.94.20=0A=
PING 192.168.94.20 (192.168.94.20) 82(110) bytes of data.=0A=
=0A=
--- 192.168.94.20 ping statistics ---=0A=
60 packets transmitted, 60 received, 0% packet loss, time 2ms=0A=
rtt min/avg/max/mdev =3D 0.151/0.173/0.247/0.020 ms, pipe 4, ipg/ewma =
0.048/0.168 ms=0A=

------=_NextPart_000_000C_01CD60E9.28EEAF70--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932310Ab1DGCLu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 22:11:50 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:54969 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757013Ab1DGCLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 22:11:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:from:date:message-id:subject:to:content-type;
        b=bDGhBECx4cTOAd+iN+XrHzwZvf3tofyxdMTjZRRodPiBNnzuE0jKfi8g714/unIhxf
         gov062EBCYCsbOhIiSsxg37Js34FVBTO9U2XKjF8ToYsUZqVcE1qYvxkF33RfvrW+0Qx
         zsXNYQ8PXHmBuO80rpBALimYcU7uQxp0q3s5Q=
MIME-Version: 1.0
From: Gottfried Haider <gottfried.haider@gmail.com>
Date: Thu, 7 Apr 2011 04:11:27 +0200
Message-ID: <BANLkTim8anqNv4MEaxCTyC8HyOZp2x=ixQ@mail.gmail.com>
Subject: [Regression] USB tethering does not work anymore in 2.6.29-rc2
 (rndis_host, does not receive DHCP offer anymore)
To: linux-kernel@vger.kernel.org, linux-net@vger.kernel.org,
        linux-usb@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

I am using an Android phone connected over USB to connect to the
internet. Something in -rc2 broke this, as I am not getting
connections through NetworkManager anymore (it doesn't receive a
DHCPOFFER anymore and times out).

This does work on the -rc1 kernel and is 100% reproducible here (same
USB port, rebooting the phone between tries).


dmesg is about the same in both cases (the usb-storage is here as the
phone frist tries to act as a mass storage device after connect and I
have to manually activate a checkbox to switch to tethering
functionality):

[  235.150385] usb 1-3: new high speed USB device number 3 using ehci_hcd
[  235.320523] scsi2 : usb-storage 1-3:1.0
[  235.801209] usb 1-3: USB disconnect, device number 3
[  236.200390] usb 1-3: new high speed USB device number 4 using ehci_hcd
[  236.452982] usbcore: registered new interface driver cdc_ether
[  236.473241] rndis_host 1-3:1.0: usb0: register 'rndis_host' at
usb-0000:00:12.2-3, RNDIS device, 06:0f:e2:6a:61:cd
[  236.474151] usbcore: registered new interface driver rndis_host
[  236.487433] usbcore: registered new interface driver rndis_wlan
[  246.850094] usb0: no IPv6 routers present


lspci is at http://sukzessiv.net/x120e , let me know if you need any more info.

cheers,
gohai



Below the full NetworkMonitor output of the working (-rc1) case and
below the failing (-rc2) one. I noticed the different ifindex in line
two, but other than that I don't see any difference except the
obviously missing DHCPOFFER.

-- begin working (-rc1) --
NetworkManager[1958]: <info> (usb0): carrier is OFF
NetworkManager[1958]: <info> (usb0): new Ethernet device (driver:
'rndis_host' ifindex: 5)
NetworkManager[1958]: <info> (usb0): exported as
/org/freedesktop/NetworkManager/Devices/2
NetworkManager[1958]: <info> (usb0): now managed
NetworkManager[1958]: <info> (usb0): device state change: 1 -> 2 (reason 2)
NetworkManager[1958]: <info> (usb0): bringing up device.
NetworkManager[1958]: <info> (usb0): preparing device.
NetworkManager[1958]: <info> (usb0): deactivating device (reason: 2).
NetworkManager[1958]: <info> Added default wired connection 'Auto
usb0' for /sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0
NetworkManager[1958]: <info> (usb0): carrier now ON (device state 2)
NetworkManager[1958]: <info> (usb0): device state change: 2 -> 3 (reason 40)
NetworkManager[1958]:    SCPlugin-Ifupdown: devices added (path:
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0, iface:
usb0)
NetworkManager[1958]:    SCPlugin-Ifupdown: device added (path:
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0, iface:
usb0): no ifupdown configuration found.
NetworkManager[1958]: <info> Activation (usb0) starting connection 'Auto usb0'
NetworkManager[1958]: <info> (usb0): device state change: 3 -> 4 (reason 0)
NetworkManager[1958]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) scheduled...
NetworkManager[1958]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) started...
NetworkManager[1958]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) scheduled...
NetworkManager[1958]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) complete.
NetworkManager[1958]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) starting...
NetworkManager[1958]: <info> (usb0): device state change: 4 -> 5 (reason 0)
NetworkManager[1958]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) successful.
NetworkManager[1958]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) scheduled.
NetworkManager[1958]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) complete.
NetworkManager[1958]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) started...
NetworkManager[1958]: <info> (usb0): device state change: 5 -> 7 (reason 0)
NetworkManager[1958]: <info> Activation (usb0) Beginning DHCPv4
transaction (timeout in 45 seconds)
NetworkManager[1958]: <info> dhclient started with pid 2030
NetworkManager[1958]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) complete.
Internet Systems Consortium DHCP Client 4.1.1-P1
Copyright 2004-2010 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

NetworkManager[1958]: <info> (usb0): DHCPv4 state changed nbi -> preinit
Listening on LPF/usb0/3e:fd:8f:24:d4:25
Sending on   LPF/usb0/3e:fd:8f:24:d4:25
Sending on   Socket/fallback
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 3
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 5
DHCPOFFER of 192.168.42.47 from 192.168.42.129
DHCPREQUEST of 192.168.42.47 on usb0 to 255.255.255.255 port 67
DHCPACK of 192.168.42.47 from 192.168.42.129
NetworkManager[1958]: <info> (usb0): DHCPv4 state changed preinit -> bound
NetworkManager[1958]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Get) scheduled...
NetworkManager[1958]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Get) started...
NetworkManager[1958]: <info>   address 192.168.42.47
NetworkManager[1958]: <info>   prefix 24 (255.255.255.0)
NetworkManager[1958]: <info>   gateway 192.168.42.129
NetworkManager[1958]: <info>   hostname 'x120e'
NetworkManager[1958]: <info>   nameserver '192.168.42.129'
bound to 192.168.42.47 -- renewal in 1587 seconds.
NetworkManager[1958]: <info> Scheduling stage 5
NetworkManager[1958]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) scheduled...
NetworkManager[1958]: <info> Done scheduling stage 5
NetworkManager[1958]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Get) complete.
NetworkManager[1958]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) started...
NetworkManager[1958]: <info> (usb0): device state change: 7 -> 8 (reason 0)
NetworkManager[1958]: <info> Policy set 'Auto usb0' (usb0) as default
for IPv4 routing and DNS.
NetworkManager[1958]: <info> Activation (usb0) successful, device activated.
NetworkManager[1958]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) complete.
-- end working (-rc1) --

-- begin fail (-rc2) --
NetworkManager[2541]: <info> (usb0): carrier is OFF
NetworkManager[2541]: <info> (usb0): new Ethernet device (driver:
'rndis_host' ifindex: 6)
NetworkManager[2541]: <info> (usb0): exported as
/org/freedesktop/NetworkManager/Devices/2
NetworkManager[2541]: <info> (usb0): now managed
NetworkManager[2541]: <info> (usb0): device state change: 1 -> 2 (reason 2)
NetworkManager[2541]: <info> (usb0): bringing up device.
NetworkManager[2541]: <info> (usb0): preparing device.
NetworkManager[2541]: <info> (usb0): deactivating device (reason: 2).
NetworkManager[2541]: <info> Added default wired connection 'Auto
usb0' for /sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0
NetworkManager[2541]: <info> (usb0): carrier now ON (device state 2)
NetworkManager[2541]: <info> (usb0): device state change: 2 -> 3 (reason 40)
NetworkManager[2541]:    SCPlugin-Ifupdown: devices added (path:
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0, iface:
usb0)
NetworkManager[2541]:    SCPlugin-Ifupdown: device added (path:
/sys/devices/pci0000:00/0000:00:12.2/usb1/1-3/1-3:1.0/net/usb0, iface:
usb0): no ifupdown configuration found.
NetworkManager[2541]: <info> Activation (usb0) starting connection 'Auto usb0'
NetworkManager[2541]: <info> (usb0): device state change: 3 -> 4 (reason 0)
NetworkManager[2541]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) scheduled...
NetworkManager[2541]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) started...
NetworkManager[2541]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) scheduled...
NetworkManager[2541]: <info> Activation (usb0) Stage 1 of 5 (Device
Prepare) complete.
NetworkManager[2541]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) starting...
NetworkManager[2541]: <info> (usb0): device state change: 4 -> 5 (reason 0)
NetworkManager[2541]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) successful.
NetworkManager[2541]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) scheduled.
NetworkManager[2541]: <info> Activation (usb0) Stage 2 of 5 (Device
Configure) complete.
NetworkManager[2541]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) started...
NetworkManager[2541]: <info> (usb0): device state change: 5 -> 7 (reason 0)
NetworkManager[2541]: <info> Activation (usb0) Beginning DHCPv4
transaction (timeout in 45 seconds)
NetworkManager[2541]: <info> dhclient started with pid 2609
NetworkManager[2541]: <info> Activation (usb0) Stage 3 of 5 (IP
Configure Start) complete.
Internet Systems Consortium DHCP Client 4.1.1-P1
Copyright 2004-2010 Internet Systems Consortium.
All rights reserved.
For info, please visit https://www.isc.org/software/dhcp/

NetworkManager[2541]: <info> (usb0): DHCPv4 state changed nbi -> preinit
Listening on LPF/usb0/06:eb:ae:9f:5d:5d
Sending on   LPF/usb0/06:eb:ae:9f:5d:5d
Sending on   Socket/fallback
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 3
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 4
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 5
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 13
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 18
DHCPDISCOVER on usb0 to 255.255.255.255 port 67 interval 14
NetworkManager[2541]: <warn> (usb0): DHCPv4 request timed out.
NetworkManager[2541]: <info> (usb0): canceled DHCP transaction, DHCP
client pid 2609
NetworkManager[2541]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Timeout) scheduled...
NetworkManager[2541]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Timeout) started...
NetworkManager[2541]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) scheduled...
NetworkManager[2541]: <info> Activation (usb0) Stage 4 of 5 (IP4
Configure Timeout) complete.
NetworkManager[2541]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) started...
NetworkManager[2541]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) failed (no IP configuration found)
NetworkManager[2541]: <info> (usb0): device state change: 7 -> 9 (reason 5)
NetworkManager[2541]: <info> Marking connection 'Auto usb0' invalid.
NetworkManager[2541]: <warn> Activation (usb0) failed.
NetworkManager[2541]: <info> Activation (usb0) Stage 5 of 5 (IP
Configure Commit) complete.
NetworkManager[2541]: <info> (usb0): device state change: 9 -> 3 (reason 0)
NetworkManager[2541]: <info> (usb0): deactivating device (reason: 0).
-- end fail (-rc2) --

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756778Ab0GWUTM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 16:19:12 -0400
Received: from gherkin.frus.com ([192.158.254.49]:38780 "EHLO gherkin.frus.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751885Ab0GWUTK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 16:19:10 -0400
X-Greylist: delayed 1291 seconds by postgrey-1.27 at vger.kernel.org; Fri, 23 Jul 2010 16:19:10 EDT
Date: Fri, 23 Jul 2010 14:57:36 -0500
From: Bob Tracy <rct@gherkin.frus.com>
To: linux-kernel@vger.kernel.org
Cc: linux-net@vger.kernel.org
Subject: [BUG] dm9601 driver won't init device properly
Message-ID: <20100723195736.GA4321@gherkin.frus.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've got one of the inexpensive Davicom DM9601 USB to fast Ethernet
devices, commonly available on eBay for under $10 including shipping.
It works fairly well in a WinXP environment with a MTU of 1000: 1500
and 1492 are confirmed not working, and values between 1000 and 1492
have not been tested at this point.

With Kubuntu (lucid) running 2.6.32-24-generic, the device is correctly
detected (the reported MAC address may not be correct -- I need to check
against the value reported for WinXP), but the driver typically sets it
to 10 Mb, half-duplex mode where the expected mode is 100 Mb, full-duplex.
DHCP fails to assign an address, and I sometimes see transmit timeouts.

Here is the presumed relevant portion of /var/log/syslog ("messages" and
"debug" didn't have anything not also in "syslog"):

Jul 23 13:57:26 no1nozit kernel: [ 1182.700192] usb 5-2: new full speed USB device using uhci_hcd and address 6
Jul 23 13:57:26 no1nozit kernel: [ 1182.884560] usb 5-2: configuration #1 chosen from 1 choice
Jul 23 13:57:26 no1nozit kernel: [ 1182.910095] eth2: register 'dm9601' at usb-0000:00:1d.0-2, Davicom DM9601 USB Ethernet, 04:00:06:04:06:e0
Jul 23 13:57:26 no1nozit NetworkManager:    SCPlugin-Ifupdown: devices added (path: /sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/net/eth2, iface: eth2)
Jul 23 13:57:26 no1nozit NetworkManager:    SCPlugin-Ifupdown: device added (path: /sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/net/eth2, iface: eth2): no ifupdown configuration found.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): carrier is OFF
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): new Ethernet device (driver: 'dm9601')
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): exported as /org/freedesktop/NetworkManager/Devices/6
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): now managed
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): device state change: 1 -> 2 (reason 2)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): bringing up device.
Jul 23 13:57:31 no1nozit kernel: [ 1187.930326] eth2: link down
Jul 23 13:57:31 no1nozit kernel: [ 1187.936850] ADDRCONF(NETDEV_UP): eth2: link is not ready
Jul 23 13:57:31 no1nozit kernel: [ 1187.937189] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.938199] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.938921] ADDRCONF(NETDEV_CHANGE): eth2: link becomes ready
Jul 23 13:57:31 no1nozit kernel: [ 1187.939187] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.940191] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.941189] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): preparing device.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): deactivating device (reason: 2).
Jul 23 13:57:31 no1nozit kernel: [ 1187.942189] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.943189] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit kernel: [ 1187.944188] dm_write_async_callback() failed with -71
Jul 23 13:57:31 no1nozit NetworkManager: Added default wired connection 'Auto eth2' for /sys/devices/pci0000:00/0000:00:1d.0/usb5/5-2/5-2:1.0/net/eth2
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): carrier now ON (device state 2)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): device state change: 2 -> 3 (reason 40)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) starting connection 'Auto eth2'
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): device state change: 3 -> 4 (reason 0)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 1 of 5 (Device Prepare) scheduled...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 1 of 5 (Device Prepare) started...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 2 of 5 (Device Configure) scheduled...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 1 of 5 (Device Prepare) complete.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 2 of 5 (Device Configure) starting...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): device state change: 4 -> 5 (reason 0)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 2 of 5 (Device Configure) successful.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 3 of 5 (IP Configure Start) scheduled.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 2 of 5 (Device Configure) complete.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 3 of 5 (IP Configure Start) started...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  (eth2): device state change: 5 -> 7 (reason 0)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Beginning DHCP transaction (timeout in 45 seconds)
Jul 23 13:57:31 no1nozit NetworkManager: <info>  dhclient started with pid 3033
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 4 of 5 (IP6 Configure Get) scheduled...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 3 of 5 (IP Configure Start) complete.
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 4 of 5 (IP6 Configure Get) started...
Jul 23 13:57:31 no1nozit NetworkManager: <info>  Activation (eth2) Stage 4 of 5 (IP6 Configure Get) complete.
Jul 23 13:57:31 no1nozit dhclient: Internet Systems Consortium DHCP Client V3.1.3
Jul 23 13:57:31 no1nozit dhclient: Copyright 2004-2009 Internet Systems Consortium.
Jul 23 13:57:31 no1nozit dhclient: All rights reserved.
Jul 23 13:57:31 no1nozit dhclient: For info, please visit https://www.isc.org/software/dhcp/
Jul 23 13:57:31 no1nozit dhclient: 
Jul 23 13:57:31 no1nozit kernel: [ 1187.956195] eth2: link up, 10Mbps, half-duplex, lpa 0xF813
Jul 23 13:57:31 no1nozit NetworkManager: <info>  DHCP: device eth2 state changed normal exit -> preinit
Jul 23 13:57:31 no1nozit dhclient: Listening on LPF/eth2/04:00:06:04:06:e0
Jul 23 13:57:31 no1nozit dhclient: Sending on   LPF/eth2/04:00:06:04:06:e0
Jul 23 13:57:31 no1nozit dhclient: Sending on   Socket/fallback
Jul 23 13:57:33 no1nozit avahi-daemon[922]: Registering new address record for fe80::600:6ff:fe04:6e0 on eth2.*.
Jul 23 13:57:35 no1nozit dhclient: DHCPDISCOVER on eth2 to 255.255.255.255 port 67 interval 3
Jul 23 13:57:38 no1nozit dhclient: DHCPDISCOVER on eth2 to 255.255.255.255 port 67 interval 5
Jul 23 13:57:41 no1nozit kernel: [ 1197.264270] usb 5-2: USB disconnect, address 6
Jul 23 13:57:41 no1nozit kernel: [ 1197.266525] eth2: unregister 'dm9601' usb-0000:00:1d.0-2, Davicom DM9601 USB Ethernet
Jul 23 13:57:41 no1nozit NetworkManager: <info>  (eth2): carrier now OFF (device state 7, deferring action for 4 seconds)
Jul 23 13:57:41 no1nozit avahi-daemon[922]: Withdrawing address record for fe80::600:6ff:fe04:6e0 on eth2.
Jul 23 13:57:41 no1nozit dhclient: receive_packet failed on eth2: Network is down

Any assistance getting this adapter working under Linux would be
greatly appreciated.  As always, thanks in advance.

--Bob

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752715Ab1LSShP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 13:37:15 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:46250 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752037Ab1LSShN convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 13:37:13 -0500
MIME-Version: 1.0
In-Reply-To: <1324280623.19383.8.camel@igor-pc.lan>
References: <1324280623.19383.8.camel@igor-pc.lan>
Date: Mon, 19 Dec 2011 10:37:13 -0800
X-Google-Sender-Auth: TnfxVlsHVpYXUiUwEb4p2TJyqoc
Message-ID: <CANEJEGseZ6Emt=iT1wGyQVJdAEsjgDX6yOV4OGa6Aht=BAVT+A@mail.gmail.com>
Subject: Re: drivers/net/usb/asix: strange numeration of eth interfaces
From: Grant Grundler <grundler@chromium.org>
To: Igor Egorkin <igor@egorkin.ru>
Cc: linux-kernel@vger.kernel.org, Allan Chou <allan@asix.com.tw>,
        Freddy Xin <freddy@asix.com.tw>, Mark Lord <kernel@teksavvy.com>,
        netdev@vger.kernel.org
X-System-Of-Record: true
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

+Freddy Xin, Mark Lord, +netdev

On Sun, Dec 18, 2011 at 11:43 PM, Igor Egorkin <igor@egorkin.ru> wrote:
> Hello!
>
> $ uname -a
> Linux 2.6.32-5-amd64 #1 SMP Thu Nov 3 03:41:26 UTC 2011 x86_64 GNU/Linux
>
> $ cat /etc/debian_version
> 6.0.3
>
> $ lsusb|grep -i asix
> Bus 004 Device 014: ID 0b95:772b ASIX Electronics Corp.
>
>
> 1) Driver asix.c from linux-3.2-rc6.
>   asix.c little modified for compiling in 2.6.32 . Diff is at the end of message.

Hi Igor!
The goal(s) of your email/patch aren't 100% clear to me.

Is the main goal to provide a backport of 3.2-rc6  asix.c driver to
pre-2.6.35 kernels?

(If so - thanks! I'm sure someone can make use of it.)

Why the comparison to ASIX v4.2.0 driver?

cheers,
grant

>  Adapter inserted to USB connector:
> Dec 18 20:03:24 kernel: [492657.344037] usb 4-2: new high speed USB device using ehci_hcd and address 12
> Dec 18 20:03:24 kernel: [492657.489541] usb 4-2: New USB device found, idVendor=0b95, idProduct=772b
> Dec 18 20:03:24 kernel: [492657.489545] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Dec 18 20:03:24 kernel: [492657.489548] usb 4-2: Product: AX88772B
> Dec 18 20:03:24 kernel: [492657.489550] usb 4-2: Manufacturer: ASIX Elec. Corp.
> Dec 18 20:03:24 kernel: [492657.489552] usb 4-2: SerialNumber: 000001
> Dec 18 20:03:24 kernel: [492657.489661] usb 4-2: configuration #1 chosen from 1 choice
> Dec 18 20:03:24 kernel: [492657.802645] eth1: register 'asix' at usb-0000:01:00.2-2, ASIX AX88772 USB 2.0 Ethernet, 00:60:6e:01:0e:99
>
> # ethtool -i eth1
> Cannot get driver information: No such device
>
> # ethtool -i eth2
> driver: asix
> version: 08-Nov-2011
> firmware-version: ASIX AX88772 USB 2.0 Ethernet
> bus-info: usb-0000:01:00.2-2
>
> $ ip addr ls dev eth1
> Device "eth1" does not exist.
>
> $ ip addr ls dev eth2
> 77: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
>    link/ether 00:60:6e:01:0e:99 brd ff:ff:ff:ff:ff:ff
>
>  Adapter removed from USB connector:
> Dec 18 20:40:58 kernel: [494911.485333] usb 4-2: USB disconnect, address 12
> Dec 18 20:40:58 kernel: [494911.485426] eth2: unregister 'asix' usb-0000:01:00.2-2, ASIX AX88772 USB 2.0 Ethernet
>
>
>
> 2) Driver AX88772B_772A_760_772_178_LINUX_Driver_v4.2.0_Source.zip from asix.com.tw . Unmodified.
> Problem is the same.
>
>  Adapter inserted to USB connector:
> Dec 18 20:42:53 kernel: [495026.620036] usb 4-2: new high speed USB device using ehci_hcd and address 13
> Dec 18 20:42:53 kernel: [495026.765514] usb 4-2: New USB device found, idVendor=0b95, idProduct=772b
> Dec 18 20:42:53 kernel: [495026.765519] usb 4-2: New USB device strings: Mfr=1, Product=2, SerialNumber=3
> Dec 18 20:42:53 kernel: [495026.765522] usb 4-2: Product: AX88772B
> Dec 18 20:42:53 kernel: [495026.765523] usb 4-2: Manufacturer: ASIX Elec. Corp.
> Dec 18 20:42:53 kernel: [495026.765525] usb 4-2: SerialNumber: 000001
> Dec 18 20:42:53 kernel: [495026.765639] usb 4-2: configuration #1 chosen from 1 choice
> Dec 18 20:42:54 kernel: [495027.399871] ASIX USB Ethernet Adapter:v4.2.0 20:17:18 Dec 17 2011
> Dec 18 20:42:54 kernel: [495027.399873] <6>    http://www.asix.com.tw
> Dec 18 20:42:54 kernel: [495027.399877] eth%d: status ep1in, 8 bytes period 11
> Dec 18 20:42:54 kernel: [495027.400873] eth1: register 'asix' at usb-0000:01:00.2-2, ASIX AX88772B USB 2.0 Ethernet, 00:60:6e:01:0e:99
>
> $ ip addr ls dev eth1
> Device "eth1" does not exist.
>
> $ ip addr ls dev eth2
> 78: eth2: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN qlen 1000
>    link/ether 00:60:6e:01:0e:99 brd ff:ff:ff:ff:ff:ff
>
>
> # ethtool -i eth1
> Cannot get driver information: No such device
>
> # ethtool -i eth2
> driver: asix
> version: 22-Aug-2005
> firmware-version: ASIX AX88772B USB 2.0 Ethernet
> bus-info: usb-0000:01:00.2-2
>
>  Adapter removed from USB connector:
> Dec 18 20:44:41 kernel: [495134.784792] usb 4-2: USB disconnect, address 13
> Dec 18 20:44:41 kernel: [495134.784882] eth2: unregister 'asix' usb-0000:01:00.2-2, ASIX AX88772B USB 2.0 Ethernet
>
>
>
> ===============================================================================================================
>
>
>  For compiling asix.c in 2.6.32  i do modification (i take it from AX88772B_772A_760_772_178_LINUX_Driver_v4.2.0_Source.zip):
>
>
> $ diff -ruN asix.c.from_linux-3.2-rc6 asix.c
> --- asix.c.from_linux-3.2-rc6   2011-12-17 06:36:26.000000000 +0400
> +++ asix.c      2011-12-18 20:00:46.000000000 +0400
> @@ -22,7 +22,7 @@
>
>  // #define     DEBUG                   // error path messages, extra info
>  // #define     VERBOSE                 // more; success messages
> -
> +#include <linux/version.h>
>  #include <linux/module.h>
>  #include <linux/kmod.h>
>  #include <linux/init.h>
> @@ -593,8 +593,24 @@
>                 * for our 8 byte filter buffer
>                 * to avoid allocating memory that
>                 * is tricky to free later */
> -               struct netdev_hw_addr *ha;
>                u32 crc_bits;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
> +               struct dev_mc_list *mc_list = net->mc_list;
> +               int i;
> +
> +               memset(data->multi_filter, 0, AX_MCAST_FILTER_SIZE);
> +
> +               /* Build the multicast hash filter. */
> +               for (i = 0; i < net->mc_count; i++) {
> +                       crc_bits =
> +                           ether_crc(ETH_ALEN,
> +                               mc_list->dmi_addr) >> 26;
> +                       data->multi_filter[crc_bits >> 3] |=
> +                           1 << (crc_bits & 7);
> +                       mc_list = mc_list->next;
> +               }
> +#else
> +               struct netdev_hw_addr *ha;
>
>                memset(data->multi_filter, 0, AX_MCAST_FILTER_SIZE);
>
> @@ -604,7 +620,7 @@
>                        data->multi_filter[crc_bits >> 3] |=
>                            1 << (crc_bits & 7);
>                }
> -
> +#endif
>                asix_write_cmd_async(dev, AX_CMD_WRITE_MULTI_FILTER, 0, 0,
>                                   AX_MCAST_FILTER_SIZE, data->multi_filter);
>
> @@ -827,18 +843,33 @@
>                 * for our 8 byte filter buffer
>                 * to avoid allocating memory that
>                 * is tricky to free later */
> -               struct netdev_hw_addr *ha;
>                u32 crc_bits;
> +#if LINUX_VERSION_CODE < KERNEL_VERSION(2,6,35)
> +               struct dev_mc_list *mc_list = net->mc_list;
> +               int i;
>
>                memset(data->multi_filter, 0, AX_MCAST_FILTER_SIZE);
>
>                /* Build the multicast hash filter. */
> +               for (i = 0; i < net->mc_count; i++) {
> +                       crc_bits =
> +                           ether_crc(ETH_ALEN,
> +                               mc_list->dmi_addr) >> 26;
> +                       data->multi_filter[crc_bits >> 3] |=
> +                           1 << (crc_bits & 7);
> +                       mc_list = mc_list->next;
> +               }
> +#else
> +               struct netdev_hw_addr *ha;
> +               memset(data->multi_filter, 0, AX_MCAST_FILTER_SIZE);
> +
> +               /* Build the multicast hash filter. */
>                netdev_for_each_mc_addr(ha, net) {
>                        crc_bits = ether_crc(ETH_ALEN, ha->addr) >> 26;
>                        data->multi_filter[crc_bits >> 3] |=
>                            1 << (crc_bits & 7);
>                }
> -
> +#endif
>                asix_write_cmd_async(dev, AX_CMD_WRITE_MULTI_FILTER, 0, 0,
>                                   AX_MCAST_FILTER_SIZE, data->multi_filter);
>
>
>
> ==============================================================================================
>
>
> Thank you!
> --
> Igor E.
>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752271Ab1K2BuZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:50:25 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43987 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751663Ab1K2BuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:50:23 -0500
Message-ID: <4ED43A5C.9000102@gmail.com>
Date: Mon, 28 Nov 2011 19:50:20 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
Subject: Poor performance and lockup with rt2800usb and Asus USB-N13 adapter
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I recently got an Asus USB-N13 USB Wireless-N adapter which apparently 
uses a Ralink RT3072 chip. I'm using it with an Asus RT-N16 access point 
running TomatoUSB. When running Windows the performance is reasonable 
(about 80 Mbps in both directions). However under Fedora 16 (currently 
kernel 3.1.2) the performance is abysmal (10 Mbps or less with lots of 
packet loss). I'll post some debug information below.

I have another adapter, a Trendnet which apparently is an RT3070 and 
uses the same driver, which works much better (about 50 Mbps) despite 
being only a 150 Mbps chip (1X MIMO) as opposed to 300 Mbps (2X MIMO) 
like the Asus. Looking at the Minstrel rc_stat output it seems like a 
lot of the MCS8-15 rates are being tried but the success is quite poor - 
I'm not sure if this is a cause of the poor performance or an effect..

While debugging this I also noticed that doing an rmmod on rt2800usb 
with the adapter plugged in locks up the machine and then spews out soft 
lockup stack traces on the console. I was only able to capture it off 
the screen with a camera, but it basically is:

rt2x00usb_work_rxdone
process_one_work
worker_thread
kthread
kernel_thread_helper

The output repeats periodically and it always seems to involve either 
rt2x00usb_work_rxdone or rt2x00usb_work_txdone so it seems like we're 
spinning through those functions for some reason. I can post/send the 
image if anyone wants more details from the stack trace.

Linux nicole 3.1.2-1.fc16.i686 #1 SMP Tue Nov 22 08:56:28 UTC 2011 i686 
i686 i386 GNU/Linux

lsusb -vv:

Bus 001 Device 002: ID 0b05:1784 ASUSTek Computer, Inc. USB-N13 802.11n 
Network Adapter [Ralink RT3072]
Device Descriptor:
   bLength                18
   bDescriptorType         1
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   idVendor           0x0b05 ASUSTek Computer, Inc.
   idProduct          0x1784 USB-N13 802.11n Network Adapter [Ralink RT3072]
   bcdDevice            1.01
   iManufacturer           1 Ralink
   iProduct                2 802.11 n WLAN
   iSerial                 3 1.0
   bNumConfigurations      1
   Configuration Descriptor:
     bLength                 9
     bDescriptorType         2
     wTotalLength           67
     bNumInterfaces          1
     bConfigurationValue     1
     iConfiguration          0
     bmAttributes         0x80
       (Bus Powered)
     MaxPower              450mA
     Interface Descriptor:
       bLength                 9
       bDescriptorType         4
       bInterfaceNumber        0
       bAlternateSetting       0
       bNumEndpoints           7
       bInterfaceClass       255 Vendor Specific Class
       bInterfaceSubClass    255 Vendor Specific Subclass
       bInterfaceProtocol    255 Vendor Specific Protocol
       iInterface              5 1.0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x81  EP 1 IN
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x01  EP 1 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x02  EP 2 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x03  EP 3 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x04  EP 4 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x05  EP 5 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
       Endpoint Descriptor:
         bLength                 7
         bDescriptorType         5
         bEndpointAddress     0x06  EP 6 OUT
         bmAttributes            2
           Transfer Type            Bulk
           Synch Type               None
           Usage Type               Data
         wMaxPacketSize     0x0200  1x 512 bytes
         bInterval               0
Device Qualifier (for other device speed):
   bLength                10
   bDescriptorType         6
   bcdUSB               2.00
   bDeviceClass            0 (Defined at Interface level)
   bDeviceSubClass         0
   bDeviceProtocol         0
   bMaxPacketSize0        64
   bNumConfigurations      1
Device Status:     0x0000
   (Bus Powered)

 From ifconfig (after running some transfer speed tests):

           RX packets:61207 errors:0 dropped:0 overruns:0 frame:0
           TX packets:43886 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:78762017 (75.1 MiB)  TX bytes:27862511 (26.5 MiB)

 From iwconfig (some AP details removed):

wlan2     IEEE 802.11bgn
           Mode:Managed  Frequency:2.422 GHz
           Bit Rate=65 Mb/s   Tx-Power=27 dBm
           Retry  long limit:7   RTS thr:off   Fragment thr:off
           Power Management:on
           Link Quality=70/70  Signal level=-37 dBm
           Rx invalid nwid:0  Rx invalid crypt:0  Rx invalid frag:0
           Tx excessive retries:836  Invalid misc:37   Missed beacon:0

rc_stats output from sysfs:

type      rate     throughput  ewma prob   this prob  this succ/attempt 
   success    attempts
HT20/LGI    MCS0        6.0       96.0      100.0          0(  0) 
   17          27
HT20/LGI    MCS1       11.2       95.4      100.0          0(  0) 
   11          13
HT20/LGI    MCS2       16.0       96.8      100.0          0(  0) 
   12          15
HT20/LGI    MCS3       10.3       49.5        0.0          0(  0) 
   57         143
HT20/LGI    MCS4        4.3       15.4        0.0          0(  0) 
   38         167
HT20/LGI    MCS5        3.7       11.1        0.0          0(  0) 
   96         248
HT20/LGI    MCS6       11.1       30.6        0.0          0(  0) 
  255         452
HT20/LGI    MCS7       20.4       52.2        0.0          0(  0) 
11871       12290
HT20/LGI    MCS8        5.0       42.5        0.0          0(  0) 
   18          38
HT20/LGI    MCS9        9.2       44.1        0.0          0(  0) 
   17          42
HT20/LGI    MCS10      12.7       45.3      100.0          0(  0) 
   24          69
HT20/LGI    MCS11      10.8       32.0        0.0          0(  0) 
   66         293
HT20/LGI    MCS12       7.7       18.0        0.0          0(  0) 
   74         361
HT20/LGI    MCS13      11.7       23.9        0.0          0(  0) 
   69         348
HT20/LGI    MCS14      16.3       31.3        0.0          0(  0) 
   99         369
HT20/LGI    MCS15      20.3       37.3        0.0          0(  0) 
  392         632
HT20/SGI    MCS0        6.9      100.0      100.0          0(  0) 
    1           1
HT20/SGI    MCS1       12.9      100.0      100.0          0(  0) 
    1           1
HT20/SGI  t MCS2       17.1       95.1      100.0          0(  0) 
   11          15
HT20/SGI    MCS3        4.2       18.9        0.0          0(  0) 
   73         278
HT20/SGI    MCS4        0.0        0.7        0.0          0(  0) 
   40         316
HT20/SGI    MCS5       12.6       35.0        0.0          0(  0) 
  106         422
HT20/SGI    MCS6        8.8       23.0        0.0          0(  0) 
  644        1063
HT20/SGI T PMCS7       40.3       97.7      100.0          2(  2) 
28626       29571
HT20/SGI    MCS8        7.4       57.4      100.0          0(  0) 
   25          47
HT20/SGI    MCS9        5.4       24.1        0.0          0(  0) 
   18          65
HT20/SGI    MCS10       0.0        2.8        0.0          0(  0) 
   31         161
HT20/SGI    MCS11       9.6       26.8      100.0          0(  0) 
   54         386
HT20/SGI    MCS12      12.7       27.9        0.0          0(  0) 
   65         448
HT20/SGI    MCS13      10.9       21.3        0.0          0(  0) 
   94         464
HT20/SGI    MCS14      15.7       29.0        0.0          0(  0) 
  219         560
HT20/SGI    MCS15      19.8       35.0        0.0          0(  0) 
  365         597

Total packet count::    ideal 43018      lookaround 1308
Average A-MPDU length: 1.0

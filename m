Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753041Ab2CXOIx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Mar 2012 10:08:53 -0400
Received: from plane.gmane.org ([80.91.229.3]:56626 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751275Ab2CXOIv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Mar 2012 10:08:51 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Frank Kingswood <frank@kingswood-consulting.co.uk>
Subject: Not getting connection with BRCM 4313 (Linux 3.3 brcmsmac)
Date: Sat, 24 Mar 2012 14:08:41 +0000
Message-ID: <4F6DD569.9000100@kingswood-consulting.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
Cc: Frank A Kingswood <frank@kingswood-consulting.co.uk>,
        Arend van Spriel <arend@broadcom.com>
X-Gmane-NNTP-Posting-Host: mail.kingswood-consulting.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20110307 Icedove/3.0.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This is on a Samsung NP305U1A subnotebook.
This WiFi never worked under Linux, tried 3.2.x previously.

When attempting to use it through NetworkManager it shows the AP, then 
keeps trying to connect, then prompts for the password again. Meanwhile 
the kernel log shows the timeout.
Yes, I double checked the password.

====

.config:
CONFIG_BCMA=m
CONFIG_BCMA_HOST_PCI_POSSIBLE=y
CONFIG_BCMA_HOST_PCI=y
CONFIG_BCMA_DEBUG=y
# CONFIG_B43 is not set
# CONFIG_B43LEGACY is not set
CONFIG_BRCMUTIL=m
CONFIG_BRCMSMAC=m
# CONFIG_BRCMFMAC is not set
CONFIG_BRCMDBG=y

====

lspci:
03:00.0 Network controller [0280]: Broadcom Corporation BCM4313 
802.11b/g/n Wireless LAN Controller [14e4:4727] (rev 01)
     Subsystem: Wistron NeWeb Corp. Device [185f:051a]
     Flags: bus master, fast devsel, latency 0, IRQ 16
     Memory at fea00000 (64-bit, non-prefetchable) [size=16K]
     Capabilities: [40] Power Management version 3
     Capabilities: [58] Vendor Specific Information: Len=78 <?>
     Capabilities: [48] MSI: Enable- Count=1/1 Maskable- 64bit+
     Capabilities: [d0] Express Endpoint, MSI 00
     Capabilities: [100] Advanced Error Reporting
     Capabilities: [13c] Virtual Channel
     Capabilities: [160] Device Serial Number 00-00-de-ff-ff-c0-90-a4
     Capabilities: [16c] Power Budgeting <?>
     Kernel driver in use: bcma-pci-bridge

====

/var/log/kern.log:
Mar 24 21:45:16 ceres kernel: ieee80211 phy0: 
brcms_ops_bss_info_changed: qos enabled: false (implement)
Mar 24 21:45:16 ceres kernel: ieee80211 phy0: brcms_ops_config: change 
power-save mode: false (implement)
...
Mar 24 21:45:32 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 1/3)
Mar 24 21:45:32 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 2/3)
Mar 24 21:45:32 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 3/3)
Mar 24 21:45:32 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
timed out
Mar 24 21:45:38 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 1/3)
Mar 24 21:45:38 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 2/3)
Mar 24 21:45:39 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
(try 3/3)
Mar 24 21:45:39 ceres kernel: wlan0: direct probe to 00:22:57:xx:xx:xx 
timed out

====

iw dev wlan0 scan shows always at most one AP (although there should be 
many visible), possibly the one with the highest rx signal:

BSS 00:22:57:xx:xx:xx (on wlan0)
     TSF: 1099047223652 usec (12d, 17:17:27)
     freq: 2462
     beacon interval: 333
     capability: ESS Privacy ShortSlotTime (0x0411)
     signal: -47.00 dBm
     last seen: 276 ms ago
     Information elements from Probe Response frame:
     SSID: 002257xxxxxx
     Supported rates: 1.0* 2.0* 5.5* 11.0* 9.0 18.0 36.0 54.0
     DS Parameter set: channel 11
     ERP: Barker_Preamble_Mode
     Extended supported rates: 6.0 12.0 24.0 48.0
     HT capabilities:
         Capabilities: 0x11ee
             HT20/HT40
             SM Power Save disabled
             RX HT20 SGI
             RX HT40 SGI
             TX STBC
             RX STBC 1-stream
             Max AMSDU length: 3839 bytes
             DSSS/CCK HT40
         Maximum RX AMPDU length 65535 bytes (exponent: 0x003)
         Minimum RX AMPDU time spacing: 4 usec (0x05)
         HT RX MCS rate indexes supported: 0-15, 32
         HT TX MCS rate indexes are undefined
     HT operation:
          * primary channel: 11
          * secondary channel offset: below
          * STA channel width: any
          * RIFS: 0
          * HT protection: 20 MHz
          * non-GF present: 1
          * OBSS non-GF present: 0
          * dual beacon: 0
          * dual CTS protection: 0
          * STBC beacon: 0
          * L-SIG TXOP Prot: 0
          * PCO active: 0
          * PCO phase: 0
     RSN:     * Version: 1
          * Group cipher: CCMP
          * Pairwise ciphers: CCMP
          * Authentication suites: PSK
          * Capabilities: PreAuth (0x0001)
     WMM:     * Parameter version 1
          * BE: CW 15-1023, AIFSN 3
          * BK: CW 15-1023, AIFSN 7
          * VI: CW 7-15, AIFSN 2, TXOP 3008 usec
          * VO: acm CW 3-7, AIFSN 2, TXOP 1504 usec
     Extended capabilities: HT Information Exchange Supported
     Country: GB    Environment: Indoor/Outdoor
         Channels [1 - 11] @ 16 dBm

====

md5sums on /lib/firmware/brcm:
96cf06e4ff9f0c04a0f26ebefdf32e3d  bcm43xx-0.fw
48882412db63b4e2dd9c26571a29a799  bcm43xx_hdr-0.fw

====

Happy to debug this, building custom kernels for this will be no problem.
Thanks in advance, bij voorbaat dank, etc.

Frank
-- 
------------------------------------------------------------------------
Frank A. Kingswood                      frank@kingswood-consulting.co.uk
Cambridge, United Kingdom                               +44-7545-209 100


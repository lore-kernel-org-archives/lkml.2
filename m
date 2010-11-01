Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755951Ab0KAJbx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:31:53 -0400
Received: from mail.sysgo.com ([195.145.229.155]:52852 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751193Ab0KAJbu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:31:50 -0400
Date: Mon, 1 Nov 2010 10:31:40 +0100
From: Pavel Machek <pma@sysgo.com>
To: kernel list <linux-kernel@vger.kernel.org>, chunkeey@googlemail.com,
        linux-wireless@vger.kernel.org
Subject: Re: carl9170 disconnects under load
Message-ID: <20101101093140.GA2766@pma.sysgo.com>
References: <20101026104811.GA11357@pma.sysgo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101026104811.GA11357@pma.sysgo.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> I'm testing driver from -wireless testing, cca 2.6.26-rc7.
> 
> It seems to work (up to 802.11n speeds -- I've seen iwconfig claiming
> 121 MB/sec), but disconnects rather quickly when under load:
> 
> telnet 192.168.1.3 chargen > /dev/null
> 
> The machine is powerpc mpc5200b board, with OHCI driver -- it is not
> capable of USB2.0 speeds.

So I tried with different AP, one not capable of 802.11n speeds. It
fails in different way :-(. But this one is with my backport to
2.6.34...
								Pavel

wlan0: associate with 00:11:95:05:30:d7 (try 1)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x421 status=0
aid=1)
wlan0: associated
phy0: Allocated STA 00:11:95:05:30:d7
phy0: Inserted STA 00:11:95:05:30:d7
phy0: Removed STA 00:11:95:05:30:d7
phy0: Destroyed STA 00:11:95:05:30:d7
wlan0: deauthenticating from 00:11:95:05:30:d7 by local choice
(reason=3)
phy0: device now idle
cfg80211: Calling CRDA to update world regulatory domain
phy0: device no longer idle - scanning
wlan0: authenticate with 00:11:95:05:30:d7 (try 1)
wlan0: authenticated
phy0: device now idle
phy0: device no longer idle - working
wlan0: associate with 00:11:95:05:30:d7 (try 1)
wlan0: RX AssocResp from 00:11:95:05:30:d7 (capab=0x421 status=0
aid=1)
wlan0: associated
phy0: Allocated STA 00:11:95:05:30:d7
phy0: Inserted STA 00:11:95:05:30:d7
received frame with suspicious error code (0x81).
received frame with suspicious error code (0x3).
received frame with suspicious error code (0x1).
received frame with suspicious error code (0x2).
received frame with suspicious error code (0x1).
received frame with suspicious error code (0x3).
usb 1-1: no command feedback received (-110).
carl9170 cmd: 08 01 00 00 04 01 1d 00 03 00 00 00
............
usb 1-1: restart device (6)
writing reg 0x1d0104 (val 0x3) failed (-110)


> Any ideas?
> 								Pavel
> 
> wlan0: RX AssocResp from 00:23:f8:5d:76:93 (capab=0xc21 status=0
> aid=1)
> wlan0: associated
> ieee80211 phy2: Allocated STA 00:23:f8:5d:76:93
> ieee80211 phy2: Inserted STA 00:23:f8:5d:76:93
> ieee80211 phy2: WMM queue=2 aci=0 acm=0 aifs=3 cWmin=15 cWmax=1023
> txop=0 uapsd=0
> ieee80211 phy2: WMM queue=3 aci=1 acm=0 aifs=7 cWmin=15 cWmax=1023
> txop=0 uapsd=0
> ieee80211 phy2: WMM queue=1 aci=2 acm=0 aifs=2 cWmin=7 cWmax=15
> txop=94 uapsd=0
> ieee80211 phy2: WMM queue=0 aci=3 acm=0 aifs=2 cWmin=3 cWmax=7 txop=47
> uapsd=0
> Open BA session requested for 00:23:f8:5d:76:93 tid 0
> activated addBA response timer on tid 0
> switched off addBA timer for tid 0
> Aggregation is on for tid 0
> Rx A-MPDU request on tid 0 result 0
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> net_ratelimit: 79 callbacks suppressed
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> net_ratelimit: 58 callbacks suppressed
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> ieee80211 phy2: release an RX reorder frame due to timeout on earlier
> frames
> usb 1-1: USB disconnect, address 6
> Tx BA session stop requested for 00:23:f8:5d:76:93 tid 0
> Rx BA session stop requested for 00:23:f8:5d:76:93 tid 0
> wlan0: deauthenticating from 00:23:f8:5d:76:93 by local choice
> (reason=3)
> Tx BA session stop requested for 00:23:f8:5d:76:93 tid 0
> ieee80211 phy2: Removed STA 00:23:f8:5d:76:93
> ieee80211 phy2: Destroyed STA 00:23:f8:5d:76:93
> ieee80211 phy2: device now idle

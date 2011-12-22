Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755483Ab1LVRd5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Dec 2011 12:33:57 -0500
Received: from mout0.freenet.de ([195.4.92.90]:57867 "EHLO mout0.freenet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753226Ab1LVRdz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Dec 2011 12:33:55 -0500
Message-Id: <201112221731.pBMHVScq005421@mail.maya.org>
Date: Thu, 22 Dec 2011 18:31:30 +0100
From: Andreas Hartmann <andihartmann@01019freenet.de>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Robert Hancock <hancockrwd@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        users@rt2x00.serialmonkey.com
Subject: Re: [rt2x00-users] Poor performance and lockup with rt2800usb and
 Asus USB-N13 adapter
In-Reply-To: <20111222161810.GB13554@redhat.com>
References: <4ED43A5C.9000102@gmail.com>
	<20111129114603.GB7299@redhat.com>
	<CADLC3L2QpEtPiBg+yvaxir1LpU6j5YMpDG4g0+ezs06g745zcg@mail.gmail.com>
	<20111220144317.GA6027@redhat.com>
	<20111222161810.GB13554@redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Thu, 22 Dec 2011 17:18:28 +0100
schrieb Stanislaw Gruszka <sgruszka@redhat.com>:

> On Tue, Dec 20, 2011 at 03:43:17PM +0100, Stanislaw Gruszka wrote:
> > I just discovered that at least some problems are related with power
> > save. After "iwconfig wlanX power off" I have pretty short ping times
> > and good throughput, both comparable with vendor driver. But I did not
> > check that on all adapters that I have yet.
> >
> > Looking a bit more at that seem we stop and wake queues several times
> > between sending each frame. Looks like that thing need to be optimized
> > in mac80211, or some parameters have to be setup properly by rt2x00 ...
> > 
> > Also rt2800 PCI and SOC have PS disabled by default ...
> 
> There is no bug with ping latencies when power save is enabled. Ping
> send packet every second, between that we put driver in power save
> mode (i.e. tell AP that we are sleeping and it has to buffer frame
> to us). When we send ping packet, we wake up and receive packet from
> a AP after longer time than in normal operation mode.
> 
> I did more testing here and I have one device that works very bad,
> no matter if PS is configured or not. It is 
> 
> phy6 -> rt2x00_set_chip: Info - Chipset detected - rt: 3071, rf: 0008, rev: 021c.

My device: 

phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 3572, rf: 0009, rev: 0221.

phy0 -> rt2x00lib_request_firmware: Info - Loading firmware file 'rt2870.bin'.
phy0 -> rt2x00lib_request_firmware: Info - Firmware detected - version: 0.236.


If CONFIG_RT2X00_DEBUG is switched on, I'm getting millions of entries
like these in messages:

[48570.815137] phy0 -> rt2800usb_txdone_entry_check: Warning - Data pending for entry 26 in queue 2
[48570.815150] phy0 -> rt2800usb_txdone_entry_check: Warning - Data pending for entry 26 in queue 2
[48570.815162] phy0 -> rt2800usb_txdone_entry_check: Warning - Data pending for entry 26 in queue 2
[48570.815174] phy0 -> rt2800usb_txdone_entry_check: Warning - Data pending for entry 26 in queue 2

or

[49404.459991] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 32
[49404.462098] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 36
[49404.462123] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 37
[49404.463596] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 40
[49404.463618] phy0 -> rt2800usb_txdone_entry_check: Warning - TX status report missed for queue 2 entry 41

not that often:

[49390.002284] phy0 -> rt2x00usb_watchdog_tx_status: Warning - TX queue 2 status timed out, invoke forced tx handler

I can easily force them running netperf in both directions (TCP_MAERTS
and TCP_STREAM). I would be happy with about 12 Mbit/s (that's
what I get with the ralink driver with good conditions stable over more
than just a few minutes) :-).

BTW: The patch in [1] breaks the driver completely (tested with
compat-wireless 3.1rc1).

> I'm going to investigate problems with that device, hopefully these are the
> same problems that Robert and Andreas have.

Thank you very much - it would be a great Christmas present if you
could repair this driver!

If you need some testing - I'll do it!


Kind regards,
Andreas

[1]
http://rt2x00.serialmonkey.com/pipermail/users_rt2x00.serialmonkey.com/2011-December/004345.html

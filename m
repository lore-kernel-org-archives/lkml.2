Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752596Ab1HDIDV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 04:03:21 -0400
Received: from lucidpixels.com ([72.73.18.11]:49717 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751226Ab1HDIDM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 04:03:12 -0400
Date: Thu, 4 Aug 2011 04:03:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
In-Reply-To: <20110803183349.GA5956@redhat.com>
Message-ID: <alpine.DEB.2.02.1108040400570.4278@p34.internal.lan>
References: <20110730113009.GA2847@redhat.com> <20110730113255.GB2847@redhat.com> <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan> <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan> <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de> <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan> <20110803160050.GA18882@redhat.com> <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan> <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
 <20110803183349.GA5956@redhat.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Wed, 3 Aug 2011, Stanislaw Gruszka wrote:

> On Wed, Aug 03, 2011 at 01:44:10PM -0400, Justin Piszcz wrote:
> > Tested that patch:
> > 
> > 1. The driver no longer automatically loads, I had to manually modprobe it.
> This must be some other problem not related with patch.
> 
> > 2. After loading, I get this (keep getting these)
> > 
> > [  384.054538] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.072773] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.096545] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.117301] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.537586] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.555716] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.573903] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.599465] phy0 -> rt2800_txdone: Error - Data pending
> > [  384.618523] phy0 -> rt2800_txdone: Error - Data pending
> You can remove line
> 
> ERROR(rt2x00dev, "Data pending\n");
> 
> from rt2800_txdone to stop seeing this. It's kinda interesting
> how frequent this happens.
> 
> > No crash yet, but bad ping again too (always with the rt2800usb) driver:
> > 
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=53.1 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=285 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=89.6 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=120 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=42.2 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=156 ms
> > 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=77.2 ms
> 
> I think patch could have site effect to not run tx queue while we have pending
> data on it. Do you have such ping times always (i.e. after a 5 minutes, 10
> minutes, 20  ... ) or just randomly?
> 
> Stanislaw

Hi,

So the patch is good but did not solve the problem, after several hours, the
main USB wireless stick went off-line:

Aug  3 22:02:16 atom kernel: [23424.597037] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.597168] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.598047] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.598411] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.599414] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.599549] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:02:16 atom kernel: [23424.599664] phy0 -> rt2800_txdone: Error - Data pending
Aug  3 22:47:12 atom kernel: [26120.279774] wlan0: deauthenticated from hidden (Reason: 2)
Aug  3 22:47:13 atom kernel: [26121.728581] wlan0: authenticate with hidden (try 1)
Aug  3 22:47:13 atom kernel: [26121.730109] wlan0: authenticated
Aug  3 22:47:13 atom kernel: [26121.745088] wlan0: associate with hidden (try 1)
Aug  3 22:47:13 atom kernel: [26121.750738] wlan0: RX ReassocResp from hidden (capab=0x431 status=0 aid=2)
Aug  3 22:47:13 atom kernel: [26121.750746] wlan0: associated
Aug  3 22:47:14 atom kernel: [26121.845641] wlan0: Wrong control channel in association response: configured center-freq: 2417 hti-cfreq: 2437  hti->control_chan: 6 band: 0.  Disabling HT.


( at this point wlan0 is offline )

$ ssh atomw
ssh: connect to host atomw port 22: No route to host

BUT: It did not crash the kernel; however, interestingly (I have two of these
sticks), now phy1 starts showing the same symptoms wlan0 had (phy0).

Aug  3 22:49:46 atom kernel: [26274.088150] phy1 -> rt2800_txdone: Error - Data pending
Aug  3 22:49:46 atom kernel: [26274.147869] phy1 -> rt2800_txdone: Error - Data pending
Aug  3 22:49:46 atom kernel: [26274.152743] phy1 -> rt2800_txdone: Error - Data pending

Are these sticks just incomptabile with the rt2800usb driver?

Justin.


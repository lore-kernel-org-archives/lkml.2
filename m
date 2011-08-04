Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab1HDMnZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Aug 2011 08:43:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:29435 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752568Ab1HDMnT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Aug 2011 08:43:19 -0400
Date: Thu, 4 Aug 2011 14:43:19 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
Message-ID: <20110804124318.GA5739@redhat.com>
References: <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de>
 <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
 <20110803160050.GA18882@redhat.com>
 <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
 <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
 <20110803183349.GA5956@redhat.com>
 <alpine.DEB.2.02.1108040400570.4278@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108040400570.4278@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 04, 2011 at 04:03:11AM -0400, Justin Piszcz wrote:
> So the patch is good but did not solve the problem, after several hours, the
> main USB wireless stick went off-line:
> 
> Aug  3 22:02:16 atom kernel: [23424.597037] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.597168] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.598047] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.598411] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.599414] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.599549] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:02:16 atom kernel: [23424.599664] phy0 -> rt2800_txdone: Error - Data pending
> Aug  3 22:47:12 atom kernel: [26120.279774] wlan0: deauthenticated from hidden (Reason: 2)
> Aug  3 22:47:13 atom kernel: [26121.728581] wlan0: authenticate with hidden (try 1)
> Aug  3 22:47:13 atom kernel: [26121.730109] wlan0: authenticated
> Aug  3 22:47:13 atom kernel: [26121.745088] wlan0: associate with hidden (try 1)
> Aug  3 22:47:13 atom kernel: [26121.750738] wlan0: RX ReassocResp from hidden (capab=0x431 status=0 aid=2)
> Aug  3 22:47:13 atom kernel: [26121.750746] wlan0: associated
> Aug  3 22:47:14 atom kernel: [26121.845641] wlan0: Wrong control channel in association response: configured center-freq: 2417 hti-cfreq: 2437  hti->control_chan: 6 band: 0.  Disabling HT.

Well, driver still need some fixes. I have 2 of these dongles and see
some problems here with reading registers, what could be related I
think. I'm gonna fix issues that I have locally. Then we will see if
problems are fixed for you as well. For now, you will need to use
drivers from ralink site, if they work well for you.

> ( at this point wlan0 is offline )
> 
> $ ssh atomw
> ssh: connect to host atomw port 22: No route to host
> 
> BUT: It did not crash the kernel; however, interestingly (I have two of these
> sticks), now phy1 starts showing the same symptoms wlan0 had (phy0).

I'm going to post modified/cleaned up patch.

> Aug  3 22:49:46 atom kernel: [26274.088150] phy1 -> rt2800_txdone: Error - Data pending
> Aug  3 22:49:46 atom kernel: [26274.147869] phy1 -> rt2800_txdone: Error - Data pending
> Aug  3 22:49:46 atom kernel: [26274.152743] phy1 -> rt2800_txdone: Error - Data pending
> 
> Are these sticks just incomptabile with the rt2800usb driver?

If rt2800usb contains usb id of the stick, it should work. 

Stanislaw

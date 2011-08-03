Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab1HCSdn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Aug 2011 14:33:43 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49737 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753379Ab1HCSdg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Aug 2011 14:33:36 -0400
Date: Wed, 3 Aug 2011 20:33:50 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Andreas Hartmann <andihartmann@01019freenet.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Ivo van Doorn <IvDoorn@gmail.com>, linux-kernel@vger.kernel.org,
        linux-wireless@vger.kernel.org, Alan Piszcz <ap@solarrain.com>,
        "users@rt2x00.serialmonkey.com" <users@rt2x00.serialmonkey.com>
Subject: Re: [PATCH] rt2x00: rt2800: fix zeroing skb structure
Message-ID: <20110803183349.GA5956@redhat.com>
References: <20110730113009.GA2847@redhat.com>
 <20110730113255.GB2847@redhat.com>
 <alpine.DEB.2.02.1107300736010.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301015340.4925@p34.internal.lan>
 <alpine.DEB.2.02.1107301031560.4925@p34.internal.lan>
 <4E341DC4.9010107@01019freenet.de>
 <alpine.DEB.2.02.1107301305590.4925@p34.internal.lan>
 <20110803160050.GA18882@redhat.com>
 <alpine.DEB.2.02.1108031328030.9421@p34.internal.lan>
 <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1108031339280.9421@p34.internal.lan>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 03, 2011 at 01:44:10PM -0400, Justin Piszcz wrote:
> Tested that patch:
> 
> 1. The driver no longer automatically loads, I had to manually modprobe it.
This must be some other problem not related with patch.

> 2. After loading, I get this (keep getting these)
> 
> [  384.054538] phy0 -> rt2800_txdone: Error - Data pending
> [  384.072773] phy0 -> rt2800_txdone: Error - Data pending
> [  384.096545] phy0 -> rt2800_txdone: Error - Data pending
> [  384.117301] phy0 -> rt2800_txdone: Error - Data pending
> [  384.537586] phy0 -> rt2800_txdone: Error - Data pending
> [  384.555716] phy0 -> rt2800_txdone: Error - Data pending
> [  384.573903] phy0 -> rt2800_txdone: Error - Data pending
> [  384.599465] phy0 -> rt2800_txdone: Error - Data pending
> [  384.618523] phy0 -> rt2800_txdone: Error - Data pending
You can remove line

ERROR(rt2x00dev, "Data pending\n");

from rt2800_txdone to stop seeing this. It's kinda interesting
how frequent this happens.

> No crash yet, but bad ping again too (always with the rt2800usb) driver:
> 
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=1 ttl=64 time=53.1 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=2 ttl=64 time=285 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=3 ttl=64 time=89.6 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=4 ttl=64 time=120 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=5 ttl=64 time=42.2 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=6 ttl=64 time=156 ms
> 64 bytes from atomw.internal.lan (192.168.0.2): icmp_req=7 ttl=64 time=77.2 ms

I think patch could have site effect to not run tx queue while we have pending
data on it. Do you have such ping times always (i.e. after a 5 minutes, 10
minutes, 20  ... ) or just randomly?

Stanislaw

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756382Ab2EJGrZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 02:47:25 -0400
Received: from db3ehsobe003.messaging.microsoft.com ([213.199.154.141]:28980
	"EHLO db3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756116Ab2EJGrB convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 02:47:01 -0400
X-SpamScore: -5
X-BigFish: VS-5(zz1432Nzz1202hzz8275bhz2dh2a8h668h839h8e2h8e3h944hd25hbe9i)
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
From: Chen Peter-B29397 <B29397@freescale.com>
To: NeilBrown <neilb@suse.de>
CC: Samuel Ortiz <sameo@linux.intel.com>, Felipe Balbi <balbi@ti.com>,
        Grazvydas Ignotas <notasas@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>
Subject: RE: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Thread-Topic: [PATCH 0/6] twl4030: Various fixes for charing-from-USB
Thread-Index: AQHNLkuhf8G1IATuKEy7uxjYSGSTfpbCowcA///pJTA=
Date: Thu, 10 May 2012 06:46:51 +0000
Message-ID: <F281D0F91ED19E4D8E63A7504E8A649803B9492C@039-SN2MPN1-022.039d.mgd.msft.net>
References: <20120425072931.20124.56635.stgit@notabene.brown>
	<20120510012422.GA32077@nchen-desktop>
 <20120510123754.6a6d95b9@notabene.brown>
In-Reply-To: <20120510123754.6a6d95b9@notabene.brown>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [10.192.242.2]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 
> 
>  Would you be able to help me understand exactly what it means for the
> USB
>  bus to go to suspend?  Is this something that the host initiates or
>  something that the gadget initiates?
Host initiates it, when host wants to suspend the whole bus or certain port,
it will stop sending SOF, after 3ms of that, the device will pullup dp.
After that, the bus is at suspend state (dp=3, dm=0).

Please see:
http://www.amebasystems.com/downloads/hardware/datasheets/USB/
usb_20_052709/Suspend%20Current%20ECN.pdf

>  How does this relate to a simple charger?  It that considered to have a
>  non-suspended bus, or is it considered as a separate case?
> 
You may need a USB Charger driver which can differentiate dedicated charger (DCP),
host charger (CDP), or pc host port(SDP).
Only at SDP case, you need to consider suspend current limiation. 

>  Maybe we need to not suspend the USB OTG interface when the device as a
>  whole enters suspend-to-RAM.  Maybe we need to register a dummy gadget
> to
>  the bus active while in suspend?
>  Does the gadget have to be responsive while-ever the bus is not
> suspended?
>  Maybe we can arrange for any USB activity to trigger a resume?
> 
>  Entering suspend while still charging really should be possible - at
> least
>  with a dump charger and hopefully from a host port as well.  I'll like
> to
>  find the best way to achieve that, and any help you can provide would be
>  greatly appreciated.
> 
The host may not limit charge current when the vbus is on, but the device should
not draw much current when the host is suspended. Consider below case:

There is a Media Player connecting at laptop (without connecting wall power), 
the laptop may suspend sometime later(vbus is still on), the Media Player may
go on working and continue drawing hundreds of mA from the host. Some hours
later, the capacity of laptop will be exhausted which is not expected. 
 



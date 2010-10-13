Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751788Ab0JMQIb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 12:08:31 -0400
Received: from 92.236.191.90.dyn.estpak.ee ([90.191.236.92]:50975 "EHLO x41"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750963Ab0JMQIa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 12:08:30 -0400
X-Greylist: delayed 438 seconds by postgrey-1.27 at vger.kernel.org; Wed, 13 Oct 2010 12:08:29 EDT
Subject: BUG: USB3.0 =?ISO-8859-1?Q?=B5PD720200?= complains about
 over-current
From: =?ISO-8859-1?Q?T=F5nu?= Samuel <tonu@jes.ee>
To: linux-kernel <linux-kernel@vger.kernel.org>
Cc: tonu@jes.ee
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 13 Oct 2010 19:01:09 +0300
Message-ID: <1286985669.4853.14.camel@x41.itrotid.ee>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I know, this is place where only Gods speak and others not. But I am
sure there is something odd I found and someone here can take care of
it.

In situation when nothing is connected to any USB ports Ubuntu 10.04.1
stock kernel complains:
spider@spider:~$ zcat /var/log/kern.log.2.gz | grep -i current | head
Sep 29 23:30:12 spider kernel: [    9.048388] hub 8-0:1.0: over-current
change on port 1
Sep 29 23:30:12 spider kernel: [    9.152036] hub 8-0:1.0: over-current
change on port 2
Sep 29 23:30:12 spider kernel: [    9.256038] hub 8-0:1.0: over-current
change on port 3
Sep 29 23:30:12 spider kernel: [    9.360037] hub 8-0:1.0: over-current
change on port 1
Sep 29 23:30:12 spider kernel: [    9.464036] hub 8-0:1.0: over-current
change on port 2
Sep 29 23:30:12 spider kernel: [    9.570621] hub 8-0:1.0: over-current
change on port 3
Sep 29 23:30:12 spider kernel: [    9.672037] hub 8-0:1.0: over-current
change on port 1
Sep 29 23:30:12 spider kernel: [    9.776038] hub 8-0:1.0: over-current
change on port 2
Sep 29 23:30:12 spider kernel: [    9.880049] hub 8-0:1.0: over-current
change on port 3
Sep 29 23:30:13 spider kernel: [    9.984041] hub 8-0:1.0: over-current
change on port 1
spider@spider:~$ 

This runs forever and makes computer busy forever just running those
messages. I verified same behavior exists with vanilla 2.6.35.7.
Disabling USB3.0 in BIOS turns off problem and all USB2 ports remain to
work. So probably this is xHCI driver who complains. I looked bit around
in source and see it is copied from USB2 code and possibly USB3 has
something different. I've read USB3 can supply more power, so possibly
something here has changed.

My hardware:

Motherboard ASUS M4A88T-I Deluxe
http://www.asus.com/product.aspx?P_ID=jGAoIFEziW5sPYy7

it has USB3 chip "NEC D720200F1" on it:
http://digi.physic.ut.ee/mw/images/d/de/20100926_digi_007.png

NEC is joined Renesas, so this is his link for datasheet etc:
http://www2.renesas.com/usb/en/product/upd720200.html

If you propose patch, I can give him test run.

   Tõnu


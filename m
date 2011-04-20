Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753737Ab1DTH0R (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 03:26:17 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:61209 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753364Ab1DTH0P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 03:26:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Wed, 20 Apr 2011 09:26:08 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Greg KH" <greg@kroah.com>, "Andy Botting" <andy@andybotting.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <201104191635.40351.arnd@arndb.de> <op.vt76hofg3ri7v4@arend-laptop>
In-Reply-To: <op.vt76hofg3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104200926.09110.arnd@arndb.de>
X-Provags-ID: V02:K0:MxSdm4lF0NyEwGHrAYVf12jWUjK/eDqo+z5Qo6qf+bW
 GQhWNabDVpQ7H/hoShl6/aaCXCGcvl7QTQtW160wjru2+TnXhN
 D4F/xyNY6cguiwRJuQPVZm8o7/OxgShW+4oQSbg4aT1yKHHKn6
 fl9FeqtpnTKArHvn21SHqjteNzCcpIRFX+X6Azl6e2wsuDnue7
 jRvfKqj0JwEyM84tqjlgQ==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 April 2011 09:16:26 Arend van Spriel wrote:
> >
> > A platform device means something that cannot be probed, in every other
> > respect it is the same as other devices. From your explanation above,
> > it seems that you don't actually need to represent the cores on your
> > particular chips as struct device in Linux at all.
> >
> > If you wanted to use platform_device, the right way would probably
> > be an MFD device that creates multiple child devices (which end
> > up as platform_device, though you don't need to worry about that)
> > from the PCI driver. Then you could use the child devices completely
> > independent from one another.
> >
> > Since you say that the cores in this case are tightly coupled and
> > don't provide independent functionality to the system, there is
> > no need to represent them as devices.
> 
> The case is a hypothetical one, but I consider it a likely one. The axi  
> bus driver currently registers each detected core as a device in the linux  
> device tree. My statement is that this implies loose or no coupling  
> between those cores, which is not true. One (or two) exceptions have  
> already been identified. I would expect your last line to read: ...to the  
> system, those cores should not be represented as devices.

The important question is what is most practical here. If most of the
cores of this type are standalone devices, it's probably best to represent
all of them as separate devices, and find ways to deal with the few logical
devices that are spread across multiple cores.
It it's the exception and you typically have a significant number of IP
blocks that need to be combined to make a single logical device, I would
recommend not representing each of them as a struct device.

We really need to figure out first what the requirements are given the
hardware you want to support with this.

	Arnd

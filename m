Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752978Ab1DSOgD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 10:36:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:60827 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1DSOfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 10:35:52 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Tue, 19 Apr 2011 16:35:40 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
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
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <201104171938.12834.arnd@arndb.de> <op.vt6ufu1n3ri7v4@arend-laptop>
In-Reply-To: <op.vt6ufu1n3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104191635.40351.arnd@arndb.de>
X-Provags-ID: V02:K0:fXRHylkA2+wY5vvPccKtk0WgJgGWi5iGHjGdgqzhdEo
 6XBSVH3DhdZK8pM+0UJqoTQ8FGrzP+mPieg2ZZ5NqP1G3kYb8b
 y4QSq/b28zX+uwD23cinmRgCmUX8jdCfGEL1bnJRGTYBjdTP5A
 fW1LHcw0cxMaQyxglXX7WZ9VAt9FqPp3SdqFxzaWeWtOVyDK/e
 YgEm5asWKvTzjG26RwVNw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 19 April 2011, Arend van Spriel wrote:

> > A new bus_type really only makes sense if you expect a lot of devices
> > to use this and you want to have the probing in the bus. If you only
> > want to have a way to enumerate devices that get created by the
> > parent driver, you can also use platform devices.
> 
> The main assumption of the (bcm)axi driver seems to be that each core can
> be considered as a device. Correct me if I am wrong, but I consider a
> device to be an entity providing a particular system function. So an
> ethernet device provides ethernet connectivity function, a mixer device
> provides sound mixing function, and so on. The cores within a chip are not
> always self-contained like this. To clarify let's say a system function is
> realized by programming core A, core B, and finally trigger core A to set
> the function in motion. This implies the need of coordination between the
> programming steps on those cores.
> 
> Is my view on what is a device wrong? Does a platform device differ in
> this respect from a regular device?

A platform device means something that cannot be probed, in every other
respect it is the same as other devices. From your explanation above,
it seems that you don't actually need to represent the cores on your
particular chips as struct device in Linux at all.

If you wanted to use platform_device, the right way would probably
be an MFD device that creates multiple child devices (which end
up as platform_device, though you don't need to worry about that)
from the PCI driver. Then you could use the child devices completely
independent from one another.

Since you say that the cores in this case are tightly coupled and
don't provide independent functionality to the system, there is
no need to represent them as devices.

	Arnd

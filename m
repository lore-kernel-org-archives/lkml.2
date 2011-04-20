Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab1DTGoe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Apr 2011 02:44:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.8]:61996 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752325Ab1DTGod (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Apr 2011 02:44:33 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: "Arend van Spriel" <arend@broadcom.com>
Subject: Re: Could I (ab)use bus (struct bus_type) for virtual Broadcom bus?
Date: Wed, 20 Apr 2011 08:44:10 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "Greg KH" <greg@kroah.com>,
        =?utf-8?q?Rafa=C5=82_Mi=C5=82ecki?= <zajec5@gmail.com>,
        "George Kashperko" <george@znau.edu.ua>,
        "Hauke Mehrtens" <hauke@hauke-m.de>,
        "Russell King" <rmk@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Jonas Gorski" <jonas.gorski@gmail.com>,
        "b43-dev@lists.infradead.org" <b43-dev@lists.infradead.org>,
        "Andy Botting" <andy@andybotting.com>,
        "Larry Finger" <Larry.Finger@lwfinger.net>
References: <BANLkTim7Uj2tsgFngWhUqFK_hk3Leg+sQA@mail.gmail.com> <20110419140257.GA20456@kroah.com> <op.vt74sxvp3ri7v4@arend-laptop>
In-Reply-To: <op.vt74sxvp3ri7v4@arend-laptop>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201104200844.10607.arnd@arndb.de>
X-Provags-ID: V02:K0:5jb8tsjXRwwMrPULsQf/2Kn5LswhqP0EvKBJMjFDPsx
 T/kfZJg8YOt9kGm6apBow1T4kn5HyxJXIrrj6gDAYjpoFSNURx
 I8ABstgxtuXEnaO/i39jLXJL2HMx+UCHAZFjjy8lhP0eNwy9UA
 1mtdM5WVxQBlBgXOm7zDTx9ZaALXQ+kYaRBEYy/WSmkoqgHC62
 bl1AT7gePrKbhusIjv3ow==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 April 2011 08:39:59 Arend van Spriel wrote:
> On Tue, 19 Apr 2011 16:02:57 +0200, Greg KH <greg@kroah.com> wrote:
> 
> > Please don't use a platform device, unless there is no other way for
> > your device to work.  For this device, you are connected to the PCI bus,
> > so a platform device does not make sense at all.
> 
> Hi Greg,
> 
> This is only true for a particular usage model. There are two models as  
> shown below:
> 
> 1) PCI(e) card
>                        ...........
> +----------+          :   x y z :     x, y, and z are cores.
> |    uC    |__________:___|_|_| :
> |          |  PCI-bus : axi-bus :
> +----------+          :.........:
>                        bcm chipset
> 
> 2) SoC
>            ...............
>            : uC    x y z :
>            :  |____|_|_| :
>            :    axi-bus  :
>            :.............:
>              bcm chipset
> 
> Your statement is true for 1) but in usage model 2) there is no PCI bus.  
> Also you refer to the chipset when you say 'device'. In the axi bus type  
> each individual core is registered as a device in the linux device tree.

I guess what Greg was referring to is having platform devices for x/y/z
here. In case 2, you might still need to have a platform_device for the
combination of the three IP cores if they make up one logical device.

As mentioned in my reply, it depends a lot on what these cores actually
are, e.g. whether you might want to have only one of them active in a
given system to drive a specific functionality, or if you always need
all three of them.

	Arnd

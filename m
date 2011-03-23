Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755420Ab1CWRMX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:12:23 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:59599 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755150Ab1CWRMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:12:22 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: andy.green@linaro.org
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Wed, 23 Mar 2011 18:11:53 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Greg KH <greg@kroah.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca, netdev@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
References: <4D79F068.2080009@linaro.org> <201103231756.39849.arnd@arndb.de> <4D8A2830.6020706@linaro.org>
In-Reply-To: <4D8A2830.6020706@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231811.54290.arnd@arndb.de>
X-Provags-ID: V02:K0:SnYjg9CoUCnfeskB2Tt2NMOUkwVoFaQHFRN+ccIX+B4
 hh8i59b1fX6NVBqoxm58bYPXIvbfB1XWfQTO9pP8afQPcGXlci
 2hsiCu/4JPBFh4McgmHU60Dh/SBKgTZo8miP6yj/ZJbKCGuUDS
 GjlkkAr8Jvbyo4/z1MT+gokkyMIBptFUGzQVxozhLv5YQgDU9q
 iw0xBsbz6GPnB2AfscQ/Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Andy Green wrote:
> > diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> > index bc86f4b..c98d3a7 100644
> > --- a/drivers/net/usb/smsc95xx.c
> > +++ b/drivers/net/usb/smsc95xx.c
> > @@ -1231,7 +1231,7 @@ static const struct driver_info smsc95xx_info = {
> 
> > -     .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
> > +     .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
> 
> >               if ((dev->driver_info->flags&  FLAG_ETHER) != 0&&
> > +                 ((dev->driver_info->flags&  FLAG_PTP) == 0 ||
> > +                  (net->dev_addr [0]&  0x02) == 0))
> >                       strcpy (net->name, "eth%d");
> 
> So it just takes the approach that all smsc95xx are going to be eth%d? 

Right, and all other drivers that are obviously ethernet-only, including
future drivers.

	Arnd

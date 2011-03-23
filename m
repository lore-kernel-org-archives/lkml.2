Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932812Ab1CWTfq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 15:35:46 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:53608 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756619Ab1CWTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 15:35:45 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Wed, 23 Mar 2011 20:35:17 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: andy.green@linaro.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca, netdev@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
References: <4D79F068.2080009@linaro.org> <201103231756.39849.arnd@arndb.de> <20110323184650.GB21728@kroah.com>
In-Reply-To: <20110323184650.GB21728@kroah.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103232035.18232.arnd@arndb.de>
X-Provags-ID: V02:K0:bKgGqsYU1W47FyIE0fPcZbAKTyyFr2g+pZRXzr5Ir7C
 WxYbGapSf6/180gMKFqCGpIs1cYt1jKRZIvwUT2H/O9prT8ZeB
 9rW9ZLix10Kltx/7YoUNXnK9QXfuswccIcLKK2XitO+iHR1jB1
 zntpxAl39wbxW2lwzV6JIUohoYzrQ2i3G6Jynt/s1+tjeLpweD
 wfcLkc7C9/gn/48oXW/Bw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011 19:46:50 Greg KH wrote:
> Looks good to me, but some questions:
> 
> >  drivers/usb/serial/usb_wwan.c |    2 +-
> 
> You don't modify this file in the diff, what caused this to show up in
> the diffstat?

A stale change I had to do to get the kernel to build on my
machine. The original problem seems fixed now. I had removed
this hunk from the patch but forgot to remove it from the diffstat.

> > --- a/include/linux/usb/usbnet.h
> > +++ b/include/linux/usb/usbnet.h
> > @@ -97,6 +97,8 @@ struct driver_info {
> >  
> >  #define FLAG_LINK_INTR       0x0800          /* updates link (carrier) status */
> >  
> > +#define FLAG_PTP     0x1000          /* maybe use "usb%d" names */
> 
> "PTP"?  What does that stand for?

point-to-point, I'll improve the comment to spell it out when I send the
fixed version.

	Arnd

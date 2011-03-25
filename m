Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753982Ab1CYQoK (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:44:10 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:50747 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751659Ab1CYQoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:44:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Alexey Orishko <alexey.orishko@gmail.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Fri, 25 Mar 2011 17:43:54 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Steve Calfee <stevecalfee@gmail.com>,
        Michal Nazarewicz <mnazarewicz@gmail.com>,
        Randy Dunlap <rdunlap@xenotime.net>,
        broonie@opensource.wolfsonmicro.com,
        lkml <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, Greg KH <greg@kroah.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, grant.likely@secretlab.ca,
        Linux USB list <linux-usb@vger.kernel.org>, andy.green@linaro.org,
        netdev@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        roger.quadros@nokia.com, Jaswinder Singh <jaswinder.singh@linaro.org>,
        patches@linaro.org
References: <4D79F068.2080009@linaro.org> <201103251257.32714.arnd@arndb.de> <AANLkTikEJi7bg5GG3Ero_Poe9F6WiKo8rW+Y1KtxhQ4B@mail.gmail.com>
In-Reply-To: <AANLkTikEJi7bg5GG3Ero_Poe9F6WiKo8rW+Y1KtxhQ4B@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103251743.54805.arnd@arndb.de>
X-Provags-ID: V02:K0:eMlboT6GKuhIOpEkHDjSJFeBDqZ/AvvHoMwvOoY2TA2
 5kEm9B06v9i0FnkZdbEabNm1MJy3I7B0ycmpy19mw39Pd/lOoN
 f2om/IYYI2vK37SrNSK4fFQcm4L6ttmHpZ568Er+uKaM8ky5mu
 cR6moMnjNtsnnFxzyzQeciP9fLDOmFlJPlUEkRmvRSYnHdZTDH
 xLZZ94NgZppGUC7XC8tgw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011, Alexey Orishko wrote:
> On Fri, Mar 25, 2011 at 12:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> >
> > That would be a different way of looking at it.  FLAG_POINTTOPOINT
> > describes what the device is (a USB cable connecting two hosts), and
> > that flag can be used for various things, where the only thing
> > we currently do is the netif naming.
> >
> 
> For example, cdc_ether and cdc-ncm drivers can be used in different use cases:
> a) when device terminates the IP traffic
> or
> b) where device is a wireless router.
> 
> In both cases ethernet frames are sent over usb cable and terminated
> in device (eth header stripped), so it is point-to-point link for ethernet, but
> looking from IP layer is not p2p link for case b).
> 
> Please, explain, based on your idea, do we set this flag in both cases or not?
> Do you want to use the same netif name for both use cases described above?
> 

Most importantly, I want to keep the current rules, so that nothing breaks
for existing users.

For cdc_ether and cdc-ncm devices, my patch always sets both FLAG_ETHER and
FLAG_POINTTOPOINT, because the driver has no way to find out which of the
two is actually there.

The usb-net core driver interprets this as meaning that it has to decide
for the name based on something else, and that happens to be the presence
of a globally assigned MAC address. I don't think that keying off the MAC
address here is a particularly good idea, but that's what the driver has
always done.

	Arnd

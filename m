Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754436Ab1CYQ0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:26:36 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:34421 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754303Ab1CYQ0e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:26:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=NHUSv3psV3UmU+WoFYfl8C5drecZAX+V+Q7DL2NIjR5krchyU107u4Hy8IlCKq5l9G
         r1oZkridM7U+K72/lL1ng6rOdXLi9PJQLpk569GMWloPrEVvqQIR5ogR0WmmEfxoG/dp
         fRMrr+I1jCN/S8aPNhUtwRzRRRhNFRncmug7I=
MIME-Version: 1.0
In-Reply-To: <201103251257.32714.arnd@arndb.de>
References: <4D79F068.2080009@linaro.org>
	<201103241415.45115.arnd@arndb.de>
	<AANLkTikZ76VXdPf46FHxhCyf3n4rNZOQW4Rp2yUZWP2h@mail.gmail.com>
	<201103251257.32714.arnd@arndb.de>
Date: Fri, 25 Mar 2011 17:26:31 +0100
Message-ID: <AANLkTikEJi7bg5GG3Ero_Poe9F6WiKo8rW+Y1KtxhQ4B@mail.gmail.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
From: Alexey Orishko <alexey.orishko@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
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
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 12:57 PM, Arnd Bergmann <arnd@arndb.de> wrote:
>
> That would be a different way of looking at it.  FLAG_POINTTOPOINT
> describes what the device is (a USB cable connecting two hosts), and
> that flag can be used for various things, where the only thing
> we currently do is the netif naming.
>

For example, cdc_ether and cdc-ncm drivers can be used in different use cases:
a) when device terminates the IP traffic
or
b) where device is a wireless router.

In both cases ethernet frames are sent over usb cable and terminated
in device (eth header stripped), so it is point-to-point link for ethernet, but
looking from IP layer is not p2p link for case b).

Please, explain, based on your idea, do we set this flag in both cases or not?
Do you want to use the same netif name for both use cases described above?

/alexey

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab1CWRN5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 13:13:57 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:54443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752255Ab1CWRNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 13:13:55 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <greg@kroah.com>
Subject: Re: [RFC] usbnet: use eth%d name for known ethernet devices
Date: Wed, 23 Mar 2011 18:13:41 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.37; KDE/4.3.2; x86_64; ; )
Cc: andy.green@linaro.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        grant.likely@secretlab.ca, netdev@vger.kernel.org,
        David Brownell <dbrownell@users.sourceforge.net>
References: <4D79F068.2080009@linaro.org> <20110323162251.GA9367@kroah.com> <201103231756.39849.arnd@arndb.de>
In-Reply-To: <201103231756.39849.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103231813.41776.arnd@arndb.de>
X-Provags-ID: V02:K0:gjE00mgd+0RHvtkKxact+T5YF6/HX2F7zRwI+mKKdXt
 bFM11sKMP8KbIE+N9ep/bbKGXJk6ELwSj28cpAD9CXAy7X7Ojn
 VxkojDgMYjVMeCCNgkpeaM8Vf0UOOWvf6SZ6+utkCS2oMO34VG
 DsQf2+EhoTuX5rh8mNQzliH+/EYr+3V2/emlRTA2ImVHLz+Qnm
 aBnLrQu8jm/r0XefPgJQw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 23 March 2011, Arnd Bergmann wrote:
> --- a/drivers/net/usb/smsc75xx.c
> +++ b/drivers/net/usb/smsc75xx.c
> @@ -1244,7 +1244,7 @@ static const struct driver_info smsc75xx_info = {
>         .rx_fixup       = smsc75xx_rx_fixup,
>         .tx_fixup       = smsc75xx_tx_fixup,
>         .status         = smsc75xx_status,
> -       .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
> +       .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
>  };
>  
>  static const struct usb_device_id products[] = {
> diff --git a/drivers/net/usb/smsc95xx.c b/drivers/net/usb/smsc95xx.c
> index bc86f4b..c98d3a7 100644
> --- a/drivers/net/usb/smsc95xx.c
> +++ b/drivers/net/usb/smsc95xx.c
> @@ -1231,7 +1231,7 @@ static const struct driver_info smsc95xx_info = {
>         .rx_fixup       = smsc95xx_rx_fixup,
>         .tx_fixup       = smsc95xx_tx_fixup,
>         .status         = smsc95xx_status,
> -       .flags          = FLAG_ETHER | FLAG_SEND_ZLP,
> +       .flags          = FLAG_ETHER | FLAG_SEND_ZLP | FLAG_REALLY_ETHER,
>  };
>  

These two hunks are from an earlier version of the patch and should not
be there, they break compilation. I'll wait for more comments and
then send a fixed version.

	Arnd

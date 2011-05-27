Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758645Ab1E0B2H (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 21:28:07 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:47285 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752515Ab1E0B2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 21:28:04 -0400
X-Sasl-enc: GgVdB3DaUVtUBTCnH2mWZsPxiV/szWEPGV44uKZc8RHW 1306459682
Date: Fri, 27 May 2011 09:20:22 +0800
From: Greg KH <greg@kroah.com>
To: Michael Tokarev <mjt@tls.msk.ru>,
        =?utf-8?B?UGF3ZcWC?= Drobek <pawel.drobek@gmail.com>
Cc: Linux USB list <linux-usb@vger.kernel.org>,
        Linux-kernel <linux-kernel@vger.kernel.org>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
Message-ID: <20110527012022.GF24630@kroah.com>
References: <4DDEC269.30808@msgid.tls.msk.ru>
 <4DDEC606.4020504@msgid.tls.msk.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4DDEC606.4020504@msgid.tls.msk.ru>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 01:28:38AM +0400, Michael Tokarev wrote:
> 27.05.2011 01:13, Michael Tokarev wrote:
> > I noticed that recently, all my systems started
> > loading option.ko driver even if I've no single
> > GSM modem anywhere around.
> > 
> > After some investigation I found this in option.c:
> > 
> > /* ZTE PRODUCTS -- alternate vendor ID */
> > #define ZTE_VENDOR_ID2                          0x1d6b
> > #define ZTE_PRODUCT_MF_330                      0x0002
> > ...
> >         { USB_DEVICE(ZTE_VENDOR_ID2, ZTE_PRODUCT_MF_330) },
> > 
> > 
> > But this matches... "Linux Foundation 2.0 root hub",
> > which has this module alias:
> > 
> >   usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00
> 
> Forgot to mention, and to add proper Cc.  The commit
> is this one:
> 
>  commit a559d2c8c1bf652ea2d0ecd6ab4a250fcdb37db8
>  Author: Dominik Brodowski <linux@dominikbrodowski.net>
>  Date:   Wed Apr 14 21:36:42 2010 +0200
> 
>     USB: option: add ID for ZTE MF 330
> 
>     Based on the information provided for by Paweł Drobek, add
>     a second vendor ID and the correct product ID for ZTE MF 330.
> 
>     Reported-by: Paweł Drobek <pawel.drobek@gmail.com>
>     Signed-off: Dominik Brodowski <linux@dominikbrodowski.net>
>     Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
> 
> Are the IDs really correct?  Maybe it's just a typo
> after all...

I don't know, Paweł, can you provide the output of 'lsusb -v' for your
system where you saw this being a option device instead of a hub?

thanks,

greg k-h

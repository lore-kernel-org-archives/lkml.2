Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758550Ab1EZV2m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 May 2011 17:28:42 -0400
Received: from isrv.corpit.ru ([86.62.121.231]:49916 "EHLO isrv.corpit.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752779Ab1EZV2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 May 2011 17:28:41 -0400
Message-ID: <4DDEC606.4020504@msgid.tls.msk.ru>
Date: Fri, 27 May 2011 01:28:38 +0400
From: Michael Tokarev <mjt@tls.msk.ru>
Organization: Telecom Service, JSC
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.16) Gecko/20110506 Icedove/3.0.11
MIME-Version: 1.0
To: Linux USB list <linux-usb@vger.kernel.org>
CC: Linux-kernel <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?UGF3ZcWCIERyb2I=?= =?UTF-8?B?ZWs=?= 
	<pawel.drobek@gmail.com>,
        Dominik Brodowski <linux@dominikbrodowski.net>
Subject: Re: option driver, ZTE MF_330 matches linux usb 2.0 root hub
References: <4DDEC269.30808@msgid.tls.msk.ru>
In-Reply-To: <4DDEC269.30808@msgid.tls.msk.ru>
X-Enigmail-Version: 1.0.1
OpenPGP: id=804465C5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

27.05.2011 01:13, Michael Tokarev wrote:
> I noticed that recently, all my systems started
> loading option.ko driver even if I've no single
> GSM modem anywhere around.
> 
> After some investigation I found this in option.c:
> 
> /* ZTE PRODUCTS -- alternate vendor ID */
> #define ZTE_VENDOR_ID2                          0x1d6b
> #define ZTE_PRODUCT_MF_330                      0x0002
> ...
>         { USB_DEVICE(ZTE_VENDOR_ID2, ZTE_PRODUCT_MF_330) },
> 
> 
> But this matches... "Linux Foundation 2.0 root hub",
> which has this module alias:
> 
>   usb:v1D6Bp0002d0206dc09dsc00dp00ic09isc00ip00

Forgot to mention, and to add proper Cc.  The commit
is this one:

 commit a559d2c8c1bf652ea2d0ecd6ab4a250fcdb37db8
 Author: Dominik Brodowski <linux@dominikbrodowski.net>
 Date:   Wed Apr 14 21:36:42 2010 +0200

    USB: option: add ID for ZTE MF 330

    Based on the information provided for by Paweł Drobek, add
    a second vendor ID and the correct product ID for ZTE MF 330.

    Reported-by: Paweł Drobek <pawel.drobek@gmail.com>
    Signed-off: Dominik Brodowski <linux@dominikbrodowski.net>
    Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>

Are the IDs really correct?  Maybe it's just a typo
after all...

It is interesting that no one noticed this so far.
Or it's just because it's difficult to search for -
"option" is really a bad search term ;)

> What are options to fix this option now? :)
> 
> Thanks!
> 
> [Cc'ing linux-kernel due to interesting USB ID clash]

/mjt

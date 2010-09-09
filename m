Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932351Ab0IIXF1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 19:05:27 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48488 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754284Ab0IIXFU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 19:05:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=et6eATNsWGyVjgKkXVuwvmUug3jkb9rpw5xPdi8n4jKjN8uxWsZ++80vB31+d2gx6c
         hAcIAlfOOOYPTG/SQMUNjfCSIJmzVU/7Wr/Xbo5DLOWlb6toeYW9XUqwhrdL/i5olh/Y
         T+tT9BCATfoqPrMJ+AuqcImt4NsGAkEOYwPiA=
MIME-Version: 1.0
In-Reply-To: <1284067889.4583.3.camel@lenovo>
References: <1284067889.4583.3.camel@lenovo>
From: Mike Frysinger <vapier@gentoo.org>
Date: Thu, 9 Sep 2010 19:04:58 -0400
X-Google-Sender-Auth: jNmv_WWjgofiJD5FW8eBfrc-4Mg
Message-ID: <AANLkTikDxQuRkyNYTwAPCv78J5yBASR+ya44-ncRNEf6@mail.gmail.com>
Subject: Re: [PATCH] USB: isp1362-hcd: Removes CONFIG_USB_OTG dependent code,
 fix build breakage
To: Javier Martinez Canillas <martinez.javier@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>,
        Lothar Wassmann <LW@karo-electronics.de>, Julia Lawall <julia@diku.dk>,
        Andrew Morton <akpm@linux-foundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 9, 2010 at 17:31, Javier Martinez Canillas wrote:
> In today linux-next I got a compile error on usb/host/isp1362-hcd:
>
> drivers/usb/host/isp1362-hcd.c: In function ‘isp1362_hub_control’:
> drivers/usb/host/isp1362-hcd.c:1680: error: ‘ohci’ undeclared (first use in this function)
>
> The problem is when the CONFIG_USB_OTG option is enabled.
>
> ohci variable is never declared and there isn't any CONFIG_USB_OTG dependent code
> besides the portion defined in isp1362_hub_control.
>
> So I think that maybe USB OTG support is not needed/supported.
>
> This patch removes the CONFIG_USB_OTG dependent block so the driver can compile cleanly.

i dont believe we've ever used OTG (or if our test board is even wired
up to support it), so this is fine by me.  let the guy who actually
uses OTG worry about it.  presumably no one has yet if it doesnt even
compile ...
-mike

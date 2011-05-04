Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab1EDMmi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 May 2011 08:42:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:42315 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752961Ab1EDMmg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 May 2011 08:42:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=vHKj0rQtd3rC1oMKlzcMMTCbr3yiZJqgflrvo8oDGJllN1kmUsWMj354lFVsrA+Pqy
         bV5QCAD/MELs36uYcL+BuHTllrxCdjiVfM78/i8oyuVcOVqzpEMb+uXdU3mxxqzR0lN8
         9q3Pu3tFWhHg0vsv8XsHm9A9GfZBkEwGnmBYs=
MIME-Version: 1.0
In-Reply-To: <1304511102.1788.91.camel@Joe-Laptop>
References: <cover.1304445019.git.joe@perches.com> <f86364fbdc335fadad003081d010843579e95765.1304445019.git.joe@perches.com>
 <4DC13A1B.8020004@ru.mvista.com> <1304511102.1788.91.camel@Joe-Laptop>
From: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>
Date: Wed, 4 May 2011 14:42:16 +0200
Message-ID: <BANLkTikW8W8ZVSYMyOSJxiWouLE1_tEiDQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] usbnet: Convert dbg to dev_dbg and neatening
To: Joe Perches <joe@perches.com>
Cc: Sergei Shtylyov <sshtylyov@mvista.com>, Oliver Neukum <oneukum@suse.de>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/5/4 Joe Perches <joe@perches.com>:
> On Wed, 2011-05-04 at 15:35 +0400, Sergei Shtylyov wrote:
>> Hello.
>
> And hello to you Sergei.
>
> On 03-05-2011 22:17, Joe Perches wrote:
>> > Use the more standard logging form.
>> > Add a bit more tidying style.
>>     Style changes look rather doubtful to me...
>> >   drivers/net/usb/usbnet.c |   23 +++++++++++------------
>> > diff --git a/drivers/net/usb/usbnet.c b/drivers/net/usb/usbnet.c
> []
>> > @@ -192,8 +192,8 @@ static int init_status(struct usbnet *dev, struct usb_interface *intf)
>> >             return 0;
>> >
>> >     pipe = usb_rcvintpipe(dev->udev,
>> > -                         dev->status->desc.bEndpointAddress
>> > -                   & USB_ENDPOINT_NUMBER_MASK);
>> > +                         (dev->status->desc.bEndpointAddress
>> > +                   & USB_ENDPOINT_NUMBER_MASK));
>>
>>     Why add parens?
>
> Leading & uses are almost always addressof.
> This makes it easier for me to see that it's not an addressof use.

This is a clear case where 80-char limit impairs code readability. Why
not just use another variable?

int epn = dev->status->desc.bEndpointAddress & USB_ENDPOINT_NUMBER_MASK;
pipe = usb_rcvintpipe(dev->udev, epn);

Best Regards,
Michał Mirosław

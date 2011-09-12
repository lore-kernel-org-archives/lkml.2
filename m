Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755576Ab1ILMON (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 08:14:13 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45461 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753801Ab1ILMOM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 08:14:12 -0400
MIME-Version: 1.0
In-Reply-To: <20110912113308.GA32396@kroah.com>
References: <CA+O4pCKfWLP+ohfUVi811CRbmrb2FyoMwkmxxGJ1TF2kKtGDEA@mail.gmail.com>
	<201108171914.52257.oliver@neukum.org>
	<CA+O4pCK3vZjZwM0D7Q0gzsTZRJC1PfzYvoVmq-g2jJQ=uP_6ug@mail.gmail.com>
	<201108190823.06638.oliver@neukum.org>
	<CA+O4pCKteFZBT0UMetuk4-gsUf4wG3DXnOooW47GWD7o=dgpQQ@mail.gmail.com>
	<CA+O4pC+gxbLaHDyAUB-ro1Z-jTGdMfey9yJht1Ux4jWhanKbkg@mail.gmail.com>
	<CA+O4pCK5WE+fgYzMjpp2x54ePGivTdZnPRQdZ+BN6HAARYVU+g@mail.gmail.com>
	<20110912113308.GA32396@kroah.com>
Date: Mon, 12 Sep 2011 14:14:11 +0200
Message-ID: <CA+O4pCKvi7rYYC=NSGgufA4T2Gajvj=+Z5YCdLKaDkcSVQ7jwA@mail.gmail.com>
Subject: Re: [PATCH] Increase usbfs bulk buffer size
From: Markus Rechberger <mrechberger@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: Oliver Neukum <oliver@neukum.org>, Greg Kroah-Hartman <gregkh@suse.de>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 1:33 PM, Greg KH <greg@kroah.com> wrote:
> On Mon, Sep 12, 2011 at 12:18:02PM +0200, Markus Rechberger wrote:
>> Hi,
>>
>> I'm a little bit curious why you guys are just ignoring this.
>
> Because you seem to be ignoring the fact that changing this can cause
> problems on systems.
>

Can you explain which problems? We are even using analogTV on
Freescale ARM Systems.
There is no way to read the maximum allowed buffersize from the kernel
right now,
if an application wants to use it they roughly need to know the
current maximum packet size.

Since this is about a product I'm not eager to introduce trouble to
our customers frankly speaking
those things are well tested at our side.

> And because it really doesn't solve any problems,

wrong, it does solve problems, and it also solved it in the past for
isochronous. Would it help if we ship a sample
device to you?
The easiest way to reproduce this is to take 2 different Ubuntu
versions, an old one with lower Isochronous packet size eg. Ubuntu
9.04
and another new one Ubuntu 10.04.
Simply dragging the player with Ubuntu 9.04 can cause framedrops,
while it works smoothly with 10.04.
Next step update the buffer with 9.04 and the video is also smoothly
with the old version - and there are no framedrops (=incomplete data).
I can imagine because the application just gets a certain timeslice
and cannot reliable requeue many packets.
The problem with Bulk is that we need to submit many Bulk URBs in
order to get it work at all, aside of that it shows up the
same issue as with isochronous.

> you are only pushing
> the processing to the kernel, when it can be done in userspace just as
> easily.
>

Your assumption is wrong, even though I understand your point.
All I want is to sort this out.

Markus

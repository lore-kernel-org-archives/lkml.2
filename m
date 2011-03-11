Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807Ab1CKQwe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 11:52:34 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:49922 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750893Ab1CKQwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 11:52:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=ww1v+323L6EXL32W460s50NdIfmodSBNkafEtkYmPrYnptOHOsTb4Q6addvpbZHuWi
         SyC2BpvlTBd2+Cj0997NuSrwxld8WHrdGyMzE/D0qPFRSB3gZXO3UpFzWtNPeyd2A2z1
         xDuz4Sk31wJnhH/zr6E47s80kG5wrQpSaW5Do=
Message-ID: <4D7A5329.6080507@linaro.org>
Date: Fri, 11 Mar 2011 16:51:53 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103111141270.1975-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 04:45 PM, Somebody in the thread at some point said:

Hi -

> Or to put it another way...  With external, hot-plugged USB devices,
> there is no need to know "how it is wired".  The fact that it is on a
> USB bus is the only information necessary.  Why does anyone need to
> know more than this for on-board USB devices?

For example, the USB device is a chip with option pins.  On the board it 
is placed on, some of the option pins are tied in a particular way that 
impacts its actual function, but can't be seen from the chip itself. 
The driver covers all the options, but it needs to be told which mode 
the chip was wired up for.

Another example, it's a USB chip with GPIO pins, analogous to a I2C GPIO 
extender.  Some of the GPIO are wired to LEDs also on the board, which 
you want to expose as generic GPIO.  The board definition file is in a 
position to do all that because it knows what the board is and what it 
is wired up to.

That the USB chips in these examples are 'discoverable' has nothing to 
do with anything.  In fact the board definition file has knowledge about 
the "functional implemntation" of the instances of those chips -- just 
exactly those instances soldered to the board.  If you plugged another 
of these chips, the board definition file has nothing to say about it 
because they are not "on the board" and in-scope for it.

-Andy

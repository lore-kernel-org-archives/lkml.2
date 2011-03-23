Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab1CWMCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 08:02:45 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:55278 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab1CWMCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 08:02:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=Q1TkooqLPgEpltsBCj6UEOPe7cFitQ51Y8kqL8tQTwHgvHJXX+88YRxD2RPydQovYJ
         ads3o84DUx3cR2pFWLJB4MW/cfDi+H4Jpl1M37OWLBepmJYQIYR5EnXEjirWP8P37AsD
         byYt7R8/pR3NRlVnaLUGE8clrlr7oiFqPnvAY=
Message-ID: <4D89E15F.2030907@linaro.org>
Date: Wed, 23 Mar 2011 12:02:39 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Arnd Bergmann <arnd@arndb.de>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	<20110323094720.63e7c6b2@lxorguk.ukuu.org.uk>	<4D89C618.1020608@linaro.org>	<201103231132.02690.arnd@arndb.de>	<4D89CDE4.3000504@linaro.org>	<20110323105607.50697c65@lxorguk.ukuu.org.uk>	<4D89D5EB.50803@linaro.org> <20110323113455.59492e24@lxorguk.ukuu.org.uk>
In-Reply-To: <20110323113455.59492e24@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 11:34 AM, Somebody in the thread at some point said:
>> business to know, but that the usb device on the specific wired-up USB
>> port to the RJ45 soldered on the board should be guided a particular way
>> when the interface name is registered.  That can only be done properly
>> in-kernel by passing in a flag to usbnet specific to the device instance
>> to guide its choice.
>
> To my mind the MAC case is a bit different to the name case. It's really
> not about policy in that situation it's a USB widget with a non standard
> "retrieve mac address" method.
>
> You could fix it up in user space from firmware tables, or in either from
> looking in your device tree.
>
> There is one way you could actually hide all this in your board specific
> gunge at the moment without touching the core kernel I think. Take a look
> at how register_netdev_notifier() works.
>
> That will give you a NETDEV_REGISTER event for each device being
> registered so you can then pick out your usb network device.
>
> It might need some slightly unclean knowledge of the usb net driver in
> your glue but in the short term until there is a nice device tree type
> answer it would allow you to get your MAC address set up properly I
> think ?

Sounds like a good way...  it's register_netdevice_notifier().

I'll study this and try adapt the patches accordingly.

Thanks a lot for this hint.

-Andy


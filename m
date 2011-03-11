Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755176Ab1CKMoQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 07:44:16 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47774 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753646Ab1CKMoP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 07:44:15 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=lYgq2ctmAxSr77odIQXQv7EYIIqm8zTps/W7cWuG0BkvJ6owDkfo4lpK7c9kQ/GL+t
         DW3zGulEUyl4nUM+L56nKq/CADS//bXlZg3w89UrHfJM1689bCkO7wbjppA7Y7IMk2SB
         MaXHcNMAO9+iJYY/ZZrWJw4TZHIlvQbHpWtMc=
Message-ID: <4D7A191B.7040100@linaro.org>
Date: Fri, 11 Mar 2011 12:44:11 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <201103111331.13932.arnd@arndb.de>
In-Reply-To: <201103111331.13932.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/11/2011 12:31 PM, Somebody in the thread at some point said:

Hi -

>> platform_data is a well established way in Linux to pass configuration
>> data up to on-board assets from a machine file like mach-xyz.c.  It's
>> also supported to pass platform_data up to devices that are probed
>> asynchronously from busses like i2c as well, which is very handy.
>>
>> However AFAIK it's not possible to bind platform_data to probed USB
>> devices as it stands.
>>
>> There are now boards which have on-board USB assets, for example OMAP4
>> Panda which has a USB<->  Ethernet bridge wired up permanently.  It'd be
>> convenient to also be able to pass optional platform_data to these
>> devices when they are asynchronously probed.
>
> Sorry, but I think it's a bad idea to use platform data for this.
> USB is a bus that we can reasonably probe, while we use platform_data
> only for stuff that we can by definition not probe at all.

...

> One relatively easy solution would be to allow passing a MAC address
> to this particular device driver as a module parameter, and generating
> a fixed MAC address in the regular vendor space when installing the
> boot loader. That would also solve the problem that a DHCP server
> currently assigns a new IP address to a panda board at every boot.

I suggested this myself on #15 of the bug you linked to.  However, it 
seems to me there is a generic issue here and it is not to do with 
whether stuff can be discovered on the bus or not; bugging the usbnet 
guys to accept devname-based commandline params and solving it for 
usbnet only would be covering up the actual issue.

The I2C implementation does not limit itself to providing I2C addresses 
and binding to driver names so it can be probed, it also provides for 
sending platform_data into the device when it is instantiated.  That is 
very useful and I don't think the I2C guys will be accepting patches to 
remove that capability.

There is no reason I can see that onboard USB assets should continue to 
be treated differently to miss out on the same capability because they 
are USB and not I2C, particularly as a permanently NULL platform_data 
pointer is already sitting there in the usb_device's .dev already 
exactly for this use.

-Andy

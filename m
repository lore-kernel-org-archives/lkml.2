Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756146Ab1CLXCj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Mar 2011 18:02:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36512 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752381Ab1CLXCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Mar 2011 18:02:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=ZQbGFZRABkqWOfe8vW7C30snuZGjT6WyeKIGeV+r8lk5c5Z1RlvLAYtTQrwvjgvG8l
         qzHK2F8CTnfltmzFhPS0bDhMDqSWHqhKnzHm/G6TwEFj5W3BfrMbTY6uu6vRj/Xt2d9L
         6y8N+nTblHQ6C1nguS0zGBnDZQfUEE3rJwbmk=
Message-ID: <4D7BFB88.8000207@linaro.org>
Date: Sat, 12 Mar 2011 23:02:32 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110302 Fedora/3.1.8-3.fc16 Thunderbird/3.1.8
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Greg KH <greg@kroah.com>, Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <Pine.LNX.4.44L0.1103121052430.25742-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1103121052430.25742-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/12/2011 04:00 PM, Somebody in the thread at some point said:

Hi -

> This depends on the platform.  On PCs, USB host controllers are usually
> PCI devices.  The only way to identify them is by the PCI device name.
> Although these names don't change often, they _can_ change.  On an
> embedded system there usually are only a couple of host controllers and
> they have more or less fixed names.

Right, on embedded boards typically the board definition file is 
responsible for calling platform_add_device() to instantiate the usb 
host / gadget / otg controllers.  That is done deterministically each 
boot.  This async platform_data support is just targeted at stuff that 
is fixed on to the board, so as you note it's reasonable to expect to be 
able to bind to it if the bus itself is instantiated by the same file 
synchronously.

I have sent a working RFC patchset to the lists now which implements 
platform support for generic async platform_data; usb core and usbnet 
specific platform_data; and finally board definition support for Panda 
onboard usbnet device by leveraging the introduced generic support. 
Beagle XM also has the same issues that can be solved by async 
platform_data from the board definition file.

-Andy

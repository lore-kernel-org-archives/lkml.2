Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab0K3PLi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:11:38 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63648 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751013Ab0K3PLg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:11:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=LmLhY1AN7KRDLEA7n8BjNm/L9VAtJ1KevZvHsNmNPNnWEucAx8cYwOg+C0W5b3NFXz
         L+DsBZIA0y0WqUijumBG625VLdZ51YXIyaaxkIqcYxO2WjRJdJ77FYeEUthPEFCMX0Av
         zmx7PCgqC8trTWWeKw748Le8+Ui7UPDnEYbnY=
Message-ID: <4CF51411.2070609@gmail.com>
Date: Tue, 30 Nov 2010 10:11:13 -0500
From: Benjamin Poirier <benjamin.poirier@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101030 Icedove/3.0.10
MIME-Version: 1.0
To: Greg KH <gregkh@suse.de>
CC: Alan Stern <stern@rowland.harvard.edu>, Johan Hovold <jhovold@gmail.com>,
        Pavel Machek <pavel@ucw.cz>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        Andreas Mohr <andi@lisas.de>,
        Daniel Sangorrin <daniel.sangorrin@gmail.com>,
        linux-usb@vger.kernel.org
Subject: Re: BUG, regression. usb-serial adapter broken by PM?
References: <4CF458CE.2050603@gmail.com> <20101130032625.GB12851@suse.de>
In-Reply-To: <20101130032625.GB12851@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/11/10 10:26 PM, Greg KH wrote:
> On Mon, Nov 29, 2010 at 08:52:14PM -0500, Benjamin Poirier wrote:
>> Hello,
>>
>> Recently, my usb-serial converter has become unusable. Attempts to open
>> the device always fail with:
>> open("/dev/ttyUSB0", O_RDONLY)          = -1 EAGAIN (Resource temporarily unavailable)
>>
>> The device is a:
>> ID 0c52:2101 Sealevel Systems, Inc. Serial Converter
>> and uses the ftdi_sio driver.
>>
>> I've bisected this problem to
>> commit 1bfee5bc86fdaecc912e06080583eddab7263df2
>> Author: Alan Stern <stern@rowland.harvard.edu>
>> Date:   Sat Sep 25 23:35:00 2010 +0200
>>
>>     PM / Runtime: Merge synchronous and async runtime routines
>>
>> I have other usb-serial converters that use other drivers and that are
>> unaffected. I have noticed the problem on a x86_64 machine (.config
>> here: http://pastebin.ca/2006414) and can reproduce it in kvm (with usb
>> passthrough, .config here: http://pastebin.ca/2006416).
>>
>> I'll be glad to provide more info or try patches.
> 
> A patch to resolve this was sent to linux-usb@vger.kernel.org yesterday,
> can you try that one out (sorry, can't dig it out at the moment...)

I think that's the one:
http://www.spinics.net/lists/linux-usb/msg39257.html

It indeed fixes the problem. Thanks!

btw. it seems I was late to the game, I should've checked bugzilla too,
https://bugzilla.kernel.org/show_bug.cgi?id=23012

-Ben

> 
> thanks,
> 
> greg k-h


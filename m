Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932435Ab1CRVdJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 17:33:09 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36997 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757492Ab1CRVdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 17:33:05 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=xifkWDLcmbGuAo3xrLK7QBZNXOJxSLmWg1Mo9ohcTlOCEBacm4Jt464ElHg9GUHD1L
         SZErQKYqRNkD8UI6PLx6Z5dYc98cWUWCA0syTfChrfDgCHi/1114BeTeMJiEUJOW13hV
         /wDV1M0yWYw4///2RNytweyvYAR/KtQsWwtN8=
Message-ID: <4D83CF8C.3020605@linaro.org>
Date: Fri, 18 Mar 2011 21:33:00 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: Greg KH <greg@kroah.com>, Grant Likely <grant.likely@secretlab.ca>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org> <201103182106.13888.arnd@arndb.de>
In-Reply-To: <201103182106.13888.arnd@arndb.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 08:06 PM, Somebody in the thread at some point said:

Hi -

> The main deficiency of platform_data is that it's very inflexible,
> you have to write code for each new board you want to support,
> something that we've generally moved away from in Linux a decade
> ago.

Well: Greg was also reduced to explaining that device renaming in 
userland was decided "a long time ago".  It's not argumentation, it is 
an appeal to an alleged tradition.

You think that striving away to create this Device Tree description of a 
specific board and maintaining it in a bootloader is LESS work somehow 
that registering platform devices in an array in the board definition 
file?  I think not.

> Another problem is that you need to hardcode data structures,
> which is arguably less flexible than key/value pairs.

After you dereferenced your static string via your API, and I 
dereferenced my platform_data member, we both end up with a pointer to 
data.  Board definition file also gets a chance to set that data at 
runtime: for example, take a look at the MAC-setting part of my 
patchset.  What exactly was your point?

> That is 142 unique files in the kernel referencing this (mostly
> powerpc, but also some others), both device drivers and dts files,

Powerpc would appear to be fairly considered as legacy, not the future.

>> =====>  If Device Tree APIs is mandated to implement functionality fixes
>> to drivers and platform_data is blocked for this, then we end up with
>> different, rotting functionality for platform_data basis and drivers
>> that remain broken on the many, many, platforms that don't have and will
>> never have Device Tree.  That does NOT sound like the right approach.
>
> See the device tree fragment patches that Grant just posted.
> It should become really easy to combine both methods, or to
> gradually migrate without breaking anything.

I take it Grant got over his initial offhand opinion of this RFC -->

''Oh, please no.

platform_data is an ugly non-type-checked anonymous pointer.  If you
need to pass data to a driver, use something better designed.  A
device tree fragment would work, or provide some kind of query api.
platform_data is definitely the wrong approach.''

I'm super happy if he mastered his distress and suddenly -- no doubt 
completely asynchronously to this thread -- decided to interoperate with 
platform_data as equals.  If that is indeed what has happened.

> The USB layer is not architecture specific, so when we add hacks
> to it for dealing with nondiscoverable hardware properties, we
> should use methods that are accepted everywhere, which platform
> data is not.

EVERY struct device has a platform_data member.

In the very deepest sense, platform_data is already accepted EVERYWHERE 
including USB and MMC / SDIO devices.

It is not platform_data that has to make its case.

-Andy

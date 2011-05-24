Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab1EXPDj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 May 2011 11:03:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:52185 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752963Ab1EXPDi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 May 2011 11:03:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=Ih9dMWtRoshxm3czCYrxU0ynFMU+VBBl2MCCEtVODT1+35wXXDksk3ktYLSYSktbPP
         BMvJSB2I4l7FMuzdfZhH4X2qnlRRQMURIbNg+WRnsd/SPDMxfWO6unYTDbJrGGiEhxFl
         75YEX1+Yy7C9fWhSJO97Qp7fywvi8maadY5fo=
Message-ID: <4DDBC8C7.4000001@gmail.com>
Date: Tue, 24 May 2011 10:03:35 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Kevin Hilman <khilman@ti.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        devicetree-discuss@lists.ozlabs.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] drivers/amba: probe via device tree
References: <1305829704-11774-1-git-send-email-robherring2@gmail.com>	<20110519233958.GB18181@ponder.secretlab.ca>	<4DD66B8A.5040404@gmail.com>	<201105201621.03801.arnd@arndb.de> <4DD68614.6090209@gmail.com>	<a42f0c27-2811-4b68-bedf-7dfaa7bff6ff@VA3EHSMHS025.ehs.local>	<BANLkTi=8vX1Cs_fzpQXZBuuDuLYLu1FGmg@mail.gmail.com>	<4DDA2AC0.1060406@gaisler.com>	<20110523095829.GG17672@n2100.arm.linux.org.uk> <BANLkTink1rrC8F3Gjhqt84gYzOibX+AgDQ@mail.gmail.com>
In-Reply-To: <BANLkTink1rrC8F3Gjhqt84gYzOibX+AgDQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant,

On 05/23/2011 10:09 AM, Grant Likely wrote:
> On Mon, May 23, 2011 at 3:58 AM, Russell King - ARM Linux
> <linux@arm.linux.org.uk>  wrote:
>> On Mon, May 23, 2011 at 11:37:04AM +0200, Kristoffer Glembo wrote:
>>> Grant Likely wrote:
>>>> In the case we're talking about the bus really is an AMBA bus, and all
>>>> the devices on it are in some sense real amba devices.  The problem is
>>>> that not all of the devices on the bus implement peripheral ID
>>>> registers or other mechanisms that good upstanding AMBA devices are
>>>> expected to have.
>>>
>>> Before we go hardware bashing of non primecell AMBA devices I would just
>>> want to point out that the primecell stuff is not part of the AMBA
>>> specification.
>>
>> And before we go down that route, let me point out that the 'amba bus'
>> stuff in the kernel is there to support primecells, rather than all
>> devices which the AMBA specification covers.
>>
>> The reason it's called 'amba' is because back in 2001 or so when the
>> first primecell drivers were created, there was little information
>> available as to what AMBA, AHB, or APB even covered.  All I had to go
>> on were the primecell documents themselves.  The higher level documents
>> were not available to me.
>>
>> So, despite it being called 'amba', it really is just for primecells
>> and if we didn't have the exposure to userspace, I'd have renamed it to
>> 'apb' or similar instead.
>
> Okay, that clarifies things a lot, and lends weight to the arguement
> that it is perfectly normal and acceptable to have both amba_devices
> and platform_devices on the same bus segment.  Are there any cases
> where amba primecells are being driven by platform_drivers?  If so,
> should those drivers have an amba_driver registration added?

I would be surprised if there are any implemented as platform_drivers 
that are not duplicates of an amba driver. The STMP uart is actually a 
pl011 and it's platform driver was recently removed IIRC. So I think we 
can consider platform drivers something that should be fixed in this case.

Do you still think we should have a global match table of all devices or 
a generic "arm,primecell" compatible property would work. Several 
drivers like the pl022 have several h/w variations they support, so we 
would either need to list all those variations or have a generic name 
per device.

I think having "arm,amba-deviceid" is not needed. The current code does 
nothing but warn if it doesn't match the h/w value. The drivers already 
have a list of id's that they support and the amba bus only matches 
against the h/w id value. The only use I can see is overriding a broken 
h/w value. Certainly seems like it should be optional at least.

Rob

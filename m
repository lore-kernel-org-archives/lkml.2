Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757163Ab1CXUK4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 16:10:56 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:64881 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756219Ab1CXUKy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 16:10:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=hG9rbd5Q0f1pqU4Y3wlZAlEoHjwciZdcqyV2Dk5BJC664V3EpzNvfIxtLkcY/lbfnZ
         VL97BaX6wgp/gEUT2QddsGrTn7l/jqkAhL8hvVv1UtInuWh760KJ9D9h1/xoA0iePu1d
         s0p0hcuSNtTnJ6aYPZb3RyiKvxoIs2k1+nj/E=
Message-ID: <4D8BA548.6030702@linaro.org>
Date: Thu, 24 Mar 2011 20:10:48 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org> <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com> <1300828125.2402.300.camel@pasglop> <4D8924B6.8040403@linaro.org> <1300842219.2402.309.camel@pasglop> <alpine.LFD.2.00.1103222138320.11889@xanadu.home> <1300850595.2402.320.camel@pasglop> <4D89BDE2.60907@linaro.org> <20110323094720.63e7c6b2@lxorguk.ukuu.org.uk> <4D89C618.1020608@linaro.org> <20110324191704.GB15807@ponder.secretlab.ca>
In-Reply-To: <20110324191704.GB15807@ponder.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/24/2011 07:17 PM, Somebody in the thread at some point said:

Hi -

>> The SDIO patches target wl12xx that is already in mainline and
>> already using literally platform_data.  Because there's no neater
>> way on offer, it currently -- in mainline -- does it by having a
>> built-in stub with its own Kconfig, that copies platform_data from
>> the board definition file into a private malloc'd buffer, then uses
>> it by getting a pointer to the copy from another private api in the
>> driver.  All this in a specific driver.
>
> I've spent some time looking at the wl12xx driver code, and while the
> data symbol it is using happens to be called 'platform_data', it isn't
> actually the same thing as we're debating in this thread.
>
> The platform_data in drivers/net/wireless/wl12xx_platform_data.c is a
> strongly typed pointer to a 'struct wl12xx_platform_data', which
> doesn't have the deficiencies associated with
> (struct device*)->platform_data.  It isn't a void* travelling through
> the device model without guarantees that the right thing will get
> dereferenced on the other end.

I see you're left exactly as you were found by the earlier discussion of 
how dangerous or not that void * is in this particular case.

> The fact that it has /other/ deficiencies is I imagine exactly why
> you want to be rid of it, and rightly so.  Immediately obvious is that
> the way it currently is done means that there can never be more than
> one wl12xx in the system.

Actually what I wanted from the start is to fix some issues for TI / 
Panda and provide a generic way for other people to do something similar 
as a side-effect, because delivery of this configuration information, 
one way or another, is a generic issue.

Arnd seems to have sold his "change everything to eth%d" fix so that one 
is off my plate.

I have a solution just at Panda level thanks to Alan Cox's workaround 
for MAC setting on ethernet and WLAN I'll issue shortly, that does not 
address the real problems that could be addressed with another approach 
at the right layer.

That leaves my async platform_data code just fixing wl12xx access to its 
own platform_data because that's what I found to clean up so far.  And 
then -->

> I've got a proposal for a solution.  I'll get it written up as
> quickly as possible and send it out soon.

I see.  Isn't it a bit curious you got this sudden off-piste interest in 
improving the platform_data situation of wl12xx after it turns up in 
this RFC?  I mean I like having my work done for me, if that's how it is 
maybe we can work out a system ^^

-Andy

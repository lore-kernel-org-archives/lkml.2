Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757478Ab1CRXEU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 19:04:20 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:59224 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab1CRXEP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 19:04:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=xb6o0aJlueVaBReaRz0Z8i+K9MTbgwM5TXTlBUh0xfqjHw9vkfa3L0ArDRKdFsARqw
         ESbBCDH4Rebs2Yw9jVmypNf20AnSoZIrrT3XfthITQYpnYGioUntWC6w8I+KM0xyHJkZ
         8XocJW124G41du+J6XOIRE3lznT9Ruj98L5dA=
Message-ID: <4D83E4EB.400@linaro.org>
Date: Fri, 18 Mar 2011 23:04:11 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: Arnd Bergmann <arnd@arndb.de>, Greg KH <greg@kroah.com>,
        devicetree-discuss@lists.ozlabs.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: RFC: Platform data for onboard USB assets
References: <20110311165642.GA9996@kroah.com> <201103172333.01474.arnd@arndb.de> <4D82979B.2050003@linaro.org> <201103181600.09877.arnd@arndb.de> <4D839BCD.6030202@linaro.org> <AANLkTi=Vy4Cu9rf7SpOFL1umN37bJgXhq9jEQpUrqjgw@mail.gmail.com>
In-Reply-To: <AANLkTi=Vy4Cu9rf7SpOFL1umN37bJgXhq9jEQpUrqjgw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/18/2011 09:28 PM, Somebody in the thread at some point said:

Hi -

> Apologies if we got a little carried away on the device tree side
> topic; it is something that needs to be investigated regardless and
> that unfortunately ended up co-opting this thread.  You're right that
> on ARM device tree is optional and a solution is required for
> !CONFIG_OF.

I appreciate your candour.

> However, at issue here is that platform_data sucks hard, and
> asynchronous platform data sucks harder.  I think I can go out on a

Personally, I spend a lot of my life trying to back up assertions with 
provable statements and logic.

> limb and say that platform_data is viewed with distaste by more people
> than just Arnd and me.  It sucks because it is an anonymous pointer
> with absolutely zero chance of verifying that the driver has the right
> thing when it comes out the other end at the driver.  This means the
> very real possibility of dereferencing the wrong structure and the
> kernel oopsing or worse.

... and if there is no problem with indeterminism for targeting that 
pointer, what you are saying is just blather.

In fact the normal use for platform_data is to be pointed to by the very 
same struct that defines the device in board definition file.  There is 
NO chance of any dropped ball if the author of the board definition file 
had it right: none.  And again, any error here is deterministic, so you 
are talking about a case where the board definition file author screwed 
it up and didn't bother to test: it is always wrong.  Okay; it is true 
that if the author writes crap and doesn't test it the result is not 
good.  Same goes for Device Tree.

So this claim against platform_data is worthless.

> Asynchronously attached pdata sucks harder because the selected driver
> is completely dissociated from the pdata type.  Not even the i2c and
> spi board info structures have this issue.  At least the board info
> structures have the driver and the pdata settings co-located.

Hm.  I am not sure how many times I used the phrase "hardwired", or 
"wired on the board" or similar, but I think it must add up by now. 
This leads to determinism.

> I certainly have no intention of trying to migrate
> {platform,i2c,spi}_device away from platform_data, but I will actively
> nack any attempt to bring it into other subsystems.  There are better

Correct me if I am wrong, but if you deploy logic to lead to NAKing 
stuff that seems wrong to you, it makes you a valuable member of the 
community.  If you cannot actually explain what the problem is 
coherently -- perhaps especially when it touches upon stuff in conflict 
with your personal hobby-horse -- then you should carefully consider if 
a NAK is appropriate or if you lose credibility by making such threats 
not backed up by logic, but - it seems to me - emotion.

I do not mind if I am fairly NAKed.  That has happened in the past and I 
made good efforts to understand what I missed and and learn.

What I find so difficult in this thread is the very poor argumentation 
deployed against my proposal.  You are actually reduced to arguing by 
authority, "because I am in a position to NAK you, I will, until you 
give up" is your approach.  I just have contempt for it, Grant.

It tells me you do not actually have faith in your own position, or you 
would be explaining my stupidity in clear terms "even I could understand".
	
I already have good reasons to continue and do the SDIO implementation: 
your opinion is not a factor, so NAK away how you feel you need to so 
you feel better.

> ways.  Device tree is one option, but I will accept other approaches.

That's good, because I have patches for my approach, I hope you will 
give them the consideration they deserve.

> Using domain specific api, such as to retrieve the correct MAC address
> is one idea that's been raised.  Regardless, the ability to validate
> the data passed to the driver, either at compile or runtime, is a hard
> requirement in my mind.

And in the (usual SoC) case where there is no indeterminism and the data 
is always as intended?  Your point is again worthless.

>> At least we agree there's no point to target pluggable devices with either
>> solution, in which case platform_data and Device Tree provide the same end
>> result, plus or minus extra query API.
>
> Right, if it is detectable it has no business being described
> anywhere, whether it be platform_data, a dt node, or something else.

So sad that you, head Device Tree dude, don't seem to understand there 
is a class of information not available at the CPU; not available at the 
IP unit, but which must be passed in externally, eg, OMAP I2C bus width 
mapping.

-Andy

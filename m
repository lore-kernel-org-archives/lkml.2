Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757206Ab2JRQPD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 12:15:03 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:34562 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756206Ab2JRQPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 12:15:01 -0400
Message-ID: <50802B00.6090907@ti.com>
Date: Thu, 18 Oct 2012 11:14:56 -0500
From: Jon Hunter <jon-hunter@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Hebbar, Gururaja" <gururaja.hebbar@ti.com>
CC: "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "Rajashekhara, Sudhakar" <sudhakar.raj@ti.com>,
        Tony Lindgren <tony@atomide.com>, "Nori, Sekhar" <nsekhar@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: discrepancy while save and restore of debounce registers
References: <1BAFE6F6C881BF42822005164F1491C33EAA9A7C@DBDE01.ent.ti.com> <507F1F21.8040206@ti.com> <1BAFE6F6C881BF42822005164F1491C33EAAA89B@DBDE01.ent.ti.com>
In-Reply-To: <1BAFE6F6C881BF42822005164F1491C33EAAA89B@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.157.144.139]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Gururaja,

On 10/18/2012 12:31 AM, Hebbar, Gururaja wrote:
> Jon,
> 
> On Thu, Oct 18, 2012 at 02:42:01, Hunter, Jon wrote:

[snip]

>>> My doubt/questions are
>>> 1. Why should debounce registers be updated only when it's accessed previously?
>>
>> If debounce is not being used by any of the gpios, then there is no need
>> to restore them as there are no bits set. So this makes sense and saves
>> a couple register writes.
> 
> What I want to know is that other than saving register writes, is there any
> other important stuff that specifies this requirement.

>From a HW perspective, none that I can see.

>From a SW perspective, yes, as I mentioned if you restore these
registers without first initialising the context variables where these
registers are stored, then you may be restoring unknown values to the
registers and that is bad.

>>> 2. What is the relation between updating debounce registers and crash seen on
>>> others registers? 
>>
>> This I am not sure about. I gave this a quick try on my omap3430 beagle
>> board, but I did not see any side-effects from doing this. However, if
>> you are always restoring the debounce context regardless of whether
>> debounce is being used, then you could be writing bad values to the
>> debounce registers as the context variables bank->context.debouce and
>> bank->context.debouce_en may not initialised. So that is bad. However,
>> that said I am still not sure how this could cause a crash.
>>
>> Can you share more details on ...
> 
> Sorry for missing below details in first post.
> 
>> 1. The OMAP platform you are using?
> 
> I was trying this on TI AM335x platform (repo below). On AM335x EVM board
> 
> http://arago-project.org/git/projects/?p=linux-am33x.git;a=shortlog;
> h=refs/heads/v3.2-staging
> 
>> 2. What linux distro/environment you are using?
> 
> Arago AM335x PSP release (linux 3.2 + am335x patch-set)
> 
>> 3. If there are any specific steps to reproduce this 100% of the time?
> 
> On top of this tree, try suspend/resume using "echo mem > /syspower/state"

I have a beagle-bone but unfortunately, suspend does not appear to be
supported in the mainline kernel yet so I am unable to test this on the
am335x on the mainline.

Have you compared the gpio driver from your v3.2 branch with the current
mainline to see how different this code is? Ideally, it would be good to
test on the mainline kernel for another data point to see if this is
local to your branch.

Cheers
Jon



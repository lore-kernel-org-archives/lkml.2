Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756129Ab1CWJb0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 05:31:26 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:51333 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1CWJbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 05:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=sender:message-id:date:from:reply-to:user-agent:mime-version:to:cc
         :subject:references:in-reply-to:content-type
         :content-transfer-encoding;
        b=UKsSBCO+u5kVo+BjCCcnUDNyVk7C0L7YBZDuuyLPYJ2wULguTwGx0BAux8oIoe0gfB
         iCaHvDnz9LGfVbraWsBrI6Cs6Gz2HrEiJ378u0Jt39U8KJUx87TuGcW6qns3Tk1KiRVa
         qGwiEuu3WMpvDssurJmukcp59JzghRwPL0QHw=
Message-ID: <4D89BDE2.60907@linaro.org>
Date: Wed, 23 Mar 2011 09:31:14 +0000
From: Andy Green <andy@warmcat.com>
Reply-To: andy.green@linaro.org
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110310 Fedora/3.1.9-2.fc16 Thunderbird/3.1.9
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Nicolas Pitre <nicolas.pitre@linaro.org>,
        Jaswinder Singh <jaswinder.singh@linaro.org>,
        Linux USB list <linux-usb@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, arnd@arndb.de,
        broonie@opensource.wolfsonmicro.com, roger.quadros@nokia.com,
        greg@kroah.com, grant.likely@secretlab.ca
Subject: Re: RFC: Platform data for onboard USB assets
References: <4D79F068.2080009@linaro.org>	 <AANLkTim=ezye=1fQP_1a2SWbPnbENP9B+k27Z3AkS=zf@mail.gmail.com>	 <1300828125.2402.300.camel@pasglop>  <4D8924B6.8040403@linaro.org>	 <1300842219.2402.309.camel@pasglop>	 <alpine.LFD.2.00.1103222138320.11889@xanadu.home> <1300850595.2402.320.camel@pasglop>
In-Reply-To: <1300850595.2402.320.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/23/2011 03:23 AM, Somebody in the thread at some point said:
>
>> Sorry Ben, but you are the one who sounds like a priest here, having
>> invoked the "religious" qualifier twice in a row in this thread.
>
> Time to burn a few books then :-)
>
>> I think that Andy is asking absurdly good questions which are backed by
>> candid logic and reasoning.  If anything, his arguments are purely
>> technical and extremely practical. And so far all he's got for answers
>> was rather subjective, emotionally charged and even dogmatic.
>
> I think the technical aspects have been essentially answered. The
> important part of the thread is what the "right" approach to identifying
> the on-board device (vs. an equivalent device being hot-plugged), and I
> think we all agreed this has to be the physical port "path" (in case
> there's hubs or switches on the way).

Well I am glad there is consensus on that, although this was the initial 
approach in the patches already.

For me the most important issues I wanted to understand from the RFC 
were: "do others see it as generally useful to target async probed 
devices with data from the board definition file", and was there 
appetite to use the apis elsewhere in the kernel to solve the problems 
in front of me in Panda.

I learned that among people that understood what the RFC was about there 
was also consensus it's useful, although some people demand Device Tree 
implementation, I think we got beyond arguing against the abstract idea 
overall: it is accepted it would be valuable.  So this is encouraging as 
far as it goes.

For subsystems using it, in the initial USB case discussion got mired 
first in understanding the idea at all from USB perspective, and then 
lost down well-trodden positions on what the actual data is used for in 
the included use-cases.  The same is happening here -->

> The device-tree and whatever other udev based solutions using physical
> path are both "transports" in a sense for that same information and so
> in the grand scheme of thing equivalent.
>
> The argument boils down to should we encourage adding an additional
> in-kernel platform_data based hooks for dynamically probed busses such

Well, these are not hooks in the usual usage of the word.

> as USB as well ? or go for a udev based solution for the time being
> which would probably work as well in practice and focus on getting the
> device-tree based solution for the long term instead.

There is no udev solution for what is being done currently by the async 
platform_data patchset with SDIO WLAN.  The patches are out there and in 
use already.  The only reason I don't post them here as round 2 of the 
RFC yet is because Grant wanted a couple of days and politically it's 
expedient for me to agree to that.

>> With regards to DT on ARM I'm rather "softly" convinced this is a good
>> thing.  However seeing a persisting lack of truly technical answers to
>> Andy's questions is rather disturbing, and makes me wish for much more
>> than the current hype around DT which appears to fall flat when
>> challenged.
>
> I don't think any technical answer is missing. Dynamic platform data is
> possible and in fact the platform could do it today using bus notifiers
> and "hooking up" the platform data on the fly if needed I suppose.

Ah now, steady on.  I was very surprised actually and I still am in this 
thread how incomplete the thinking and implementation is for Device Tree 
interoperation with platform_data.  Surely interoperation with the 
established way of doing things should have been very high on the list 
of things to have an answer for before embarking on everything else.  In 
fact, how to do that in drivers seems to be being figured out by you 
guys as you go along in this thread as if my RFC is the first time that 
particular critical bit of Device Tree rubber is meeting the real road. 
  I have no idea why the burden of that has appeared on my particular back.

When I described the issues I see with Arnd's approach fracturing 
support for new features and bugfixes in drivers, it was waved off 
because of patches that were "just posted" that apparently "solve" this. 
  Where they were posted, what they do, how they solve it was not told 
and that strand of the discussion was killed.  However it seemed like 
the single most important issue to come out of the thread for Device 
Tree and we take it back up again in this post.

> Does it make sense however to add platform data for generic probed
> devices ? I don't think so.
>
> For some reason Andy doesn't seem to consider the lack of type
> information as a problem, Grant and I do, I don't know where we can go
> from there, it's a very technical argument and I don't feel like I need
> to teach people on this list what are the drawbacks on relying on void *
> pointers to structures attached to devices like that that -will- go
> wrong.

I spent some time last night writing up exactly why I don't consider it 
a real issue in exactly the platform_data case.  During that I agree 
typesafety is generally good and void * generally bad.  So, it's more ad 
hominem to try to make out you "need to teach people" about that; it's 
consistent with what seems to be a quite arrogant culture around Device 
Tree that it is the higher path and anyone questioning or disagreeing 
with it is a fool / religious / odd.  But when I study the specific case 
of void * in platform_data, I find there is no real special problem 
caused by it - and you did not show any.

> I simply believe that this is the wrong solution for the problem. I
> would very much prefer having a way for the driver to retrieve "platform
> attributes".
>
> This is essentially what the name/value properties of the device-tree
> provide, but it could be abstracted in a way that doesn't require the
> device-tree and allows drivers to be unchanged whether the thing is
> backed with a DT or by platform callbacks as long as there's a minimum
> amount of thought given to naming the property reasonably.
>
> For some reason I didn't find Andy answers conductive to a reasonable
> discussion and indeed I admit I probably switched to dismiss/troll mode

I don't mind being called "full of shit" under these circumstances 
though, because it is useful to gauge how insecure people are about 
their arguments, and after all, everyone reading has their own mind to 
make up.

> a bit too quickly, so let's the heat go down a bit here and see if we
> can find a common ground.
>
> If you guys can agree on my above proposal, we could maybe come up with
> some "get_device_attribute(dev, name)" kind of interface, that would
> then boild down to platform calls or device-tree transparently (or arch
> calls optionally populated by generic device-tree based helpers
> etc....).

What is so surprising is that you seem to start to think about this on 
my RFC thread in mid-March 2011.

OK.  So it seems your proposal to interoperate with platform_data should 
be studied.  How exactly will it work with existing platform_data 
structs?  It will work with existing platform_data structs, will it?

> This would be much better I believe that having those random structures
> hooked up to void * pointers floating around and also generally more

But there are a huge number of users of platform_data in mainline 
already we can agree.  Are you talking about a mass conversion of those 
to eliminating platform_data so they use your preferred token query model?

If so, could I possibly suggest sticking your own neck above the parapet 
on that and issuing your own RFC to defend, as I have?  You could call 
it, eg, "RFC: change every driver using platform_data to use token 
queries", and you know, explain what that effort actually buys anyone. 
In the meanwhile, I can get on with my implementation and gladly change 
it to yours when - not if, of course - it hits mainline.

> flexible vs. platforms that provide or don't provide some of this
> information (platforms might provide a subset etc...)
>
>> There is one hard fact that no one can ignore: DT support on ARM still
>> has a long way to go before it is truly usable.  The world just can't
>> stop turning until this is ready.
>
> Right but more efforts could be put into making that happen :-)

I think the first additional effort needs to start at home on that one 
and think through Device Tree and kernel policy on interoperation with 
existing driver implementations using platform_data.  Just being sniffy 
about platform_data for reasons you can't back up when challenged won't 
cut it IMO.

-Andy

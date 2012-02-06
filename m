Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753091Ab2BFFxr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Feb 2012 00:53:47 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:17307 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab2BFFxq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Feb 2012 00:53:46 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Sun, 05 Feb 2012 21:53:40 -0800
Message-ID: <4F2F6AE2.1040504@nvidia.com>
Date: Sun, 05 Feb 2012 21:53:38 -0800
From: Stephen Warren <swarren@nvidia.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111229 Thunderbird/9.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Dong Aisheng <dongas86@gmail.com>, Shawn Guo <shawn.guo@linaro.org>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "Sascha Hauer (s.hauer@pengutronix.de)" <s.hauer@pengutronix.de>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "cjb@laptop.org" <cjb@laptop.org>,
        "Simon Glass (sjg@chromium.org)" <sjg@chromium.org>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        "Grant Likely (grant.likely@secretlab.ca)" 
	<grant.likely@secretlab.ca>,
        "ext Tony Lindgren (tony@atomide.com)" <tony@atomide.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: An extremely simplified pinctrl bindings proposal
References: <74CDBE0F657A3D45AFBB94109FB122FF178E5D3160@HQMAIL01.nvidia.com> <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
In-Reply-To: <CACRpkdahin4srDh7dphgvq306gjz7CGP=h4dVkUY+w0z0wpXRQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/05/2012 08:20 PM, Linus Walleij wrote:
> On Sun, Feb 5, 2012 at 6:31 AM, Stephen Warren <swarren@nvidia.com> wrote:
> 
>> Sorry, I haven't had a chance to read any of the pincrl emails from
>> Friday onwards. However, I thought a bit more about this, and decided
>> to propose someting much simpler:
> 
> I think this approach is quite interesting, but since it removes more
> or less all semantic meaning of the pinctrl system, I don't see why
> it would be a pinctrl rewrite at all or called pinctrl, rather it'd be
> something new and separate, since it could (if I understand
> correctly) very well be used to configure things that are totally
> unrelated to pin control, could it not?

I guess we could indeed use this technique for almost anything.

I think the main argument to call it pinctrl/pinmux still is to provide
some named API and reason for drivers to invoke when they wanted to make
use of the feature.

In other words, it's pretty easy to see why and when a driver would
invoke a pin control API to configure the HW surrounding the HW module
that driver controls. If we don't call that pinctrl, what else might we
call it? That said, I'm sure we can come up with some reasonable more
general-purpose name.

...
> Can we defined it then as controlled register processing at
> determined points, some during boot, some at runtime, and
> maybe tied to certain devices at certain points in time?

Certainly, yes.

> A controlled set of register read/writes and maybe also conditionals
> (if that bit is 1, do this, else do that, plus a loop command to wait
> for a flag or similar) are known as a "jam tables" and usually used
> in BIOSes to do a compact machine initialization. I learned this term
> in Bunnie Huang's "Hacking the Xbox, where he describes finding a
> jam table interpreter in the Xbox ROM.

I think anything beyond a simple linear list of register writes would
get a /lot/ of pushback. See for example Grant's comments in one of the
links I referenced:

http://www.gossamer-threads.com/lists/linux/kernel/1305624

about delays in the PHY initialization sequence being "right out".

I can imagine the data including flags like 8/16/32/64-bit register
accesses, or read-modify-write vs. just write (i.e. do we need to
include a mask or not) being reasonable, but any state, looping, delay,
conditionals etc. being nak'd. Otherwise, we'd be inventing a byte code
interpreter instead of just a list of register writes. If we /did/ want
to go that route (and I suspect there's no need...) then I think we'd
want to re-use some existing byte code definition rather than creating a
new one.

...
> While I would probably mourn the death of sematics I also see
> that if the goal is to get huge static data sets out of the kernel,
> something like this may be the best way to get there.

Yes, the loss of semantics also doesn't entirely appeal to me. However,
I wonder if the other advantages don't outweigh that.

-- 
nvpublic

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759534Ab2CMTed (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Mar 2012 15:34:33 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:49368 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759160Ab2CMTec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Mar 2012 15:34:32 -0400
Message-ID: <4F5FA144.10000@wwwdotorg.org>
Date: Tue, 13 Mar 2012 13:34:28 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Linus Walleij <linus.walleij@stericsson.com>, B29396@freescale.com,
        s.hauer@pengutronix.de, dongas86@gmail.com, shawn.guo@linaro.org,
        thomas.abraham@linaro.org, tony@atomide.com
Subject: Re: [PATCH] dt: pinctrl: Document device tree binding
References: <1331316873-20052-1-git-send-email-swarren@wwwdotorg.org> <CACRpkdY3BAD+w3X6ZLPpfkO2=yKFjbU=N11wPP4v7TfZqcy7Dg@mail.gmail.com>
In-Reply-To: <CACRpkdY3BAD+w3X6ZLPpfkO2=yKFjbU=N11wPP4v7TfZqcy7Dg@mail.gmail.com>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2012 03:14 AM, Linus Walleij wrote:
> On Fri, Mar 9, 2012 at 7:14 PM, Stephen Warren <swarren@wwwdotorg.org> wrote:
> 
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt
>> @@ -0,0 +1,118 @@
>> +== Introduction ==
>> +
>> +Hardware modules that control pin multiplexing or configuration parameters
>> +such as pull-up/down, tri-state, drive-strength etc are designated as pin
>> +controllers. Each pin controller must be represented as a node in device tree,
>> +just like any other hardware module.
> 
> Maybe put in a reference to Documentation/pinctrl.txt for in-depth
> discussion? Also some stuff may be moved over there as generic
> information. A lot of the text here does not seem to be about the
> device tree ...
> 
> However maybe the use case is outside the Linux kernel too
> and in that case I'm happy with it.

Yes, the idea is that the bindings are OS-independent as much as
possible. That's why it's a little redundant w.r.t. the existing Linux
pinctrl documentation.

>> +For a client device to operate correctly, certain pin controllers must
>> +set up certain specific pin configurations. Some client devices need a
>> +single static pin configuration, e.g. set up during initialization. Others
>> +need to reconfigure pins at run-time, for example to tri-state pins when the
>> +device is inactive. Hence, each client device can define a set of named
>> +states. The number and names of those states is defined by the client device's
>> +own binding.
> 
> Just so I understand: is "pin configuration" here strictly what we
> handle in pinconf.c or does it include multiplexing (pinmux.c)?
> 
> I guess it's not multiplexing, just making sure.
>
> Maybe state explicitly that multiplexing is not part of pin config,
> else someone will invariably get confused.

No, it's intended to cover any aspect at all of pin control hardware,
including muxing. I'm not sure why you would expect pin muxing /not/ to
be represented by these bindings?

>> +Note that pin controllers themselves may also be client devices of themselves.
> 
> Insert something about this being known as config hogging.

I think that's Linux-specific terminology, hence not appropriate for a
generic document. (And as an aside, I don't really like the name
"hogging", or even treating it as some kind of special-case).

> The rest I barely understand so I leave it for the others to discuss...

Hmm. That's unfortunate. It'd be very useful if you could fully digest
this aspect of pinctrl.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751556Ab1DSEu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 00:50:57 -0400
Received: from outbound.icp-qv1-irony-out3.iinet.net.au ([203.59.1.148]:7321
	"EHLO outbound.icp-qv1-irony-out3.iinet.net.au" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750796Ab1DSEu4 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 00:50:56 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApEBANMTrU3L2T1e/2dsb2JhbAAMrxu8ToVxBJIW
X-IronPort-AV: E=Sophos;i="4.64,237,1301846400"; 
   d="scan'208";a="700971959"
Subject: Re: [PATCH 1/2] gpio: add pin biasing and drive mode to gpiolib
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
From: Ben Nizette <bn@niasdigital.com>
In-Reply-To: <20110418223108.GA5935@sirena.org.uk>
Date: Tue, 19 Apr 2011 14:50:52 +1000
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        Grant Likely <grant.likely@secretlab.ca>,
        linux-arm-kernel@lists.infradead.org, Lee Jones <lee.jones@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Transfer-Encoding: 8BIT
Message-Id: <528C1A42-AFCB-4EE1-A881-3D6BD4C1F539@niasdigital.com>
References: <1303076273-8093-1-git-send-email-linus.walleij@stericsson.com> <3F5641E3-C443-4541-9FDA-24D215597C1F@niasdigital.com> <20110418091902.13345132@lxorguk.ukuu.org.uk> <92FFDB9F-37F1-4618-A53D-FEF4151A4953@niasdigital.com> <20110418115903.GB9462@sirena.org.uk> <34EB51B7-AF3B-4DCE-A402-953B2DBC0474@niasdigital.com> <20110418223108.GA5935@sirena.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
X-Mailer: Apple Mail (2.1084)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 19/04/2011, at 8:31 AM, Mark Brown wrote:

> On Tue, Apr 19, 2011 at 08:16:12AM +1000, Ben Nizette wrote:
>> On 18/04/2011, at 9:59 PM, Mark Brown wrote:
> 
>>> Even if it ends up being the board code using these APIs it seems
>>> sensible to have a standard API that GPIO drivers can use to expose the
>>> functionality.  This will help with getting control into code Linux owns
>>> (since people don't have to implement custom APIs) and will mean we can
>>> do things like add control of this for device tree based boards.
> 
>> Oh I'm all for platform-specific libraries abstracting this away from the
>> board code if that helps, that's certainly the way that, eg, AVR32 does it.
>> It just doesn't make sense to me to bounce from the board code in to
>> 'generic' gpio code then back to platform-specific implementations when
>> you could cut out the middle man.
> 
> We have cross platform abstractions for lots of things - device tree,
> which I mentioned, is the obvious example - and many of the GPIO
> controllers are themselves cross platform as they're for off-SoC chips.

OK let's take a step back here:  My qualms simply expressed are that the
board code knows how the pin needs to be set up and the gpio provider knows
how the pin can be set up; I don't like the idea of trying to teach gpiolib
and any driver that uses it about those parameters.  I don't see it as necessary
or, for that matter, a war we can without exploding enums.

How about we provide a conduit in gpiolib through which the board code can
express its wishes directly to the gpio provider without trying to interpret
it first?  The gpio provider can supply the mode enumerations in a header
file (much like they do already with, eg, platform data structures), the
board support writer can make a judgement about which settings are required
and gpiolib just worries about passing essentially an opaque cookie of setup
data through as soon as the latter side is ready to accept it?

Or does the gpio-consuming driver genuinely need to know about these concepts?

	--Ben.

> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/


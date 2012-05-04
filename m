Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751908Ab2EDFUC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 01:20:02 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:60899 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751179Ab2EDFUA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 01:20:00 -0400
X-Greylist: delayed 54300 seconds by postgrey-1.27 at vger.kernel.org; Fri, 04 May 2012 01:20:00 EDT
Date: Fri, 4 May 2012 06:43:05 +0200
From: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Tony Lindgren <tony@atomide.com>, Linus Walleij <linus.walleij@linaro.org>,
        linux-omap@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: Add generic pinctrl-simple driver that
 supports omap2+ padconf
Message-ID: <20120504044305.GD7788@game.jcrosoft.org>
References: <20120502172401.GG3739@atomide.com>
 <20120503065131.GA3738@game.jcrosoft.org>
 <20120503152708.GC5140@atomide.com>
 <4FA30805.5050804@wwwdotorg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA30805.5050804@wwwdotorg.org>
X-PGP-Key: http://uboot.jcrosoft.org/plagnioj.asc
X-PGP-key-fingerprint: 6309 2BBA 16C8 3A07 1772 CC24 DEFC FFA3 279C CE7C
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Ovh-Tracer-Id: 7163538158801431373
X-Ovh-Remote: 213.251.161.87 (ns32433.ovh.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdefucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeghedrtdefucetufdoteggodetrfdofgetucfrrhhofhhilhgvmecuqfggjfenuceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecuhfhrohhmpeflvggrnhdqvehhrhhishhtohhphhgvucfrnfetiffpkffqnfdqggfknffnteftffcuoehplhgrghhnihhojhesjhgtrhhoshhofhhtrdgtohhmqeenucfjughrpeffhffvuffkfhggtggujggfsehttdfttddtredv
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:34 Thu 03 May     , Stephen Warren wrote:
> On 05/03/2012 09:27 AM, Tony Lindgren wrote:
> > Hi,
> > 
> > * Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com> [120503 00:16]:
> >>
> >> 	I really like it
> >>
> >> 	I was working on something simillar
> >>
> >> 	but can we split the group management so we can use it on other
> >> 	bindings
> > 
> > Hmm I'm not sure I follow on the group management splitting, can you specify
> > what you have in mind here?
> > 
> > If you mean moving more things into pinctrl fwk, then yeah I'd assume that
> > will happen eventually and drivers like this will end up becoming more minimal.
> 
> Jean-Christophe, forgive me if I'm putting words in your mouth, but I
> assume the following is what you mean:
> 
> There are two pieces of data required by the pinctrl subsystem:
> 
> a) The set of pins, functions, and groups that exist.
> 
> b) The specific function to select for each pin/group on a given board.
> 
> Item (a) can be represented in the pinctrl driver (e.g. as in the Tegra
> driver), or can be represented in device tree in order to avoid large
> tables in the driver.
> 
> Item (b) has to be represented in device tree, since the whole point is
> that it's board-specific.
> 
> For all DT bindings I've seen that choose to represent (a) in the DT
> rather than in the driver, the DT represents (b) directly, and (a) is
> implicitly extracted/created based on (a).
> 
> When I was first thinking about DT bindings for pinctrl, I had hoped
> that even if (a) was represented in DT, the DT nodes/properties for (a)
> and (b) would be entirely separate, so that the binding for (b) could be
> completely common across all SoCs, even though the binding for (a) would
> perhaps be different across SoCs (if it existed at all).
> 
> So, perhaps Jean-Christophe is talking about splitting up (a) and (b) in
> device tree?
> 
> Or perhaps Jean-Christophe only refers to the code that creates the
> group and function definitions from (b), and not the actual DT binding
> itself?
yes you are right Stephen
I was thinking of both but the second could be a first step

today we tend all to represent the group of pin in DT

for TI, IM, MXC, at91, ST and others

the way to represend the groups are exactly the same

a group is a node with a set on pin

uart {
 pincfg......
}

and the group is uart

so we do need to have a common way to handle it in c

the code propose by Tony is really what I'm working on to acheive this

In my mind in the driver we do not have to care how to list
register/unregister the group. We just need to be able to do this

pinctrl_register_group(...)

or 

pinctrl_unregistewr_group(...)

On at91 we have this type of controller

one pin can have multiple function and each function can be on different pin
and we need to program and represent each of them one by one

And each pin have different parameter

so I was thinking to do like on gpio

uart {
	pin = < &pioA 12 {pararms} >

}

and use macro as basicaly we are just this

and this can be applied to tegra too as you will just refer the pin in this hw
pin block

Best Regards,
J.

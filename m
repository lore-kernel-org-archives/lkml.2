Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab2DWQNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:13:25 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:47758 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752193Ab2DWQNX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:13:23 -0400
Message-ID: <4F957F9F.7000309@wwwdotorg.org>
Date: Mon, 23 Apr 2012 10:13:19 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Wolfram Sang <w.sang@pengutronix.de>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        David Daney <ddaney.cavm@gmail.com>
Subject: Re: [PATCH 1/2] i2c: mux: add device tree support
References: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org> <20120423111507.GF19192@pengutronix.de>
In-Reply-To: <20120423111507.GF19192@pengutronix.de>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 05:15 AM, Wolfram Sang wrote:
> On Tue, Apr 17, 2012 at 12:49:04PM -0600, Stephen Warren wrote:
>> From: Stephen Warren <swarren@nvidia.com>
>>
>> * Define core portions of the DT binding for I2C bus muxes.
>> * Enhance i2c_add_mux_adapter():
>> ** Add parameters required for DT support. Update all callers.
>> ** Set the appropriate adap->dev.of_node for the child bus.
>> ** Call of_i2c_register_devices() for the child bus.
>>
>> Signed-off-by: Stephen Warren <swarren@nvidia.com>
> 
> David Daney (CCed) posted another variant [1]. Just looking at the
> patches (and not really using them), I tend to like the approach using
> <reg> better. But I am open for discussion, so I'd appreciate your
> feedback.
> 
> Regards,
> 
>    Wolfram
> 
> [1] http://lkml.org/lkml/2012/4/12/423

Ah, that does look like a reasonable binding.

I had meant to call out to reviewers the potentially unusual use of
explicitly named sub-nodes, rather than using the usual reg-based matching.

The main reason I chose named sub-nodes for the busses was so the
sub-nodes would match the pinctrl named states. However, I think we can
make the pinctrl numbering match rather than the pinctrl naming instead.
The only issue is the "idle" state; if we allow it to exist anywhere in
the pinctrl-names list, it'll make the pinctrl numbering mismatch the
sub-node numbering. I think we can solve this by forcing the idle state
to be listed last in pinctrl-names (if it's listed at all). I'll update
my patches based on that David's patch.

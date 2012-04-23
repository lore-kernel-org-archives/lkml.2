Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab2DWRLi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 13:11:38 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:48966 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753274Ab2DWRLh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 13:11:37 -0400
Message-ID: <4F958D45.1080800@gmail.com>
Date: Mon, 23 Apr 2012 10:11:33 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Wolfram Sang <w.sang@pengutronix.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree-discuss@lists.ozlabs.org, linux-i2c@vger.kernel.org,
        linux-kernel@vger.kernel.org, Stephen Warren <swarren@nvidia.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 1/2] i2c: mux: add device tree support
References: <1334688545-8465-1-git-send-email-swarren@wwwdotorg.org> <20120423111507.GF19192@pengutronix.de> <4F957F9F.7000309@wwwdotorg.org>
In-Reply-To: <4F957F9F.7000309@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2012 09:13 AM, Stephen Warren wrote:
> On 04/23/2012 05:15 AM, Wolfram Sang wrote:
>> On Tue, Apr 17, 2012 at 12:49:04PM -0600, Stephen Warren wrote:
>>> From: Stephen Warren<swarren@nvidia.com>
>>>
>>> * Define core portions of the DT binding for I2C bus muxes.
>>> * Enhance i2c_add_mux_adapter():
>>> ** Add parameters required for DT support. Update all callers.
>>> ** Set the appropriate adap->dev.of_node for the child bus.
>>> ** Call of_i2c_register_devices() for the child bus.
>>>
>>> Signed-off-by: Stephen Warren<swarren@nvidia.com>
>>
>> David Daney (CCed) posted another variant [1]. Just looking at the
>> patches (and not really using them), I tend to like the approach using
>> <reg>  better. But I am open for discussion, so I'd appreciate your
>> feedback.
>>
>> Regards,
>>
>>     Wolfram
>>
>> [1] http://lkml.org/lkml/2012/4/12/423
>
> Ah, that does look like a reasonable binding.
>

It was arrived at by iterating through several versions with Grant and Rob.

You make at least the third person (after me and Lars-Peter Clausen) 
wanting to use the device tree to configure the I2C muxes.  So at a 
minimum, it shows a need for this.

David Daney.

> I had meant to call out to reviewers the potentially unusual use of
> explicitly named sub-nodes, rather than using the usual reg-based matching.
>
> The main reason I chose named sub-nodes for the busses was so the
> sub-nodes would match the pinctrl named states. However, I think we can
> make the pinctrl numbering match rather than the pinctrl naming instead.
> The only issue is the "idle" state; if we allow it to exist anywhere in
> the pinctrl-names list, it'll make the pinctrl numbering mismatch the
> sub-node numbering. I think we can solve this by forcing the idle state
> to be listed last in pinctrl-names (if it's listed at all). I'll update
> my patches based on that David's patch.


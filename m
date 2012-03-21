Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2CURZc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Mar 2012 13:25:32 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:36772 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751284Ab2CURZb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Mar 2012 13:25:31 -0400
Message-ID: <4F6A0F05.90104@wwwdotorg.org>
Date: Wed, 21 Mar 2012 11:25:25 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110921 Thunderbird/3.1.15
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>,
        Dong Aisheng-B29396 <B29396@freescale.com>,
        "s.hauer@pengutronix.de" <s.hauer@pengutronix.de>,
        "dongas86@gmail.com" <dongas86@gmail.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "tony@atomide.com" <tony@atomide.com>,
        "sjg@chromium.org" <sjg@chromium.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Subject: Re: [PATCH V2 3/6] pinctrl: core device tree mapping table parsing
 support
References: <1332265479-1260-1-git-send-email-swarren@wwwdotorg.org> <1332265479-1260-3-git-send-email-swarren@wwwdotorg.org> <20120321073116.GE3191@shlinux2.ap.freescale.net> <4F69F844.3060102@wwwdotorg.org>
In-Reply-To: <4F69F844.3060102@wwwdotorg.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/21/2012 09:48 AM, Stephen Warren wrote:
> On 03/21/2012 01:31 AM, Dong Aisheng wrote:
>> On Wed, Mar 21, 2012 at 01:44:36AM +0800, Stephen Warren wrote:
...
>>> +int pinctrl_dt_to_map(struct pinctrl *p)
>>> +{
>>> +	struct device_node *np = p->dev->of_node;
>>> +	int state, ret;
>>> +	char *propname;
>>> +	struct property *prop;
>>> +	const char *statename;
>>> +	const __be32 *list;
>>> +	int size, config;
>>> +	phandle phandle;
>>> +	struct device_node *np_config;
>>> +	struct pinctrl_dt_map *dt_map;
>>
>> Add NULL np checking?
> 
> Oops yes. I though I had that somewhere, but evidently not...

It turns out this isn't needed; of_node_get() and of_find_property()
both handle a NULL np just fine. Still, I suppose this might not always
be true for arbitrary code that's in pinctrl_dt_to_map(), so perhaps we
should add this anyway.

>>> +		}
>>> +
>>> +		/* For every referenced pin configuration node in it */
>>> +		for (config = 0; config < size; config++) {
>>> +			phandle = be32_to_cpup(list++);
>>> +
>>> +			/* Look up the pin configuration node */
>>> +			np_config = of_find_node_by_phandle(phandle);
>>
>> One option is using of_parse_phandle, then we do not need calculate
>> the phandle offset by ourselves.
>> Like:
>> np_config = of_parse_phandle(propname , config);
> 
> Yes, that's a good idea. I'll try that.

I looked at this more, and the existing code is a lot more efficient;
of_parse_phandle() internally calls of_find_property() each time, which
this pinctrl code has already done. I'd rather just leave this as it is.
Are you OK with that?

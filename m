Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753623Ab2LLLQl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Dec 2012 06:16:41 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:35543 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab2LLLQj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Dec 2012 06:16:39 -0500
Message-ID: <50C86767.60806@ti.com>
Date: Wed, 12 Dec 2012 16:45:51 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: "Philip, Avinash" <avinashphilip@ti.com>
CC: "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "artem.bityutskiy@linux.intel.com" <artem.bityutskiy@linux.intel.com>,
        "Mohammed, Afzal" <afzal@ti.com>,
        "tony@atomide.com" <tony@atomide.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "rmk+kernel@arm.linux.org.uk" <rmk+kernel@arm.linux.org.uk>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "Hebbar, Gururaja" <gururaja.hebbar@ti.com>,
        "ivan.djelic@parrot.com" <ivan.djelic@parrot.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH v3 2/3] mtd: devices: elm: Add support for ELM error correction
References: <1354189595-12784-1-git-send-email-avinashphilip@ti.com> <1354189595-12784-3-git-send-email-avinashphilip@ti.com> <50C1C6E3.5020300@ti.com> <518397C60809E147AF5323E0420B992E3EA1FA14@DBDE01.ent.ti.com>
In-Reply-To: <518397C60809E147AF5323E0420B992E3EA1FA14@DBDE01.ent.ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/10/2012 12:13 PM, Philip, Avinash wrote:
> On Fri, Dec 07, 2012 at 16:07:23, Nori, Sekhar wrote:
>> On 11/29/2012 5:16 PM, Philip, Avinash wrote:

[...]

>>> +struct device *elm_request(enum bch_ecc bch_type)
>>> +{
>>> +	struct elm_info *info;
>>> +
>>> +	list_for_each_entry(info, &elm_devices, list) {
>>> +		if (info && info->dev) {
>>> +				info->bch_type = bch_type;
>>> +				elm_config(info);
>>> +				return info->dev;
>>> +		}
>>> +	}
>>
>> This will always return the first ELM device probed since you never
>> remove the allocated device from the list.
> 
> But now I realized that, there is no mechanism of freeing the requested
> resource.

Right. You essentially want to assign an ELM instance to work with a
given instance of GPMC and that could be done statically too. Just pass
phandle of ELM node in GPMC DT data?

> So I will add mechanism to request ELM module successfully only if ELM
> module is not requested already and add mechanism to free it, on NAND
> driver module unload (loadable module support). This way ELM driver
> can achieve multi instance support.
> 
>> I wonder why you really need a list?
> 
> The prime motivation for the list is the driver should support multi
> instances of ELM by removing global symbols.

I still think a request/free API is bit too much for something that will
turn out to be a simple 1-to-1 match anyway. Can you please look at the
phandle suggestion above? I am no DT expert, but I think that will work
for your use case.

Thanks,
Sekhar

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753416Ab1JYG4N (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 02:56:13 -0400
Received: from na3sys009aog109.obsmtp.com ([74.125.149.201]:45278 "EHLO
	na3sys009aog109.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752353Ab1JYG4M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 02:56:12 -0400
Message-ID: <4EA65D81.6030109@ti.com>
Date: Tue, 25 Oct 2011 12:26:01 +0530
From: Rajendra Nayak <rnayak@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.20) Gecko/20110805 Thunderbird/3.1.12
MIME-Version: 1.0
To: Shawn Guo <shawn.guo@freescale.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        broonie@opensource.wolfsonmicro.com, patches@linaro.org,
        tony@atomide.com, devicetree-discuss@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, lrg@ti.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2 3/5] regulator: helper routine to extract regulator_init_data
References: <4EA13053.7080306@ti.com> <20111021115809.GB337@S2100-06.ap.freescale.net> <4EA4FF6B.2080906@ti.com> <20111024081706.GC8708@ponder.secretlab.ca> <20111024090228.GA1755@S2100-06.ap.freescale.net> <4EA52851.8000203@ti.com> <20111024091158.GB1755@S2100-06.ap.freescale.net> <4EA52C56.3080908@ti.com> <20111024134727.GF1755@S2100-06.ap.freescale.net> <4EA65073.7050205@ti.com> <20111025065216.GD2119@S2100-06.ap.freescale.net>
In-Reply-To: <20111025065216.GD2119@S2100-06.ap.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 October 2011 12:22 PM, Shawn Guo wrote:
> On Tue, Oct 25, 2011 at 11:30:19AM +0530, Rajendra Nayak wrote:
>> On Monday 24 October 2011 07:17 PM, Shawn Guo wrote:
>>> On Mon, Oct 24, 2011 at 02:43:58PM +0530, Rajendra Nayak wrote:
>>>> Case 2:
>>>> One device for all regulators:
>>>>
>>>> DT nodes look something like this
>>>>
>>>> regulators {
>>>> 	reg1: reg@1 {
>>>> 			...
>>>> 			...
>>>> 	};
>>>>
>>>> 	reg2: reg@2 {
>>>> 			...
>>>> 			...
>>>> 	};
>>>> };
>>>>
>>>> The regulator driver probes only one device and the dev->of_node
>>>> points to the "regulators" node above.
>>>
>>> The mc13892 example I put in the reply to Grant demonstrates that
>>> for some case, dev->of_node is NULL (devices are created by mfd core).
>>
>> In that case should you not be first converting the mfd driver to
>> register regulator devices using DT?
>
> The mc13892 mfd driver calls mfd_add_devices() to add device for
> mc13892 regulator driver.  Are you suggesting that I should hack
> mfd_add_devices() to have device_node of 'regulators' attached?
> The mfd is not a bus like i2c and spi, so I'm not sure this is the
> right thing to do.
>
>> Thats what we did for OMAP, and hence we always have the of_node
>> populated when the regulator devices are probed.
>> See this patch from Benoit on how thats done for twl devices..
>> http://marc.info/?l=linux-omap&m=131489864814428&w=2
>>
> OMAP is "Case 1", and we are talking about "Case 2".

I don't see why it wouldn't work for "Case 2". The only difference
is in case of "Case 1", the dev->of_node would already point to
the right regulator node, like 'reg1', 'reg2' above.
In case of "Case 2", the dev->of_node would point to the 'regulators'
node instead, and the driver could then do a for_each_child_of_node()
to iterate over all its children to get 'reg1', 'reg2' etc.

>


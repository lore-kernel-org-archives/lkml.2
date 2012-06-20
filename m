Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753318Ab2FTIT1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 04:19:27 -0400
Received: from hqemgate04.nvidia.com ([216.228.121.35]:14838 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612Ab2FTITX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 04:19:23 -0400
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Wed, 20 Jun 2012 01:19:15 -0700
Message-ID: <4FE1877C.4090103@nvidia.com>
Date: Wed, 20 Jun 2012 13:49:08 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "rob.herring@calxeda.com" <rob.herring@calxeda.com>,
        "arnd@arndb.de" <arnd@arndb.de>,
        "linus.walleij@linaro.org" <linus.walleij@linaro.org>,
        "lrg@ti.com" <lrg@ti.com>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH V2 3/3] ARM: dts: db8500: add node property "regulator-compatible"
 regulator node
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-4-git-send-email-ldewangan@nvidia.com> <4FE0A546.1010707@linaro.org> <4FE0B79D.4090201@wwwdotorg.org> <4FE1772A.2010806@linaro.org> <4FE17E24.8050702@nvidia.com> <4FE18371.2020602@linaro.org>
In-Reply-To: <4FE18371.2020602@linaro.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2012 01:31 PM, Lee Jones wrote:
> On 20/06/12 08:39, Laxman Dewangan wrote:
>> On Wednesday 20 June 2012 12:39 PM, Lee Jones wrote:
>>> On 19/06/12 18:32, Stephen Warren wrote:
>>>> On 06/19/2012 10:13 AM, Lee Jones wrote:
>>>>>> On 19/06/12 15:28, Laxman Dewangan wrote:
>>>>>>>> Device's regulator matches their hardware counterparts with the
>>>>>>>> property "regulator-compatible" of each child regulator node in
>>>>>>>> place of the child node.
>>>>>>>> Add the property "regulator-compatible" for each regulator with
>>>>>>>> their name.
>>>>>>>>
>>>>>>>> Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>>>>>>> ---
>>>>>>>> Changes from V1:
>>>>>>>> - This is new change in V2.
>>>>>>>>
>>>>>>>> arch/arm/boot/dts/db8500.dtsi | 128
>>>>>>>> +++++++++++++++++++++++++++++++----------
>>>>>>>> 1 files changed, 97 insertions(+), 31 deletions(-)
>>>>>>>>
>>>>>>>> diff --git a/arch/arm/boot/dts/db8500.dtsi
>>>>>>>> b/arch/arm/boot/dts/db8500.dtsi
>>>>>>>> index 4ad5160..9548f80 100644
>>>>>>>> --- a/arch/arm/boot/dts/db8500.dtsi
>>>>>>>> +++ b/arch/arm/boot/dts/db8500.dtsi
>>>>>>>> @@ -203,107 +203,149 @@
>>>>>>>>
>>>>>>>> db8500-prcmu-regulators {
>>>>>>>> compatible = "stericsson,db8500-prcmu-regulator";
>>>>>>>> + #address-cells =<1>;
>>>>>>>> + #size-cells =<0>;
>>>>>> Why are these and the reg properties required?
>>>> DT nodes should be named after the type of object they describe (e.g.
>>>> "regulator") rather than the name of the object they're describing (e.g.
>>>> "vape").
>>>>
>>>> Once you've made that change, you end up with many nodes with the same
>>>> name in the same parent, so you need to make their names unique. You do
>>>> this by adding a "unit address" to each of them - "@0", "@1", ... But,
>>>> in order to be "allowed" to use such a unit address, you need a reg
>>>> property that matches the unit address, and #address-cells/#size-cells
>>>> in the parent node.
>>> I don't like it. By doing this you are preventing any regulator from
>>> being registered by of_platform_populate(). Also, the nodes are already
>>> placed under an identifying node "db8500-prcmu-regulators", so we know
>>> they are regulators, making the regulator@x, the reg property and the
>>> *-cells properties unnecessary cruft.
>>>
>>> I'd prefer to have the second label removed and just to call the
>>> regulators by their correct name. The property names become functionally
>>> redundant after the previous patch has been applied in any case.
>>>
>>> Something like this:
>>>
>>>> db8500-prcmu-regulators {
>>>> compatible = "stericsson,db8500-prcmu-regulator";
>>>>
>>>> // DB8500_REGULATOR_VAPE
>>>> - db8500_vape_reg: db8500_vape {
>>>> + db8500_vape {
>>>> + regulator-compatible = "db8500_vape";
>>>> regulator-name = "db8500-vape";
>>>> regulator-always-on;
>>>> };
>>
>> You will require a label so that it can refer by the consumer.
> Don't they both act as labels? Thus if you removed the second one, the
> phandle will be taken from the remaining label? It's not something I've
> tried, so I'm happy to be wrong here.
>
> If I'm wrong about that, can't we just omit the reg and *-size
> properties? They are meaningless and restrictive.
>

We need to have the label. The name can not act as label. I tried 
following and got compilation error for dts file.
Tried following way

                                 reg_vdd1 {
                                         regulator-compatible = "vdd1";
                                         :::::::::::::::::
                                 };

                                 reg_vdd2: regulator@1 {
                                         regulator-compatible = "vdd2";
                                         :::::::::::::::::
                                 };

                                 reg_vddctrl: regulator@2 {
                                         regulator-compatible = "vddctrl";
                                         :::::::::::::::::
                                         vin-supply = <&reg_vdd1>;
                                 };

And got build error as
**********
DTC: dts->dtb  on file "arch/arm/boot/dts/tegra30-cardhu.dts"
ERROR (phandle_references): Reference to non-existent node or label 
"reg_vdd1"

ERROR: Input tree has errors, aborting (use -f to force output)
*******

Are you OK to have the first patch with adding property 
"regulator-compatible" on each of child node so that I can go ahead with 
this patch and regulator core/documentation patch along with changes in 
my board to enable regulators.
Once we will conclude on the child name either like vdd1 or regulator@0, 
we can have modification accordingly.

This will also need to avoid bi-sect issue as Stephen's suggested
patch 1: Add regulator-property on each child node of db8500.
patch 2: modify the regulator/core and documentation.

Patch3 and onwards: Based on discussion, name the child node.

Patch1 and 2 will not break anything and with this I can enable 
regulator on my boards.


Thanks,
Laxman



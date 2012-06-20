Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754084Ab2FTHJg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 03:09:36 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:39212 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074Ab2FTHJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 03:09:35 -0400
Message-ID: <4FE1772A.2010806@linaro.org>
Date: Wed, 20 Jun 2012 08:09:30 +0100
From: Lee Jones <lee.jones@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120410 Thunderbird/11.0.1
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Laxman Dewangan <ldewangan@nvidia.com>,
        broonie@opensource.wolfsonmicro.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, arnd@arndb.de, linus.walleij@linaro.org,
        lrg@ti.com, devicetree-discuss@lists.ozlabs.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH V2 3/3] ARM: dts: db8500: add node property "regulator-compatible"
 regulator node
References: <1340116099-17629-1-git-send-email-ldewangan@nvidia.com> <1340116099-17629-4-git-send-email-ldewangan@nvidia.com> <4FE0A546.1010707@linaro.org> <4FE0B79D.4090201@wwwdotorg.org>
In-Reply-To: <4FE0B79D.4090201@wwwdotorg.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/06/12 18:32, Stephen Warren wrote:
> On 06/19/2012 10:13 AM, Lee Jones wrote:
>> >  On 19/06/12 15:28, Laxman Dewangan wrote:
>>> >>  Device's regulator matches their hardware counterparts with the
>>> >>  property "regulator-compatible" of each child regulator node in
>>> >>  place of the child node.
>>> >>  Add the property "regulator-compatible" for each regulator with
>>> >>  their name.
>>> >>
>>> >>  Signed-off-by: Laxman Dewangan<ldewangan@nvidia.com>
>>> >>  ---
>>> >>  Changes from V1:
>>> >>     - This is new change in V2.
>>> >>
>>> >>     arch/arm/boot/dts/db8500.dtsi |  128
>>> >>  +++++++++++++++++++++++++++++++----------
>>> >>     1 files changed, 97 insertions(+), 31 deletions(-)
>>> >>
>>> >>  diff --git a/arch/arm/boot/dts/db8500.dtsi
>>> >>  b/arch/arm/boot/dts/db8500.dtsi
>>> >>  index 4ad5160..9548f80 100644
>>> >>  --- a/arch/arm/boot/dts/db8500.dtsi
>>> >>  +++ b/arch/arm/boot/dts/db8500.dtsi
>>> >>  @@ -203,107 +203,149 @@
>>> >>
>>> >>                 db8500-prcmu-regulators {
>>> >>                     compatible = "stericsson,db8500-prcmu-regulator";
>>> >>  +                #address-cells =<1>;
>>> >>  +                #size-cells =<0>;
>> >
>> >  Why are these and the reg properties required?
> DT nodes should be named after the type of object they describe (e.g.
> "regulator") rather than the name of the object they're describing (e.g.
> "vape").
>
> Once you've made that change, you end up with many nodes with the same
> name in the same parent, so you need to make their names unique. You do
> this by adding a "unit address" to each of them - "@0", "@1", ... But,
> in order to be "allowed" to use such a unit address, you need a reg
> property that matches the unit address, and #address-cells/#size-cells
> in the parent node.

I don't like it. By doing this you are preventing any regulator from 
being registered by of_platform_populate(). Also, the nodes are already 
placed under an identifying node "db8500-prcmu-regulators", so we know 
they are regulators, making the regulator@x, the reg property and the 
*-cells properties unnecessary cruft.

I'd prefer to have the second label removed and just to call the 
regulators by their correct name. The property names become functionally 
redundant after the previous patch has been applied in any case.

Something like this:

>  			db8500-prcmu-regulators {
>  				compatible = "stericsson,db8500-prcmu-regulator";
>
>  				// DB8500_REGULATOR_VAPE
> -				db8500_vape_reg: db8500_vape {
> +				db8500_vape {
> +					regulator-compatible = "db8500_vape";
>  					regulator-name = "db8500-vape";
>  					regulator-always-on;
>  				};

It's also a shame we can't do anything about the regulator-name, or 
regulator-compatible property naming conventions. They are almost always 
going to be either extremely similar or even the same. Seems like a bit 
of a wasted property to me at this point.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
M: +44 77 88 633 515
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog

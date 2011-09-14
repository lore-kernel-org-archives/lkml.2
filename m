Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757251Ab1INR55 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 13:57:57 -0400
Received: from mail-gw0-f52.google.com ([74.125.83.52]:36742 "EHLO
	mail-gw0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab1INR5z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 13:57:55 -0400
X-Greylist: delayed 5163 seconds by postgrey-1.27 at vger.kernel.org; Wed, 14 Sep 2011 13:57:55 EDT
Message-ID: <4E70EB1F.4060000@gmail.com>
Date: Wed, 14 Sep 2011 12:57:51 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110906 Thunderbird/7.0
MIME-Version: 1.0
To: Marc Zyngier <marc.zyngier@arm.com>
CC: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "grant.likely@secretlab.ca" <grant.likely@secretlab.ca>,
        "thomas.abraham@linaro.org" <thomas.abraham@linaro.org>,
        "jamie@jamieiles.com" <jamie@jamieiles.com>,
        "b-cousson@ti.com" <b-cousson@ti.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>
Subject: Re: [PATCH 5/5] ARM: gic: add OF based initialization
References: <1316017900-19918-1-git-send-email-robherring2@gmail.com> <1316017900-19918-6-git-send-email-robherring2@gmail.com> <4E70E88E.4090503@arm.com>
In-Reply-To: <4E70E88E.4090503@arm.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Marc,

On 09/14/2011 12:46 PM, Marc Zyngier wrote:
> On 14/09/11 17:31, Rob Herring wrote:
>> From: Rob Herring <rob.herring@calxeda.com>
>>
>> This adds gic initialization using device tree data. The initialization
>> functions are intended to be called by a generic OF interrupt
>> controller parsing function once the right pieces are in place.
>>
>> PPIs are handled using 3rd cell of interrupts properties to specify the cpu
>> mask the PPI is assigned to.
>>
>> Signed-off-by: Rob Herring <rob.herring@calxeda.com>
>> ---
>>  Documentation/devicetree/bindings/arm/gic.txt |   53 ++++++++++++++++++++++++
>>  arch/arm/common/gic.c                         |   55 +++++++++++++++++++++++--
>>  arch/arm/include/asm/hardware/gic.h           |   10 +++++
>>  3 files changed, 114 insertions(+), 4 deletions(-)
>>  create mode 100644 Documentation/devicetree/bindings/arm/gic.txt
>>
>> diff --git a/Documentation/devicetree/bindings/arm/gic.txt b/Documentation/devicetree/bindings/arm/gic.txt
>> new file mode 100644
>> index 0000000..6c513de
>> --- /dev/null
>> +++ b/Documentation/devicetree/bindings/arm/gic.txt
>> @@ -0,0 +1,53 @@
>> +* ARM Generic Interrupt Controller
>> +
>> +ARM SMP cores are often associated with a GIC, providing per processor
>> +interrupts (PPI), shared processor interrupts (SPI) and software
>> +generated interrupts (SGI).
>> +
>> +Primary GIC is attached directly to the CPU and typically has PPIs and SGIs.
>> +Secondary GICs are cascaded into the upward interrupt controller and do not
>> +have PPIs or SGIs.
>> +
>> +Main node required properties:
>> +
>> +- compatible : should be one of:
>> +	"arm,cortex-a9-gic"
>> +	"arm,arm11mp-gic"
>> +- interrupt-controller : Identifies the node as an interrupt controller
>> +- #interrupt-cells : Specifies the number of cells needed to encode an
>> +  interrupt source.  The type shall be a <u32> and the value shall be 3.
>> +
>> +  The 1st cell is the interrupt number. 0-15 are reserved for SGIs. 16-31 are
>> +  for PPIs.
>> +
>> +  The 2nd cell is the level-sense information, encoded as follows:
>> +                    1 = low-to-high edge triggered
>> +                    2 = high-to-low edge triggered
>> +                    4 = active high level-sensitive
>> +                    8 = active low level-sensitive
>> +
>> +  Only values of 1 and 4 are valid for GIC 1.0 spec.
>> +
>> +  The 3rd cell contains the mask of the cpu number for the interrupt source.
>> +  The cpu mask is only valid for PPIs and shall be 0 for SPIs. This value shall
>> +  be 0 for PPIs.
>      ^^^^^^^^^^^^^
> 
> Typo here ? The way I understand it, it should read "For PPIs, this
> value shall be the mask of the possible CPU numbers for the interrupt
> source" (or something to similar effect...).
> 

Cut and paste error. This sentence goes in the previous paragraph. What
I meant is the 2nd cell should contain 0 for PPIs as you cannot set the
edge/level on PPIs (that is always true, right?). I probably should also
add 0 in the list of values.

I take it you are otherwise fine with this binding?

Rob


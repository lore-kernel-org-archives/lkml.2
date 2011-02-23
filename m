Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932393Ab1BWTGc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 14:06:32 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:10058 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932122Ab1BWTGb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 14:06:31 -0500
Message-ID: <4D655AB6.80400@caviumnetworks.com>
Date: Wed, 23 Feb 2011 11:06:30 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com> <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com> <20110223000759.GA26300@yookeroo>
In-Reply-To: <20110223000759.GA26300@yookeroo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 19:06:31.0419 (UTC) FILETIME=[C7FB04B0:01CBD38C]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:07 PM, David Gibson wrote:
> On Tue, Feb 22, 2011 at 12:57:46PM -0800, David Daney wrote:
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   arch/mips/cavium-octeon/.gitignore      |    2 +
>>   arch/mips/cavium-octeon/Makefile        |   13 ++
>>   arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
>>   arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
>>   4 files changed, 428 insertions(+), 0 deletions(-)
>>   create mode 100644 arch/mips/cavium-octeon/.gitignore
>>   create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
>>   create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
>>
>> diff --git a/arch/mips/cavium-octeon/.gitignore b/arch/mips/cavium-octeon/.gitignore
>> new file mode 100644
>> index 0000000..39c9686
>> --- /dev/null
>> +++ b/arch/mips/cavium-octeon/.gitignore
>> @@ -0,0 +1,2 @@
>> +*.dtb.S
>
> .dtb.S?

I think I have the correct .gitignore syntax.

>
> [snip]
>> +/dts-v1/;
>> +/* OCTEON 3XXX, 5XXX, 63XX device tree skeleton. */
>> +/ {
>> +  model = "OCTEON";
>
> 1 tab indents are the usual convention for device trees.

OK.

>
>> +  compatible = "octeon,octeon";
>
> There's no model number at all for this board?


I think it should be:

	compatible = "octeon,octeon-3860";

>
>> +  #address-cells =<2>;
>> +  #size-cells =<2>;
>> +
>> +  soc@0 {
>> +    device_type = "soc";
>
> Drop this device_type.

OK.

>
>> +    compatible = "simple-bus";
>> +    #address-cells =<2>;
>> +    #size-cells =<2>;
>> +    ranges; /* Direct mapping */
>> +
>> +    ciu: ciu-3xxx@1070000000000 {
>> +      compatible = "octeon,ciu-3xxx";
>
> So, names or compatible values with "wildcards" like 3xxx should be
> avoided.  Instead, use the specific model number of this device, then
> future devices can claim compatibility with the earlier one.
>
> But, in addition the generic names convention means that the node name
> should be "interrupt-controller" rather than something model specific.

Let's try:

ciu: interrupt-controller@1070000000000 {
       compatible = "octeon,octeon-3860-ciu";


>
>> +      interrupt-controller;
>> +      #address-cells =<0>;
>> +      #interrupt-cells =<2>;
>> +      reg =<0x10700 0x00000000 0x0 0x7000>;
>> +    };
>> +
>> +    /* SMI0 */
>> +    mdio0: mdio@1180000001800 {
>
> If SMI0 is the name generally used in the documentation, using that in
> the label instead of mdio0 might be more useful.
>
>> +      compatible = "octeon,mdio";
>
> No model or revision number?
>
Let's try:

	smi0: mdio@1180000001800 {
		compatible = "octeon,octeon-3860-mdio";

>> +      #address-cells =<1>;
>> +      #size-cells =<0>;
>> +      reg =<0x11800 0x00001800 0x0 0x40>;
>> +      device_type = "mdio";
>
> Drop this device_type.

OK.

>
[...]
>> +    mgmt0: ethernet@1070000100000 {
>> +      compatible = "octeon,mgmt";

This becomes:

	mgmt0: ethernet@1070000100000 {
		compatible = "octeon,octeon-5230-mii";


>> +      device_type = "network";
>> +      model = "mgmt";
>> +      reg =<0x10700 0x00100000 0x0 0x100>, /* MIX */
>> +<0x11800 0xE0000000 0x0 0x300>, /* AGL */
>> +<0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
>> +<0x11800 0xE0002000 0x0 0x8>;   /* AGL_PRT_CTL */
>> +      unit-number =<0>;
>
> What is this 'unit-number' property for?
>


The AGL_SHARED register bank is shared among all the octeon-5230-mii 
devices.  the 'unit-number' indicates the bit-field index that this 
device should use within those registers.


>> +      interrupt-parent =<&ciu>;
>> +      interrupts =<0 62>,<1 46>;
>> +      local-mac-address = [ 00 00 00 00 00 00 ];
>
> That's not a valid MAC address of course.  If this has to be patched
> in by the bootloader / later processing, you should add a comment to
> that effect.
>

Right.

>> +      phy-handle =<&phy0>;
>> +    };
>> +
>> +    mgmt1: ethernet@1070000100800 {
>> +      compatible = "octeon,mgmt";
>> +      device_type = "network";
>> +      model = "mgmt";
>> +      reg =<0x10700 0x00100800 0x0 0x100>, /* MIX */
>> +<0x11800 0xE0000800 0x0 0x300>, /* AGL */
>> +<0x11800 0xE0000400 0x0 0x400>, /* AGL_SHARED  */
>> +<0x11800 0xE0002008 0x0 0x8>;   /* AGL_PRT_CTL */
>> +      unit-number =<1>;
>> +      interrupt-parent =<&ciu>;
>> +      interrupts =<1 18>,<  1 46>;
>> +      local-mac-address = [ 00 00 00 00 00 00 ];
>> +      phy-handle =<&phy1>;
>> +    };
>> +
>> +    pip: pip@11800a0000000 {
>> +      compatible = "octeon,pip";
>> +      #address-cells =<1>;
>> +      #size-cells =<0>;
>> +      reg =<0x11800 0xa0000000 0x0 0x2000>;
>> +
>> +      interface@0 {
>
> These subnodes and subsubnodes should have compatible values too, even
> if it's just "octeon,pip-interface" and "octeon,pip-ethernet".
>

OK.

>> +        #address-cells =<1>;
>> +        #size-cells =<0>;
>> +        reg =<0>; /* interface */
>> +
>> +        ethernet@0 {
>> +          device_type = "network";
>> +          model = "pip";
>
> This model property doesn't look very useful.
>

I will remove it.

> [snip]

>
> Uh.. where are the CPUs?
>

Answered in other e-mail.

Thanks,
David Daney

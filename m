Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab1ACL2m (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 06:28:42 -0500
Received: from www.tglx.de ([62.245.132.106]:51575 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753095Ab1ACL2l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 06:28:41 -0500
Message-ID: <4D21B2D8.8040509@linutronix.de>
Date: Mon, 03 Jan 2011 12:28:24 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
User-Agent: Mozilla-Thunderbird 2.0.0.24 (X11/20100329)
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>
CC: linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 03/15] x86/dtb: Add a device tree for CE4100
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-4-git-send-email-bigeasy@linutronix.de> <20101230085122.GE11721@angua.secretlab.ca>
In-Reply-To: <20101230085122.GE11721@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Grant Likely wrote:

>> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
>> new file mode 100644
>> index 0000000..24e67ca
>> --- /dev/null
>> +++ b/arch/x86/platform/ce4100/falconfalls.dts
>> +
>> +				i2c@15a00 {
>> +					#address-cells = <1>;
>> +					#size-cells = <0>;
>> +					reg = <0x15a00 0x0 0x0 0x0>;
>> +
>> +
>> +					i2c@0 {
>> +						reg = <0>;
>> +					};
>> +
>> +					i2c@1 {
>> +						#address-cells = <1>;
>> +						#size-cells = <0>;
>> +						reg = <1>;
>> +
>> +						pcf8575@26 {
>> +							compatible = "ti,pcf8575";
>> +							reg = <0x26>;
>> +						};
>> +					};
>> +
>> +					i2c@2 {
>> +						#address-cells = <1>;
>> +						#size-cells = <0>;
>> +						reg = <2>;
>> +
>> +						pcf8575@26 {
>> +							compatible = "ti,pcf8575";
>> +							reg = <0x26>;
>> +						};
>> +					};
> 
> All these i2c bus controllers should have a compatible value so that
> the OS knows what driver to bind to them.

The node i2c@15a00 is the PCI device. This PCI device has three bars, each
bar is a complete i2c controller. All three controller share one IRQ. The
device is probed via its pci-id and therefore I have no compatible value
here. Do you want me to add compatible values based on "Vendor ID, Device
ID, Subsystem Vendor ID, ..." as mention in the PCI-bindings?

The child nodes here (i2c@0,...) represent the bars. I probably should
replace i2c@0 with bar@0 and the reg property with a bar property. Would
that be okay?

> Also, the node names for the i2c devices should reflect what the
> device does, not what the part number is (grep ePAPR for 'generic
> names')
Okay. This probably also means that I should replace pic@ with 
interrupt-controller and so on.

Sebastian

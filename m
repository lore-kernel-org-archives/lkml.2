Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751831Ab1AEKBZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 05:01:25 -0500
Received: from www.tglx.de ([62.245.132.106]:38863 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751639Ab1AEKBY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 05:01:24 -0500
Date: Wed, 5 Jan 2011 11:01:12 +0100
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de, x86@kernel.org,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 03/15] x86/dtb: Add a device tree for CE4100
Message-ID: <20110105100112.GA670@www.tglx.de>
References: <1292600033-12271-1-git-send-email-bigeasy@linutronix.de> <1292600033-12271-4-git-send-email-bigeasy@linutronix.de> <20101230085122.GE11721@angua.secretlab.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20101230085122.GE11721@angua.secretlab.ca>
User-Agent: Mutt/1.4.2.2i
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Grant Likely | 2010-12-30 01:51:22 [-0700]:

>> diff --git a/arch/x86/platform/ce4100/falconfalls.dts b/arch/x86/platform/ce4100/falconfalls.dts
>> new file mode 100644
>> index 0000000..24e67ca
>> --- /dev/null
>> +++ b/arch/x86/platform/ce4100/falconfalls.dts
>> @@ -0,0 +1,212 @@
>> +/*
>> + * CE4100 on Falcon Falls
>> + *
>> + * (c) Copyright 2010 Intel Corporation
>> + *
>> + * This program is free software; you can redistribute it and/or modify it
>> + * under the terms of the GNU General Public License as published by the
>> + * Free Software Foundation; version 2 of the License.
>> + */
>> +/dts-v1/;
>> +/ {
>> +	model = "Intel,FalconFalls";
>> +	compatible = "Intel,FalconFalls";
>
>To-date the convention has been to use all lowercase in compatible
>properties.  Ditto throughout this file.
done

>> +	soc@0 {
>> +		#address-cells = <1>;
>> +		#size-cells = <1>;
>> +		device_type = "soc";
>
>Drop device_type property.
done

>> +		ioapic1: pic@fec00000 {
>> +			#interrupt-cells = <2>;
>> +			compatible = "Intel,ioapic";
>> +			interrupt-controller;
>> +			device_type = "interrupt-controller";
>
>Ditto
done

>> +		pci@3fc {
>> +			#address-cells = <3>;
>> +			#interrupt-cells = <1>;
>> +			#size-cells = <2>;
>> +			compatible = "Intel,ce4100-pci", "pci";
>> +			device_type = "pci";
>
>I'd like to say ditto here, but it might require a change to the
>current kernel code.  I believe ePAPR specified a compatible value
>alternative to 'device_type = "pci";'.
I have the pci property. So I drop the device_type once it is possible.

>> +			isa@0 {
>> +				#address-cells = <2>;
>> +				#size-cells = <1>;
>> +				compatible = "isa";
>> +				ranges = <1 0 0 0 0 0x100>;
>> +
>> +				rtc@70 {
>> +					compatible = "motorola,mc146818";
>> +					interrupts = <8 3>;
>> +					interrupt-parent = <&ioapic1>;
>
>If you put an interrupt-parent property in the root node, then it will
>become the default interrupt controller for the system which is
>usually convenient to have.
Okay, I mode it once I have more common devices. I have two interrupt
controller and most devices are attached to the second one (and are
assigned via interrupt-map).

>> +			/* Secondary IO-APIC */
>> +			ioapic2: pic@bffff000 {
>> +				#interrupt-cells = <2>;
>> +				compatible = "Intel,ioapic-ce4100", "Intel,ioapic";
>> +				interrupt-controller;
>> +				device_type = "interrupt-controller";
>
>Drop device_type.
done

Sebastian

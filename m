Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755516Ab0IVVbH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 17:31:07 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:50604 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753438Ab0IVVbG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 17:31:06 -0400
Message-ID: <4C9A7533.9010903@kernel.org>
Date: Wed, 22 Sep 2010 14:29:23 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] x86: tidy e820 output
References: <20100922172744.19085.41844.stgit@bob.kio> <201009221311.19567.bjorn.helgaas@hp.com> <4C9A6FF4.2060201@kernel.org> <201009221522.06873.bjorn.helgaas@hp.com>
In-Reply-To: <201009221522.06873.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/22/2010 02:22 PM, Bjorn Helgaas wrote:
> On Wednesday, September 22, 2010 03:07:00 pm Yinghai Lu wrote:
>> On 09/22/2010 12:11 PM, Bjorn Helgaas wrote:
> 
>>> -static void __init e820_print_type(u32 type)
>>> +static char * __init e820_type_name(u32 type)
>>>  {
>>>  	switch (type) {
>>>  	case E820_RAM:
>>>  	case E820_RESERVED_KERN:
>>> -		printk(KERN_CONT "(usable)");
>>> -		break;
>>> +		return "usable";
>>>  	case E820_RESERVED:
>>> -		printk(KERN_CONT "(reserved)");
>>> -		break;
>>> +		return "reserved";
>>>  	case E820_ACPI:
>>> -		printk(KERN_CONT "(ACPI data)");
>>> -		break;
>>> +		return "ACPI data";
>>>  	case E820_NVS:
>>> -		printk(KERN_CONT "(ACPI NVS)");
>>> -		break;
>>> +		return "ACPI NVS";
>>>  	case E820_UNUSABLE:
>>> -		printk(KERN_CONT "(unusable)");
>>> -		break;
>>> -	default:
>>> -		printk(KERN_CONT "type %u", type);
>>> -		break;
>>> +		return "unusable";
>>>  	}
>>> +	return "(unknown)";
>>>  }
>>
>> type value?
> 
> I decided the code simplification was worth skipping the type.
> I'd certainly rather have the type value, too, but I don't know
> how much hassle to go through to debug a firmware problem.  How
> important do you think it is?

I have some systems with "type 9".

Yinghai

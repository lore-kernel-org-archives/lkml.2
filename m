Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1FPB4D (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 21:56:03 -0400
Received: from mga02.intel.com ([134.134.136.20]:31276 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753803Ab1FPB4B (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 21:56:01 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,372,1304319600"; 
   d="scan'208";a="15370825"
Message-ID: <4DF962AE.60204@intel.com>
Date: Thu, 16 Jun 2011 09:55:58 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Matthew Garrett <mjg59@srcf.ucam.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>
Subject: Re: [PATCH] ACPI, APEI, Add APEI _OSC support
References: <1306303538-30524-1-git-send-email-ying.huang@intel.com> <20110614145246.GA17469@srcf.ucam.org> <4DF82CBC.5070400@intel.com> <20110615121703.GA8638@srcf.ucam.org> <4DF950EB.7050400@intel.com> <20110616013812.GA32494@srcf.ucam.org>
In-Reply-To: <20110616013812.GA32494@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/16/2011 09:38 AM, Matthew Garrett wrote:
> On Thu, Jun 16, 2011 at 08:40:11AM +0800, Huang Ying wrote:
>> On 06/15/2011 08:17 PM, Matthew Garrett wrote:
>>>> You means the "APEI Support" bit for standard UUID?  Do you know which
>>>> machine uses this bit?  I can write the code, but I have no machine to
>>>> test it.
>>>
>>> I have access to a Dell system that uses this.
>>
>> Great! Can you help us to test the code?
> 
> Yup, no problem.
> 
>>> Urgh. One machine I've looked at enables APEI if the WHEA _OSC call is 
>>> made, and then clears a flag if any other _OSC call is made. In that 
>>> specific case it doesn't seem to matter (the flag never actually gets 
>>> checked in any of the other codepaths), but it seems that the intention 
>>> is for the generic call to be made and the WHEA one to be made after 
>>> that.
>>
>> Yes.  The WHEA call should be made after the generic one.  Another
>> situation is as follow:
>>
>> - Generic _OSC call without "APEI Support" bit is called (in
>> acpi_bus_osc_support).
>>
>> - After some time, when we think it is good to turn on firmware first
>> mode fully, usually after we checking HEST and initializing
>> corresponding module, we make generic _OSC call with "APEI Support" bit
>> to turn on firmware first mode fully in standard way.
>>
>> Is it a good idea to make generic _OSC call twice, one without "APEI
>> Support" bit, the other with "APEI Support" bit?
> 
> I think we probably need to make the HEST decision early, and use that 
> to decide how to make the generic call. Our experience has been that 
> many firmware vendors only expect _OSC to be called once with any given 
> UUID - multiple calls can result in unexpected behaviour.

acpi_bus_osc_support is called via subsys_initcall.  It is a little hard
to do all checking before that.  Is it possible to call
acpi_bus_osc_support later?

Best Regards,
Huang Ying

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753265Ab0DMXMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:12:48 -0400
Received: from acsinet12.oracle.com ([141.146.126.234]:64238 "EHLO
	acsinet12.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752728Ab0DMXMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:12:46 -0400
Message-ID: <4BC4F9C2.20503@oracle.com>
Date: Tue, 13 Apr 2010 16:09:54 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Andy Isaacson <adi@hexapodia.org>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH -v2 1/2] x86: Reserve [0xa0000, 0x100000] in e820 map
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC4F03C.1020707@oracle.com> <4BC4F320.8020902@zytor.com> <4BC4F703.5030700@oracle.com> <4BC4F80C.2020209@zytor.com> <4BC4F851.7040500@oracle.com> <4BC4F948.8050500@zytor.com>
In-Reply-To: <4BC4F948.8050500@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090206.4BC4FA2C.0145:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 04:07 PM, H. Peter Anvin wrote:
> On 04/13/2010 04:03 PM, Yinghai wrote:
>> On 04/13/2010 04:02 PM, H. Peter Anvin wrote:
>>>>
>>>> Are you sure? what is BAR range? greater than 1M ?
>>>>
>>>> e820_reserve_resources() will make that range to be reserved and BUSY in resource tree.
>>>> and if driver for that device want to call pci_request_region, it will get failure...
>>>>
>>>
>>> Yes, > 1 MB in that case, I'm fairly sure.
>>
>> that is ok. actually that is handled by e820_reserve_resource_late(), and it will not put BUSY on the entry at all.
>>
> 
> OK... why is that handled differently?

about one year ago, Linus made that change to use insert_resource_expand_to_fit() to honor PCI device BAR than E820_RESERVED.

YH

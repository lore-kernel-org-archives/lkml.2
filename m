Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752597Ab0DMXBX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Apr 2010 19:01:23 -0400
Received: from acsinet11.oracle.com ([141.146.126.233]:51168 "EHLO
	acsinet11.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751437Ab0DMXBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Apr 2010 19:01:22 -0400
Message-ID: <4BC4F703.5030700@oracle.com>
Date: Tue, 13 Apr 2010 15:58:11 -0700
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
References: <20100409223532.GC11130@hexapodia.org>	 <4BBFB1D8.6090802@oracle.com> <20100410000030.GE11130@hexapodia.org>	 <4BBFD019.9040405@oracle.com> <20100410014308.GG11130@hexapodia.org>	 <4BBFD8EF.6020108@oracle.com> <20100410015711.GH11130@hexapodia.org>	 <4BBFE66C.2040603@oracle.com> <20100412185416.GA19959@hexapodia.org>	 <4BC375D9.4040503@oracle.com> <20100412200224.GO11130@hexapodia.org>	 <4BC39F67.4090407@oracle.com> <1271192527.6035.44.camel@dc7800.home> <4BC4DD85.5030203@zytor.com> <4BC4DDEA.60202@oracle.com> <4BC4DFAD.9020600@zytor.com> <4BC4E55B.7000103@oracle.com> <4BC4E8FB.8060802@zytor.com> <4BC4F03C.1020707@oracle.com> <4BC4F320.8020902@zytor.com>
In-Reply-To: <4BC4F320.8020902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090205.4BC4F79C.0083:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/2010 03:41 PM, H. Peter Anvin wrote:
> On 04/13/2010 03:29 PM, Yinghai wrote:
>>>
>>> We have talked about a need to resolve this before.
>>
>> current code for mmio that is just below 4g, if some PCI BAR use that range, and those range is falling into E820_RESERVED,
>>
>> those range still can be claimed, but driver can not use pci_request_region() later.
>>
>> So We still
>> 1. rely that BIOS does not reserve the [0xa0000, 0xe0000)
>> 2. kernel only reserve the range when we make sure these is legacy device on that range.
>>
> 
> This really isn't sufficient.  There are systems in the field which
> marks a memory range reserved in E820 because it a device pointed there,
> and it doesn't want that device moved because it is used by an SMM handler.
> 
> This was reported quite a while ago (like two years.)  I can dig up the
> thread if it matters.

Are you sure? what is BAR range? greater than 1M ?

e820_reserve_resources() will make that range to be reserved and BUSY in resource tree.
and if driver for that device want to call pci_request_region, it will get failure...

YH

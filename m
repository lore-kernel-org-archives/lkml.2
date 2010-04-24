Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757203Ab0DXAe0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 20:34:26 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:61686 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752901Ab0DXAeY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 20:34:24 -0400
Message-ID: <4BD23D01.2080303@oracle.com>
Date: Fri, 23 Apr 2010 17:36:17 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below BIOS_END
References: <4BC4E55B.7000103@oracle.com> <4BCE8E3E.4030809@oracle.com> <20100421193120.GD11130@hexapodia.org> <201004231705.25659.bjorn.helgaas@hp.com> <4BD230C9.3090309@zytor.com>
In-Reply-To: <4BD230C9.3090309@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090207.4BD23C69.0003:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 04:44 PM, H. Peter Anvin wrote:
> On 04/23/2010 04:05 PM, Bjorn Helgaas wrote:
>   
>> On Wednesday 21 April 2010 01:31:20 pm Andy Isaacson wrote:
>>     
>>> On Tue, Apr 20, 2010 at 10:33:50PM -0700, Yinghai wrote:
>>>       
>>>> Update e820 at first, and later put them resource tree.
>>>> Reserved that early, will not be allocated to unassigned PCI BAR
>>>>
>>>> v3: remove probe_roms() that is not needed, because whole range is reserved
>>>> 	 already
>>>>         
>>> Test booted this patch series on the problematic t3400, seems to work
>>> fine.  dmesg attached to bug 15744.
>>>       
>> Thanks for testing (again).  I'm not confident that this series is
>> going to be successful, so I started looking for other approaches.
>>
>> I can't reproduce the exact problem you're seeing, but in my
>> kludged-up attempt, the patch below is enough to keep us from
>> assigning the space below 1MB to a device.
>>
>> Would you guys (Andy & Andy, what a coincidence :-)) mind giving
>> it a try?  This is intended to work on top of current upstream,
>> with no other patches required.
>>
>>     
> This certainly wins from a simplicity standpoint!
>
>   
indeed.



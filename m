Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755952Ab0DVAIk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:08:40 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:41128 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755516Ab0DVAIi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:08:38 -0400
Message-ID: <4BCF92E8.5030103@oracle.com>
Date: Wed, 21 Apr 2010 17:06:00 -0700
From: Yinghai <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100317 SUSE/3.0.4-1.1.1 Thunderbird/3.0.4
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Bjorn Helgaas <bjorn.helgaas@hp.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>, Jesse Barnes <jbarnes@virtuousgeek.org>,
       Andy Isaacson <adi@hexapodia.org>, guenter.roeck@ericsson.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>,
       "Pan, Jacob jun" <jacob.jun.pan@intel.com>
Subject: Re: [PATCH 3/3] x86,pci,acpi: Handle invalid _CRS
References: <20100409223532.GC11130@hexapodia.org> <201004211059.17264.bjorn.helgaas@hp.com> <4BCF7D38.8070206@zytor.com> <201004211704.05541.bjorn.helgaas@hp.com> <4BCF85CF.1080101@zytor.com> <4BCF8DAE.5020204@oracle.com> <4BCF921B.7030307@zytor.com>
In-Reply-To: <4BCF921B.7030307@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: rcsinet15.oracle.com [148.87.113.117]
X-CT-RefId: str=0001.0A090207.4BCF9365.002F:SCFMA4539811,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 05:02 PM, H. Peter Anvin wrote:
> On 04/21/2010 04:43 PM, Yinghai wrote:
>>
>> then use -v3 please
>>
>> -v4: also don't trim [0xa0000, 0x100000] for mrst.
>>
> 
> That makes a lot of sense for 2.6.34.  I agree with moving the trimming
> into subsystems, but I think it's .35 material at this point.
> 
> [Cc: Jacob Pan]
> 
>>>
>>> The use of a string match in:
>>>
>>> +       if (check_child && !conflict->child && strstr(conflict->name,
>>> "PCI Bus"))
>>> ^^^^^^^^^
>>>
>>> ... screams "wrong! ugly! bad!" in my opinion.  I utterly fail to see
>>> how that could be acceptable under any circumstances.  I thought that
>>> had been flagged earlier in the conversation, but it is apparently still
>>> there.
>>
>> the string checking is to make sure pci device that is hooked into bus0 directly, but pci bar is falling into
>> 0xa0000 - 0x100000.  So can not put "reserved" holder under them.
>>
> 
> It makes me extremely concerned, because such hacks tend to be extremely
> vulnerable.  Strings are designed primarily for human consumption, and
> "find string inside another string" is *very* much so.  As such, I
> really would like to understand that there isn't any more sensible way,
> such as a flag, that can be used to accomplish the objective.

pass function pointer to additional checking?

YH

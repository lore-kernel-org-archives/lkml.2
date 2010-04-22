Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755251Ab0DVADQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 20:03:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:56114 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753106Ab0DVADO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 20:03:14 -0400
Message-ID: <4BCF921B.7030307@zytor.com>
Date: Wed, 21 Apr 2010 17:02:35 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Yinghai <yinghai.lu@oracle.com>
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
References: <20100409223532.GC11130@hexapodia.org> <201004211059.17264.bjorn.helgaas@hp.com> <4BCF7D38.8070206@zytor.com> <201004211704.05541.bjorn.helgaas@hp.com> <4BCF85CF.1080101@zytor.com> <4BCF8DAE.5020204@oracle.com>
In-Reply-To: <4BCF8DAE.5020204@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2010 04:43 PM, Yinghai wrote:
>
> then use -v3 please
> 
> -v4: also don't trim [0xa0000, 0x100000] for mrst.
> 

That makes a lot of sense for 2.6.34.  I agree with moving the trimming
into subsystems, but I think it's .35 material at this point.

[Cc: Jacob Pan]

>>
>> The use of a string match in:
>>
>> +       if (check_child && !conflict->child && strstr(conflict->name,
>> "PCI Bus"))
>> ^^^^^^^^^
>>
>> ... screams "wrong! ugly! bad!" in my opinion.  I utterly fail to see
>> how that could be acceptable under any circumstances.  I thought that
>> had been flagged earlier in the conversation, but it is apparently still
>> there.
> 
> the string checking is to make sure pci device that is hooked into bus0 directly, but pci bar is falling into
> 0xa0000 - 0x100000.  So can not put "reserved" holder under them.
> 

It makes me extremely concerned, because such hacks tend to be extremely
vulnerable.  Strings are designed primarily for human consumption, and
"find string inside another string" is *very* much so.  As such, I
really would like to understand that there isn't any more sensible way,
such as a flag, that can be used to accomplish the objective.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756003Ab0D1RMM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 13:12:12 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:23338 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753840Ab0D1RMK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 13:12:10 -0400
Message-ID: <4BD86D05.20402@oracle.com>
Date: Wed, 28 Apr 2010 10:14:45 -0700
From: Yinghai Lu <yinghai.lu@oracle.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100228 SUSE/3.0.3-1.1.1 Thunderbird/3.0.3
MIME-Version: 1.0
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       "H. Peter Anvin" <hpa@zytor.com>, Andy Isaacson <adi@hexapodia.org>,
       "R. Andrew Bailey" <bailey@akamai.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       guenter.roeck@ericsson.com,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Thomas Renninger <trenn@suse.de>, yaneti@declera.com
Subject: Re: [PATCH] x86/PCI: never allocate PCI MMIO resources below    BIOS_END
References: <2b1eecc3-75b8-4ab3-8932-fdf7cc1e181b@email.android.com> <4BD640E3.1050101@oracle.com> <201004270911.12124.bjorn.helgaas@hp.com> <201004281007.37016.bjorn.helgaas@hp.com>
In-Reply-To: <201004281007.37016.bjorn.helgaas@hp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Auth-Type: Internal IP
X-Source-IP: acsinet15.oracle.com [141.146.126.227]
X-CT-RefId: str=0001.0A090203.4BD86C41.017F:SCFMA922111,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Never mind, for 2.6.34 your patch should be good enough.

On 04/28/2010 09:07 AM, Bjorn Helgaas wrote:
> Yinghai, ping, do you have any more information about this?
>
> On Tuesday 27 April 2010 09:11:10 am Bjorn Helgaas wrote:
>   
>> On Monday 26 April 2010 07:41:55 pm Yinghai wrote:
>> But let's double-check this:
>>
>>     
>>> also find one AMD system:
>>> [    7.056011] pci_root PNP0A03:00: host bridge window [mem 0xfed20000-0xffffffff]
>>> ...
>>> pci assign unassign code could use range like [mem 0xfed20000-0xffffffff] wrongly.
>>>       
>> I agree, it's very unlikely that it's safe to put PCI devices all the
>> way up to 0xffffffff.  I suspect this might be fixed by d558b483d5a,
>> which computes the end of the bridge window using _MAX rather than _LEN.
>>
>> See https://bugzilla.kernel.org/show_bug.cgi?id=15480#c15 for an example
>> similar to the one above: we originally thought the window was
>> [mem 0xcff00000-0xffffffff], but d558b483d5a changes that to
>> [mem 0xcff00000-0xfebfffff], which matches what Windows found.
>>
>> Yinghai, can you take a look at your AMD system again with a kernel that
>> includes d558b483d5a, and see whether we still have a problem?  If we
>> *do* still have a problem, please open a bugzilla and attach a dmesg log
>> with ACPI resource info collected with the debug patch here:
>> https://bugzilla.kernel.org/show_bug.cgi?id=15533#c5
>>
>> Bjorn
>>
>>     
>
>   


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758797Ab2DJODL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 10:03:11 -0400
Received: from server1.neighborhoods.net ([207.154.13.48]:60620 "EHLO
	server1.neighborhoods.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753201Ab2DJODK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 10:03:10 -0400
Message-ID: <4F843D9B.3010601@meetinghouse.net>
Date: Tue, 10 Apr 2012 10:03:07 -0400
From: Miles Fidelman <mfidelman@meetinghouse.net>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.6; rv:11.0) Gecko/20120312 Firefox/11.0 SeaMonkey/2.8
MIME-Version: 1.0
To: Matthew Garrett <mjg@redhat.com>
CC: linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, x86@kernel.org, peter.chubb@nicta.com.au,
        michael.d.labriola@gmail.com
Subject: Re: reboot via bios on X86_64?
References: <4F8302B4.8040901@meetinghouse.net> <20120409155155.GA22974@srcf.ucam.org> <4F831BD0.3010707@meetinghouse.net> <20120409173223.GA25717@srcf.ucam.org> <4F83231A.8040005@meetinghouse.net> <20120409180711.GA26277@srcf.ucam.org>
In-Reply-To: <20120409180711.GA26277@srcf.ucam.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matthew Garrett wrote:
> On Mon, Apr 09, 2012 at 01:57:46PM -0400, Miles Fidelman wrote:
>> Matthew Garrett wrote:
>>> On Mon, Apr 09, 2012 at 01:26:40PM -0400, Miles Fidelman wrote:
>>>
>>>> No.  Tried all the combinations - w/ and w/o hypervisor, all the
>>>> available kernel options.  Seems
>>>> like the only thing that will reboot this particular hardware/bios
>>>> combo is via the bios.
>>> And this is with 3.3? Interesting. What's the exact behaviour you see,
>>> and what motherboard is this?
>>>
>> No.  2.6.32.5  (the one that currently ships with Debian stable).
> Ok. The reboot code has been reworked since then. It'd be good to try it
> with a new kernel.
>
I just went through the reboot.c code, line-by-line, comparing what I'm 
running (2.6.32.41) with the 3.3 code, and
what I'm seeing is:

- the same huge amount of code excluded by #ifdef CONFIG_X86_32 blocks 
(i.e., still no path to reboot through the bios)

- no new methods for executing a reboot - choices for X86_64 remain 
[warm|cold|triple|kbd|acpi|efi,|pci|force]

- no changes to the actual code that invokes any of those reboot methods

All that seems to have changed is:

- there are some additional quirks handled, but they all translate to 
invoking one of [warm|cold|triple|kbd|acpi|efi,|pci|force]

- if one is trying to do a shutdown (which already works for me), there 
is one section of code that actually changes, specifically:
inside a #ifdef CONFIG_X86_64
    pci_iommu_shutdown();    changes to   x86_platform.iommu_shutdown();

----
So... I don't see that trying a newer kernel is going to have any effect 
vis-a-vis rebooting my particularly piece of hardware under a 64-bit 
kernel - and what with the close coupling of xen versions w/ kernel 
versions, seems like a lot of potential pain points just to test this.  
Sigh...

Miles


-- 
In theory, there is no difference between theory and practice.
In practice, there is.   .... Yogi Berra



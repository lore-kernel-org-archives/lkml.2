Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab0GMXaU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 19:30:20 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60911 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756130Ab0GMXaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 19:30:17 -0400
Message-ID: <4C3CF650.30905@kernel.org>
Date: Tue, 13 Jul 2010 16:27:12 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: tip/master broken with x2apic and kexec
References: <4C3BD6AA.3070908@kernel.org> <4C3CE210.2030902@zytor.com>
In-Reply-To: <4C3CE210.2030902@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090202.4C3CF6FD.0028,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 03:00 PM, H. Peter Anvin wrote:
> On 07/12/2010 07:59 PM, Yinghai Lu wrote:
>> tip/master: 
>> system1: BIOS enabled x2apic, first kernel boot well, and when kexec second kernel will cause system instant reboot.
>>
>> system2: BIOS not enable x2apic, first kernel boot well and enable x2apic, and kexec second kernel well. but when kexec third kernel will case system instant reboot.
>>
>> linus' tree is ok.
>>
>> but for system2 if boot with nox2apic ,intr-remaping off, iommu off, the kexec loop test will pass.
>>
>> the problem looks start in recent two or three weeks.
>>
>> Any idea?
>>
>> bisecting will take a while, because the system post take a while everytime.
>>
>> Thanks
>>
>> Yinghai Lu
> 
> OK, I found the bug... if you could test out the patch which will be
> sent out shortly I would very much appreciate it.

not sure if your patch is the offending one now.

kL: kernel from linus tree
kT1: kernel from tip
kT2: kernel from tip with reverting your patch

BIOS-->kL ---> kL ---> kL....always working
BIOS-->kT1 ---> kT1 --->  kT1 : between second one and third one system reset instant...
BIOS-->kT2 ---> kT2 --->  kT2 : between second one and third one system reset instant...

BIOS-->kL ---> kL ---> kL ---> then kT1 ---> kT1 .... always working
BIOS-->kL ---> kL ---> kL ---> then kT2 ---> kT2 .... always working

looks like first kernel and second one can not be kernel from tip.

Yinghai

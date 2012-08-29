Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752203Ab2H2FPP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Aug 2012 01:15:15 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18738 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751626Ab2H2FPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Aug 2012 01:15:10 -0400
Message-ID: <503DA591.4010100@oracle.com>
Date: Wed, 29 Aug 2012 13:16:01 +0800
From: "zhenzhong.duan" <zhenzhong.duan@oracle.com>
Reply-To: zhenzhong.duan@oracle.com
Organization: oracle
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: tglx@linutronix.de, mingo@redhat.com, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Feng Jin <joe.jin@oracle.com>
Subject: Re: [PATCH] Parallelize mtrr init between cpus
References: <5020C3D7.2070407@oracle.com> <5021432F.2030907@zytor.com> <5021CA31.7000405@oracle.com> <5021E2A2.8080606@zytor.com>
In-Reply-To: <5021E2A2.8080606@zytor.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 2012-08-08 11:53, H. Peter Anvin wrote:
> On 08/07/2012 07:08 PM, zhenzhong.duan wrote:
>>
>>
>>   2012-08-08 00:32, H. Peter Anvin wrote:
>>> On 08/07/2012 12:29 AM, zhenzhong.duan wrote:
>>>> Current code serialize mtrr init with set_atomicity_lock.
>>>> Mtrr init is quite slow when we bootup on a hvm with large mem, vcpus
>>>> and pci passthroughed devices(eg. 24 vcpus + 90G mem).
>>>> It took about ~30 mins to bootup, after patch, it took ~2 min.
>>> When you're saying "HVM" do you mean "Xen HVM"?  How does it behave on
>>> native hardware?
>>>
>>>     -hpa
>> Yes, I mean Xen HVM. Bootup at same speed as before on baremetal.
>
> Then I would like to know why Xen HVM takes so infernally long.  It 
> isn't a good idea to make gratuitous changes in the main kernel to 
> work around defects in Xen.
>
>     -hpa
Hi,
Sorrry for late response, I have an opportunity to test the patch on an 
old G5 with 128 physical CPUS and 1 TB of memory. Arround 0.82 second 
time saved.
Depends on cpu count on the system.
I'm curious what's the usage of set_atomicity_lock here? There may be 
something I missed. thanks

Before patch:
[   13.176038] NMI watchdog enabled, takes one hw-pmu counter.
[   13.176444] Brought up 128 CPUs
[   13.176688] Total of 128 processors activated (578760.49 BogoMIPS).
[   14.035223] devtmpfs: initialized
[   17.277652] PM: Registering ACPI NVS region at 7f76e000 (401408 bytes)
[   17.279541] print_constraints: dummy:
[   17.280576] NET: Registered protocol family 16
After patch:
[   13.094227] smpboot cpu 127: start_ip = 90000
[   13.185142] NMI watchdog enabled, takes one hw-pmu counter.
[   13.185599] Brought up 128 CPUs
[   13.185851] Total of 128 processors activated (578871.80 BogoMIPS).
[   13.224783] devtmpfs: initialized
[   16.468002] PM: Registering ACPI NVS region at 7f76e000 (401408 bytes)
[   16.469706] print_constraints: dummy:
[   16.470745] NET: Registered protocol family 16


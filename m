Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1EEWGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 May 2011 18:06:51 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:45108 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752727Ab1EEWGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 May 2011 18:06:50 -0400
Message-ID: <4DC31F72.5050206@kernel.org>
Date: Thu, 05 May 2011 15:06:42 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110414 SUSE/3.1.10 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stefan Hellermann <stefan@the2masters.de>
CC: linux-kernel@vger.kernel.org
Subject: Re: early crash on ancient tablet related to no-bootmem
References: <4DC30251.9040902@the2masters.de> <4DC31D5F.8070209@the2masters.de>
In-Reply-To: <4DC31D5F.8070209@the2masters.de>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-Source-IP: rcsinet13.oracle.com [148.87.113.125]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4DC31F77.0110,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/05/2011 02:57 PM, Stefan Hellermann wrote:
> CC: yinghai@kernel.org
> 
> Is this BIOS-88 RAM map supposed to work?
> 
> Am 05.05.2011 22:02, schrieb Stefan Hellermann:
>> Hi!
>>
>> I have an really old tablet PC. It's and 486 with 40MHz and 8MB Ram
>> (http://www.homecomputermuseum.de/comp/327_de.htm)
>> I sometimes test new kernels on it, and since the invention of
>> CONFIG_NO_BOOTMEM it does not work with this option enabled. So 2.6.36
>> without NO_BOOTMEM work, every newer Kernel will hang, only visible with
>> earlyprintk=vga.
>>
>> Bootlog:
>> Booting the kernel.
>> Linux version 2.6.36 (stefan@hel-stefan.lan) (gcc version 4.6.0 20110428
>> (Red Hat 4.6.0-6) (GCC) ) #5 Thu May 5 21:49:09 CEST 2011
>> BIOS-provided physical RAM map:
>>  BIOS-88: 0000000000000000 - 000000000009f000 (usable)
>>  BIOS-88: 0000000000100000 - 0000000000840000 (usable)
>> bootconsole [earlyser0] enabled
>> Notice: NX (Execute Disable) protection missing in CPU or disabled in BIOS!
>> DMI not present or invalid.
>> last_pfn = 0x840 max_arch_pfn = 0x100000
>> init_memory_mapping: 0000000000000000-0000000000840000
>> 8MB LOWMEM available.
>>   mapped low ram: 0 - 00840000
>>   low ram: 0 - 00840000
>> Zone PFN ranges:
>>   DMA      0x00000001 -> 0x00001000
>>   Normal   empty
>> Movable zone start PFN for each node
>> early_node_map[2] active PFN ranges
>>     0: 0x00000001 -> 0x0000009f
>>     0: 0x00000100 -> 0x00000840
>> BUG: Int 6: CR2 (null)
>>      EDI c034663c  ESI (null)  EBP c0329f38  ESP c0329ef4
>>      EBX c0346380  EDX 00000006  ECX ffffffff  EAX fffffff4
>>      err (null)  EIP c0353191   CS c0320060  flg 00010082
>> Stack: (null) c030c533 000007cd (null) c030c533 00000001 (null) (null)
>>        00000003 0000083f 00000018 00000002 00000002 c0329f6c c03534d6 (null)
>>        (null) 00000100 00000840 (null) c0329f64 00000001 00001000 (null)
>> Pid: 0, comm: swapper Not tainted 2.6.36 #5
>> Call Trace:
>>  [<c02e3707>] ? 0xc02e3707
>>  [<c035e6e5>] 0xc035e6e5
>>  [<c0353191>] ? 0xc0353191
>>  [<c03534d6>] 0xc03534d6
>>  [<c034f1cd>] 0xc034f1cd
>>  [<c034a824>] 0xc034a824
>>  [<c03513cb>] ? 0xc03513cb
>>  [<c0349432>] 0xc0349432
>>  [<c0349066>] 0xc0349066
>>
>> with NO_BOOTMEM=y. Is it possible to resolve this symbols somehow?
>> CONFIG_FRAMEPOINTER=y. With latest git the crash is about the same.

can you please boot with "ignore_loglevel debug memblock=debug"?

Thanks

Yinghai

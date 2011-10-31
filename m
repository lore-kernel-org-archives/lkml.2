Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754181Ab1JaHiM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Oct 2011 03:38:12 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36116 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751026Ab1JaHiL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Oct 2011 03:38:11 -0400
MIME-Version: 1.0
In-Reply-To: <CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
References: <CAJw04pD24W_nGSLheWunCa_o7QqBmRf_TSAD44EkzazigRe_nQ@mail.gmail.com>
	<12144.1320040276@neuling.org>
	<CAJw04pAh5QDQMkUHbj9=rRPiUCZejimHiydCJFMAoZeSd_ydhA@mail.gmail.com>
Date: Mon, 31 Oct 2011 13:08:09 +0530
Message-ID: <CAJw04pC6ZPpO8xvybjLH0ya9eKBKAkpf8N3gDTMpFnpTuhJs2A@mail.gmail.com>
Subject: Re: powerpc 476, Little-endian, pte fault
From: Santosh Kumar <santoshkumar.a@gmail.com>
To: Michael Neuling <mikey@neuling.org>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        Tony Breeds <tony@bakeyournoodle.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is not the first user-space instruction. While executing this
process kernel has added two TLB entries with TID(process id) 1. while
trying to map 0x100000fc it is raising pte faults .

Santosh Kumar .A

Vision without Action is a daydream... Action without Vision is a nightmare...



On 31 October 2011 12:05, Santosh Kumar <santoshkumar.a@gmail.com> wrote:
> I have built a cross compiler for ppc440 in little endian mode and
> using it to build the kernel.
>
> Yes i am running Linux in Little-Endian. This is the first user space
> process. I wrote the below program and running it as init from
> /sbin/init. I have also set the permissions with chmod +s.
>
> main()
> {
>
> while(1){
> printf("hello world");
> sleep(1);
>  }
> }
>
> I have attached the patch.
>
> -
> Santosh Kumar .A
>
> Vision without Action is a daydream... Action without Vision is a nightmare...
>
>
>
> On 31 October 2011 11:21, Michael Neuling <mikey@neuling.org> wrote:
>> Adding linuxppc-dev list to the CC
>>
>>> KERNEL: linux 2.6.39.4
>>> POWERPC: 476, little endian.
>>>
>>> I am trying to get linux 2.6.39.4 up on PPC 476 i have done done
>>> Big-endian to little endian Changes in:
>>
>> Can you explain what you are trying to do in more detail?  What does "i
>> have done Big-endian to little endian Changes" mean?
>>
>>> 1) bitops header file.
>>> 2) while reading the device tree.
>>> 3) the PTE read/computed in head_32.S
>>> 4) added E bit in the TLB entries.
>>>
>>> with all the above changes the kernel_init is done but and inited is
>>> mounted.
>>
>> Can you post your patch?
>>
>> Are you trying to boot the kernel in little endian or just run userspace
>> in little endian?
>>
>>> But while spawning init process the kernel continuously hits pte
>>> faults at address 0x100000fc and never comes out. Please let me know
>>> where i should be looking into.
>>
>> Is this the very first userspace instruction?
>>
>> Mikey
>>
>>
>

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755416Ab0HBVZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 17:25:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:27557 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755125Ab0HBVZM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 17:25:12 -0400
Message-ID: <4C57371C.4000708@kernel.org>
Date: Mon, 02 Aug 2010 14:22:36 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com> <4C571DF2.5080100@kernel.org> <4C5731AF.9040009@zytor.com> <4C5733CF.20100@zytor.com>
In-Reply-To: <4C5733CF.20100@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090208.4C573786.01C5,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 02:08 PM, H. Peter Anvin wrote:
> On 08/02/2010 01:59 PM, H. Peter Anvin wrote:
>> On 08/02/2010 12:35 PM, Yinghai Lu wrote:
>>>
>>> it seems I can not global variables in arch/x86/boot/compressed/misc.c
>>>
>>
>> I just looked at it, it's the fact that we don't relocate the GOT that
>> is causing problems.  It's relatively easy to fix: here is a patch, but
>> in grand Linus tradition it is completely untested.
>>
> 
> Untested indeed... here is one which doesn't clobber live registers.
> 
> 	-hpa
> 

still doesn't work.

with global early_serial_base got :

early console in setup code
[    0.000000] bootconsole [uart0] enabled


with static early_serial_base got :

early console in setup code
early console in decompress_kernel
decompress_kernel:
  input: [0x24a0269-0x2e8b234], output: 0x1000000, heap: [0x2e909c0-0x2e979bf]

Decompressing Linux... Parsing ELF... done.
Booting the kernel.
[    0.000000] bootconsole [uart0] enabled


Thanks

Yinghai

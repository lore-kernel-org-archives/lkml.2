Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754378Ab0HBWwe (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 18:52:34 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:33900 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753586Ab0HBWwd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 18:52:33 -0400
Message-ID: <4C574BEE.7060802@kernel.org>
Date: Mon, 02 Aug 2010 15:51:26 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Cyrill Gorcunov <gorcunov@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 2/2] x86: more early console output from	compressed/misc.c
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <4C568D6F.3050004@kernel.org> <20100802174916.GD5544@lenovo> <4C5710C1.8020809@zytor.com> <20100802185410.GE5544@lenovo> <4C57153F.7030107@zytor.com> <4C571DF2.5080100@kernel.org> <4C5731AF.9040009@zytor.com> <4C5733CF.20100@zytor.com> <4C57382E.8050501@zytor.com> <4C574700.1080000@kernel.org> <4C574AB6.5030403@zytor.com>
In-Reply-To: <4C574AB6.5030403@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt354.oracle.com [141.146.40.154]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090209.4C574BFD.0085,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 08/02/2010 03:46 PM, H. Peter Anvin wrote:
> First, I'm not quite sure which 1/2 patch you're expecting this to be
> compiled against.

-v3

> 
> On 08/02/2010 03:30 PM, Yinghai Lu wrote:
>>  
>> +	if (debug) {
>> +		putstr("decompress_kernel:\n");
>> +		printf("  input: [0x%lx-0x%lx], output: 0x%lx, heap: [0x%lx-0x%lx]\n",
>> +			 (unsigned long)input_data,
>> +			 (unsigned long)input_data + input_len - 1,
>> +			 (unsigned long)output,
>> +			 (unsigned long)heap,
>> +			 (unsigned long)heap + BOOT_HEAP_SIZE - 1);
>> +	}
>> +
> 
> This seems to be the only user of printf() in the code.  As such, I
> really suspect it's not worth pulling in all of printf().  I'd be
> willing to be convinced, but if so I need (a) a concrete usage case, and
> (b) it should be a separate patch.

ok, will drop printf.

Yinghai

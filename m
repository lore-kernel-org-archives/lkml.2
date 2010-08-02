Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078Ab0HBTRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 15:17:19 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:21268 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752441Ab0HBTRS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 15:17:18 -0400
Message-ID: <4C57193A.1030805@kernel.org>
Date: Mon, 02 Aug 2010 12:15:06 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Cyrill Gorcunov <gorcunov@gmail.com>
CC: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v3 1/2] x86, setup: reorgize the early_console_setup
References: <4C56701B.1030000@kernel.org> <4C5670DA.2080703@zytor.com> <4C5680D2.4020302@kernel.org> <4C568D2B.205@kernel.org> <20100802174334.GC5544@lenovo>
In-Reply-To: <20100802174334.GC5544@lenovo>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsmt355.oracle.com [141.146.40.155]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090204.4C571985.0264,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02/2010 10:43 AM, Cyrill Gorcunov wrote:
> On Mon, Aug 02, 2010 at 02:17:31AM -0700, Yinghai Lu wrote:
> ...
>> Index: linux-2.6/arch/x86/boot/printf.c
>> ===================================================================
>> --- linux-2.6.orig/arch/x86/boot/printf.c
>> +++ linux-2.6/arch/x86/boot/printf.c
>> @@ -34,7 +34,7 @@ static int skip_atoi(const char **s)
>>  #define SMALL	32		/* Must be 32 == 0x20 */
>>  #define SPECIAL	64		/* 0x */
>>  
>> -#define do_div(n,base) ({ \
>> +#define __do_div(n, base) ({ \
>>  int __res; \
>>  __res = ((unsigned long) n) % (unsigned) base; \
>>  n = ((unsigned long) n) / (unsigned) base; \
>> @@ -83,7 +83,7 @@ static char *number(char *str, long num,
>>  		tmp[i++] = '0';
>>  	else
>>  		while (num != 0)
>> -			tmp[i++] = (digits[do_div(num, base)] | locase);
>> +			tmp[i++] = (digits[__do_div(num, base)] | locase);
> 
> Yinghai, what was wrong with the origin do_div? After inclusion it as "printf.c"
> in another *.c do_div gets clashed?

yes. get clashed if include that printf.c in arch/x86/boot/compressed/misc.c

Yinghai

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760368Ab0LOA5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 19:57:00 -0500
Received: from terminus.zytor.com ([198.137.202.10]:60411 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760267Ab0LOA47 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 19:56:59 -0500
Message-ID: <4D081225.8000007@zytor.com>
Date: Tue, 14 Dec 2010 16:56:05 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: Tejun Heo <tj@kernel.org>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [cpuops cmpxchg double V1 2/4] x86: this_cpu_cmpxchg_double()
 support
References: <20101214174847.887713690@linux.com> <20101214174900.659284593@linux.com> <4D080FDC.7030005@zytor.com>
In-Reply-To: <4D080FDC.7030005@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/14/2010 04:46 PM, H. Peter Anvin wrote:
> On 12/14/2010 09:48 AM, Christoph Lameter wrote:
>> +
>> +/*
>> + * Inputs:
>> + * %rsi : memory location to compare
>> + * %rax : low 64 bits of old value
>> + * %rdx : high 64 bits of old value
>> + * %rbx : low 64 bits of new value
>> + * %rcx : high 64 bits of new value
>> + * %al  : Operation successful
>> + */
>> +ENTRY(cmpxchg16b_cpuops_emu)
>> +CFI_STARTPROC
>> +
>> +#
>> +# Emulate 'cmpxchg16b %gs:(%rsi)' except we return the result in
>> +# al not via the ZF. Caller will access al to get result.
>> +#
> 
> NAK on this.  This is acceptable for cmpxchg8b only because we don't
> support SMP on 486s anymore.  x86-64 is another matter...
> 	

Hm, this is meant to be a CPU local operation, isn't it... it isn't very
clear from the comments or naming *in this file*.

Could you make it a little clearer in the local code, please?

	-hpa

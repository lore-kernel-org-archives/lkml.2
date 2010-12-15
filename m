Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755496Ab0LOVEr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 16:04:47 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33396 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab0LOVEq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 16:04:46 -0500
Message-ID: <4D092D15.7030700@zytor.com>
Date: Wed, 15 Dec 2010 13:03:17 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Christoph Lameter <cl@linux.com>, Tejun Heo <tj@kernel.org>,
        Pekka Enbeerg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: x86: A fast way to check capabilities of the current cpu
References: <alpine.DEB.2.00.1012151404070.21102@router.home> <20101215125626.25f7d648.akpm@linux-foundation.org>
In-Reply-To: <20101215125626.25f7d648.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/15/2010 12:56 PM, Andrew Morton wrote:
> On Wed, 15 Dec 2010 14:07:39 -0600 (CST)
> Christoph Lameter <cl@linux.com> wrote:
> 
>> +#define cpu_has(c, bit)							\
>> +	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 :	\
>>  	 test_cpu_cap(c, bit))
>>
>> +#define this_cpu_has(bit)						\
>> +	(__builtin_constant_p(bit) && REQUIRED_MASK_BIT_SET(bit) ? 1 : 	\
>> +	 this_cpu_test_bit(bit, (unsigned long *)&cpu_info.x86_capability))
>> +
> 
> Isn't
> 
> 	a ? 1 : b
> 
> a complex way of writing
> 
> 	a || b
> 

Not if b is not a bool.

	-hpa


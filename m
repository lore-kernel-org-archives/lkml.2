Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab0KZRGz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:06:55 -0500
Received: from hera.kernel.org ([140.211.167.34]:48788 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755606Ab0KZRGx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:06:53 -0500
Message-ID: <4CEFE8F6.5050109@kernel.org>
Date: Fri, 26 Nov 2010 18:05:58 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Christoph Lameter <cl@linux.com>
CC: akpm@linux-foundation.org, Pekka Enberg <penberg@cs.helsinki.fi>,
        linux-kernel@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 05/10] x86: Use this_cpu_inc_return for nmi
 counter
References: <20101123235139.908255844@linux.com> <20101123235158.826005750@linux.com> <4CEFE1CB.4050404@kernel.org> <alpine.DEB.2.00.1011261047460.13524@router.home>
In-Reply-To: <alpine.DEB.2.00.1011261047460.13524@router.home>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 17:06:00 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 06:02 PM, Christoph Lameter wrote:
> On Fri, 26 Nov 2010, Tejun Heo wrote:
> 
>>> -		__this_cpu_inc(alert_counter);
>>> -		if (__this_cpu_read(alert_counter) == 5 * nmi_hz)
>>> +		if (__this_cpu_inc_return(alert_counter) == 5 * nmi_hz)
>>
>> Hmmm... one worry I have is that xadd, being not a very popular
>> operation, might be slower than add and read.  Using it for atomicity
>> would probably be beneficial in most cases but have you checked this
>> actually is cheaper?
> 
> XADD takes 3 uops. INC 1 and MOV 1 uop. So there is an additiona uop.
> 
> However, a memory fetch from l1 takes a mininum 4 cycles. Doing that twice
> already ends up with at least 8 cycles.

Thanks for the explanation.  It might be beneficial to note
performance characteristics on top of the x86 implementation?
Anyways, for this and the following simple conversion patches.

Reviewed-by: Tejun Heo <tj@kernel.org>

-- 
tejun

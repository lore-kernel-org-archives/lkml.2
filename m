Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755609Ab0KZRIH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Nov 2010 12:08:07 -0500
Received: from hera.kernel.org ([140.211.167.34]:48846 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752778Ab0KZRIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Nov 2010 12:08:05 -0500
Message-ID: <4CEFE958.2020606@kernel.org>
Date: Fri, 26 Nov 2010 18:07:36 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: Christoph Lameter <cl@linux.com>, akpm@linux-foundation.org,
        Pekka Enberg <penberg@cs.helsinki.fi>, linux-kernel@vger.kernel.org,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: [thiscpuops upgrade 08/10] percpu: generic this_cpu_cmpxchg()
 and this_cpu_cmpxchg_double support
References: <20101123235139.908255844@linux.com>	 <20101123235200.582485207@linux.com>  <4CEFE583.8070103@kernel.org>	 <1290790569.2855.254.camel@edumazet-laptop>  <4CEFE71F.5090303@kernel.org> <1290790887.2855.260.camel@edumazet-laptop>
In-Reply-To: <1290790887.2855.260.camel@edumazet-laptop>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Fri, 26 Nov 2010 17:07:38 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2010 06:01 PM, Eric Dumazet wrote:
>> What I'm afraid of is generic code switching to use it in very hot
>> paths when a lot of archs can't actually do it leading to performance
>> regressions.  Is this something which is available on most archs?
>>
> 
> I would say cmpxchg() has the same problem, some arches dont have a
> native instruction, yet we use it in some paths.

Yeah, well, there's difference between some not having it and only
x86_64 having it.  cmpxchg was already rather well received when it
was added even though it wasn't available on all archs.  I'm not
against it but think we should use some caution here and think about
the impact of unoptimized cases which can be pretty common (preemption
toggling isn't too expensive but irq toggling can be quite).

Thanks.

-- 
tejun

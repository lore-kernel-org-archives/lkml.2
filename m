Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab0KDWgL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 18:36:11 -0400
Received: from mao.bsc.es ([84.88.52.34]:52529 "EHLO opsmail01.bsc.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab0KDWgI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 18:36:08 -0400
X-Greylist: delayed 478 seconds by postgrey-1.27 at vger.kernel.org; Thu, 04 Nov 2010 18:36:08 EDT
Message-ID: <4CD33374.60800@bsc.es>
Date: Thu, 04 Nov 2010 23:28:04 +0100
From: Victor Jimenez <victor.javier@bsc.es>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Francis Moreau <francis.moro@gmail.com>
CC: Reid Kleckner <reid.kleckner@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.eqFHAk86WhpTuYclHhngn7QZr8Y@ifi.uio.no>	<fa.X++YRAJg+rmPtm3nmroZZoNU7u8@ifi.uio.no>	<fa.Elk8wOfBHRdKtkHIjP9hOtzVCgQ@ifi.uio.no>	<fa.U3fdWUGXguguIIyQ4v66/uKOhus@ifi.uio.no>	<fa.YTQQoGhoS6d3BaZXcZMN+l9TojQ@ifi.uio.no> <m24obwst53.fsf@gmail.com>
In-Reply-To: <m24obwst53.fsf@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Copyrighted-Material: Please visit http://www.bsc.es/disclaimer.htm
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/04/2010 09:58 PM, Francis Moreau wrote:
> Francis Moreau<francis.moro@gmail.com>  writes:
>
>> Francis Moreau<francis.moro@gmail.com>  writes:
>>
> [...]
>
>>> How could I know the number of cache level on my cpu ?
>>>
>>> I tried:
>>>
>>>    $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>>>
>>>      Performance counter stats for 'true':
>>>
>>>                     802  cache-misses
>>>                     937  L1-dcache-load-misses
>>>
>>>             0.000996578  seconds time elapsed
>>>
>>>    $ perf stat -e cache-misses:u,L2-loads-misses:u true
>>>
>>>     Performance counter stats for 'true':
>>>
>>>                    788  cache-misses
>>>                     95  LLC-load-misses
>>>
>>>            0.001025423  seconds time elapsed
>>>
>>> So it looks like you're right: in my case I have this cache
>>> configuration:
>>>
>> oops sorry, I replied too early...
>>
>> so my cache configuration is:
>>
>>     L1 ->  L2 ->  LLC
>>
>> where L2 misses is given by: 'cache-misses' - 'LLC-load-misses'
>>
>> Is that correct ?
>>
>> If so, I found 'cache-misses' term very not intuitive IMHO, probably
>> because I'm not an expert in cpu caches...
> Well thinking more about it, the above is wrong and I'm lost.
>
> If 'cache-misses' is the last level cache misses then how to interpret
> these results ?
>
>    $ perf stat -e llc-load-misses:u,llc-store-misses:u true
>
>     Performance counter stats for 'true':
>
>                     94  LLC-load-misses
>                      0  LLC-store-misses
>
>            0.000981840  seconds time elapsed
>
>
>    $ perf stat -e cache-misses:u true
>
>     Performance counter stats for 'true':
>
>                    796  cache-misses
>
>            0.001345136  seconds time elapsed
>
> Here 'cache-misses' value is much more than llc misses one...
>
If you are measuring last level cache misses, I would recommend you to 
use a memory intensive application/benchmark instead of /bin/true, as 
otherwise there can be a significant variation between two runs.

Victor

-- 
------------------------------------------------------------------------

      Victor Jimenez Perez
      Barcelona Supercomputing Center
      Centro Nacional de Supercomputacion
      WWW: http://www.bsc.es
      e-mail: victor.javier@bsc.es

------------------------------------------------------------------------


WARNING / LEGAL TEXT: This message is intended only for the use of the
individual or entity to which it is addressed and may contain
information which is privileged, confidential, proprietary, or exempt
from disclosure under applicable law. If you are not the intended
recipient or the person responsible for delivering the message to the
intended recipient, you are strictly prohibited from disclosing,
distributing, copying, or in any way using this message. If you have
received this communication in error, please notify the sender and
destroy and delete any copies you may have received.

http://www.bsc.es/disclaimer.htm

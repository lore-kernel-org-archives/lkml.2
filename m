Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab0KDIqF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:46:05 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62383 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab0KDIp7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:45:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=xeVVRS/0YoZSAN498eAZmwI6VkGf1ywrzaNh/e1qTQXIbh/wZJGaPE4oYuh2hWUx0n
         RToCGYpguzGx/9NCcPZ+EwZDzNJEShPmKMFiqpg671klBGSY3ROKv0HMK/0iHwSWbY/j
         FXa+/x6Ms9aNJyhTvYKR4xL7rOLSUQ5+Vei0E=
From: Francis Moreau <francis.moro@gmail.com>
To: Reid Kleckner <reid.kleckner@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.AyvjD8RxwvZsnL5ZXcZ+OzALKY8@ifi.uio.no>
	<fa.wlHJxDLDciTHF6/icJo+JfjJPus@ifi.uio.no>
	<fa.8PQyp14JyjNgKJB4NUWsi+YoZBM@ifi.uio.no>
	<fa.ZajcSOe/t8/XBoLV1hZ7SjSJvtI@ifi.uio.no>
Date: Thu, 04 Nov 2010 09:45:45 +0100
In-Reply-To: <fa.ZajcSOe/t8/XBoLV1hZ7SjSJvtI@ifi.uio.no> (Francis Moreau's
	message of "Thu, 04 Nov 2010 08:34:31 UTC")
Message-ID: <m2pqulschy.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> writes:

> Reid Kleckner <reid.kleckner@gmail.com> writes:
>
>> On Wed, Nov 3, 2010 at 5:43 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>>> What's exactly the 'cache-misses' event ? does it include both instructions
>>>> _and_ data cache misses ? both L1 and L2 caches ?
>>>>
>>
>>>> I was expecting so but the following command makes me wondering:
>>>>
>>>>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>>>>     Performance counter stats for 'true':
>>>>
>>>>                 763  cache-misses
>>>>                 874  L1-dcache-load-misses
>>>>
>>>>         0.000916609  seconds time elapsed
>>>>
>>>> Here cache-misses < L1-dcache-load-misses.
>>>
>>>
>>>
>>> Dunno, will let others answer.
>>
>> I think it corresponds to last level cache misses, which makes sense
>> here.  The difference in the two numbers represents hits to L2 (and L3
>> if it exists).
>
> How could I know the number of cache level on my cpu ?
>
> I tried:
>
>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>
>     Performance counter stats for 'true':
>
>                    802  cache-misses
>                    937  L1-dcache-load-misses
>
>            0.000996578  seconds time elapsed
>
>   $ perf stat -e cache-misses:u,L2-loads-misses:u true
>
>    Performance counter stats for 'true':
>
>                   788  cache-misses
>                    95  LLC-load-misses
>
>           0.001025423  seconds time elapsed
>
> So it looks like you're right: in my case I have this cache
> configuration:
>

oops sorry, I replied too early...

so my cache configuration is:

   L1 -> L2 -> LLC

where L2 misses is given by: 'cache-misses' - 'LLC-load-misses'

Is that correct ?

If so, I found 'cache-misses' term very not intuitive IMHO, probably
because I'm not an expert in cpu caches...

-- 
Francis

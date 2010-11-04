Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753198Ab0KDU6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 16:58:55 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43371 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab0KDU6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 16:58:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=brt5fKu/Hv2hmyhCPOJwF5ljo9hpitXAU7qxjudV+u8aKVaxm3xW+ZOzdcl9keWnJU
         PLIAMWqdpek1D1bnP5fkGOMA/cHOqTFW40hq4f6GeXy7pDwaygntcHApxZN38Viy0cm3
         PK/4Mmvlhd34aVM93UFvItTzhfq80P+mt6/kQ=
From: Francis Moreau <francis.moro@gmail.com>
To: Reid Kleckner <reid.kleckner@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.eqFHAk86WhpTuYclHhngn7QZr8Y@ifi.uio.no>
	<fa.X++YRAJg+rmPtm3nmroZZoNU7u8@ifi.uio.no>
	<fa.Elk8wOfBHRdKtkHIjP9hOtzVCgQ@ifi.uio.no>
	<fa.U3fdWUGXguguIIyQ4v66/uKOhus@ifi.uio.no>
	<fa.YTQQoGhoS6d3BaZXcZMN+l9TojQ@ifi.uio.no>
Date: Thu, 04 Nov 2010 21:58:32 +0100
In-Reply-To: <fa.YTQQoGhoS6d3BaZXcZMN+l9TojQ@ifi.uio.no> (Francis Moreau's
	message of "Thu, 04 Nov 2010 08:46:09 UTC")
Message-ID: <m24obwst53.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Francis Moreau <francis.moro@gmail.com> writes:

> Francis Moreau <francis.moro@gmail.com> writes:
>

[...]

>>
>> How could I know the number of cache level on my cpu ?
>>
>> I tried:
>>
>>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>>
>>     Performance counter stats for 'true':
>>
>>                    802  cache-misses
>>                    937  L1-dcache-load-misses
>>
>>            0.000996578  seconds time elapsed
>>
>>   $ perf stat -e cache-misses:u,L2-loads-misses:u true
>>
>>    Performance counter stats for 'true':
>>
>>                   788  cache-misses
>>                    95  LLC-load-misses
>>
>>           0.001025423  seconds time elapsed
>>
>> So it looks like you're right: in my case I have this cache
>> configuration:
>>
>
> oops sorry, I replied too early...
>
> so my cache configuration is:
>
>    L1 -> L2 -> LLC
>
> where L2 misses is given by: 'cache-misses' - 'LLC-load-misses'
>
> Is that correct ?
>
> If so, I found 'cache-misses' term very not intuitive IMHO, probably
> because I'm not an expert in cpu caches...

Well thinking more about it, the above is wrong and I'm lost.

If 'cache-misses' is the last level cache misses then how to interpret
these results ?

  $ perf stat -e llc-load-misses:u,llc-store-misses:u true

   Performance counter stats for 'true':

                   94  LLC-load-misses         
                    0  LLC-store-misses        

          0.000981840  seconds time elapsed


  $ perf stat -e cache-misses:u true

   Performance counter stats for 'true':

                  796  cache-misses            

          0.001345136  seconds time elapsed

Here 'cache-misses' value is much more than llc misses one...

-- 
Francis

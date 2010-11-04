Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752556Ab0KDIeV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Nov 2010 04:34:21 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47632 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab0KDIeT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Nov 2010 04:34:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type:content-transfer-encoding;
        b=WvuZwZqkleVH8K2IHLNvF9zCIXLcZmVNLkBCDuA2/Gr9LLyr8XK4Qj9ld1fVGKcrYD
         jpDLrdsaB83kYTbBFvSfHb6Qj56j5BbGj5lHIk3Kq0OP4XaShWp56HB5BDPbaq1CLWeP
         wt94t2r+3Ys5Z9PXHkOPOft4mMN90HTeY+VSg=
From: Francis Moreau <francis.moro@gmail.com>
To: Reid Kleckner <reid.kleckner@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Subject: Re: perf tools miscellaneous questions
References: <fa.yHA7Aw03llqLWxPVYRnHvK5/dT8@ifi.uio.no>
	<fa.13KEqWk+Dk+jLLdFlAoZtQ2Vjuw@ifi.uio.no>
	<fa.AGo9lmnVDcmFVUpOFG/kfd1aYfI@ifi.uio.no>
Date: Thu, 04 Nov 2010 09:34:04 +0100
In-Reply-To: <fa.AGo9lmnVDcmFVUpOFG/kfd1aYfI@ifi.uio.no> (Reid Kleckner's
	message of "Wed, 03 Nov 2010 22:15:39 UTC")
Message-ID: <m2tyjxsd1f.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Reid Kleckner <reid.kleckner@gmail.com> writes:

> On Wed, Nov 3, 2010 at 5:43 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>>> What's exactly the 'cache-misses' event ? does it include both instructions
>>> _and_ data cache misses ? both L1 and L2 caches ?
>>>
>
>>> I was expecting so but the following command makes me wondering:
>>>
>>>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>>>     Performance counter stats for 'true':
>>>
>>>                 763  cache-misses
>>>                 874  L1-dcache-load-misses
>>>
>>>         0.000916609  seconds time elapsed
>>>
>>> Here cache-misses < L1-dcache-load-misses.
>>
>>
>>
>> Dunno, will let others answer.
>
> I think it corresponds to last level cache misses, which makes sense
> here.  The difference in the two numbers represents hits to L2 (and L3
> if it exists).

How could I know the number of cache level on my cpu ?

I tried:

  $ perf stat -e cache-misses:u,l1d-loads-misses:u true

    Performance counter stats for 'true':

                   802  cache-misses
                   937  L1-dcache-load-misses

           0.000996578  seconds time elapsed

  $ perf stat -e cache-misses:u,L2-loads-misses:u true

   Performance counter stats for 'true':

                  788  cache-misses
                   95  LLC-load-misses

          0.001025423  seconds time elapsed

So it looks like you're right: in my case I have this cache
configuration:










--
Francis

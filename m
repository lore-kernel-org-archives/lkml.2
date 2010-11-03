Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753094Ab0KCWPf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:15:35 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:38464 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752186Ab0KCWPc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:15:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=RW0Xyk7VpDRv37RG/j7Zg+ffF7D5C0hHMA4fLVe88QEhf5zXjYtHPz1J5v85xbSFY0
         pNVK395K5CMdg1mfE8jWzglls0XzhkL3Q/fSUsOQeWy3879m7SsqPwE7PqmU7DMzo+QT
         jN1EvVpAie0hg3s2ASFIzLM1/DrnqQFaQCurk=
MIME-Version: 1.0
In-Reply-To: <20101103214308.GA5421@nowhere>
References: <m2eib2uryc.fsf@gmail.com> <20101103214308.GA5421@nowhere>
From: Reid Kleckner <reid.kleckner@gmail.com>
Date: Wed, 3 Nov 2010 18:15:10 -0400
Message-ID: <AANLkTikpFW_fqc6nTMspwBGZRMe1PMWVFD+aRQAab0LF@mail.gmail.com>
Subject: Re: perf tools miscellaneous questions
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Francis Moreau <francis.moro@gmail.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        linux-perf-users@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 5:43 PM, Frederic Weisbecker <fweisbec@gmail.com> wrote:
>> What's exactly the 'cache-misses' event ? does it include both instructions
>> _and_ data cache misses ? both L1 and L2 caches ?
>>
>> I was expecting so but the following command makes me wondering:
>>
>>   $ perf stat -e cache-misses:u,l1d-loads-misses:u true
>>     Performance counter stats for 'true':
>>
>>                 763  cache-misses
>>                 874  L1-dcache-load-misses
>>
>>         0.000916609  seconds time elapsed
>>
>> Here cache-misses < L1-dcache-load-misses.
>
>
>
> Dunno, will let others answer.

I think it corresponds to last level cache misses, which makes sense
here.  The difference in the two numbers represents hits to L2 (and L3
if it exists).

Reid

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751998Ab1IZInz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 04:43:55 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:46494 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751467Ab1IZIny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 04:43:54 -0400
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <1317021659.9084.51.camel@twins>
References: <1316940890-24138-1-git-send-email-gilad@benyossef.com>
	<1317021659.9084.51.camel@twins>
Date: Mon, 26 Sep 2011 11:43:54 +0300
Message-ID: <CAOtvUMeBRv4OO9DcYJgj07_MnbfL4jT24D2YQfQN8Srj4CEzzg@mail.gmail.com>
Subject: Re: [PATCH 0/5] Reduce cross CPU IPI interference
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Chris Metcalf <cmetcalf@tilera.com>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 26, 2011 at 10:20 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Sun, 2011-09-25 at 11:54 +0300, Gilad Ben-Yossef wrote:
>> This first version creates an on_each_cpu_mask infrastructure API
>
> But we already have the existing smp_call_function_many() doing that.

I might be wrong but my understanding is that smp_call_function_many()
does not invoke the IPI handler on the current processor. The original
code I replaced uses on_each_cpu() which does, so I figured a wrapper
was in order and then I discovered the same wrapper in arch specific
code.

> The on_each_cpu() thing is mostly a hysterical relic and could be
> completely depricated

Wont this require each caller to call smp_call_function_* and then
check to see if it needs to also invoke the IPI handler locally ? I
thought that was the reason for on_each_cpu existence... What have I
missed?

Thanks,
Gilad





-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"I've seen things you people wouldn't believe. Goto statements used to
implement co-routines. I watched C structures being stored in
registers. All those moments will be lost in time... like tears in
rain... Time to die. "

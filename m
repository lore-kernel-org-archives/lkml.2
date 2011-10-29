Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933426Ab1J2P3n (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 11:29:43 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:51478 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932944Ab1J2P3m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 11:29:42 -0400
MIME-Version: 1.0
X-Originating-IP: [89.138.18.247]
In-Reply-To: <4EAAD351.70805@redhat.com>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	<1319385413-29665-5-git-send-email-gilad@benyossef.com>
	<4EAAD351.70805@redhat.com>
Date: Sat, 29 Oct 2011 17:29:41 +0200
Message-ID: <CAOtvUMd8Z_jbs__+cVG2+ZkPZLqGkJGym402RMRYGDDjT73bkg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Rik van Riel <riel@redhat.com>
Cc: linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Christoph Lameter <cl@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 28, 2011 at 6:07 PM, Rik van Riel <riel@redhat.com> wrote:
> On 10/23/2011 11:56 AM, Gilad Ben-Yossef wrote:
>>
>> Use a cpumask to track CPUs with per-cpu pages in any zone
>> and only send an IPI requesting CPUs to drain these pages
>> to the buddy allocator if they actually have pages.
>
>> +/* Which CPUs have per cpu pages  */
>> +cpumask_var_t cpus_with_pcp;
>> +static DEFINE_PER_CPU(unsigned long, total_cpu_pcp_count);
>
> Does the flushing happen so frequently that it is worth keeping this
> state on a per-cpu basis, or would it be better to check each CPU's
> pcp info and assemble a cpumask at flush time like done in patch 5?
>

No, I don't  believe it is frequent at all. I will try to re-work the
patch as suggested.

Thanks,
Gilad

>

>
> --
> All rights reversed
>



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

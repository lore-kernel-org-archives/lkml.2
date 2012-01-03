Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754712Ab2ACTAU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 14:00:20 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:39331 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754497Ab2ACTAS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 14:00:18 -0500
MIME-Version: 1.0
X-Originating-IP: [89.138.10.219]
In-Reply-To: <4F033F44.6020403@gmail.com>
References: <1325499859-2262-1-git-send-email-gilad@benyossef.com>
	<1325499859-2262-9-git-send-email-gilad@benyossef.com>
	<4F033F44.6020403@gmail.com>
Date: Tue, 3 Jan 2012 21:00:17 +0200
Message-ID: <CAOtvUMc259XZ5BdOqys3Kbv_u=Qa0matnuFyGrJhMPLtRKKkUA@mail.gmail.com>
Subject: Re: [PATCH v5 8/8] mm: add vmstat counters for tracking PCP drains
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christoph Lameter <cl@linux.com>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Mel Gorman <mel@csn.ul.ie>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>, Avi Kivity <avi@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/3 KOSAKI Motohiro <kosaki.motohiro@gmail.com>:
> (1/2/12 5:24 AM), Gilad Ben-Yossef wrote:
>> This patch introduces two new vmstat counters: pcp_global_drain
>> that counts the number of times a per-cpu pages global drain was
>> requested and pcp_global_ipi_saved that counts the number of times
>> the number of CPUs with per-cpu pages in any zone were less then
>> 1/2 of the number of online CPUs.
>>
>> The patch purpose is to show the usefulness of only sending an IPI
>> asking to drain per-cpu pages to CPUs that actually have them
>> instead of a blind global IPI. It is probably not useful by itself.
...

             }
>>       on_each_cpu_mask(cpus_with_pcps, drain_local_pages, NULL, 1);
>> +
>> +     count_vm_event(PCP_GLOBAL_DRAIN);
>> +     if (cpumask_weight(cpus_with_pcps)<  (cpumask_weight(cpu_online_mask) / 2))
>> +             count_vm_event(PCP_GLOBAL_IPI_SAVED);
>
> NAK.
>
> PCP_GLOBAL_IPI_SAVED is only useful at development phase. I can't
> imagine normal admins use it.

As the description explains, the purpose of the patch is to show why i
claim the previous
patch is useful. I did not meant it to be applied to mainline. My
apologies for not
stating this more clearly. I agree it is not useful for an admin,
although perhaps PCP_GLOBAL_DRAIN
alone might - I am not sure?

Gilad



-- 
Gilad Ben-Yossef
Chief Coffee Drinker
gilad@benyossef.com
Israel Cell: +972-52-8260388
US Cell: +1-973-8260388
http://benyossef.com

"Unfortunately, cache misses are an equal opportunity pain provider."
-- Mike Galbraith, LKML

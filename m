Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758931Ab0LNKXV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Dec 2010 05:23:21 -0500
Received: from mail-fx0-f43.google.com ([209.85.161.43]:63643 "EHLO
	mail-fx0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754875Ab0LNKXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Dec 2010 05:23:19 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:from:to:cc:subject:references:x-face:face:x-url:x-pgp-fp
         :x-pgp:date:in-reply-to:message-id:user-agent:mime-version
         :content-type;
        b=PNAv42NIYDxwGvvJ3FR2ORLwQ7HLDUpuEAXRRzUfixWXJzK2nX/fRvKrkC0gE47j1n
         ya/iyQAitNRj6ZEdBrrLM5AdAxc/J8662cKP64XjUosknlaOw442wmes87ndfcJGfV1l
         SvEd5BZyrVgxSeNNpMShO3tPvZROKB4NdrGMo=
From: Michal Nazarewicz <mina86@mina86.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Michal Nazarewicz <m.nazarewicz@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ankita Garg <ankita@in.ibm.com>, BooJin Kim <boojin.kim@samsung.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mel@csn.ul.ie>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-mm@kvack.org,
        Kyungmin Park <kyungmin.park@samsung.com>
Subject: Re: [PATCHv7 08/10] mm: cma: Contiguous Memory Allocator added
References: <cover.1292004520.git.m.nazarewicz@samsung.com>
	<fc8aa07ac71d554ba10af4943fdb05197c681fa2.1292004520.git.m.nazarewicz@samsung.com>
	<20101214102401.37bf812d.kamezawa.hiroyu@jp.fujitsu.com>
X-Face: PbkBB1w#)bOqd`iCe"Ds{e+!C7`pkC9a|f)Qo^BMQvy\q5x3?vDQJeN(DS?|-^$uMti[3D*#^_Ts"pU$jBQLq~Ud6iNwAw_r_o_4]|JO?]}P_}Nc&"p#D(ZgUb4uCNPe7~a[DbPG0T~!&c.y$Ur,=N4RT>]dNpd;KFrfMCylc}gc??'U2j,!8%xdD
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAJFBMVEWbfGlUPDDHgE57V0jUupKjgIObY0PLrom9mH4dFRK4gmjPs41MxjOgAAACQElEQVQ4jW3TMWvbQBQHcBk1xE6WyALX1069oZBMlq+ouUwpEQQ6uRjttkWP4CmBgGM0BQLBdPFZYPsyFUo6uEtKDQ7oy/U96XR2Ux8ehH/89Z6enqxBcS7Lg81jmSuujrfCZcLI/TYYvbGj+jbgFpHJ/bqQAUISj8iLyu4LuFHJTosxsucO4jSDNE0Hq3hwK/ceQ5sx97b8LcUDsILfk+ovHkOIsMbBfg43VuQ5Ln9YAGCkUdKJoXR9EclFBhixy3EGVz1K6eEkhxCAkeMMnqoAhAKwhoUJkDrCqvbecaYINlFKSRS1i12VKH1XpUd4qxL876EkMcDvHj3s5RBajHHMlA5iK32e0C7VgG0RlzFPvoYHZLRmAC0BmNcBruhkE0KsMsbEc62ZwUJDxWUdMsMhVqovoT96i/DnX/ASvz/6hbCabELLk/6FF/8PNpPCGqcZTGFcBhhAaZZDbQPaAB3+KrWWy2XgbYDNIinkdWAFcCpraDE/knwe5DBqGmgzESl1p2E4MWAz0VUPgYYzmfWb9yS4vCvgsxJriNTHoIBz5YteBvg+VGISQWUqhMiByPIPpygeDBE6elD973xWwKkEiHZAHKjhuPsFnBuArrzxtakRcISv+XMIPl4aGBUJm8Emk7qBYU8IlgNEIpiJhk/No24jHwkKTFHDWfPniR4iw5vJaw2nzSjfq2zffcE/GDjRC2dn0J0XwPAbDL84TvaFCJEU4Oml9pRyEUhR3Cl2t01AoEjRbs0sYugp14/4X5n4pU4EHHnMAAAAAElFTkSuQmCC
X-Url: http://mina86.com/
X-PGP-FP: 9134 06FA 7AD8 D134 9D0C  C33F 532C CB00 B7C6 DF1E
X-PGP: B7C6DF1E
Date: Tue, 14 Dec 2010 11:23:15 +0100
In-Reply-To: <20101214102401.37bf812d.kamezawa.hiroyu@jp.fujitsu.com>
	(KAMEZAWA Hiroyuki's message of "Tue, 14 Dec 2010 10:24:01 +0900")
Message-ID: <87zks8fyb0.fsf@erwin.mina86.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/24.0 (Slckware Linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, 13 Dec 2010 12:26:49 +0100
> Michal Nazarewicz <m.nazarewicz@samsung.com> wrote:
>> +/************************* Initialise CMA *************************/
>> +
>> +static struct cma_grabbed {
>> +	unsigned long start;
>> +	unsigned long size;
>> +} cma_grabbed[8] __initdata;
>> +static unsigned cma_grabbed_count __initdata;
>> +
>> +int cma_init(unsigned long start, unsigned long size)
>> +{
>> +	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
>> +
>> +	if (!size)
>> +		return -EINVAL;
>> +	if ((start | size) & ((MAX_ORDER_NR_PAGES << PAGE_SHIFT) - 1))
>> +		return -EINVAL;
>> +	if (start + size < start)
>> +		return -EOVERFLOW;
>> +
>> +	if (cma_grabbed_count == ARRAY_SIZE(cma_grabbed))
>> +		return -ENOSPC;
>> +
>> +	cma_grabbed[cma_grabbed_count].start = start;
>> +	cma_grabbed[cma_grabbed_count].size  = size;
>> +	++cma_grabbed_count;
>> +	return 0;
>> +}
>> +

KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> Is it guaranteed that there are no memory holes, or zone overlap
> in the range ? I think correctness of the range must be checked.

I keep thinking about it myself.  The idea is that you get memory range
reserved using memblock (or some such) thus it should not contain any
memory holes.  I'm not entirely sure about spanning different zones.
I'll add the checking code.

>> +#define MIGRATION_RETRY	5
>> +static int __cm_migrate(unsigned long start, unsigned long end)
>> +{
[...]
>> +}
>> +
>> +static int __cm_alloc(unsigned long start, unsigned long size)
>> +{
>> +	unsigned long end, _start, _end;
>> +	int ret;
>> +
[...]
>> +
>> +	start = phys_to_pfn(start);
>> +	end   = start + (size >> PAGE_SHIFT);
>> +
>> +	pr_debug("\tisolate range(%lx, %lx)\n",
>> +		 pfn_to_maxpage(start), pfn_to_maxpage_up(end));
>> +	ret = __start_isolate_page_range(pfn_to_maxpage(start),
>> +					 pfn_to_maxpage_up(end), MIGRATE_CMA);
>> +	if (ret)
>> +		goto done;
>> +
>> +	pr_debug("\tmigrate range(%lx, %lx)\n", start, end);
>> +	ret = __cm_migrate(start, end);
>> +	if (ret)
>> +		goto done;
>> +
[...]
>> +
>> +	pr_debug("\tfinding buddy\n");
>> +	ret = 0;
>> +	while (!PageBuddy(pfn_to_page(start & (~0UL << ret))))
>> +		if (WARN_ON(++ret >= MAX_ORDER))
>> +			return -EINVAL;
>> +
>> +	_start = start & (~0UL << ret);
>> +	pr_debug("\talloc freed(%lx, %lx)\n", _start, end);
>> +	_end   = alloc_contig_freed_pages(_start, end, 0);
>> +
>> +	/* Free head and tail (if any) */
>> +	pr_debug("\tfree contig(%lx, %lx)\n", _start, start);
>> +	free_contig_pages(pfn_to_page(_start), start - _start);
>> +	pr_debug("\tfree contig(%lx, %lx)\n", end, _end);
>> +	free_contig_pages(pfn_to_page(end), _end - end);
>> +
>> +	ret = 0;
>> +
>> +done:
>> +	pr_debug("\tundo isolate range(%lx, %lx)\n",
>> +		 pfn_to_maxpage(start), pfn_to_maxpage_up(end));
>> +	__undo_isolate_page_range(pfn_to_maxpage(start),
>> +				  pfn_to_maxpage_up(end), MIGRATE_CMA);
>> +
>> +	pr_debug("ret = %d\n", ret);
>> +	return ret;
>> +}
>> +
>> +static void __cm_free(unsigned long start, unsigned long size)
>> +{
>> +	pr_debug("%s(%p+%p)\n", __func__, (void *)start, (void *)size);
>> +
>> +	free_contig_pages(pfn_to_page(phys_to_pfn(start)),
>> +			  size >> PAGE_SHIFT);
>> +}

> Hmm, it seems __cm_alloc() and __cm_migrate() has no special codes for CMA.
> I'd like reuse this for my own contig page allocator.
> So, could you make these function be more generic (name) ?
> as
> 	__alloc_range(start, size, mirate_type);
>
> Then, what I have to do is only to add "search range" functions.

Sure thing.  I'll post it tomorrow or Friday. How about
alloc_contig_range() maybe?

-- 
Pozdrawiam                                            _     _
 .o. | Wasal Jasnie Oswieconej Pani Informatyki     o' \,=./ `o
 ..o | Michal "mina86" Nazarewicz  <mina86*tlen.pl>    (o o)
 ooo +---<jid:mina86-jabber.org>---<tlen:mina86>---ooO--(_)--Ooo--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933612Ab1KJID3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 03:03:29 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53696 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755136Ab1KJID2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 03:03:28 -0500
MIME-Version: 1.0
X-Originating-IP: [212.179.42.66]
In-Reply-To: <alpine.DEB.2.00.1111020352210.23788@router.home>
References: <1319385413-29665-1-git-send-email-gilad@benyossef.com>
	<1319385413-29665-5-git-send-email-gilad@benyossef.com>
	<4EAAD351.70805@redhat.com>
	<CAOtvUMd8Z_jbs__+cVG2+ZkPZLqGkJGym402RMRYGDDjT73bkg@mail.gmail.com>
	<alpine.DEB.2.00.1111020352210.23788@router.home>
Date: Thu, 10 Nov 2011 10:03:27 +0200
Message-ID: <CAOtvUMd7asdth2nhWdO_ZriFSOcM75F0YmgwtGmtXgp1XrMGzg@mail.gmail.com>
Subject: Re: [PATCH v2 4/6] mm: Only IPI CPUs to drain local pages if they exist
From: Gilad Ben-Yossef <gilad@benyossef.com>
To: Christoph Lameter <cl@gentwo.org>
Cc: Rik van Riel <riel@redhat.com>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-mm@kvack.org,
        Pekka Enberg <penberg@kernel.org>, Matt Mackall <mpm@selenic.com>,
        Sasha Levin <levinsasha928@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 2, 2011 at 10:53 AM, Christoph Lameter <cl@gentwo.org> wrote:
> On Sat, 29 Oct 2011, Gilad Ben-Yossef wrote:
>
>> >> +/* Which CPUs have per cpu pages  */
>> >> +cpumask_var_t cpus_with_pcp;
>> >> +static DEFINE_PER_CPU(unsigned long, total_cpu_pcp_count);
>> >
>> > Does the flushing happen so frequently that it is worth keeping this
>> > state on a per-cpu basis, or would it be better to check each CPU's
>> > pcp info and assemble a cpumask at flush time like done in patch 5?
>> >
>>
>> No, I don't  believe it is frequent at all. I will try to re-work the
>> patch as suggested.
>
> The draining of the pcp pages is done from the vmstat callback which
> occurs every second. Only if there is something to clean in the caches
> will the flush happen.
>

Right,  I wasn't accurate with my answer - I meant to say that the code to IPI
all CPUs asking to flush their pcp pages is infrequent, so doing more
work in that
code path is not unthinkable. Thanks for pointing it out.

As Christoph pointed out flushing on each CPU is also done by the  vmstat
workqueue every second, in addition to the IPI path.

Since the changes I need wish to do involve the code that sends the IPI and not
the flush code itself, I believe it is correct to say it is not a
frequent activity.

Having said that, trying to come up with a way with avoiding waking up each CPU
once per second to do the vmstat work is also on my todo list, but
this is another
patch and another story altogether... :-)

Thanks!
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

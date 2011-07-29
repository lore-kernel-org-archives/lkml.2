Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754645Ab1G2AaX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 20:30:23 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:33881 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752603Ab1G2AaV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 20:30:21 -0400
Message-ID: <4E31FEB3.4060708@bx.jp.nec.com>
Date: Thu, 28 Jul 2011 20:28:35 -0400
From: Keiichi KII <k-keiichi@bx.jp.nec.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110621 Fedora/3.1.11-1.fc14 Thunderbird/3.1.11
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Wu Fengguang <fengguang.wu@intel.com>, Mel Gorman <mel@csn.ul.ie>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Tom Zanussi <tzanussi@gmail.com>, "riel@redhat.com" <riel@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Fr??d??ric Weisbecker <fweisbec@gmail.com>,
        "BA, Moussa" <Moussa.BA@numonyx.com>
Subject: Re: [RFC PATCH -tip 0/5] perf tools: pagecache monitoring
References: <4E24A61D.4060702@bx.jp.nec.com> <20110721070129.GA9216@elte.hu>
In-Reply-To: <20110721070129.GA9216@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> My patches are based on the latest "linux-tip.git" tree and
>> also the following 3 commits in "tip:tracing/mm" and a "pagecache
>> object collections" patch. 
>>
>>   - dcac8cd: tracing/mm: add page frame snapshot trace
>>   - 1487a7a: tracing/mm: fix mapcount trace record field
>>   - eb46710: tracing/mm: rename 'trigger' file to 'dump_range'
>>   - http://lkml.org/lkml/2010/2/9/156
>>
>> Any comments are welcome.
> 
> I totally like the approach you have taken here.
> 
> Note that tracepoints need a detailed, careful review from interested 
> mm folks.
> 
> The set of tracepoints does not have to be complete but the 
> tracepoints have to be well thought out and near-perfect in this 
> context they are instrumenting, with an eye on future extensions with 
> the goal of making them painless.
> 
> the pagecache tracepoints you have added are:
> 
>  include/trace/events/filemap.h |   75 ++++++++++++++++++++++++++++++++++++++++
>  mm/filemap.c                   |    4 ++
>  mm/truncate.c                  |    2 +
>  mm/vmscan.c                    |    2 +
>  4 files changed, 83 insertions(+), 0 deletions(-)
> 
> So once such kind of review has been iterated through and Andrew et 
> al is happy with it i'd be more than happy to dust off the tracing/mm 
> bits (which have been done two years ago) and get it all to Linus.
> 
> Andrew, Mel, Fengguang?

Thank you for your comments. 
And I agree the tracepoints need reviews from mm folks.
I think the patches in tracing/mm are useful for monitoring mm behavior.
Is there any comments for these patches(especially the tracepoints)?
Any comments are welcome.

Thanks,
Keiichi

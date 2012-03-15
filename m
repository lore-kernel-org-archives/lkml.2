Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1032111Ab2CORlk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Mar 2012 13:41:40 -0400
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:50912 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1032086Ab2CORlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Mar 2012 13:41:36 -0400
Message-ID: <4F6229B7.2060702@fb.com>
Date: Thu, 15 Mar 2012 10:41:11 -0700
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Namhyung Kim <namhyung.kim@lge.com>, <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, <linux-perf-users@vger.kernel.org>
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com> <4F5DA91F.7060908@lge.com> <4F5E3E8C.1020005@fb.com> <4F5E554C.4060209@fb.com> <4F5EA49F.7020706@lge.com> <20120315145033.GB550@somewhere.redhat.com>
In-Reply-To: <20120315145033.GB550@somewhere.redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-03-15_04:2012-03-15,2012-03-14,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/15/12 7:50 AM, Frederic Weisbecker wrote:

>> AFAIK, "sort" here means how perf identifies a sample event from
>> others: "comm" will collect samples have same pid/comm, then "dso"
>> will group samples belong to same library, and "symbol" will group
>> again samples have same symbol name. This is what default sort order
>> (comm,dso,symbol) does.
>
> Right this is about how we group the events into histograms.
> If you sort by dso, you'll have one histogram per dso and events
> will be added to the histogram matching their dso.
>
> Multiple sorting does the same with an "AND" between sort entries.
> If you sort by dso,pid, you'll have one histogram per possible couple
> of (dso,pid).
>
> Say you have dso1, dso2 and pid1 and pid2, then you get 4 possible histograms:
> (dso1,pid1), (dso1,pid2), (dso2,pid1), (dso2,pid2)
> ...assuming that over your events you have all these combinations.
>
> So this is how we group samples into histograms.

Agreed. It's a different sort order, but not necessarily a different 
sort dimension. I'm thinking "group by" vs "order by" in SQL here.

Re: adding a new top level flag, struct option options[] in 
builtin-report.c looks busy (especially for short options. Eg: -i is 
already taken).

I can see parallels between this and sort__branch_mode. Stephane: what 
do you think about putting this in a different namespace?

--sort-mode branch (sort__branch_mode)
--sort-mode inclusive (sort__inclusive_mode)

  -Arun

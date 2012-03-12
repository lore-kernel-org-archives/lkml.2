Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720Ab2CLHnh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 03:43:37 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:59368 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751882Ab2CLHnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 03:43:31 -0400
X-AuditID: 9c93016f-b7c68ae000000b77-f0-4f5da920d9e0
Message-ID: <4F5DA91F.7060908@lge.com>
Date: Mon, 12 Mar 2012 16:43:27 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel,gmane.linux.kernel.perf.user
To: Arun Sharma <asharma@fb.com>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Tom Zanussi <tzanussi@gmail.com>, linux-perf-users@vger.kernel.org
Subject: Re: [PATCH 0/2] perf: add sort by inclusive time functionality (v2)
References: <1331160079-13821-1-git-send-email-asharma@fb.com>
In-Reply-To: <1331160079-13821-1-git-send-email-asharma@fb.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2012-03-08 7:41 AM, Arun Sharma wrote:
> This patch series refactors existing code a bit and adds sort by
> inclusive time (time spent in the function + callees).
>
> Sample command lines:
>
> # perf record -ag -- sleep 1
> # perf report -g graph,0.5,callee -n -s inclusive
>
> Known bugs:
>
> total_period computation is broken for order=callee
>

I'd like to add two more :).

* If perf record misses callchain info, perf report will get stuck.
* If it's used with "symbol" sort order, it'll get stuck too.


BTW, I don't like the name 'inclusive' as a sort key. If it cares about time, 
IMHO, the name should contain 'time' - something like 'itime' or 'inctime'?

Furthermore, I don't think it is a sort key. As it doesn't sort anything,  and 
only affects the way calculating symbol's period value, wouldn't it be better 
making it a separate switch rather than a sort key? Plus, checking whether it 
has callchain data and symbol sort key might be added also.

Thanks,
Namhyung

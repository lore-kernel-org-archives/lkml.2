Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754158Ab0KCLm3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 07:42:29 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13669 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752877Ab0KCLm1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 07:42:27 -0400
Message-ID: <4CD14A6F.4010109@redhat.com>
Date: Wed, 03 Nov 2010 07:41:35 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Lightning/1.0b2pre Thunderbird/3.1.2
MIME-Version: 1.0
To: Minchan Kim <minchan.kim@gmail.com>
CC: Mandeep Singh Baines <msb@chromium.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        Johannes Weiner <hannes@cmpxchg.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, wad@chromium.org, olofj@chromium.org,
        hughd@chromium.org
Subject: Re: [PATCH] RFC: vmscan: add min_filelist_kbytes sysctl for protecting
 the working set
References: <20101028191523.GA14972@google.com>	<20101101012322.605C.A69D9226@jp.fujitsu.com>	<20101101182416.GB31189@google.com>	<4CCF0BE3.2090700@redhat.com>	<AANLkTi=src1L0gAFsogzCmejGOgg5uh=9O4Uw+ZmfBg4@mail.gmail.com>	<4CCF8151.3010202@redhat.com>	<AANLkTi=JJ-0ae+QybtR+e=4_4mpQghh61c4=TZYAw8uF@mail.gmail.com>	<4CD0C22B.2000905@redhat.com> <AANLkTik8y=bh3dBJe0bFmjAUvc7y8yBpjP4DKuKU+Z2j@mail.gmail.com>
In-Reply-To: <AANLkTik8y=bh3dBJe0bFmjAUvc7y8yBpjP4DKuKU+Z2j@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/02/2010 11:03 PM, Minchan Kim wrote:

> It could.
> But time based approach would be same, IMHO.
> First of all, I don't want long latency of direct reclaim process.
> It could affect response of foreground process directly.
>
> If VM limits the number of pages reclaimed per second, direct reclaim
> process's latency will be affected. so we should avoid throttling in
> direct reclaim path. Agree?

The idea would be to not throttle the processes trying to
reclaim page cache pages, but to only reclaim anonymous
pages when the page cache pages are low (and occasionally
a few page cache pages, say 128 a second).

If too many reclaimers come in when the page cache is
low and no swap is available, we will OOM kill instead
of stalling.

After all, the entire point of this patch would be to
avoid minutes-long latencies in triggering the OOM
killer.

-- 
All rights reversed

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755529Ab2AYBpl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jan 2012 20:45:41 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:58352 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754694Ab2AYBpk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jan 2012 20:45:40 -0500
Message-ID: <4F1F5EB8.3000407@fb.com>
Date: Tue, 24 Jan 2012 17:45:28 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:8.0) Gecko/20111105 Thunderbird/8.0
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        Balbir Singh <bsingharora@gmail.com>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <20120119114206.653b88bd.kamezawa.hiroyu@jp.fujitsu.com> <4F1E013E.9060009@fb.com> <20120124120704.3f09b206.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120124120704.3f09b206.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.211,0.0.0000
 definitions=2012-01-25_01:2012-01-24,2012-01-25,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 1/23/12 7:07 PM, KAMEZAWA Hiroyuki wrote:

> You can see reduction of clear_page() cost by removing GFP_ZERO but
> what's your application's total performance ? Is it good enough considering
> many risks ?

I see 90k calls/sec to clear_page_c when running our application. I 
don't have data on the impact of GFP_ZERO alone, but an earlier 
experiment when we tuned malloc to not call madvise(MADV_DONTNEED) 
aggressively saved us 3% CPU. So I'm expecting this to be a 1-2% win.

But not calling madvise() increases our RSS and increases the risk of OOM.

Agree with your analysis that removing the cache misses at clear_page() 
is not always a win, since it moves the misses to the code where the app 
first touches the data.

  -Arun



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755515Ab2LRSxK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 13:53:10 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:44494 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751348Ab2LRSxI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 13:53:08 -0500
X-Greylist: delayed 1018 seconds by postgrey-1.27 at vger.kernel.org; Tue, 18 Dec 2012 13:53:08 EST
Message-ID: <50D0B5A2.2010707@fb.com>
Date: Tue, 18 Dec 2012 10:27:46 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, Michael Kerrisk <mtk.manpages@gmail.com>,
        <sanjay@google.com>, Paul Turner <pjt@google.com>,
        David Rientjes <rientjes@google.com>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KOSAKI Motohiro <kosaki.motohiro@gmail.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [RFC v4 0/3] Support volatile for anonymous range
References: <1355813274-571-1-git-send-email-minchan@kernel.org>
In-Reply-To: <1355813274-571-1-git-send-email-minchan@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.16.4]
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.9.8327,1.0.431,0.0.0000
 definitions=2012-12-18_08:2012-12-18,2012-12-18,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/17/12 10:47 PM, Minchan Kim wrote:

> I hope more inputs from user-space allocator people and test patch
> with their allocator because it might need design change of arena
> management for getting real vaule.

jemalloc knows how to handle MADV_FREE on platforms that support it. 
This looks similar (we'll need a SIGBUS handler that does the right 
thing = zero the page + mark it as non-volatile in the common case).

All of this of course assumes that apps madvise the kernel through APIs 
exposed by the malloc implementation - not via a raw syscall.

In other words, some new user space code needs to be written to test 
this out fully. Sounds feasible though.

  -Arun

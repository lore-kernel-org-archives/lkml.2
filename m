Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933635Ab2KFCif (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 21:38:35 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:49390 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933560Ab2KFCie (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 21:38:34 -0500
X-Greylist: delayed 1869 seconds by postgrey-1.27 at vger.kernel.org; Mon, 05 Nov 2012 21:38:34 EST
Message-ID: <50987004.1000003@fb.com>
Date: Mon, 5 Nov 2012 18:03:48 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Minchan Kim <minchan@kernel.org>
CC: KOSAKI Motohiro <kosaki.motohiro@gmail.com>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        John Stultz <john.stultz@linaro.org>, Christoph Lameter <cl@linux.com>,
        Android Kernel Team <kernel-team@android.com>,
        Robert Love <rlove@google.com>, Mel Gorman <mel@csn.ul.ie>,
        Hugh Dickins <hughd@google.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Dave Chinner <david@fromorbit.com>,
        Neil Brown <neilb@suse.de>, Mike Hommey <mh@glandium.org>,
        Taras Glek <tglek@mozilla.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <sanjay@google.com>, David Rientjes <rientjes@google.com>
Subject: Re: [RFC v2] Support volatile range for anon vma
References: <1351560594-18366-1-git-send-email-minchan@kernel.org> <20121031143524.0509665d.akpm@linux-foundation.org> <CAPM31RKm89s6PaAnfySUD-f+eGdoZP6=9DHy58tx_4Zi8Z9WPQ@mail.gmail.com> <CAHGf_=om34CQoPqgmVE5v8oVxntaJQ-bvFeEPMnfe_R+uvxqrQ@mail.gmail.com> <20121105235443.GA27718@dev3310.snc6.facebook.com> <20121106014932.GA4623@barrios>
In-Reply-To: <20121106014932.GA4623@barrios>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.254]
X-Proofpoint-Spam-Reason: safe
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.7.7855,1.0.431,0.0.0000
 definitions=2012-11-05_06:2012-11-05,2012-11-05,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/5/12 5:49 PM, Minchan Kim wrote:

>> Also, memory allocators have a second motivation in using madvise: to
>> create virtually contiguous regions of memory from a fragmented address
>> space, without increasing the RSS.
>
> I don't get it. How do we create contiguos region by madvise?
> Just out of curiosity.
> Could you elaborate that use case? :)

By using a new anonymous map and faulting pages in.

The fragmented virtual memory is released via MADV_DONTNEED and if the 
malloc/free activity on the system is dominated by one process, chances 
are that the newly faulted in page is the one released by the same 
process :)

The net effect is that physical pages within a single address space are 
rearranged so larger allocations can be satisfied.

  -Arun

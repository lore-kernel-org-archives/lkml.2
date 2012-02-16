Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756817Ab2BPCLP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Feb 2012 21:11:15 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:52046 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754791Ab2BPCLM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Feb 2012 21:11:12 -0500
Message-ID: <4F3C6594.3030709@fb.com>
Date: Wed, 15 Feb 2012 18:10:28 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:9.0) Gecko/20111222 Thunderbird/9.0.1
MIME-Version: 1.0
To: Andrea Righi <andrea@betterlinux.com>
CC: Andrew Morton <akpm@linux-foundation.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Johannes Weiner <jweiner@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Rik van Riel <riel@redhat.com>, Hugh Dickins <hughd@google.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Shaohua Li <shaohua.li@intel.com>,
        =?UTF-8?B?UMOhZHJhaWcgQnJhZHk=?= <P@draigBrady.com>,
        John Stultz <john.stultz@linaro.org>,
        Jerry James <jamesjer@betterlinux.com>,
        Julius Plenz <julius@plenz.com>, linux-mm <linux-mm@kvack.org>,
        <linux-fsdevel@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v5 3/3] fadvise: implement POSIX_FADV_NOREUSE
References: <1329006098-5454-1-git-send-email-andrea@betterlinux.com> <1329006098-5454-4-git-send-email-andrea@betterlinux.com> <20120215233537.GA20724@dev3310.snc6.facebook.com> <20120215234724.GA21685@thinkpad> <4F3C467B.1@fb.com> <20120216005608.GC21685@thinkpad>
In-Reply-To: <20120216005608.GC21685@thinkpad>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7361,1.0.260,0.0.0000
 definitions=2012-02-16_01:2012-02-16,2012-02-16,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/15/12 4:56 PM, Andrea Righi wrote:

> Oh sorry, you're right! nocache_tree is not a pointer inside
> address_space, so the compiler must know the size.
>
> mmh... move the definition of the rb_root struct in linux/types.h? or
> simply use a rb_root pointer. The (void *) looks a bit scary and too bug
> prone.

Either way is fine. I did some black box testing of the patch (comparing 
noreuse vs dontneed) and it behaves as expected.

On a file copy, neither one pollutes the page cache. But if I run a 
random read benchmark on the source file right before and afterwards, 
page cache is warm with noreuse, but cold with dontneed. Copy 
performance was unaffected.

I can't really comment on the implementation details since I haven't 
reviewed it, but the functionality sounds useful.

  -Arun


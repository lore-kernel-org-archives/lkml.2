Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754611Ab2B0Sco (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Feb 2012 13:32:44 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:44672 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754251Ab2B0Scn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Feb 2012 13:32:43 -0500
Message-ID: <4F4BCC4A.1090402@fb.com>
Date: Mon, 27 Feb 2012 10:32:42 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Balbir Singh <bsingharora@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com> <4F468888.9090702@fb.com> <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com> <CAKTCnzk7TgDeYRZK0rCugopq0tO7BtM8jM9U0RJUTqNtz42ZKw@mail.gmail.com> <4F47E0D0.9030409@fb.com> <CAKTCnznyZGLiZPNS151GzsUMApN_SYu3n6xX9E0ceMpq9JNq7w@mail.gmail.com>
In-Reply-To: <CAKTCnznyZGLiZPNS151GzsUMApN_SYu3n6xX9E0ceMpq9JNq7w@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-27_04:2012-02-27,2012-02-27,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/12 8:13 PM, Balbir Singh wrote:
>> A uid based approach such as the one implemented by Davide Libenzi
>>
>> http://thread.gmane.org/gmane.linux.kernel/548928
>> http://thread.gmane.org/gmane.linux.kernel/548926
>>
>> would probably apply the optimization to more use cases - but conceptually a
>> bit more complex. If we go with this more relaxed approach, we'll have to
>> design a race-free cgroup_uid_count() based mechanism.
>
> Are you suggesting all processes with the same UID should have access
> to each others memory contents?

No - that's a stronger statement than the one I made in my last message. 
I'll however observe that something like this is already possible via 
PTRACE_PEEKDATA.

Like I said: a cgroup with a single mm_struct is conceptually cleanest 
and covers some of our heavy use cases. A cgroup with a single uid would 
cover more of our use cases. It'd be good to know if you and other 
maintainers are willing to accept the former, but not the latter.

I'll note that the malloc implementation which uses these interfaces can 
still decide to zero the memory depending on which variant of *alloc is 
called. But then, we'd have more fine grained control and more 
flexibility in terms of temporal usage hints.

  -Arun

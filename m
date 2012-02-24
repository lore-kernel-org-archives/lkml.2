Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757102Ab2BXTLU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:11:20 -0500
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:54675 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753234Ab2BXTLT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:11:19 -0500
Message-ID: <4F47E0D0.9030409@fb.com>
Date: Fri, 24 Feb 2012 11:11:12 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Balbir Singh <bsingharora@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com> <4F468888.9090702@fb.com> <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com> <CAKTCnzk7TgDeYRZK0rCugopq0tO7BtM8jM9U0RJUTqNtz42ZKw@mail.gmail.com>
In-Reply-To: <CAKTCnzk7TgDeYRZK0rCugopq0tO7BtM8jM9U0RJUTqNtz42ZKw@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-24_06:2012-02-24,2012-02-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/24/12 6:51 AM, Balbir Singh wrote:
> On Fri, Feb 24, 2012 at 8:17 AM, KAMEZAWA Hiroyuki
> <kamezawa.hiroyu@jp.fujitsu.com>  wrote:
>>> They don't have access to each other's VMAs, but if "accidentally" one
>>> of them comes across an uninitialized page with data from another task,
>>> it's not a violation of the security model.
>
> Can you expand more on the single address space model?

I haven't thought this through yet. But I know that just adding

&& (cgroup_task_count() == 1)

to page_needs_clearing() is not going to do it. We'll have to design a 
new mechanism (cgroup_mm_count_all()?) and make sure that it doesn't 
race with fork() and inadvertently expose pages from the new address 
space to the existing one.

A uid based approach such as the one implemented by Davide Libenzi

http://thread.gmane.org/gmane.linux.kernel/548928
http://thread.gmane.org/gmane.linux.kernel/548926

would probably apply the optimization to more use cases - but 
conceptually a bit more complex. If we go with this more relaxed 
approach, we'll have to design a race-free cgroup_uid_count() based 
mechanism.

  -Arun



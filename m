Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756630Ab2BWSmb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 13:42:31 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:37577 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752819Ab2BWSma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 13:42:30 -0500
Message-ID: <4F468888.9090702@fb.com>
Date: Thu, 23 Feb 2012 10:42:16 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Balbir Singh <bsingharora@gmail.com>
CC: <linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
In-Reply-To: <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-23_07:2012-02-23,2012-02-23,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Balbir,

Thanks for reviewing. Would you change your position if I limit the 
scope of the patch to a cgroup with a single address space?

The moment the cgroup sees more than one address space (either due to 
tasks getting created or being added), this optimization would be turned 
off.

More details below:

On 2/22/12 11:45 PM, Balbir Singh wrote:
>
> So the assumption is that only apps that have access to each others
> VMA's will run in this cgroup?
>

In a distributed computing environment, a user submits a job to the 
cluster job scheduler. The job might involve multiple related 
executables and might involve multiple address spaces. But they're 
performing one logical task, have a single resource limit enforced by a 
cgroup.

They don't have access to each other's VMAs, but if "accidentally" one 
of them comes across an uninitialized page with data from another task, 
it's not a violation of the security model.

> Sorry, I am not convinced we need to do this
>
> 1. I know that zeroing out memory is expensive, but building a
> potential loop hole is not a good idea
> 2. How do we ensure that tasks in a cgroup should be allowed to reuse
> memory uninitialized, how does the cgroup admin know what she is
> getting into?

I was thinking of addressing this via documentation (as in: don't use 
this if you don't know what you're doing!). But limiting the scope to a 
single address space cgroup seems cleaner to me.

  -Arun

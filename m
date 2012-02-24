Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757091Ab2BXT1I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Feb 2012 14:27:08 -0500
Received: from mx0b-00082601.pphosted.com ([67.231.153.30]:54868 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754135Ab2BXT1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Feb 2012 14:27:07 -0500
Message-ID: <4F47E47B.3000409@fb.com>
Date: Fri, 24 Feb 2012 11:26:51 -0800
From: Arun Sharma <asharma@fb.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
CC: Balbir Singh <bsingharora@gmail.com>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
References: <1326912662-18805-1-git-send-email-asharma@fb.com> <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com> <4F468888.9090702@fb.com> <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20120224114748.720ee79a.kamezawa.hiroyu@jp.fujitsu.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.18.252]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.6.7498,1.0.260,0.0.0000
 definitions=2012-02-24_06:2012-02-24,2012-02-24,1970-01-01 signatures=0
X-Proofpoint-Spam-Reason: safe
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2/23/12 6:47 PM, KAMEZAWA Hiroyuki wrote:
>>
>> In a distributed computing environment, a user submits a job to the
>> cluster job scheduler. The job might involve multiple related
>> executables and might involve multiple address spaces. But they're
>> performing one logical task, have a single resource limit enforced by a
>> cgroup.
>>
>> They don't have access to each other's VMAs, but if "accidentally" one
>> of them comes across an uninitialized page with data from another task,
>> it's not a violation of the security model.
>>
> How do you handle shared resouce, file-cache ?
>

 From a security perspective or a resource limit perspective?

Security: all processes in the cgroup run with the same uid and have the 
same access to the filesystem. Multiple address spaces in a cgroup can 
be thought of as an implementation detail.

Resource limit: We don't have strict enforcement right now. There is a 
desire to include everything (file cache, slab memory) in the job's 
memory resource limit.

  -Arun

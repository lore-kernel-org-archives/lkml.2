Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757743Ab2JSIvX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 04:51:23 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:19877 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753183Ab2JSIvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 04:51:20 -0400
Message-ID: <5081145A.2010307@huawei.com>
Date: Fri, 19 Oct 2012 16:50:34 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Frederic Weisbecker <fweisbec@gmail.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Is not locking task_lock in cgroup_fork() safe?
References: <20121008020000.GB2575@localhost> <CAFTL4hzXWtzp7megsCAEuak5=_2SWmp9age-+wrpyQAU4BRZ0w@mail.gmail.com> <20121016193341.GD16166@google.com> <CAFTL4hzo_w7HTgC9ApTk113X8WdZSpV+D+VSEe=604YEJFmKsg@mail.gmail.com> <20121018200705.GG13370@google.com> <CAFTL4hy7g4e11OUOyoihrEU8hiVgZoV1=141UtUpj9a72SNs_Q@mail.gmail.com> <20121019003835.GE13370@google.com> <20121019005801.GF13370@google.com>
In-Reply-To: <20121019005801.GF13370@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012/10/19 8:58, Tejun Heo wrote:
> Hello, again.
> 
> On Thu, Oct 18, 2012 at 05:38:35PM -0700, Tejun Heo wrote:
>> Even if there isn't an actual race, the comment is dead wrong.  I'm
>> reverting the following three patches.  Let's try again later.
>>
>>   7e381b0eb1 ("cgroup: Drop task_lock(parent) on cgroup_fork()")
>>   7e3aa30ac8 ("cgroup: Remove task_lock() from cgroup_post_fork()")
> 
> So, after some more looking, I think the following is correct and
> doesn't need to be reverted.  It's depending on threadgroup locking
> from migration path to synchronize against exit path which is always
> performed.
> 
>>   c84cdf75cc ("cgroup: Remove unnecessary task_lock before fetching css_set on migration")
> 
> Frederic, were you trying to say that the above commit is correct?
> Li, do you agree?
> 

This one does look innocent.


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752910Ab0ICBE6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Sep 2010 21:04:58 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:59223 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751217Ab0ICBE5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Sep 2010 21:04:57 -0400
Message-ID: <4C804AE8.1090203@cn.fujitsu.com>
Date: Fri, 03 Sep 2010 09:10:00 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1b3pre) Gecko/20090513 Fedora/3.0-2.3.beta2.fc11 Thunderbird/3.0b2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Dave Jones <davej@redhat.com>, netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH] cls_cgroup: Fix rcu lockdep warning
References: <4C7F446F.8040303@cn.fujitsu.com> <1283423916.2059.1847.camel@laptop>
In-Reply-To: <1283423916.2059.1847.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra wrote:
> On Thu, 2010-09-02 at 14:30 +0800, Li Zefan wrote:
>> Calling task_subsys_state() without holding rcu_read_lock or
>> cgroup_mutex can cause lockdep warning.
>>
> 
> That is not a suitable changelog.
> 
> Was the warning correct? Is your patch correct? What does RCU protect
> here and why can we use classid after dropping it.
> 
> Simply frobbing code to make the warning go away is not good.
> 
> 

task->cgroups and task->cgroups->subsys[i] are protected by RCU.
So we avoid accessing invalid pointers here. This can happen,
for example, when you are deref those pointers while someone move
@task from one cgroup to another.

otoh, there is no lock rule for ->classid.

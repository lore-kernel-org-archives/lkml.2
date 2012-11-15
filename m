Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756257Ab2KNTAB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:00:01 -0500
Received: from mx2.parallels.com ([64.131.90.16]:35893 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754842Ab2KNS77 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 13:59:59 -0500
Message-ID: <50A45ABB.3040507@parallels.com>
Date: Thu, 15 Nov 2012 07:00:11 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <mhocko@suse.cz>
Subject: Re: [PATCH 05/17] cgroup: cgroup->dentry isn't a RCU pointer
References: <1352775704-9023-1-git-send-email-tj@kernel.org> <1352775704-9023-6-git-send-email-tj@kernel.org> <50A37B0A.7010608@parallels.com> <20121114185504.GG21185@mtj.dyndns.org>
In-Reply-To: <20121114185504.GG21185@mtj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/14/2012 10:55 PM, Tejun Heo wrote:
> Hello, Glauber.
> 
> On Wed, Nov 14, 2012 at 03:05:46PM +0400, Glauber Costa wrote:
>> Will memcontrol.c need similar amendments?
>>
>> The code that lives in -mm and includes kmemcg includes the following
>> excerpt:
>>
>>         rcu_read_lock();
>>         dentry = rcu_dereference(memcg->css.cgroup->dentry);
>>         rcu_read_unlock();
> 
> Ooh, yeah, hmmm... that should happen after this series gets merged.
> I'll mark it as pending.
> 
> Thanks.
> 
Btw: I did this because there is no other facility to figure out a
memcg's "name".

I wonder if there is anyone else using this, so we could just abstract
that in cgroup.c?


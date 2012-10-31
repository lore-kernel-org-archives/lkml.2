Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab2JaRYZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:24:25 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50402 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754234Ab2JaRYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:24:23 -0400
Message-ID: <50915EB6.3060704@parallels.com>
Date: Wed, 31 Oct 2012 21:24:06 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizefan@huawei.com>, <hannes@cmpxchg.org>, <mhocko@suse.cz>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] cgroup: simplify cgroup removal path
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <50912C6D.6020000@parallels.com> <20121031171849.GH2945@htj.dyndns.org>
In-Reply-To: <20121031171849.GH2945@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 09:18 PM, Tejun Heo wrote:
> Hello,
> 
> On Wed, Oct 31, 2012 at 05:49:33PM +0400, Glauber Costa wrote:
>> The only think that drew my attention is that you are changing the
>> local_irq_save callsite to local_irq_disable. It shouldn't be a problem,
>> since this is never expected to be called in interrupt context.
>>
>> Still... it makes me wonder if that disabled-interrupt block is still
>> needed? According to the changelogs, it was introduced in e7c5ec919 for
>> the css_tryget mechanism. But css_tryget itself will never scan
>> subsystems, so if we can no longer fail, we should be able to just ditch
>> it. Unless I am missing something
> 
> Note both in the commit messages.
> 

I am sorry, but I can't find anything that may be related to this in the
commit messages. Can you be more specific ?



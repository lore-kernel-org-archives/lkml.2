Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759504Ab2JaRo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:44:29 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:39771 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759329Ab2JaRoZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:44:25 -0400
Date: Wed, 31 Oct 2012 10:44:20 -0700
From: Tejun Heo <tj@kernel.org>
To: Glauber Costa <glommer@parallels.com>
Cc: Michal Hocko <mhocko@suse.cz>, lizefan@huawei.com, hannes@cmpxchg.org,
        bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com,
        containers@lists.linux-foundation.org, cgroups@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
Message-ID: <20121031174420.GL2945@htj.dyndns.org>
References: <1351657365-25055-1-git-send-email-tj@kernel.org>
 <1351657365-25055-3-git-send-email-tj@kernel.org>
 <20121031153926.GC22809@dhcp22.suse.cz>
 <20121031165739.GE2945@htj.dyndns.org>
 <50915A87.4070504@parallels.com>
 <CAOS58YP=CjTPFdETLRXnc3gXEzX2=EEe2dMdSh3Eov7zRfV4Qg@mail.gmail.com>
 <50915DB7.5020706@parallels.com>
 <20121031172522.GJ2945@htj.dyndns.org>
 <50916218.3090301@parallels.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50916218.3090301@parallels.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Glauber.

On Wed, Oct 31, 2012 at 09:38:32PM +0400, Glauber Costa wrote:
> Because I am allocating an array big enough to hold one entry per memcg.
> The natural array index for this, is the css_id. Obviously, I don't want
> this array to have 65k entries in size, so I resize it (doubling every
> time) Because I don't know the css_id at this time, I have to do it later.
> 
> Another option for this - which I also considered - would be to use a
> different index. We get more packing, since not all memcgs will be kmem
> limited (and the index would contain only the kmem limited memcgs), and
> we can allocate this index during ->create().
> 
> I initially picked the css_index because I though a specialized index
> might be confusing. But if you feel strongly about all the allocations
> happening inside ->create(), this would be a way to avoid it. Would you
> prefer that?

I'll think more about it.  The whole css_id thing might need some soul
searching too anyway.  Let's continue this one your patch thread.

Thanks.

-- 
tejun

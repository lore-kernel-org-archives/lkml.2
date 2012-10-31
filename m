Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338Ab2JaRGh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 13:06:37 -0400
Received: from mx2.parallels.com ([64.131.90.16]:44842 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754341Ab2JaRGf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 13:06:35 -0400
Message-ID: <50915A87.4070504@parallels.com>
Date: Wed, 31 Oct 2012 21:06:15 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121016 Thunderbird/16.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Michal Hocko <mhocko@suse.cz>, <lizefan@huawei.com>, <hannes@cmpxchg.org>,
        <bsingharora@gmail.com>, <kamezawa.hiroyu@jp.fujitsu.com>,
        <containers@lists.linux-foundation.org>, <cgroups@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/8] cgroup: kill CSS_REMOVED
References: <1351657365-25055-1-git-send-email-tj@kernel.org> <1351657365-25055-3-git-send-email-tj@kernel.org> <20121031153926.GC22809@dhcp22.suse.cz> <20121031165739.GE2945@htj.dyndns.org>
In-Reply-To: <20121031165739.GE2945@htj.dyndns.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [46.39.244.6]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/31/2012 08:57 PM, Tejun Heo wrote:
> I have a patch queued to add ->pre_destroy() - different from
> Glauber's in that it can't fail, so we'll have
> 
> 	->create()
> 		->post_create()
> 		->pre_destroy()
> 	->destroy()
> 
> Where ->create() may fail but none other can. 

This is not the topic of this thread, but since you brought it:
If you take a look at the description patch in the patch I sent, the
problem I outlined is that at create time, we don't know anything about
which will the css_id be - and I would like to avoid creating yet
another index.

Is there any way you would suggest of handling this ? Any chance of us
allocating the css_id earlier then?


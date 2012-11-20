Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753451Ab2KTPKx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 10:10:53 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:51649 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753208Ab2KTPKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 10:10:49 -0500
Message-ID: <50AB9D76.3010809@monom.org>
Date: Tue, 20 Nov 2012 16:10:46 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 7/7] netprio_cgroup: allow nesting and inherit config
 on cgroup creation
References: <1353400211-5182-1-git-send-email-tj@kernel.org> <1353400211-5182-8-git-send-email-tj@kernel.org> <50AB45EA.2050507@monom.org> <20121120144036.GP15971@htj.dyndns.org>
In-Reply-To: <20121120144036.GP15971@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 20.11.2012 15:40, Tejun Heo wrote:
> Hello, Daniel.
>
> On Tue, Nov 20, 2012 at 09:57:14AM +0100, Daniel Wagner wrote:
>>> -static void cgrp_css_free(struct cgroup *cgrp)
>>> +static int cgrp_css_online(struct cgroup *cgrp)
>>>   {
>>> -	struct cgroup_netprio_state *cs = cgrp_netprio_state(cgrp);
>>> +	struct cgroup *parent = cgrp->parent;
>>>   	struct net_device *dev;
>>> +	int ret = 0;
>>> +
>>> +	if (!parent)
>>> +		return 0;
>>
>> BTW, parent is always != NULL, because the root cgroup will be
>> attached to the dummytop cgroup.
>
> Hmmm?  I'm confused.  When ->css_online() is called for dummytop in
> cgroup_init_subsys(), its parent is NULL.  What am I missing?

Forget my comment, I was really confused when writing this. I was 
looking only at cgroups which were created after bootup.

cheers,
daniel


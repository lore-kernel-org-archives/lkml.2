Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754318Ab2KSTRm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 14:17:42 -0500
Received: from hotel311.server4you.de ([85.25.146.15]:50574 "EHLO
	hotel311.server4you.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754009Ab2KSTRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 14:17:41 -0500
Message-ID: <50AA85D3.7070000@monom.org>
Date: Mon, 19 Nov 2012 20:17:39 +0100
From: Daniel Wagner <wagi@monom.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: serge.hallyn@canonical.com, ebiederm@xmission.com, nhorman@tuxdriver.com,
        tgraf@suug.ch, davem@davemloft.net, lizefan@huawei.com,
        cgroups@vger.kernel.org, containers@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] netcls_cgroup: implement proper hierarchy support
References: <1353123062-23193-1-git-send-email-tj@kernel.org> <1353123062-23193-4-git-send-email-tj@kernel.org> <50AA385A.90503@monom.org> <20121119170859.GI15971@htj.dyndns.org>
In-Reply-To: <20121119170859.GI15971@htj.dyndns.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tejun,

On 19.11.2012 18:08, Tejun Heo wrote:
> Hello, Daniel.
> 
> On Mon, Nov 19, 2012 at 02:47:06PM +0100, Daniel Wagner wrote:
>> On 17.11.2012 04:31, Tejun Heo wrote:
>>> @@ -112,15 +161,6 @@ struct cgroup_subsys net_cls_subsys = {
>>>   	.subsys_id	= net_cls_subsys_id,
>>>   	.base_cftypes	= ss_files,
>>>   	.module		= THIS_MODULE,
>>> -
>>> -	/*
>>> -	 * While net_cls cgroup has the rudimentary hierarchy support of
>>> -	 * inheriting the parent's classid on cgroup creation, it doesn't
>>> -	 * properly propagates config changes in ancestors to their
>>> -	 * descendents.  A child should follow the parent's configuration
>>> -	 * but be allowed to override it.  Fix it and remove the following.
>>> -	 */
>>> -	.broken_hierarchy = true,
>>>   };
>>
>> Are you sure you want to set the default to false at this point?
> 
> Hmmm.... why not?  It's now implementing proper hierarchy behavior.

Well, I though the rule is to keep API as stable as possible. On second
though this change will only extend the API, so for the existing
user base nothing changes.

Acked-by: Daniel Wagner <daniel.wagner@bmw-carit.de>

thanks,
daniel

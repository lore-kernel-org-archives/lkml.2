Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760105Ab2CTOHI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 10:07:08 -0400
Received: from mx2.parallels.com ([64.131.90.16]:50238 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759284Ab2CTOHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 10:07:03 -0400
Message-ID: <4F688EA9.8050905@parallels.com>
Date: Tue, 20 Mar 2012 18:05:29 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: <lizf@cn.fujitsu.com>, <containers@lists.linux-foundation.org>,
        <cgroups@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <fweisbec@gmail.com>, <rni@google.com>, <ctalbott@google.com>
Subject: Re: [PATCH 09/10] cgroup: introduce struct cfent
References: <1331940963-15756-1-git-send-email-tj@kernel.org> <1331940963-15756-10-git-send-email-tj@kernel.org>
In-Reply-To: <1331940963-15756-10-git-send-email-tj@kernel.org>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/17/2012 03:36 AM, Tejun Heo wrote:
> +static void cgroup_clear_directory(struct dentry *dir)
> +{
> +	struct cgroup *cgrp = __d_cgrp(dir);
> +
> +	while (!list_empty(&cgrp->files))
> +		cgroup_rm_file(cgrp, NULL);
> +	WARN_ON_ONCE(!list_empty(&dir->d_subdirs));
>   }


I am hitting this warning here under pretty much normal conditions.
You forgot to account for trivial directories like "."

I'll send a patch ontop of what you have.


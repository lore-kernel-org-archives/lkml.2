Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751332Ab1IWSQx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 14:16:53 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:51274 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750736Ab1IWSQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 14:16:52 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+kNad4mV2k7YpHZzSkDlrehdC4MkK1lahevRi/gu
	ia7FmoFymHhR/f
Subject: Re: [patch] cpusets: allow PF_THREAD_BOUND kworkers to escape from
 a cpuset
From: Mike Galbraith <efault@gmx.de>
To: David Rientjes <rientjes@google.com>
Cc: Tejun Heo <htejun@gmail.com>, Li Zefan <lizf@cn.fujitsu.com>,
        LKML <linux-kernel@vger.kernel.org>, Paul Menage <paul@paulmenage.org>
In-Reply-To: <1316788392.6544.33.camel@marge.simson.net>
References: <1316758874.7393.2.camel@marge.simson.net>
	 <4E7C2E7F.40307@cn.fujitsu.com> <1316762345.8168.4.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230204270.29350@chino.kir.corp.google.com>
	 <1316770936.6641.11.camel@marge.simson.net>
	 <1316775204.7562.9.camel@marge.simson.net>
	 <alpine.DEB.2.00.1109230619410.666@chino.kir.corp.google.com>
	 <1316788392.6544.33.camel@marge.simson.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 23 Sep 2011 20:16:47 +0200
Message-ID: <1316801807.6834.14.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-09-23 at 16:33 +0200, Mike Galbraith wrote:

> @@ -1382,9 +1383,10 @@ static int cpuset_can_attach(struct cgroup_subsys *ss, struct cgroup *cont,
>  	 * set of allowed nodes is unnecessary.  Thus, cpusets are not
>  	 * applicable for such threads.  This prevents checking for success of
>  	 * set_cpus_allowed_ptr() on all attached tasks before cpus_allowed may
> -	 * be changed.
> +	 * be changed.  We also disallow attaching kthreadd, to prevent it's
> +	 * child from becoming trapped should it then acquire PF_THREAD_BOUND.
>  	 */
> -	if (tsk->flags & PF_THREAD_BOUND)
> +	if (tsk->flags & PF_THREAD_BOUND || tsk == kthreadd_task)
>  		return -EINVAL;
>  
>  	return 0;

And maybe || is_container_init(tsk) for symmetry.

	-Mike


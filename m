Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2K2TCA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 14:02:00 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:59371 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753318Ab2K2TB6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 14:01:58 -0500
Date: Thu, 29 Nov 2012 19:06:26 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Aristeu Rozanski <aris@redhat.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge.hallyn@canonical.com>, cgroups@vger.kernel.org
Subject: Re: [PATCH 1/5] device_cgroup: fix locking in devcgroup_destroy()
Message-ID: <20121129190626.GA26104@mail.hallyn.com>
References: <20121127193501.255267751@napanee.usersys.redhat.com>
 <20121127193501.728193744@napanee.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121127193501.728193744@napanee.usersys.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Aristeu Rozanski (aris@redhat.com):
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Serge Hallyn <serge.hallyn@canonical.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> Signed-off-by: Aristeu Rozanski <aris@redhat.com>
> ---
>  security/device_cgroup.c |    4 ++++
>  1 file changed, 4 insertions(+)
> 
> Index: github/security/device_cgroup.c
> ===================================================================
> --- github.orig/security/device_cgroup.c	2012-11-26 17:13:54.008153189 -0500
> +++ github/security/device_cgroup.c	2012-11-27 11:58:43.574251075 -0500
> @@ -215,7 +215,11 @@
>  	struct dev_cgroup *dev_cgroup;
>  
>  	dev_cgroup = cgroup_to_devcgroup(cgroup);
> +
> +	mutex_lock(&devcgroup_mutex);
>  	dev_exception_clean(dev_cgroup);
> +	mutex_unlock(&devcgroup_mutex);
> +
>  	kfree(dev_cgroup);
>  }
>  
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

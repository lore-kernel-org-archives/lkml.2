Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757711Ab2IZRvo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:51:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46809 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757192Ab2IZRvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:51:42 -0400
Date: Wed, 26 Sep 2012 12:51:36 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-security-module@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        linux-kernel@vger.kernel.org, James Morris <james.l.morris@oracle.com>,
        Eric Paris <eparis@parisplace.org>,
        Stephen Smalley <sds@tycho.nsa.gov>
Subject: Re: [PATCH 04/14] userns: Convert selinux to use kuid and kgid where
 appropriate
Message-ID: <20120926175136.GB30620@sergelap>
References: <87k3vote43.fsf@xmission.com>
 <1348187330-6616-1-git-send-email-ebiederm@xmission.com>
 <1348187330-6616-4-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1348187330-6616-4-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Cc: Stephen Smalley <sds@tycho.nsa.gov>
> Cc: James Morris <james.l.morris@oracle.com>
> Cc: Eric Paris <eparis@parisplace.org>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>
> ---
>  security/selinux/selinuxfs.c   |    6 +++---
>  security/selinux/ss/services.c |    2 +-
>  2 files changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
> index 298e695..55af8c5 100644
> --- a/security/selinux/selinuxfs.c
> +++ b/security/selinux/selinuxfs.c
> @@ -174,7 +174,7 @@ static ssize_t sel_write_enforce(struct file *file, const char __user *buf,
>  		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
>  			"enforcing=%d old_enforcing=%d auid=%u ses=%u",
>  			new_value, selinux_enforcing,
> -			audit_get_loginuid(current),
> +			from_kuid(&init_user_ns, audit_get_loginuid(current)),
>  			audit_get_sessionid(current));
>  		selinux_enforcing = new_value;
>  		if (selinux_enforcing)
> @@ -305,7 +305,7 @@ static ssize_t sel_write_disable(struct file *file, const char __user *buf,
>  			goto out;
>  		audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_STATUS,
>  			"selinux=0 auid=%u ses=%u",
> -			audit_get_loginuid(current),
> +			from_kuid(&init_user_ns, audit_get_loginuid(current)),
>  			audit_get_sessionid(current));
>  	}
>  
> @@ -551,7 +551,7 @@ static ssize_t sel_write_load(struct file *file, const char __user *buf,
>  out1:
>  	audit_log(current->audit_context, GFP_KERNEL, AUDIT_MAC_POLICY_LOAD,
>  		"policy loaded auid=%u ses=%u",
> -		audit_get_loginuid(current),
> +		from_kuid(&init_user_ns, audit_get_loginuid(current)),
>  		audit_get_sessionid(current));
>  out:
>  	mutex_unlock(&sel_mutex);
> diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
> index 4321b8f..b4feecc 100644
> --- a/security/selinux/ss/services.c
> +++ b/security/selinux/ss/services.c
> @@ -2440,7 +2440,7 @@ int security_set_bools(int len, int *values)
>  				sym_name(&policydb, SYM_BOOLS, i),
>  				!!values[i],
>  				policydb.bool_val_to_struct[i]->state,
> -				audit_get_loginuid(current),
> +				from_kuid(&init_user_ns, audit_get_loginuid(current)),
>  				audit_get_sessionid(current));
>  		}
>  		if (values[i])
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

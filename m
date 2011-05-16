Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755557Ab1EPOOM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 10:14:12 -0400
Received: from adelie.canonical.com ([91.189.90.139]:45189 "EHLO
	adelie.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755358Ab1EPOOK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 10:14:10 -0400
Date: Mon, 16 May 2011 09:13:59 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: James Morris <jmorris@namei.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Eric Paris <eparis@redhat.com>
Subject: Re: linux-next: manual merge of the security-testing tree with
 Linus' tree
Message-ID: <20110516141359.GA9430@mail.hallyn.com>
References: <20110516130209.0477a9e7.sfr@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110516130209.0477a9e7.sfr@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

looking at commit ffa8e59df047, it also adds

+extern const kernel_cap_t __cap_full_set;

under __cap_empty_set.  My trees are a bit screwed up so I'm not sure if
that gets later removed, but I just wanted to make sure you didn't
accidentally drop that.

Otherwise looks good, thanks and sorry for the noise.

thanks,
-serge

Quoting Stephen Rothwell (sfr@canb.auug.org.au):
> Hi James,
> 
> Today's linux-next merge of the security-testing tree got a conflict in
> include/linux/capability.h between commit 47a150edc2ae ("Cache user_ns in
> struct cred") from Linus' tree and commit ffa8e59df047 ("capabilities: do
> not drop CAP_SETPCAP from the initial task") from the security-testing
> tree.
> 
> Just context changes.  I fixed it up (see below) and can carry the fix as
> necessary.
> -- 
> Cheers,
> Stephen Rothwell                    sfr@canb.auug.org.au
> 
> diff --cc include/linux/capability.h
> index d4675af,04fed72..0000000
> --- a/include/linux/capability.h
> +++ b/include/linux/capability.h
> @@@ -546,8 -541,21 +541,10 @@@ extern bool has_capability_noaudit(stru
>   extern bool capable(int cap);
>   extern bool ns_capable(struct user_namespace *ns, int cap);
>   extern bool task_ns_capable(struct task_struct *t, int cap);
>  +extern bool nsown_capable(int cap);
>   
> + extern const kernel_cap_t __cap_empty_set;
> + 
>  -/**
>  - * nsown_capable - Check superior capability to one's own user_ns
>  - * @cap: The capability in question
>  - *
>  - * Return true if the current task has the given superior capability
>  - * targeted at its own user namespace.
>  - */
>  -static inline bool nsown_capable(int cap)
>  -{
>  -	return ns_capable(current_user_ns(), cap);
>  -}
>  -
>   /* audit system wants to get cap info from files as well */
>   extern int get_vfs_caps_from_disk(const struct dentry *dentry, struct cpu_vfs_cap_data *cpu_caps);
>   

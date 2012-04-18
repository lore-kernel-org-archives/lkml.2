Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754753Ab2DRTFo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 15:05:44 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:33810 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754398Ab2DRTFm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 15:05:42 -0400
Date: Wed, 18 Apr 2012 19:06:40 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: "Eric W. Beiderman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.linux-foundation.org>,
        Cyrill Gorcunov <gorcunov@openvz.org>,
        linux-security-module@vger.kernel.org,
        Al Viro <viro@ZenIV.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 31/43] userns: Teach inode_capable to understand inodes
 whose uids map to other namespaces.
Message-ID: <20120418190640.GI5186@mail.hallyn.com>
References: <m11unyn70b.fsf@fess.ebiederm.org>
 <1333862139-31737-31-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1333862139-31737-31-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Beiderman (ebiederm@xmission.com):
> From: Eric W. Biederman <ebiederm@xmission.com>
> 
> Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>

Acked-by: Serge Hallyn <serge.hallyn@canonical.com>

> ---
>  kernel/capability.c |    6 ++++--
>  1 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/kernel/capability.c b/kernel/capability.c
> index cc5f071..493d972 100644
> --- a/kernel/capability.c
> +++ b/kernel/capability.c
> @@ -429,12 +429,14 @@ bool nsown_capable(int cap)
>   * targeted at it's own user namespace and that the given inode is owned
>   * by the current user namespace or a child namespace.
>   *
> - * Currently inodes can only be owned by the initial user namespace.
> + * Currently we check to see if an inode is owned by the current
> + * user namespace by seeing if the inode's owner maps into the
> + * current user namespace.
>   *
>   */
>  bool inode_capable(const struct inode *inode, int cap)
>  {
>  	struct user_namespace *ns = current_user_ns();
>  
> -	return ns_capable(ns, cap) && (ns == &init_user_ns);
> +	return ns_capable(ns, cap) && kuid_has_mapping(ns, inode->i_uid);
>  }
> -- 
> 1.7.2.5
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

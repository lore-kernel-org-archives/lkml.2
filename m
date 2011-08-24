Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756032Ab1HXIVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 04:21:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51127 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754509Ab1HXIVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 04:21:42 -0400
Date: Wed, 24 Aug 2011 01:23:28 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Al Viro <viro@ZenIV.linux.org.uk>,
        James Bottomley <jbottomley@parallels.com>, Tejun Heo <tj@kernel.org>,
        Glauber Costa <glommer@parallels.com>, containers@lists.osdl.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Serge Hallyn <serge.hallyn@canonical.com>,
        Nathan Lynch <ntl@pobox.com>, Oren Laadan <orenl@cs.columbia.edu>,
        Daniel Lezcano <dlezcano@fr.ibm.com>,
        LINUXFS-ML <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH resend] vfs: Add ->statfs callback for pipefs
Message-Id: <20110824012328.f7bfc68a.akpm@linux-foundation.org>
In-Reply-To: <20110824080924.GG29452@sun>
References: <20110824080924.GG29452@sun>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 24 Aug 2011 12:09:24 +0400 Cyrill Gorcunov <gorcunov@gmail.com> wrote:

> From: Pavel Emelyanov <xemul@parallels.com>
> 
> This is done to make it possible to distinguish pipes
> from fifos when opening one via /proc/<pid>/fd/ link.
> 
> Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
> Reviewed-by: Tejun Heo <tj@kernel.org>
> Acked-by: Serge Hallyn <serge.hallyn@canonical.com>
> Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
> ---
>  fs/pipe.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> Any objections to this one? It was a part of a patchset
> but can be treated independently so I'm re-sending it alone.
> 
> Index: linux-2.6.git/fs/pipe.c
> ===================================================================
> --- linux-2.6.git.orig/fs/pipe.c
> +++ linux-2.6.git/fs/pipe.c
> @@ -1254,6 +1254,7 @@ out:
>  
>  static const struct super_operations pipefs_ops = {
>  	.destroy_inode = free_inode_nonrcu,
> +	.statfs = simple_statfs,
>  };
>  
>  /*

OK, I give up - how does it work?

<goes off and reads the kernel>

So it appears that the statfs call would previously return -ENOSYS, but
with this change the statfs will succeed and userspace can then inspect
f_type.  Yes?  I will fix your changelog by adding a description along these
lines.

And I'll ask you to fix it further by telling us why we want to do
this?  The kernel has had this issue for a long time - why does it now
matter?

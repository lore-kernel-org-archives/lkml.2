Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757313Ab2IZRhg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 13:37:36 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46729 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752173Ab2IZRhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 13:37:34 -0400
Date: Wed, 26 Sep 2012 12:37:18 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, manfred@colorfullife.com,
        a.p.zijlstra@chello.nl, netdev@vger.kernel.org, will.deacon@arm.com,
        linux-kernel@vger.kernel.org, cmetcalf@tilera.com, jmorris@namei.org,
        linux-driver@qlogic.com, linux-security-module@vger.kernel.org,
        hughd@google.com, ron.mercer@qlogic.com, viro@zeniv.linux.org.uk,
        james.l.morris@oracle.com, catalin.marinas@arm.com,
        casey@schaufler-ca.com, eparis@parisplace.org, sds@tycho.nsa.gov,
        jitendra.kalsaria@qlogic.com, devel@openvz.org
Subject: Re: [PATCH v5 01/10] ipc: remove forced assignment of selected
 message
Message-ID: <20120926173718.GA30620@sergelap>
References: <20120919160430.11254.86848.stgit@localhost6.localdomain6>
 <20120919160531.11254.48182.stgit@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120919160531.11254.48182.stgit@localhost6.localdomain6>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
> This is a cleanup patch. The assignment is redundant.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>
> ---
>  ipc/msg.c |    1 -
>  1 files changed, 0 insertions(+), 1 deletions(-)
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index 7385de2..f3bfbb8 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -787,7 +787,6 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
>  			    !security_msg_queue_msgrcv(msq, walk_msg, current,
>  						       msgtyp, mode)) {
>  
> -				msg = walk_msg;
>  				if (mode == SEARCH_LESSEQUAL &&
>  						walk_msg->m_type != 1) {
>  					msg = walk_msg;

Perhaps your tree is different from mine, but it looks to me like it would
be simpler to remove the 'msg = walk_msg' from both the 'if' and 'else',
and keep them above the if/else?

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933134Ab2JWPze (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 11:55:34 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47751 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757185Ab2JWPzd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 11:55:33 -0400
Date: Tue, 23 Oct 2012 10:54:48 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Stanislav Kinsbursky <skinsbursky@parallels.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, will.deacon@arm.com,
        dhowells@redhat.com, manfred@colorfullife.com, hughd@google.com,
        jmorris@namei.org, mtk.manpages@gmail.com,
        kosaki.motohiro@jp.fujitsu.com, paulmck@linux.vnet.ibm.com,
        sds@tycho.nsa.gov, devel@openvz.org, a.p.zijlstra@chello.nl,
        cmetcalf@tilera.com, linux-driver@qlogic.com, ron.mercer@qlogic.com,
        viro@zeniv.linux.org.uk, eparis@parisplace.org, tglx@linutronix.de,
        jitendra.kalsaria@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        ebiederm@xmission.com, casey@schaufler-ca.com
Subject: Re: [PATCH v6 01/10] ipc: remove forced assignment of selected
 message
Message-ID: <20121023155448.GA9755@sergelap>
References: <20121015155800.28348.23561.stgit@localhost.localdomain>
 <20121015155941.28348.88481.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121015155941.28348.88481.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Stanislav Kinsbursky (skinsbursky@parallels.com):
> This is a cleanup patch. The assignment is redundant.
> 
> Signed-off-by: Stanislav Kinsbursky <skinsbursky@parallels.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  ipc/msg.c |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/ipc/msg.c b/ipc/msg.c
> index a71af5a..2f272fa 100644
> --- a/ipc/msg.c
> +++ b/ipc/msg.c
> @@ -793,12 +793,9 @@ long do_msgrcv(int msqid, long *pmtype, void __user *mtext,
>  				msg = walk_msg;
>  				if (mode == SEARCH_LESSEQUAL &&
>  						walk_msg->m_type != 1) {
> -					msg = walk_msg;
>  					msgtyp = walk_msg->m_type - 1;
> -				} else {
> -					msg = walk_msg;
> +				} else
>  					break;
> -				}
>  			}
>  			tmp = tmp->next;
>  		}
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-security-module" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

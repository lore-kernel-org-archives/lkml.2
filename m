Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757928Ab1K3Qfu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Nov 2011 11:35:50 -0500
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:46497 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756422Ab1K3Qft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Nov 2011 11:35:49 -0500
Date: Wed, 30 Nov 2011 16:36:07 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Doug Ledford <dledford@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Davidlohr Bueso <dave@gnu.org>, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [patch -next] ipc/mqueue: lock() => unlock() typo
Message-ID: <20111130163607.GA32365@hallyn.com>
References: <20111130135604.GA2803@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111130135604.GA2803@elgon.mountain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Dan Carpenter (dan.carpenter@oracle.com):
> There was a double lock typo introduced in b085f4bd6b21 "user namespace:
> make signal.c respect user namespaces"
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Jinkeys!

Acked-by: Serge Hallyn <serge@hallyn.com>

thanks very much, Dan.
-serge

> ---
> I think this patch is only needed in the -mm tree.
> 
> diff --git a/ipc/mqueue.c b/ipc/mqueue.c
> index 691cfee..c246c83 100644
> --- a/ipc/mqueue.c
> +++ b/ipc/mqueue.c
> @@ -558,7 +558,7 @@ static void __do_notify(struct mqueue_inode_info *info)
>  						ns_of_pid(info->notify_owner));
>  			sig_i.si_uid = user_ns_map_uid(info->user->user_ns,
>  						current_cred(), current_uid());
> -			rcu_read_lock();
> +			rcu_read_unlock();
>  
>  			kill_pid_info(info->notify.sigev_signo,
>  				      &sig_i, info->notify_owner);

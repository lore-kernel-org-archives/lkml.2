Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752808Ab2DRDVQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 23:21:16 -0400
Received: from 50-56-35-84.static.cloud-ips.com ([50.56.35.84]:47532 "EHLO
	mail.hallyn.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2DRDVP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 23:21:15 -0400
Date: Wed, 18 Apr 2012 03:22:10 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Doug Ledford <dledford@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        kosaki.motohiro@gmail.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Amerigo Wang <amwang@redhat.com>, "Serge E. Hallyn" <serue@us.ibm.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: Re: [Patch 5/8] mqueue: revert bump up DFLT_*MAX
Message-ID: <20120418032210.GB18830@mail.hallyn.com>
References: <cover.1334676645.git.dledford@redhat.com>
 <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <de8d761688dd34f312822db71ceed6753493933a.1334676645.git.dledford@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Doug Ledford (dledford@redhat.com):
> From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> 
> Mqueue limitation is slightly naieve parameter likes other ipcs
> because unprivileged user can consume kernel memory by using ipcs.
> 
> Thus, too aggressive raise bring us security issue. Example,
> current setting allow evil unprivileged user use 256GB (= 256
> * 1024 * 1024*1024) and it's enough large to system will belome
> unresponsive. Don't do that.
> 
> Instead, every admin should adjust the knobs for their own systems.

Would you be terribly averse to having a higher limit in init_ipc_ns,
and the lower values by default in all child namespaces?

Sorry it sounds from the intro like you've already had quite a bit of
discussion on this...

Of course I realize the values can just be raised by distro boot
scripts...

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
> Acked-by: Doug Ledford <dledford@redhat.com>
> Acked-by: Joe Korty <joe.korty@ccur.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>

Acked-by: Serge E. Hallyn <serge.hallyn@canonical.com>

> Cc: Jiri Slaby <jslaby@suse.cz>
> ---
>  include/linux/ipc_namespace.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 6e1dd08..2488535 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -118,12 +118,12 @@ extern int mq_init_ns(struct ipc_namespace *ns);
>  #define DFLT_QUEUESMAX		      256
>  #define HARD_QUEUESMAX		     1024
>  #define MIN_MSGMAX			1
> -#define DFLT_MSG		       64U
> -#define DFLT_MSGMAX		     1024
> +#define DFLT_MSG		       10U
> +#define DFLT_MSGMAX		       10
>  #define HARD_MSGMAX		    65536
>  #define MIN_MSGSIZEMAX		      128
>  #define DFLT_MSGSIZE		     8192U
> -#define DFLT_MSGSIZEMAX	       (1024*1024)
> +#define DFLT_MSGSIZEMAX		     8192
>  #define HARD_MSGSIZEMAX	    (16*1024*1024)
>  #else
>  static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> -- 
> 1.7.7.6
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

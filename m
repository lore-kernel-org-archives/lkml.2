Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933699Ab1JZR24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 13:28:56 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:48621 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932885Ab1JZR2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 13:28:54 -0400
Date: Wed, 26 Oct 2011 13:28:50 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: akpm@linux-foundation.org, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, joe korty <joe.korty@ccur.com>,
        amwang@redhat.com
Subject: Re: [PATCH 5/4] ipc/mqueue: revert bump up DFLT_*MAX
Message-ID: <fcf56fe9-a348-4032-a402-e85eab18963c@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <4EA82926.8050502@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.3.113.99]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> Mqueue limitation is slightly naieve parameter likes other ipcs
> because unprivileged user can consume kernel memory by using ipcs.
> 
> Thus, too aggressive raise bring us security issue. Example,
> current setting allow evil unprivileged user use 256GB (= 256
> * 1024 * 1024*1024) and it's enough large to system will belome
> unresponsive. Don't do that.

The RLIMIT_MSGQUEUE will kick in at 819200 bytes.  The purpose of
changing the default maximums was simply to allow applications
a little more flexibility in how they use their 819200 byte limit,
not to allow them an unbounded limit.  And even if you raise the
RLIMIT value, there is still the fact that msgqueue bytes are
accounted on a per user id basis and there is a hard limit of
2GB (INT_MAX) on any given user id.  So the situation isn't as
dire as you painted ;-)

> Instead, every admin should adjust the knobs for their own systems.

Given that there are knobs to adjust things, I'm fine putting the
defaults back where they were.

Acked-by: Doug Ledford <dledford@redhat.com>

> Signed-off-by: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
> Cc: Doug Ledford <dledford@redhat.com>
> Cc: Amerigo Wang <amwang@redhat.com>
> Cc: Serge E. Hallyn <serue@us.ibm.com>
> Cc: Jiri Slaby <jslaby@suse.cz>
> Cc: Joe Korty <joe.korty@ccur.com>
> ---
>  include/linux/ipc_namespace.h |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/ipc_namespace.h
> b/include/linux/ipc_namespace.h
> index e2bac00..2d7c5e0 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -118,12 +118,12 @@ extern int mq_init_ns(struct ipc_namespace
> *ns);
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
> -#define DFLT_MSGSIZEMAX		(1024*1024)
> +#define DFLT_MSGSIZEMAX		     8192
>  #define HARD_MSGSIZEMAX	     (16*1024*1024)
>  #else
>  static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> --
> 1.7.5.2
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: 0E572FDD
	      http://people.redhat.com/dledford


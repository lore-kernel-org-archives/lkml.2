Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754172Ab1J0Qzo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:55:44 -0400
Received: from flusers.ccur.com ([173.221.59.2]:37530 "EHLO gamx.iccur.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752901Ab1J0QzO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:55:14 -0400
X-Greylist: delayed 835 seconds by postgrey-1.27 at vger.kernel.org; Thu, 27 Oct 2011 12:55:12 EDT
Date: Thu, 27 Oct 2011 12:41:08 -0400
From: Joe Korty <joe.korty@ccur.com>
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
Cc: "dledford@redhat.com" <dledford@redhat.com>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "amwang@redhat.com" <amwang@redhat.com>
Subject: Re: [PATCH 5/4] ipc/mqueue: revert bump up DFLT_*MAX
Message-ID: <20111027164108.GC21264@tsunami.ccur.com>
Reply-To: Joe Korty <joe.korty@ccur.com>
References: <1317162613-11060-1-git-send-email-dledford@redhat.com> <1317162613-11060-3-git-send-email-dledford@redhat.com> <CAHGf_=obvkUN-JYVfbLueTV3hmobnV3jY86ukHo1E6d-3NDZxg@mail.gmail.com> <4EA828E4.1070409@gmail.com> <4EA82926.8050502@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4EA82926.8050502@gmail.com>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 11:37:10AM -0400, KOSAKI Motohiro wrote:
> Mqueue limitation is slightly naieve parameter likes other ipcs
> because unprivileged user can consume kernel memory by using ipcs.
> 
> Thus, too aggressive raise bring us security issue. Example,
> current setting allow evil unprivileged user use 256GB (= 256
> * 1024 * 1024*1024) and it's enough large to system will belome
> unresponsive. Don't do that.
> 
> Instead, every admin should adjust the knobs for their own systems.
> 
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
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index e2bac00..2d7c5e0 100644
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
> -#define DFLT_MSGSIZEMAX		(1024*1024)
> +#define DFLT_MSGSIZEMAX		     8192
>  #define HARD_MSGSIZEMAX	     (16*1024*1024)
>  #else
>  static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
> -- 
> 1.7.5.2

Acked-by: Joe Korty <joe.korty@ccur.com>


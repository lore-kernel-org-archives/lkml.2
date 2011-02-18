Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758842Ab1BSAAi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:00:38 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42584 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755866Ab1BSAAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:00:20 -0500
Date: Fri, 18 Feb 2011 15:59:31 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: "Serge E. Hallyn" <serge@hallyn.com>
Cc: LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 7/9] add a user namespace owner of ipc ns
Message-Id: <20110218155931.288266d8.akpm@linux-foundation.org>
In-Reply-To: <20110217150349.GG26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150349.GG26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:03:49 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

>
> ...
>
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -24,6 +24,7 @@ struct ipc_ids {
>  	struct idr ipcs_idr;
>  };
>  
> +struct user_namespace;

Move to top of file.

>  struct ipc_namespace {
>  	atomic_t	count;
>  	struct ipc_ids	ids[3];
> @@ -56,6 +57,8 @@ struct ipc_namespace {
>  	unsigned int    mq_msg_max;      /* initialized to DFLT_MSGMAX */
>  	unsigned int    mq_msgsize_max;  /* initialized to DFLT_MSGSIZEMAX */
>  
> +	/* user_ns which owns the ipc ns */
> +	struct user_namespace *user_ns;
>  };
>  
>  extern struct ipc_namespace init_ipc_ns;
> diff --git a/ipc/msgutil.c b/ipc/msgutil.c
> index f095ee2..d91ff4b 100644
> --- a/ipc/msgutil.c
> +++ b/ipc/msgutil.c
> @@ -20,6 +20,8 @@
>  
>  DEFINE_SPINLOCK(mq_lock);
>  
> +extern struct user_namespace init_user_ns;

Should be declared in .h, not in .c.

>  /*
>   * The next 2 defines are here bc this is the only file
>   * compiled when either CONFIG_SYSVIPC and CONFIG_POSIX_MQUEUE
>
> ...
>


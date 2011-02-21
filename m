Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755173Ab1BUKFn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 05:05:43 -0500
Received: from smtp4-g21.free.fr ([212.27.42.4]:58003 "EHLO smtp4-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754544Ab1BUKFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 05:05:42 -0500
Message-ID: <4D6238E6.1060402@free.fr>
Date: Mon, 21 Feb 2011 11:05:26 +0100
From: Daniel Lezcano <daniel.lezcano@free.fr>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: "Serge E. Hallyn" <serge@hallyn.com>
CC: Andrew Morton <akpm@osdl.org>, Oleg Nesterov <oleg@redhat.com>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 2/4] userns: let copy_ipcs handle setting ipc_ns->user_ns
References: <20110221040156.GA12580@mail.hallyn.com> <20110221040230.GB12580@mail.hallyn.com>
In-Reply-To: <20110221040230.GB12580@mail.hallyn.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/21/2011 05:02 AM, Serge E. Hallyn wrote:
> To do that, we have to pass in the task_struct of the task which
> will own the ipc_ns, so we can assign its user_ns.
>
> Signed-off-by: Serge E. Hallyn<serge.hallyn@canonical.com>
> ---
>   include/linux/ipc_namespace.h |    8 +++++---
>   ipc/namespace.c               |   12 +++++++-----
>   kernel/nsproxy.c              |    7 +------
>   3 files changed, 13 insertions(+), 14 deletions(-)
>
> diff --git a/include/linux/ipc_namespace.h b/include/linux/ipc_namespace.h
> index 46d2eb4..9974429 100644
> --- a/include/linux/ipc_namespace.h
> +++ b/include/linux/ipc_namespace.h
> @@ -92,7 +92,8 @@ static inline int mq_init_ns(struct ipc_namespace *ns) { return 0; }
>   #endif
>
>   #if defined(CONFIG_IPC_NS)
> -extern struct ipc_namespace *copy_ipcs(unsigned long flags,
> +extern struct ipc_namespace *copy_ipcs(struct task_struct *tsk,
> +				       unsigned long flags,
>   				       struct ipc_namespace *ns);

Same comment than patch 1/4

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758769Ab1BSACQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:02:16 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58741 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754895Ab1BSACM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:02:12 -0500
Date: Fri, 18 Feb 2011 16:01:24 -0800
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
Subject: Re: [PATCH 6/9] user namespaces: convert all capable checks in
 kernel/sys.c
Message-Id: <20110218160124.4d2e520b.akpm@linux-foundation.org>
In-Reply-To: <20110217150342.GF26395@mail.hallyn.com>
References: <20110217150224.GA26334@mail.hallyn.com>
	<20110217150342.GF26395@mail.hallyn.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Feb 2011 15:03:42 +0000
"Serge E. Hallyn" <serge@hallyn.com> wrote:

> @@ -1177,8 +1189,11 @@ SYSCALL_DEFINE2(sethostname, char __user *, name, int, len)
>  	int errno;
>  	char tmp[__NEW_UTS_LEN];
>  
> -	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN))
> +	if (!ns_capable(current->nsproxy->uts_ns->user_ns, CAP_SYS_ADMIN)) {
> +		printk(KERN_NOTICE "%s: did not have CAP_SYS_ADMIN\n", __func__);
>  		return -EPERM;
> +	}
> +	printk(KERN_NOTICE "%s: did have CAP_SYS_ADMIN\n", __func__);
>  	if (len < 0 || len > __NEW_UTS_LEN)
>  		return -EINVAL;
>  	down_write(&uts_sem);

Left over debugging printks?

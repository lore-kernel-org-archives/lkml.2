Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754050Ab0LGWNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Dec 2010 17:13:20 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:38772 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753275Ab0LGWNT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Dec 2010 17:13:19 -0500
Date: Tue, 7 Dec 2010 14:13:15 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Pavel Emelyanov <xemul@parallels.com>
Cc: Linux Containers <containers@lists.osdl.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Serge E. Hallyn" <serge@hallyn.com>
Subject: Re: [PATCH] user_ns: Improve the user_ns on-the-slab packaging
Message-Id: <20101207141315.5ea45abf.akpm@linux-foundation.org>
In-Reply-To: <4CFE40D1.5000309@parallels.com>
References: <4CFE40D1.5000309@parallels.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 07 Dec 2010 17:12:33 +0300
Pavel Emelyanov <xemul@parallels.com> wrote:

> @@ -126,3 +128,11 @@ gid_t user_ns_map_gid(struct user_namespace *to, const struct cred *cred, gid_t
>  	/* No useful relationship so no mapping */
>  	return overflowgid;
>  }
> +
> +static __init int user_namespaces_init(void)
> +{
> +	user_ns_cachep = KMEM_CACHE(user_namespace, SLAB_PANIC);
> +	return 0;
> +}
> +
> +__initcall(user_namespaces_init);

checkpatch (which you apparently didn't use) says

WARNING: please use device_initcall() instead of __initcall()
#81: FILE: kernel/user_namespace.c:138:
+__initcall(user_namespaces_init);

which was a somewhat random recommendation.  I think I'll switch it to
plain old module_init().

Presumably user-namespaces don't get used prior to initcalls being run.


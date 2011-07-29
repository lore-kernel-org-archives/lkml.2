Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752924Ab1G2UpF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 16:45:05 -0400
Received: from vostochny.stro.at ([78.47.22.85]:44490 "EHLO vostochny.stro.at"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752358Ab1G2UpE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 16:45:04 -0400
Date: Fri, 29 Jul 2011 22:41:16 +0200
From: Maximilian Attems <max@stro.at>
To: Mike Waychison <mikew@google.com>
Cc: "Andrew G. Morgan" <agm@google.com>, Eric Northup <digitaleric@google.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, "H. Peter Anvin" <hpa@zytor.com>,
        Eric Paris <eparis@parisplace.org>, klibc@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 1/2] syscalls: Add capset and capget
Message-ID: <20110729204116.GA3207@stro.at>
References: <20110719203843.646.73383.stgit@mike2.sea.corp.google.com>
 <20110719203848.646.62196.stgit@mike2.sea.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110719203848.646.62196.stgit@mike2.sea.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Jul 2011, Mike Waychison wrote:

> Add the capset and capget system calls to klibc so that userland can
> invoke them.
> 
> Signed-off-by: Mike Waychison <mikew@google.com>
> ---
>  usr/include/sys/capability.h   |   10 ++++++++++
>  usr/klibc/SYSCALLS.def         |    6 ++++++
>  usr/klibc/syscalls/syscommon.h |    1 +
>  3 files changed, 17 insertions(+), 0 deletions(-)
>  create mode 100644 usr/include/sys/capability.h
> 
> diff --git a/usr/include/sys/capability.h b/usr/include/sys/capability.h
> new file mode 100644
> index 0000000..84ad419
> --- /dev/null
> +++ b/usr/include/sys/capability.h
> @@ -0,0 +1,10 @@
> +#ifndef _SYS_CAPABILITY_H
> +#define _SYS_CAPABILITY_H
> +
> +#include <klibc/extern.h>
> +#include <linux/capability.h>
> +
> +__extern int capget(cap_user_header_t hdrp, cap_user_data_t datap);
> +__extern int capset(cap_user_header_t hdrp, const cap_user_data_t datap);
> +
> +#endif				/* _SYS_CAPABILITY_H */
> diff --git a/usr/klibc/SYSCALLS.def b/usr/klibc/SYSCALLS.def
> index d3279c7..ee3ffa9 100644
> --- a/usr/klibc/SYSCALLS.def
> +++ b/usr/klibc/SYSCALLS.def
> @@ -77,6 +77,12 @@ int setfsgid32,setfsgid::setfsgid(gid_t);
>  int setresuid32,setresuid::setresuid(int, uid_t, uid_t, uid_t);
>  
>  /*
> + * POSIX Capabilities
> + */
> +int capget(cap_user_header_t, cap_user_data_t);
> +int capset(cap_user_header_t, cap_user_data_t);
> +
> +/*
>   * Filesystem-related system calls
>   */
>  int mount(const char *, const char *, const char *, unsigned long, const void *);
> diff --git a/usr/klibc/syscalls/syscommon.h b/usr/klibc/syscalls/syscommon.h
> index 0acae12..78f8858 100644
> --- a/usr/klibc/syscalls/syscommon.h
> +++ b/usr/klibc/syscalls/syscommon.h
> @@ -12,6 +12,7 @@
>  
>  #include <poll.h>
>  #include <sched.h>
> +#include <sys/capability.h>
>  #include <sys/dirent.h>
>  #include <sys/klog.h>
>  #include <sys/mman.h>

this looks good to me.
thanks will add to klibc repo soonest.

-- 
maks

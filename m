Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757540Ab2JXNsk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 09:48:40 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52346 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756082Ab2JXNsi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 09:48:38 -0400
Date: Wed, 24 Oct 2012 08:48:31 -0500
From: Serge Hallyn <serge.hallyn@canonical.com>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, "Eric W. Biederman" <ebiederm@xmission.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH 155/193] init: remove CONFIG_EXPERIMENTAL
Message-ID: <20121024134831.GB7217@sergelap>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-156-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-156-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Kees Cook (keescook@chromium.org):
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: "Eric W. Biederman" <ebiederm@xmission.com>
> CC: Serge Hallyn <serge.hallyn@canonical.com>
> CC: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> CC: Andrew Morton <akpm@linux-foundation.org>
> CC: Frederic Weisbecker <fweisbec@gmail.com>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  init/Kconfig |   23 ++++++++++-------------
>  1 file changed, 10 insertions(+), 13 deletions(-)
> 
> diff --git a/init/Kconfig b/init/Kconfig
> index 2bf7b83..4b65c1c 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -220,7 +220,7 @@ config SYSVIPC_SYSCTL
>  
>  config POSIX_MQUEUE
>  	bool "POSIX Message Queues"
> -	depends on NET && EXPERIMENTAL
> +	depends on NET
>  	---help---
>  	  POSIX variant of message queues is a part of IPC. In POSIX message
>  	  queues every message has a priority which decides about succession
> @@ -366,7 +366,7 @@ config BSD_PROCESS_ACCT_V3
>  	  at <http://www.gnu.org/software/acct/>.
>  
>  config TASKSTATS
> -	bool "Export task/process statistics through netlink (EXPERIMENTAL)"
> +	bool "Export task/process statistics through netlink"

In these cases, should we keep the '(EXPERIMENTAL)' text since it is just
a hint to anyone running make menuconfig?  I think removing the 'depends on
EXPERIMENTAL's is fine, but cases we should leave it (or replace it) as
a textual hint, except in cases where we're sure that is no longer the case.

>  	depends on NET
>  	default n
>  	help
> @@ -379,7 +379,7 @@ config TASKSTATS
>  	  Say N if unsure.
>  
>  config TASK_DELAY_ACCT
> -	bool "Enable per-task delay accounting (EXPERIMENTAL)"
> +	bool "Enable per-task delay accounting"
>  	depends on TASKSTATS
>  	help
>  	  Collect information on time spent by a task waiting for system
> @@ -390,7 +390,7 @@ config TASK_DELAY_ACCT
>  	  Say N if unsure.
>  
>  config TASK_XACCT
> -	bool "Enable extended accounting over taskstats (EXPERIMENTAL)"
> +	bool "Enable extended accounting over taskstats"
>  	depends on TASKSTATS
>  	help
>  	  Collect extended task accounting data and send the data
> @@ -399,7 +399,7 @@ config TASK_XACCT
>  	  Say N if unsure.
>  
>  config TASK_IO_ACCOUNTING
> -	bool "Enable per-task storage I/O accounting (EXPERIMENTAL)"
> +	bool "Enable per-task storage I/O accounting"
>  	depends on TASK_XACCT
>  	help
>  	  Collect information on the number of bytes of storage I/O which this
> @@ -788,8 +788,8 @@ config MEMCG_SWAP_ENABLED
>  	  select this option (if, for some reason, they need to disable it
>  	  then swapaccount=0 does the trick).
>  config MEMCG_KMEM
> -	bool "Memory Resource Controller Kernel Memory accounting (EXPERIMENTAL)"
> -	depends on MEMCG && EXPERIMENTAL
> +	bool "Memory Resource Controller Kernel Memory accounting"
> +	depends on MEMCG
>  	default n
>  	help
>  	  The Kernel Memory extension for Memory Resource Controller can limit
> @@ -801,7 +801,7 @@ config MEMCG_KMEM
>  
>  config CGROUP_HUGETLB
>  	bool "HugeTLB Resource Controller for Control Groups"
> -	depends on RESOURCE_COUNTERS && HUGETLB_PAGE && EXPERIMENTAL
> +	depends on RESOURCE_COUNTERS && HUGETLB_PAGE
>  	default n
>  	help
>  	  Provides a cgroup Resource Controller for HugeTLB pages.
> @@ -840,7 +840,6 @@ config FAIR_GROUP_SCHED
>  
>  config CFS_BANDWIDTH
>  	bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
> -	depends on EXPERIMENTAL
>  	depends on FAIR_GROUP_SCHED
>  	default n
>  	help
> @@ -852,7 +851,6 @@ config CFS_BANDWIDTH
>  
>  config RT_GROUP_SCHED
>  	bool "Group scheduling for SCHED_RR/FIFO"
> -	depends on EXPERIMENTAL
>  	depends on CGROUP_SCHED
>  	default n
>  	help
> @@ -934,8 +932,7 @@ config IPC_NS
>  	  different IPC objects in different namespaces.
>  
>  config USER_NS
> -	bool "User namespace (EXPERIMENTAL)"
> -	depends on EXPERIMENTAL
> +	bool "User namespace"
>  	depends on UIDGID_CONVERTED
>  	select UIDGID_STRICT_TYPE_CHECKS
>  
> @@ -1518,7 +1515,7 @@ config MODULE_UNLOAD
>  
>  config MODULE_FORCE_UNLOAD
>  	bool "Forced module unloading"
> -	depends on MODULE_UNLOAD && EXPERIMENTAL
> +	depends on MODULE_UNLOAD
>  	help
>  	  This option allows you to force a module to unload, even if the
>  	  kernel believes it is unsafe: the kernel will remove the module
> -- 
> 1.7.9.5
> 

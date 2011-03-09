Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753734Ab1CIXHW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 18:07:22 -0500
Received: from shutemov.name ([188.40.19.243]:60847 "EHLO shutemov.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814Ab1CIXHV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 18:07:21 -0500
Date: Thu, 10 Mar 2011 01:07:20 +0200
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Eric B Munson <emunson@mgebm.net>
Cc: containers@lists.linux-foundation.org, rdunlap@xenotime.net,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH] Documentation: cgroups: Add notes on removing PIDs from
 tasks and cgroups requiring setup
Message-ID: <20110309230720.GA32096@shutemov.name>
References: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299704969-4485-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.20 (2010-08-04)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 09, 2011 at 04:09:29PM -0500, Eric B Munson wrote:
> The cgroup documentation does not specify how a process can be removed from a
> particular group.  This patch adds a note at the end of the simple example
> about how this is done.  Also, some cgroups (like cpusets) require user input
> before a new group can be used.  This is noted in the patch as well.
> 
> Signed-off-by: Eric B Munson <emunson@mgebm.net>
> ---
>  Documentation/cgroups/cgroups.txt |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/cgroups/cgroups.txt b/Documentation/cgroups/cgroups.txt
> index 44b8b7a..6c975a1 100644
> --- a/Documentation/cgroups/cgroups.txt
> +++ b/Documentation/cgroups/cgroups.txt
> @@ -349,6 +349,10 @@ To mount a cgroup hierarchy with all available subsystems, type:
>  The "xxx" is not interpreted by the cgroup code, but will appear in
>  /proc/mounts so may be any useful identifying string that you like.
>  
> +Note: Some subsystems do not work without some user input first.  For instance,
> +if cpusets are enabled the user will have to populate the cpus and mems files
> +for each new cgroup created before that group can be used.
> +
>  To mount a cgroup hierarchy with just the cpuset and memory
>  subsystems, type:
>  # mount -t cgroup -o cpuset,memory hier1 /dev/cgroup
> @@ -426,6 +430,9 @@ You can attach the current shell task by echoing 0:
>  
>  # echo 0 > tasks
>  
> +Note: To remove a task from a cgroup you must write its PID to the root
> +tasks file.
> +

'to tasks file of another cgroup.'?

>  2.3 Mounting hierarchies by name
>  --------------------------------
>  
> -- 
> 1.7.1
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linux-foundation.org/mailman/listinfo/containers

-- 
 Kirill A. Shutemov

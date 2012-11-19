Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753899Ab2KSR7H (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:59:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:47037 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752733Ab2KSR7G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:59:06 -0500
Date: Mon, 19 Nov 2012 11:58:53 -0600
From: Serge Hallyn <serge.hallyn@canonical.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Linux Containers <containers@lists.linux-foundation.org>,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH review 11/16] procfs: Print task uids and gids in the
 userns that opened the proc file
Message-ID: <20121119175853.GB1883@serge-ThinkPad-X130e>
References: <87lidx8wbo.fsf@xmission.com>
 <1353337961-12962-1-git-send-email-ebiederm@xmission.com>
 <1353337961-12962-11-git-send-email-ebiederm@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1353337961-12962-11-git-send-email-ebiederm@xmission.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Eric W. Biederman (ebiederm@xmission.com):
> From: "Eric W. Biederman" <ebiederm@xmission.com>
> 
> Instead of using current_userns() use the userns of the opener
> of the file so that if the file is passed between processes
> the contents of the file do not change.
> 
> Signed-off-by: "Eric W. Biederman" <ebiederm@xmission.com>

Acked-by: Serge E. Hallyn <serge.hallyn@ubuntu.com>

> ---
>  fs/proc/array.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
> 
> diff --git a/fs/proc/array.c b/fs/proc/array.c
> index c1c207c..5544342 100644
> --- a/fs/proc/array.c
> +++ b/fs/proc/array.c
> @@ -162,7 +162,7 @@ static inline const char *get_task_state(struct task_struct *tsk)
>  static inline void task_state(struct seq_file *m, struct pid_namespace *ns,
>  				struct pid *pid, struct task_struct *p)
>  {
> -	struct user_namespace *user_ns = current_user_ns();
> +	struct user_namespace *user_ns = seq_user_ns(m);
>  	struct group_info *group_info;
>  	int g;
>  	struct fdtable *fdt = NULL;
> -- 
> 1.7.5.4
> 
> _______________________________________________
> Containers mailing list
> Containers@lists.linux-foundation.org
> https://lists.linuxfoundation.org/mailman/listinfo/containers

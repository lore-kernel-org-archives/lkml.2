Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310Ab0KHK0o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 05:26:44 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38330 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751822Ab0KHK0n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 05:26:43 -0500
Subject: Re: [PATCH 3/7] fs/gfs2/glock.c: Convert sprintf_symbol to %pS
From: Steven Whitehouse <swhiteho@redhat.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, cluster-devel@redhat.com,
        linux-kernel@vger.kernel.org
In-Reply-To: <1288998760-11775-4-git-send-email-joe@perches.com>
References: <1288998760-11775-1-git-send-email-joe@perches.com>
	 <1288998760-11775-4-git-send-email-joe@perches.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Red Hat UK Ltd
Date: Mon, 08 Nov 2010 10:26:16 +0000
Message-ID: <1289211976.2408.1.camel@dolmen>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Fri, 2010-11-05 at 16:12 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
Seems like a good idea:
Acked-by: Steven Whitehouse <swhiteho@redhat.com>

Steve.

>  fs/gfs2/glock.c |   15 +++++++--------
>  1 files changed, 7 insertions(+), 8 deletions(-)
> 
> diff --git a/fs/gfs2/glock.c b/fs/gfs2/glock.c
> index 8777885..08dd4a2 100644
> --- a/fs/gfs2/glock.c
> +++ b/fs/gfs2/glock.c
> @@ -1627,18 +1627,17 @@ static const char *hflags2str(char *buf, unsigned flags, unsigned long iflags)
>  static int dump_holder(struct seq_file *seq, const struct gfs2_holder *gh)
>  {
>  	struct task_struct *gh_owner = NULL;
> -	char buffer[KSYM_SYMBOL_LEN];
>  	char flags_buf[32];
>  
> -	sprint_symbol(buffer, gh->gh_ip);
>  	if (gh->gh_owner_pid)
>  		gh_owner = pid_task(gh->gh_owner_pid, PIDTYPE_PID);
> -	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %s\n",
> -		  state2str(gh->gh_state),
> -		  hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
> -		  gh->gh_error, 
> -		  gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
> -		  gh_owner ? gh_owner->comm : "(ended)", buffer);
> +	gfs2_print_dbg(seq, " H: s:%s f:%s e:%d p:%ld [%s] %pS\n",
> +		       state2str(gh->gh_state),
> +		       hflags2str(flags_buf, gh->gh_flags, gh->gh_iflags),
> +		       gh->gh_error,
> +		       gh->gh_owner_pid ? (long)pid_nr(gh->gh_owner_pid) : -1,
> +		       gh_owner ? gh_owner->comm : "(ended)",
> +		       (void *)gh->gh_ip);
>  	return 0;
>  }
>  



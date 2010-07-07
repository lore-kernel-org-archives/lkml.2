Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758090Ab0GGV64 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Jul 2010 17:58:56 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:45226 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756630Ab0GGV6y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Jul 2010 17:58:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=IlvGAvh/+xRGfKgM5I4OuAqIsm7BY7HKFb0v2hcBrgTWQIgto9MR0re/VqgYbs7jXB
         UOLaw76elQKvoJBVvZ2HBWi4VZ/g+Y6Jt3/j2jm0yUlh1CFJQ0GHdbAUNDogJqxHNVSI
         nJ0p5DxaVKKVuCdVDRvUfrmo+HKF0roe/PunQ=
Date: Wed, 7 Jul 2010 23:58:44 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, John Kacur <jkacur@redhat.com>,
       Christoph Hellwig <hch@lst.de>, Steven Rostedt <rostedt@goodmis.org>,
       Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH 09/18] tracing: use generic_file_llseek for debugfs
Message-ID: <20100707215838.GA5420@nowhere>
References: <1278538820-1392-1-git-send-email-arnd@arndb.de> <1278538820-1392-10-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278538820-1392-10-git-send-email-arnd@arndb.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 07, 2010 at 11:40:11PM +0200, Arnd Bergmann wrote:
> The default for llseek will change to no_llseek,
> so the tracing debugfs files need to add explicit
> .llseek assignments. Since we're dealing with regular
> files from a VFS perspective, use generic_file_llseek.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Ingo Molnar <mingo@redhat.com>
> ---
>  kernel/trace/trace.c |   15 +++++++++++++++
>  1 files changed, 15 insertions(+), 0 deletions(-)
> 
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 086d363..de3d6b3 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2394,6 +2394,7 @@ static const struct file_operations show_traces_fops = {
>  	.open		= show_traces_open,
>  	.read		= seq_read,
>  	.release	= seq_release,
> +	.llseek		= seq_lseek,
>  };
>  
>  /*
> @@ -2487,6 +2488,7 @@ static const struct file_operations tracing_cpumask_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_cpumask_read,
>  	.write		= tracing_cpumask_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static int tracing_trace_options_show(struct seq_file *m, void *v)
> @@ -2653,6 +2655,7 @@ tracing_readme_read(struct file *filp, char __user *ubuf,
>  static const struct file_operations tracing_readme_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_readme_read,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static ssize_t
> @@ -2703,6 +2706,7 @@ tracing_saved_cmdlines_read(struct file *file, char __user *ubuf,
>  static const struct file_operations tracing_saved_cmdlines_fops = {
>      .open       = tracing_open_generic,
>      .read       = tracing_saved_cmdlines_read,
> +    .llseek	= generic_file_llseek,
>  };
>  
>  static ssize_t
> @@ -3032,6 +3036,7 @@ static int tracing_open_pipe(struct inode *inode, struct file *filp)
>  	if (iter->trace->pipe_open)
>  		iter->trace->pipe_open(iter);
>  
> +	nonseekable_open(inode, filp);
>  out:
>  	mutex_unlock(&trace_types_lock);
>  	return ret;
> @@ -3590,18 +3595,21 @@ static const struct file_operations tracing_max_lat_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_max_lat_read,
>  	.write		= tracing_max_lat_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static const struct file_operations tracing_ctrl_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_ctrl_read,
>  	.write		= tracing_ctrl_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static const struct file_operations set_tracer_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_set_trace_read,
>  	.write		= tracing_set_trace_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static const struct file_operations tracing_pipe_fops = {
> @@ -3610,17 +3618,20 @@ static const struct file_operations tracing_pipe_fops = {
>  	.read		= tracing_read_pipe,
>  	.splice_read	= tracing_splice_read_pipe,
>  	.release	= tracing_release_pipe,
> +	.llseek		= no_llseek,




If you use nonseekable_open you don't need no_llseek there. That said I'm
all for keeping this as it's easier to grep fops that lack a proper llseek
callback with that.




>  };
>  
>  static const struct file_operations tracing_entries_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_entries_read,
>  	.write		= tracing_entries_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static const struct file_operations tracing_mark_fops = {
>  	.open		= tracing_open_generic,
>  	.write		= tracing_mark_write,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  static const struct file_operations trace_clock_fops = {
> @@ -3926,6 +3937,7 @@ tracing_stats_read(struct file *filp, char __user *ubuf,
>  static const struct file_operations tracing_stats_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_stats_read,
> +	.llseek		= generic_file_llseek,
>  };
>  
>  #ifdef CONFIG_DYNAMIC_FTRACE
> @@ -3962,6 +3974,7 @@ tracing_read_dyn_info(struct file *filp, char __user *ubuf,
>  static const struct file_operations tracing_dyn_info_fops = {
>  	.open		= tracing_open_generic,
>  	.read		= tracing_read_dyn_info,
> +	.llseek		= generic_file_llseek,
>  };
>  #endif
>  
> @@ -4115,6 +4128,7 @@ static const struct file_operations trace_options_fops = {
>  	.open = tracing_open_generic,
>  	.read = trace_options_read,
>  	.write = trace_options_write,
> +	.llseek	= generic_file_llseek,
>  };
>  
>  static ssize_t
> @@ -4166,6 +4180,7 @@ static const struct file_operations trace_options_core_fops = {
>  	.open = tracing_open_generic,
>  	.read = trace_options_core_read,
>  	.write = trace_options_core_write,
> +	.llseek = generic_file_llseek,
>  };
>  
>  struct dentry *trace_create_file(const char *name,
> -- 
> 1.7.1
> 



Applied, thanks Arnd!


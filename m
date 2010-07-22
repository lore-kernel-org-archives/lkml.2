Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753450Ab0GVS61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 14:58:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:56902 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029Ab0GVS6Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 14:58:24 -0400
X-Authority-Analysis: v=1.1 cv=nxp4sGnGskpld68D65f6QeagdS7Y+3TTkvBhhEd/T4I= c=1 sm=0 a=gZ05mB2OILcA:10 a=Q9fys5e9bTEA:10 a=gMqfjgEr1zLu/65IO0LwxA==:17 a=IJv9LcIfAAAA:8 a=meVymXHHAAAA:8 a=E67OxlfP3ZQvvHyW11QA:9 a=0FKE0EH3qmtmMi85ZlmRCJDmzKgA:4 a=PUjeQqilurYA:10 a=K6kUPx8HyhEA:10 a=jeBq3FmKZ4MA:10 a=gMqfjgEr1zLu/65IO0LwxA==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.89.75
Subject: Re: [PATCH 29/36] kernel/trace: Remove unnecessary casts of
 private_data
From: Steven Rostedt <rostedt@goodmis.org>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>
In-Reply-To: <9ba657c52c49f10023a45c178e98acf553a68385.1278967121.git.joe@perches.com>
References: <cover.1278967120.git.joe@perches.com>
	 <9ba657c52c49f10023a45c178e98acf553a68385.1278967121.git.joe@perches.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 22 Jul 2010 14:58:22 -0400
Message-ID: <1279825102.3319.15.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Late reply due to traveling, but...

On Mon, 2010-07-12 at 13:50 -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> ---
>  kernel/trace/ftrace.c |    4 ++--
>  kernel/trace/trace.c  |    2 +-
>  2 files changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 0d88ce9..0691e87 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1592,7 +1592,7 @@ ftrace_failures_open(struct inode *inode, struct file *file)
>  
>  	ret = ftrace_avail_open(inode, file);
>  	if (!ret) {
> -		m = (struct seq_file *)file->private_data;
> +		m = file->private_data;
>  		iter = (struct ftrace_iterator *)m->private;
>  		iter->flags = FTRACE_ITER_FAILURES;
>  	}
> @@ -2349,7 +2349,7 @@ static void __init set_ftrace_early_filters(void)
>  static int
>  ftrace_regex_release(struct inode *inode, struct file *file, int enable)
>  {
> -	struct seq_file *m = (struct seq_file *)file->private_data;
> +	struct seq_file *m = file->private_data;
>  	struct ftrace_iterator *iter;
>  	struct trace_parser *parser;
>  
> diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
> index 8683dec..10b82a1 100644
> --- a/kernel/trace/trace.c
> +++ b/kernel/trace/trace.c
> @@ -2257,7 +2257,7 @@ int tracing_open_generic(struct inode *inode, struct file *filp)
>  
>  static int tracing_release(struct inode *inode, struct file *file)
>  {
> -	struct seq_file *m = (struct seq_file *)file->private_data;
> +	struct seq_file *m = file->private_data;
>  	struct trace_iterator *iter;
>  	int cpu;
>  



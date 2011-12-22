Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686Ab1LVAMT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 19:12:19 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:51891 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab1LVAMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 19:12:15 -0500
X-Authority-Analysis: v=2.0 cv=SqgSGYy0 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=7CHv9HGwdLwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=q9Lo21TjUDtVh7s2V8kA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324512732.5916.111.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 1/7] ftrace: Change filter/notrace set functions to
 return exit code
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 21 Dec 2011 19:12:12 -0500
In-Reply-To: <1324493791-5688-2-git-send-email-jolsa@redhat.com>
References: <1324468136-3997-1-git-send-email-jolsa@redhat.com>
	 <1324493791-5688-1-git-send-email-jolsa@redhat.com>
	 <1324493791-5688-2-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 19:56 +0100, Jiri Olsa wrote:
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index b79ab33..7eb702f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -2912,8 +2912,11 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
>  	mutex_lock(&ftrace_regex_lock);
>  	if (reset)
>  		ftrace_filter_reset(hash);
> -	if (buf)
> -		ftrace_match_records(hash, buf, len);
> +	if (buf &&
> +	    !ftrace_match_records(hash, buf, len)) {

I'm fine with this patch, but the above line break is ugly. Put that on
one line, and it still is < 80 characters.

I could just take this patch and fix the above. No need to make a new
patch set for this one fix.

-- Steve

> +		ret = -EINVAL;
> +		goto out_regex_unlock;
> +	}
>  
>  	mutex_lock(&ftrace_lock);
>  	ret = ftrace_hash_move(ops, enable, orig_hash, hash);
> @@ -2923,6 +2926,7 @@ ftrace_set_regex(struct ftrace_ops *ops, unsigned char *buf, int len,
>  
>  	mutex_unlock(&ftrace_lock);
>  
> + out_regex_unlock:
>  	mutex_unlock(&ftrace_regex_lock);
>  
>  	free_ftrace_hash(hash);



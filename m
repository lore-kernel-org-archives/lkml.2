Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759026Ab2DYL3s (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 07:29:48 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:14566 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758638Ab2DYL3o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 07:29:44 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=DP5z0Fm-GvoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=pdiIOGQpc7p32w3lwnwA:9 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335353383.28106.162.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 3/4] ftrace: No return value for ftrace_process_locs
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, linux-kernel@vger.kernel.org
Date: Wed, 25 Apr 2012 07:29:43 -0400
In-Reply-To: <1335342219-2782-4-git-send-email-jolsa@redhat.com>
References: <1335342219-2782-1-git-send-email-jolsa@redhat.com>
	 <1335342219-2782-4-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 10:23 +0200, Jiri Olsa wrote:
> The return value of ftrace_process_locs is never checked. The function
> tries to update as many calls as possible and in case of error there's
> either warning output or ftrace_bug call.

No, the real bug is...

>  #ifdef CONFIG_MODULES
> @@ -3789,9 +3784,9 @@ void __init ftrace_init(void)
>  
>  	last_ftrace_enabled = ftrace_enabled = 1;
>  
> -	ret = ftrace_process_locs(NULL,
> -				  __start_mcount_loc,
> -				  __stop_mcount_loc);
> +	ftrace_process_locs(NULL,
> +			    __start_mcount_loc,
> +			    __stop_mcount_loc);

We should check the return code of ftrace_process_locs().

-- Steve

>  
>  	ret = register_module_notifier(&ftrace_module_nb);
>  	if (ret)



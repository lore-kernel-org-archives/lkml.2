Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753364Ab1LUPXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 10:23:46 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:45081 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751517Ab1LUPXp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 10:23:45 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=qLkpjsMThDcA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=D19gQVrFAAAA:8 a=20KFwNOVAAAA:8 a=6jxBsJtdXEPMm902llQA:9 a=cdW6xDTV6i2yTHuOpI8A:7 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1324481022.5916.81.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/8] ftrace: Fix possible NULL dereferencing in
 __ftrace_hash_rec_update
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiri Olsa <jolsa@redhat.com>
Cc: fweisbec@gmail.com, mingo@redhat.com, paulus@samba.org,
        acme@ghostprotocols.net, a.p.zijlstra@chello.nl,
        linux-kernel@vger.kernel.org, aarapov@redhat.com
Date: Wed, 21 Dec 2011 10:23:42 -0500
In-Reply-To: <1324468136-3997-3-git-send-email-jolsa@redhat.com>
References: <1323105776-26961-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-1-git-send-email-jolsa@redhat.com>
	 <1324468136-3997-3-git-send-email-jolsa@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.0.3-3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-12-21 at 12:48 +0100, Jiri Olsa wrote:
> We need to check the existence of the other_hash before
> we touch its count variable.
> 
> This issue is hit only when non global ftrace_ops is used.
> The global ftrace_ops is initialized with empty hashes.
> 

As this wasn't the first time this bug showed up, I fixed this by this
patch:

https://lkml.org/lkml/2011/12/21/197

So you can remove this patch as well.

-- Steve

> Signed-off-by: Jiri Olsa <jolsa@redhat.com>
> ---
>  kernel/trace/ftrace.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
> index 09007c0..7eb702f 100644
> --- a/kernel/trace/ftrace.c
> +++ b/kernel/trace/ftrace.c
> @@ -1372,7 +1372,8 @@ static void __ftrace_hash_rec_update(struct ftrace_ops *ops,
>  			if (filter_hash && in_hash && !in_other_hash)
>  				match = 1;
>  			else if (!filter_hash && in_hash &&
> -				 (in_other_hash || !other_hash->count))
> +				 (in_other_hash ||
> +				  !other_hash || !other_hash->count))
>  				match = 1;
>  		}
>  		if (!match)



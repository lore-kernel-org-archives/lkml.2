Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756291Ab2ASBUL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 20:20:11 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:60458 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752401Ab2ASBUJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 20:20:09 -0500
X-Authority-Analysis: v=2.0 cv=I83ntacg c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=UhQuX-oTrpoA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=ibZNfqGfNAz8go-EeSkA:9 a=q85V_gzgjcJFh-hc-eUA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326936007.17534.95.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 2/5] xt_log: Make printk() in sb_close() optional
From: Steven Rostedt <rostedt@goodmis.org>
To: Richard Weinberger <rw@linutronix.de>
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Richard Weinberger <richard@nod.at>
Date: Wed, 18 Jan 2012 20:20:07 -0500
In-Reply-To: <1326926610-17830-3-git-send-email-rw@linutronix.de>
References: <1326926610-17830-1-git-send-email-rw@linutronix.de>
	 <1326926610-17830-3-git-send-email-rw@linutronix.de>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-18 at 23:43 +0100, Richard Weinberger wrote:
> From: Richard Weinberger <richard@nod.at>
> 
> 

Missing change log. Note, the subject is not good enough of a
description.

-- Steve

> Signed-off-by: Richard Weinberger <richard@nod.at>
> ---
>  include/net/netfilter/xt_log.h |    9 ++++++---
>  1 files changed, 6 insertions(+), 3 deletions(-)
> 
> diff --git a/include/net/netfilter/xt_log.h b/include/net/netfilter/xt_log.h
> index 0dfb34a..767e08d 100644
> --- a/include/net/netfilter/xt_log.h
> +++ b/include/net/netfilter/xt_log.h
> @@ -39,10 +39,12 @@ static struct sbuff *sb_open(void)
>  	return m;
>  }
>  
> -static void sb_close(struct sbuff *m)
> +static void __sb_close(struct sbuff *m, int print)
>  {
> -	m->buf[m->count] = 0;
> -	printk("%s\n", m->buf);
> +	if (print) {
> +		m->buf[m->count] = 0;
> +		printk("%s\n", m->buf);
> +	}
>  
>  	if (likely(m != &emergency))
>  		kfree(m);
> @@ -52,3 +54,4 @@ static void sb_close(struct sbuff *m)
>  	}
>  }
>  
> +#define sb_close(m)	__sb_close(m, 1)



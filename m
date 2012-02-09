Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2BIBgI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 20:36:08 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:61415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750813Ab2BIBgH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 20:36:07 -0500
X-Authority-Analysis: v=2.0 cv=MaXuSuDf c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=kn8_q9ZxZNMA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=VnNF1IyMAAAA:8 a=2tZjTqkPNj3sqSrJRkkA:9 a=EjechaRy4jb96lPV7S4A:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1328751364.2200.124.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] parse-events: Allow expressions in __print_symbolic()
 fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, linux-kernel@vger.kernel.org
Date: Wed, 08 Feb 2012 20:36:04 -0500
In-Reply-To: <1315131959-7452-1-git-send-email-stefanha@linux.vnet.ibm.com>
References: <1315131959-7452-1-git-send-email-stefanha@linux.vnet.ibm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-09-04 at 11:25 +0100, Stefan Hajnoczi wrote:
> The __print_symbolic() function takes a sequence of key-value pairs for
> pretty-printing a constant.  The new kvm:kvm_exit print fmt uses the
> expression:
> 
>   __print_symbolic(..., { 0x040 + 1, "DB excp" }, ...)
> 
> Currently only atoms are supported and this print fmt fails to parse.
> This patch adds support for expressions instead of just atoms so that
> 0x040 + 1 is parsed successfully.

Egad! Doing some early spring cleaning of my Inbox I stumbled across
this patch.

I'll apply it now, thanks!

Hey, if you ever send me a patch and after a week I don't reply to it,
don't be afraid to ping me about it. I sometimes get swarms of email
that I skim over, and will sometimes miss something like this.

Thanks!

-- Steve

> 
> Signed-off-by: Stefan Hajnoczi <stefanha@linux.vnet.ibm.com>
> ---
>  parse-events.c |    7 +++++++
>  1 files changed, 7 insertions(+), 0 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 1cdc3a9..e9b7e7d 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -2110,6 +2110,13 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>  
>  		free_token(token);
>  		type = process_arg(event, arg, &token);
> +
> +		if (type == EVENT_OP)
> +			type = process_op(event, arg, &token);
> +
> +		if (type == EVENT_ERROR)
> +			goto out_free;
> +
>  		if (test_type_token(type, token, EVENT_DELIM, ","))
>  			goto out_free;
>  



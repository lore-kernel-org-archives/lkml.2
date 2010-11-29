Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753893Ab0K2Q0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 11:26:49 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:37782 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751602Ab0K2Q0s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 11:26:48 -0500
X-Authority-Analysis: v=1.1 cv=NFUeGz0loTdi/T6hXKngYYtckjed7x3pKvNOqmBBK18= c=1 sm=0 a=8cL3MtyfY58A:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=20KFwNOVAAAA:8 a=8ihFfIJwqyCAqWK5UNwA:9 a=Wgynq_MgBHPBeVnDFRCzWPRtz5sA:4 a=PUjeQqilurYA:10 a=jEp0ucaQiEUA:10 a=LaDIu8IYw2Jky5q_:21 a=49ovBrhUIj-Ag2jr:21 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] Don't spam trace report about missing fields
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-trace-users@vger.kernel.org
In-Reply-To: <1291047601-13879-1-git-send-email-avi@redhat.com>
References: <1291047601-13879-1-git-send-email-avi@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Mon, 29 Nov 2010 11:26:45 -0500
Message-ID: <1291048005.30543.731.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-11-29 at 18:20 +0200, Avi Kivity wrote:
> Instead of spamming the output with complaints about missing fields, simply
> return an error to the caller, which can print something out or do something
> more intelligent about them.
> 
> Fixes kvm plugin tracing older kernels.

Hmm, what about just passing in err=0?

-- Steve

> 
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  parse-events.c |   15 +++------------
>  1 files changed, 3 insertions(+), 12 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index f0b0324..7a4c3a6 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -4446,17 +4446,11 @@ int get_field_val(struct trace_seq *s, struct format_field *field,
>  		  const char *name, struct record *record,
>  		  unsigned long long *val, int err)
>  {
> -	if (!field) {
> -		if (err)
> -			trace_seq_printf(s, "<CANT FIND FIELD %s>", name);
> +	if (!field)
>  		return -1;
> -	}
>  
> -	if (pevent_read_number_field(field, record->data, val)) {
> -		if (err)
> -			trace_seq_printf(s, " %s=INVALID", name);
> +	if (pevent_read_number_field(field, record->data, val))
>  		return -1;
> -	}
>  
>  	return 0;
>  }
> @@ -4489,11 +4483,8 @@ void *pevent_get_field_raw(struct trace_seq *s, struct event_format *event,
>  
>  	field = pevent_find_field(event, name);
>  
> -	if (!field) {
> -		if (err)
> -			trace_seq_printf(s, "<CANT FIND FIELD %s>", name);
> +	if (!field)
>  		return NULL;
> -	}
>  
>  	/* Allow @len to be NULL */
>  	if (!len)



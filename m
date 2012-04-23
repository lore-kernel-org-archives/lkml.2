Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754921Ab2DWSid (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 14:38:33 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:32358 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754832Ab2DWSic (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 14:38:32 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=ssWGk-soENwA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=ZwQlH-4_4mVzRoqj_qkA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335206310.28106.111.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 05/11] parse-events: Use proper function parameter type
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 14:38:30 -0400
In-Reply-To: <1335157118-14658-6-git-send-email-namhyung.kim@lge.com>
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	 <1335157118-14658-6-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
> The param needs to be updated when setting args up so that
> the loop in process_defined_func() can see the correct
> param->type for the farg.

Ouch!

Applied, thanks!

-- Steve

> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 3e5ac44..b7c81d8 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -3396,6 +3396,7 @@ process_defined_func(struct trace_seq *s, void *data, int size,
>  			break;
>  		}
>  		farg = farg->next;
> +		param = param->next;
>  	}
>  
>  	ret = (*func_handle->func)(s, args);



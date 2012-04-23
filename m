Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab2DWPvR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 11:51:17 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:3125 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752013Ab2DWPvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 11:51:16 -0400
X-Authority-Analysis: v=2.0 cv=MNHiabll c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=02riegOredAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=57SyGIRnAAAA:8 a=gJRCKNI9cHgJULs8WxQA:9 a=PUjeQqilurYA:10 a=64oMysvvN-kA:10 a=TIV7c6GJmisA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1335196274.28106.101.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH 4/7] parse-events: Handle strdup failure cases
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung.kim@lge.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Date: Mon, 23 Apr 2012 11:51:14 -0400
In-Reply-To: <1333940074-19052-5-git-send-email-namhyung.kim@lge.com>
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	 <1333940074-19052-5-git-send-email-namhyung.kim@lge.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-04-09 at 11:54 +0900, Namhyung Kim wrote:
> There were some places didn't check return value of the strdup
> and had unneeded/duplicated checks. Fix it.
> 
> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
> ---
>  parse-events.c |   29 +++++++++++++++++++++++++++--
>  1 files changed, 27 insertions(+), 2 deletions(-)
> 
> diff --git a/parse-events.c b/parse-events.c
> index 0b1e40a..773c928 100644
> --- a/parse-events.c
> +++ b/parse-events.c
> @@ -463,8 +463,10 @@ int pevent_register_function(struct pevent *pevent, char *func,
>  		item->mod = NULL;
>  	item->addr = addr;
>  
> -	pevent->funclist = item;
> +	if (!item->func || (mod && !item->mod))
> +		die("malloc func");
>  

I just added this patch, but we need to get rid of all the "die"
functions and do proper freeing and error notifications to make this a
real library.

Thanks,

-- Steve



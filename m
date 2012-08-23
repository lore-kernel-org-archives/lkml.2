Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933443Ab2HWJa3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 05:30:29 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:31994 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932259Ab2HWJaZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 05:30:25 -0400
X-Authority-Analysis: v=2.0 cv=LIjkseq9 c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=CnhymWjh_EAA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=elah4ftNUEAA:10 a=meVymXHHAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=gu6fZOg2AAAA:8 a=hps_UrdzcsAUvVNZuwEA:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=GC8p-B92FUEA:10 a=NWVoK91CQyQA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1345714223.5069.45.camel@gandalf.local.home>
Subject: Re: [PATCH] tools lib traceevent: Fix off-by-one bug in
 pevent_strerror()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Thu, 23 Aug 2012 05:30:23 -0400
In-Reply-To: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
References: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-08-23 at 16:37 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> As pevent_errno is defined using PEVENT_ERRORS which uses _PE macro
> magic, the first errno is bigger than __PEVENT_ERRNO_START by 1. So we
> need to subtract the 1 also when calculating the index of the error
> strings.
> 
> Cc: Fredereic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index f978c59f67bf..b5b4d806ffa2 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -4822,7 +4822,7 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>  	    errnum >= __PEVENT_ERRNO__END)
>  		return -1;
>  
> -	idx = errnum - __PEVENT_ERRNO__START;
> +	idx = errnum - __PEVENT_ERRNO__START - 1;
>  	msg = pevent_error_str[idx];
>  

Note, if you had kept my original way, you wouldn't have this bug ;-)

http://marc.info/?l=linux-kernel&m=133976417632111

-- Steve

>  	switch (errnum) {



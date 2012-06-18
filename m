Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752139Ab2FRNhP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 09:37:15 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:10370 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751016Ab2FRNhN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 09:37:13 -0400
X-Authority-Analysis: v=2.0 cv=eIiRfQV1 c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=FNqztoQSzWUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=Se955t_jP1Xh-7t4e08A:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1340026630.25903.84.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH v2 1/5] tools lib traceevent: Replace malloc_or_die to
 plain calloc in alloc_event()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Date: Mon, 18 Jun 2012 09:37:10 -0400
In-Reply-To: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
References: <1339987851-22491-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-18 at 11:50 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Because the only caller of the alloc_event()
> (pevent_parse_event) checks return value properly
> and all it does after allocation is initializing,
> it can be changed to use plain calloc.
> 
> Thanks to Steven for suggesting this simpler way.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve


> Link: http://lkml.kernel.org/n/tip-wagq5qbdy1mytvjkrjbqt095@git.kernel.org
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c |    7 +------
>  1 file changed, 1 insertion(+), 6 deletions(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index c471075e4974..4f667fdc5fae 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -619,12 +619,7 @@ void pevent_print_printk(struct pevent *pevent)
>  
>  static struct event_format *alloc_event(void)
>  {
> -	struct event_format *event;
> -
> -	event = malloc_or_die(sizeof(*event));
> -	memset(event, 0, sizeof(*event));
> -
> -	return event;
> +	return calloc(1, sizeof(struct event_format));
>  }
>  
>  static void add_event(struct pevent *pevent, struct event_format *event)



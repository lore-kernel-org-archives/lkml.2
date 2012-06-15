Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755442Ab2FODbA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 23:31:00 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:4809 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752157Ab2FODa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 23:30:58 -0400
X-Authority-Analysis: v=2.0 cv=D8PF24tj c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=kmXZxglG5U4A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=57SyGIRnAAAA:8 a=pGLkceISAAAA:8 a=VwQbUJbxAAAA:8 a=3wCX1Dk-YWY1SBFbvy0A:9 a=PUjeQqilurYA:10 a=TIV7c6GJmisA:10 a=MSl-tDqOz04A:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1339731057.13377.313.camel@gandalf.stny.rr.com>
Subject: Re: [PATCH] tools lib traceevent: Replace malloc_or_die to plain
 malloc in alloc_event()
From: Steven Rostedt <rostedt@goodmis.org>
To: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Date: Thu, 14 Jun 2012 23:30:57 -0400
In-Reply-To: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
References: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 15:28 +0900, Namhyung Kim wrote:
> From: Namhyung Kim <namhyung.kim@lge.com>
> 
> Because the only caller of the alloc_event()
> (pevent_parse_event) checks return value properly,
> it can be changed to use plain malloc.
> 
> Cc: Frederic Weisbecker <fweisbec@gmail.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  tools/lib/traceevent/event-parse.c |    4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
> index c471075e4974..a6b5bcdc5580 100644
> --- a/tools/lib/traceevent/event-parse.c
> +++ b/tools/lib/traceevent/event-parse.c
> @@ -621,7 +621,9 @@ static struct event_format *alloc_event(void)
>  {
>  	struct event_format *event;
>  
> -	event = malloc_or_die(sizeof(*event));
> +	event = malloc(sizeof(*event));
> +	if (!event)
> +		return NULL;
>  	memset(event, 0, sizeof(*event));

Perhaps we should combined these to:

{
	struct event_format *event;

	event = calloc(1, sizeof(*event));
	return event;
}

Or even:

{
	return calloc(1, sizeof(struct event_format));
}


-- Steve


>  
>  	return event;



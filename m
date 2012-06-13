Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab2FMFvZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 01:51:25 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:46649 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750778Ab2FMFvY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 01:51:24 -0400
X-AuditID: 9c93016f-b7c3cae000001954-bd-4fd82a594be4
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tools lib traceevent: Replace malloc_or_die to plain malloc in alloc_event()
References: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
Date: Wed, 13 Jun 2012 14:48:27 +0900
In-Reply-To: <1339396133-9839-1-git-send-email-namhyung@kernel.org> (Namhyung
	Kim's message of "Mon, 11 Jun 2012 15:28:53 +0900")
Message-ID: <87aa0769uc.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

Could you take a look at this too?


On Mon, 11 Jun 2012 15:28:53 +0900, Namhyung Kim wrote:
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
>  
>  	return event;

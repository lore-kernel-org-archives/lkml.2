Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2FOIs1 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jun 2012 04:48:27 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:42178 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752544Ab2FOIsY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jun 2012 04:48:24 -0400
X-AuditID: 9c930197-b7b87ae000000e4d-9c-4fdaf6d0768d
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: Re: [PATCH] tools lib traceevent: Replace malloc_or_die to plain malloc in alloc_event()
References: <1339396133-9839-1-git-send-email-namhyung@kernel.org>
	<1339731057.13377.313.camel@gandalf.stny.rr.com>
Date: Fri, 15 Jun 2012 17:45:32 +0900
In-Reply-To: <1339731057.13377.313.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Thu, 14 Jun 2012 23:30:57 -0400")
Message-ID: <87mx453qvn.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, 14 Jun 2012 23:30:57 -0400, Steven Rostedt wrote:
> On Mon, 2012-06-11 at 15:28 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> Because the only caller of the alloc_event()
>> (pevent_parse_event) checks return value properly,
>> it can be changed to use plain malloc.
>> 
>> Cc: Frederic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/event-parse.c |    4 +++-
>>  1 file changed, 3 insertions(+), 1 deletion(-)
>> 
>> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
>> index c471075e4974..a6b5bcdc5580 100644
>> --- a/tools/lib/traceevent/event-parse.c
>> +++ b/tools/lib/traceevent/event-parse.c
>> @@ -621,7 +621,9 @@ static struct event_format *alloc_event(void)
>>  {
>>  	struct event_format *event;
>>  
>> -	event = malloc_or_die(sizeof(*event));
>> +	event = malloc(sizeof(*event));
>> +	if (!event)
>> +		return NULL;
>>  	memset(event, 0, sizeof(*event));
>
> Perhaps we should combined these to:
>
> {
> 	struct event_format *event;
>
> 	event = calloc(1, sizeof(*event));
> 	return event;
> }
>
> Or even:
>
> {
> 	return calloc(1, sizeof(struct event_format));
> }
>

Ok, I'll take this. Thanks.
Namhyung


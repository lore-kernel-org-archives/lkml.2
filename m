Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884Ab2DXAFv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:05:51 -0400
Received: from LGEMRELSE1Q.lge.com ([156.147.1.111]:45569 "EHLO
	LGEMRELSE1Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754218Ab2DXAFu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:05:50 -0400
X-AuditID: 9c93016f-b7cfcae00000449e-ba-4f95ee5cac04
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 01/11] parse-events: Free flag/sym field on failure path
References: <1335157118-14658-1-git-send-email-namhyung.kim@lge.com>
	<1335157118-14658-2-git-send-email-namhyung.kim@lge.com>
	<1335198066.28106.103.camel@gandalf.stny.rr.com>
Date: Tue, 24 Apr 2012 09:05:01 +0900
In-Reply-To: <1335198066.28106.103.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 23 Apr 2012 12:21:06 -0400")
Message-ID: <87ty0aro42.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Apr 2012 12:21:06 -0400, Steven Rostedt wrote:
> On Mon, 2012-04-23 at 13:58 +0900, Namhyung Kim wrote:
>> If parsing flag/sym field failed after allocating it, it
>> should be freed.
>> 
>> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
>> ---
>>  parse-events.c |   14 +++++++++-----
>>  1 file changed, 9 insertions(+), 5 deletions(-)
>> 
>> diff --git a/parse-events.c b/parse-events.c
>> index bd078ba..81e6581 100644
>> --- a/parse-events.c
>> +++ b/parse-events.c
>> @@ -2166,10 +2166,10 @@ process_fields(struct event_format *event, struct print_flag_sym **list, char **
>>  
>>  		value = arg_eval(arg);
>>  		if (value == NULL)
>> -			goto out_free;
>> +			goto out_free_field;
>
> Instead of adding more goto's what, before the first goto "out_free"
> add:
>
> 	field = NULL;
>
> and since the field is allocated and also memset to zero, we could do in
> the out_free:
>
> 	if (field) {
> 		free(field->value);
> 		free(field);
> 	}
>
> I think that would be cleaner.
>
> -- Steve
>

OK, will resend v2.

Thanks,
Namhyung

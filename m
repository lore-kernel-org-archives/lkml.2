Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755480Ab2DXAgk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 20:36:40 -0400
Received: from LGEMRELSE7Q.lge.com ([156.147.1.151]:61238 "EHLO
	LGEMRELSE7Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2DXAgj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 20:36:39 -0400
X-AuditID: 9c930197-b7ca1ae0000069e6-6c-4f95f596fcd7
From: Namhyung Kim <namhyung.kim@lge.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Borislav Petkov <bp@alien8.de>, David Ahern <dsahern@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/7] parse-events: Handle strdup failure cases
References: <1333940074-19052-1-git-send-email-namhyung.kim@lge.com>
	<1333940074-19052-5-git-send-email-namhyung.kim@lge.com>
	<1335196274.28106.101.camel@gandalf.stny.rr.com>
Date: Tue, 24 Apr 2012 09:35:50 +0900
In-Reply-To: <1335196274.28106.101.camel@gandalf.stny.rr.com> (Steven
	Rostedt's message of "Mon, 23 Apr 2012 11:51:14 -0400")
Message-ID: <87ehrermop.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.0.95 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, 23 Apr 2012 11:51:14 -0400, Steven Rostedt wrote:
> On Mon, 2012-04-09 at 11:54 +0900, Namhyung Kim wrote:
>> There were some places didn't check return value of the strdup
>> and had unneeded/duplicated checks. Fix it.
>> 
>> Signed-off-by: Namhyung Kim <namhyung.kim@lge.com>
>> ---
>>  parse-events.c |   29 +++++++++++++++++++++++++++--
>>  1 files changed, 27 insertions(+), 2 deletions(-)
>> 
>> diff --git a/parse-events.c b/parse-events.c
>> index 0b1e40a..773c928 100644
>> --- a/parse-events.c
>> +++ b/parse-events.c
>> @@ -463,8 +463,10 @@ int pevent_register_function(struct pevent *pevent, char *func,
>>  		item->mod = NULL;
>>  	item->addr = addr;
>>  
>> -	pevent->funclist = item;
>> +	if (!item->func || (mod && !item->mod))
>> +		die("malloc func");
>>  
>
> I just added this patch, but we need to get rid of all the "die"
> functions and do proper freeing and error notifications to make this a
> real library.
>

Agreed. I'm planning to dive into it soonish..

Thanks,
Namhyung

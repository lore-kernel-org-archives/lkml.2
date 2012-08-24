Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835Ab2HXAkG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 20:40:06 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:42864 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752918Ab2HXAkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 20:40:02 -0400
X-AuditID: 9c930179-b7cc4ae00000134d-ff-5036cd60a5e4
From: Namhyung Kim <namhyung@kernel.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Namhyung Kim <namhyung.kim@lge.com>
Subject: Re: [PATCH] tools lib traceevent: Fix off-by-one bug in pevent_strerror()
References: <1345707420-21767-1-git-send-email-namhyung@kernel.org>
	<1345714223.5069.45.camel@gandalf.local.home>
Date: Fri, 24 Aug 2012 09:33:22 +0900
In-Reply-To: <1345714223.5069.45.camel@gandalf.local.home> (Steven Rostedt's
	message of "Thu, 23 Aug 2012 05:30:23 -0400")
Message-ID: <87393di0x9.fsf@sejong.aot.lge.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Steve

On Thu, 23 Aug 2012 05:30:23 -0400, Steven Rostedt wrote:
> On Thu, 2012-08-23 at 16:37 +0900, Namhyung Kim wrote:
>> From: Namhyung Kim <namhyung.kim@lge.com>
>> 
>> As pevent_errno is defined using PEVENT_ERRORS which uses _PE macro
>> magic, the first errno is bigger than __PEVENT_ERRNO_START by 1. So we
>> need to subtract the 1 also when calculating the index of the error
>> strings.
>> 
>> Cc: Fredereic Weisbecker <fweisbec@gmail.com>
>> Cc: Steven Rostedt <rostedt@goodmis.org>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>> ---
>>  tools/lib/traceevent/event-parse.c | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/tools/lib/traceevent/event-parse.c b/tools/lib/traceevent/event-parse.c
>> index f978c59f67bf..b5b4d806ffa2 100644
>> --- a/tools/lib/traceevent/event-parse.c
>> +++ b/tools/lib/traceevent/event-parse.c
>> @@ -4822,7 +4822,7 @@ int pevent_strerror(struct pevent *pevent, enum pevent_errno errnum,
>>  	    errnum >= __PEVENT_ERRNO__END)
>>  		return -1;
>>  
>> -	idx = errnum - __PEVENT_ERRNO__START;
>> +	idx = errnum - __PEVENT_ERRNO__START - 1;
>>  	msg = pevent_error_str[idx];
>>  
>
> Note, if you had kept my original way, you wouldn't have this bug ;-)
>
> http://marc.info/?l=linux-kernel&m=133976417632111

Oh, I missed the BEFORE_START part at that time, sorry. :)

Thanks,
Namhyung

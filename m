Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759033Ab1FQOFG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 10:05:06 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:63751 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754768Ab1FQOFB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 10:05:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=n4ObGD2LCiNVC9gJrlNLhDWEvQoPnMYBoaYCEZ/yEJVb67M4Veee9wGCb0Y/QWkzNb
         Q4dgKu96XHCQERcwHVw1wMfMyo/zY/vMknQCwVSBCk0sQlp1xQFbtk7Gm1pUVPWWufFc
         NjGLB9ZNqBx3sJPGAYSv+WMUTSNo8Ps5V3mMY=
Message-ID: <4DFB5F0B.4020903@gmail.com>
Date: Fri, 17 Jun 2011 08:04:59 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 3/6] perf: add reference time event
References: <1307490806-24548-1-git-send-email-dsahern@gmail.com> <1307490946-24673-1-git-send-email-dsahern@gmail.com> <20110617133230.GC25197@somewhere.redhat.com>
In-Reply-To: <20110617133230.GC25197@somewhere.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 06/17/2011 07:32 AM, Frederic Weisbecker wrote:
> On Tue, Jun 07, 2011 at 05:55:46PM -0600, David Ahern wrote:
>> For initial perf_clock to time-of-day correlation.
>>
>> Signed-off-by: David Ahern <dsahern@gmail.com>
>> ---
>>  tools/perf/util/event.c   |    1 +
>>  tools/perf/util/event.h   |    8 ++++++++
>>  tools/perf/util/session.c |    4 ++++
>>  tools/perf/util/session.h |    3 ++-
>>  4 files changed, 15 insertions(+), 1 deletions(-)
>>
>> diff --git a/tools/perf/util/event.c b/tools/perf/util/event.c
>> index 3c1b8a6..1a89a04 100644
>> --- a/tools/perf/util/event.c
>> +++ b/tools/perf/util/event.c
>> @@ -24,6 +24,7 @@ static const char *perf_event__names[] = {
>>  	[PERF_RECORD_HEADER_TRACING_DATA]	= "TRACING_DATA",
>>  	[PERF_RECORD_HEADER_BUILD_ID]		= "BUILD_ID",
>>  	[PERF_RECORD_FINISHED_ROUND]		= "FINISHED_ROUND",
>> +	[PERF_RECORD_REFTIME]			= "REF_TIME",
>>  };
>>  
>>  const char *perf_event__name(unsigned int id)
>> diff --git a/tools/perf/util/event.h b/tools/perf/util/event.h
>> index 1d7f664..f481f90 100644
>> --- a/tools/perf/util/event.h
>> +++ b/tools/perf/util/event.h
>> @@ -98,6 +98,7 @@ enum perf_user_event_type { /* above any possible kernel type */
>>  	PERF_RECORD_HEADER_TRACING_DATA		= 66,
>>  	PERF_RECORD_HEADER_BUILD_ID		= 67,
>>  	PERF_RECORD_FINISHED_ROUND		= 68,
>> +	PERF_RECORD_REFTIME			= 69,
> 
> We would like to avoid adding more custom events like these. They were very convenient
> but they steal the kernel event type space. They are deemed for removal in the long term.
> 
> Another idea to achieve what you want would be to create a new perf event header feature,
> like HEADER_TRACE_INFO or HEADER_BUILD_ID are. Then use that to create a space in the perf
> file to save that couple of clocks initial values.

you mean like this:
https://lkml.org/lkml/2010/12/7/813

David

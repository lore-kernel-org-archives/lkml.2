Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753808Ab0KWNTd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 08:19:33 -0500
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40901 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab0KWNTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 08:19:32 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:cc:subject:references:date:in-reply-to:message-id
         :user-agent:mime-version:content-type;
        b=qqZyT5GUpd3klaVuhRxVVIoDhGauz/ukOJLfECGHbQjdZsp2YglIm0hh552P8UYcU/
         dbZaRQyMID2H/1ql0SPenCdF4KiNxkBVYZfn6lxwJn6gh0uOkRgcNkfSuFzKVhXMNqqX
         rfDLlfc5gbZ6gKLgbCvmRboQ38xrFTtCBS/e0=
From: Franck Bui-Huu <vagabon.xyz@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Franck Bui-Huu <vagabon.xyz@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: How about limiting refresh ioctl to sampling events ?
References: <m3zkt05h3w.fsf@gmail.com> <1290517646.2072.403.camel@laptop>
Date: Tue, 23 Nov 2010 14:19:25 +0100
In-Reply-To: <1290517646.2072.403.camel@laptop> (Peter Zijlstra's message of
	"Tue, 23 Nov 2010 14:07:26 +0100")
Message-ID: <m3vd3o5g9u.fsf@gmail.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter Zijlstra <a.p.zijlstra@chello.nl> writes:

> On Tue, 2010-11-23 at 14:01 +0100, Franck Bui-Huu wrote:
>> Hello Peter,
>> 
>> I'm looking at the perf event stuff and wondering if
>
>> perf_event_refresh() should be limited to sampling events.
>> 
>> Does the following make sense ?
>> 
>> diff --git a/kernel/perf_event.c b/kernel/perf_event.c
>> index 3b105e0..1a90a6c 100644
>> --- a/kernel/perf_event.c
>> +++ b/kernel/perf_event.c
>> @@ -1072,7 +1072,7 @@ static int perf_event_refresh(struct perf_event *event, int refresh)
>>  	/*
>>  	 * not supported on inherited events
>>  	 */
>> -	if (event->attr.inherit)
>> +	if (event->attr.inherit || !event->attr.sample_period)
>>  		return -EINVAL;
>>  
>>  	atomic_add(refresh, &event->event_limit);
>
> Yes it does, please submit as a proper patch.

Ok.

I'm also wondering if you would accept a second patch which will
introduce:

static inline bool is_sampling_event(struct perf_event *event)
{
        return event->attr.sample_period != 0;
}

That would make the code slighlty easier to read IMHO.

-- 
		Franck

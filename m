Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933240Ab2GCA2b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 20:28:31 -0400
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:57651 "EHLO
	LGEMRELSE6Q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933228Ab2GCA2a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 20:28:30 -0400
X-AuditID: 9c930179-b7cceae000004195-2b-4ff23cab370e
Message-ID: <4FF23CAA.8070108@lge.com>
Date: Tue, 03 Jul 2012 09:28:26 +0900
From: Namhyung Kim <namhyung.kim@lge.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Markus Trippelsdorf <markus@trippelsdorf.de>
Subject: Re: [PATCH] perf target: Ignore return value of strerror_r() explicitly
References: <1341210014-10113-1-git-send-email-namhyung@kernel.org> <20120702153426.GC12542@infradead.org>
In-Reply-To: <20120702153426.GC12542@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: AAAAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012-07-03 12:34 AM, Arnaldo Carvalho de Melo wrote:
> Em Mon, Jul 02, 2012 at 03:20:14PM +0900, Namhyung Kim escreveu:
>> Since glibc 2.16 added the warn_unused_result (wur) attribute
>> to the function, we should check the return value or ignore it
>> explicitly.
>>
>> Reported-by: Markus Trippelsdorf <markus@trippelsdorf.de>
>> Signed-off-by: Namhyung Kim <namhyung@kernel.org>
>
>> +++ b/tools/perf/util/target.c
>> @@ -111,7 +111,8 @@ int perf_target__strerror(struct perf_target *target, int errnum,
>>   	const char *msg;
>>
>>   	if (errnum >= 0) {
>> -		strerror_r(errnum, buf, buflen);
>> +		/* make glibc (>= 2.16) happy */
>> +		(void)strerror_r(errnum, buf, buflen);
>
> Is this really the best way to handle this?
>
> What if some perf tool is buggy and passes an invalid errnum?  Shouldn't
> we catch that?
>

$ man strerror_r
...
RETURN VALUE
        The  strerror()  and  the  GNU-specific strerror_r() functions
        return the appropriate error description string, or an
        "Unknown error nnn" message if the error number is unknown.

Isn't it sufficient? Or we can reset the @buf at the beginning for the case of 
a invalid negative @errnum.

Thanks,
Namhyung


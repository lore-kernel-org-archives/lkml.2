Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755460Ab0EYMlQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:41:16 -0400
Received: from toro.web-alm.net ([62.245.132.31]:48581 "EHLO toro.web-alm.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754053Ab0EYMlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:41:14 -0400
Message-ID: <4BFBC393.50207@osadl.org>
Date: Tue, 25 May 2010 14:33:23 +0200
From: Carsten Emde <C.Emde@osadl.org>
Organization: Open Source Automation Development Lab (OSADL) eG
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100430 Fedora/3.0.4-2.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org,
       Andrew Morton <akpm@linux-foundation.org>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: Re: [PATCH 2/4] tracing/sched: Fix task states in sched switch event
References: <RYmXFZH5FML2.rJxWwvD3@ce.dyn.web-alm.net> <20100513133539.GA17107@elte.hu>
In-Reply-To: <20100513133539.GA17107@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

>>> Hm, this is totally unreadable. What does 'TASK_STATE_X' mean??
>> Would this be better?
>> +#define MAKE_TASK_STATE_STRING(num) TASK_STATE_##num " (" DESCR_TASK_STATE_##num ")"
>>   static const char *task_state_array[] = {
>> -	"R (running)",		/*   0 */
>> -	"S (sleeping)",		/*   1 */
>> -	"D (disk sleep)",	/*   2 */
>> -	"T (stopped)",		/*   4 */
>> -	"t (tracing stop)",	/*   8 */
>> -	"Z (zombie)",		/*  16 */
>> -	"X (dead)",		/*  32 */
>> -	"x (dead)",		/*  64 */
>> -	"K (wakekill)",		/* 128 */
>> -	"W (waking)",		/* 256 */
>> +	MAKE_TASK_STATE_STRING(0),
>> +	MAKE_TASK_STATE_STRING(1),
>> +	MAKE_TASK_STATE_STRING(2),
>> +	MAKE_TASK_STATE_STRING(4),
>> +	MAKE_TASK_STATE_STRING(8),
>> +	MAKE_TASK_STATE_STRING(16),
>> +	MAKE_TASK_STATE_STRING(32),
>> +	MAKE_TASK_STATE_STRING(64),
>> +	MAKE_TASK_STATE_STRING(128),
>> +	MAKE_TASK_STATE_STRING(256)
>
> The whole enumeration there is pointless in that .c file - it tells nothing to
> the code reader.
>
> If it cannot be expressed in a meaningful way then introduce
> TASK_STATE_STRINGS_INIT construct that is defined next to the strings (in a .h
> file or so) - that way it's a coherent whole.
This is what I did and submitted some time ago. Is there anything else
you want me to change?

Thanks,

	Carsten.

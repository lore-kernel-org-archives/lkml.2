Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab1CJAEk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:04:40 -0500
Received: from sj-iport-2.cisco.com ([171.71.176.71]:4204 "EHLO
	sj-iport-2.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab1CJAEj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:04:39 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAD6kd02rR7Hu/2dsb2JhbACmcnSmeJw1hWUEhSKHGINIgiM
X-IronPort-AV: E=Sophos;i="4.62,292,1297036800"; 
   d="scan'208";a="318808021"
Message-ID: <4D78158F.6010403@cisco.com>
Date: Wed, 09 Mar 2011 17:04:31 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: Frederic Weisbecker <fweisbec@gmail.com>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [PATCH 07/10] perf script: Move printing of 'common' data from
 print_event and rename
References: <1299695491-15786-1-git-send-email-acme@infradead.org> <1299695491-15786-8-git-send-email-acme@infradead.org> <20110309235007.GB2533@nowhere>
In-Reply-To: <20110309235007.GB2533@nowhere>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 03/09/11 16:50, Frederic Weisbecker wrote:

>> +++ b/tools/perf/util/trace-event-parse.c
>> @@ -2648,63 +2648,8 @@ static void print_lat_fmt(void *data, int size __unused)
>>  		printf("%d", lock_depth);
>>  }
>>  
>> -/* taken from Linux, written by Frederic Weisbecker */
>> -static void print_graph_cpu(int cpu)
>> -{
>> -	int i;
>> -	int log10_this = log10_cpu(cpu);
>> -	int log10_all = log10_cpu(cpus);
>> -
>> -
>> -	/*
>> -	 * Start with a space character - to make it stand out
>> -	 * to the right a bit when trace output is pasted into
>> -	 * email:
>> -	 */
>> -	printf(" ");
>> -
>> -	/*
>> -	 * Tricky - we space the CPU field according to the max
>> -	 * number of online CPUs. On a 2-cpu system it would take
>> -	 * a maximum of 1 digit - on a 128 cpu system it would
>> -	 * take up to 3 digits:
>> -	 */
>> -	for (i = 0; i < log10_all - log10_this; i++)
>> -		printf(" ");
>> -
>> -	printf("%d) ", cpu);
>> -}
> 
> So, we indeed don't use the function graph tracer with perf yet.
> But there are fair chances we will in the future.
> 
> So if we remove such code, I would prefer this to be made as
> a seperate commit. Something we can easily retrieve and revert
> in the future.

Once the references to the functions are removed, compile fails --
functions defined without a user.

I left the cpu arg into print_trace_event to avoid having to delete even
more code because of that.

David


> 
> Other than that and the callchain bug, the whole series looks
> pretty good now.
> 
> Thanks a lot!

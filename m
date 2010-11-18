Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759875Ab0KRRHR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 12:07:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:41086 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab0KRRHP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 12:07:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,218,1288594800"; 
   d="scan'208";a="350463681"
Message-ID: <4CE55D15.1020908@linux.intel.com>
Date: Thu, 18 Nov 2010 09:06:29 -0800
From: Darren Hart <dvhart@linux.intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: Pekka Enberg <penberg@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [patch] trace: Add user-space event tracing/injection
References: <alpine.LFD.2.00.1011162103580.2900@localhost6.localdomain6> <4CE38C53.8090606@kernel.org> <20101117120740.GA24972@elte.hu> <4CE47ED0.7080901@linux.intel.com> <20101118085513.GH26398@elte.hu>
In-Reply-To: <20101118085513.GH26398@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:55 AM, Ingo Molnar wrote:
>
> * Darren Hart<dvhart@linux.intel.com>  wrote:
>
>> Ideally I would like to see something just like trace_printf()
>> without having to define it myself in each of my testcases. [...]
>
> We can make the prctl a single-argument thing, at the cost of not allowing \0 in the
> content. (which is probably sane anyway)
>
> That way deployment is super-simple:
>
> 	prctl(35, "My Trace Message");
> 	...
>
>
> 	if (asprintf(&msg, "My Trace Message: %d\n", 1234) != -1) {
> 		prctl(35, *msg);
> 		free(*msg);
> 	}


I think that would be ideal.

-- 
Darren Hart
Yocto Linux Kernel

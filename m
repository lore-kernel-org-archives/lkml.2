Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759115Ab0GPTk4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 15:40:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39721 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759101Ab0GPTkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 15:40:55 -0400
Message-ID: <4C40B57A.1090107@redhat.com>
Date: Fri, 16 Jul 2010 22:39:38 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100621 Fedora/3.0.5-1.fc13 Thunderbird/3.0.5
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Steven Rostedt <rostedt@rostedt.homelinux.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>,
        Li Zefan <lizf@cn.fujitsu.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Tom Zanussi <tzanussi@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Andi Kleen <andi@firstfloor.org>, akpm@osdl.org,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        "Frank Ch. Eigler" <fche@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com> <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com> <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com> <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com> <4C409F62.6030303@zytor.com> <4C40A1BD.4040507@redhat.com> <20100716182240.GA23215@Krystal> <4C40A5A0.3010107@redhat.com> <4C40B324.4040907@zytor.com>
In-Reply-To: <4C40B324.4040907@zytor.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/16/2010 10:29 PM, H. Peter Anvin wrote:
> On 07/16/2010 11:32 AM, Avi Kivity wrote:
>    
>> How long would vmalloc_sync_all take with a few thousand mm_struct take?
>>
>> We share the pmds, yes?  So it's a few thousand memory accesses.  The
>> direct impact is probably negligible, compared to actually loading the
>> module from disk.  All we need is to make sure the locking doesn't slow
>> down unrelated stuff.
>>
>>      
> It's not the memory accesses, it's the need to synchronize all the CPUs.
>    

I'm missing something.  Why do we need to sync all cpus?  the 
vmalloc_sync_all() I'm reading doesn't.

Even if we do an on_each_cpu() somewhere, it isn't the end of the world.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.


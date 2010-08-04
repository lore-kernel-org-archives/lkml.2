Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934746Ab0HDU1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 16:27:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47656 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758986Ab0HDU1A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 16:27:00 -0400
Message-ID: <4C59CC54.7080809@zytor.com>
Date: Wed, 04 Aug 2010 13:23:48 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.7) Gecko/20100720 Fedora/3.1.1-1.fc13 Thunderbird/3.1.1
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Avi Kivity <avi@redhat.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, Ingo Molnar <mingo@elte.hu>,
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
        "Frank Ch. Eigler" <fche@redhat.com>,
        David Howells <dhowells@redhat.com>
Subject: Re: [patch 2/2] x86 NMI-safe INT3 and Page Fault
References: <20100714154923.947138065@efficios.com>	 <20100714155804.252253097@efficios.com> <4C405078.20707@redhat.com>	 <20100716144927.GA22516@Krystal> <4C408D0C.5050709@redhat.com>	 <20100716165855.GA3836@Krystal> <4C409CBA.1050709@redhat.com>	 <4C409F62.6030303@zytor.com> <1280915205.1923.882.camel@laptop>
In-Reply-To: <1280915205.1923.882.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/04/2010 02:46 AM, Peter Zijlstra wrote:
> On Fri, 2010-07-16 at 11:05 -0700, H. Peter Anvin wrote:
>>
>> I really hope noone ever gets the idea of touching user space from an
>> NMI handler, though, and expecting it to work... 
> 
> Perf actually already does that to unwind user-space stacks... ;-)
> 
> See arch/x86/kernel/cpu/perf_event.c:copy_from_user_nmi() and its users.
> 
> What we do is a manual page table walk (using __get_user_pages_fast) and
> simply bail when the page is not available.
> 

That's not really "touching user space", though.

	-hpa

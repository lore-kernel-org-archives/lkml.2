Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752191Ab1HQAIP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Aug 2011 20:08:15 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:36133 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab1HQAIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Aug 2011 20:08:15 -0400
Message-ID: <4E4B0667.8090107@gmail.com>
Date: Tue, 16 Aug 2011 18:08:07 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110707 Thunderbird/5.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Borislav Petkov <bp@alien8.de>, Arjan van de Ven <arjan@infradead.org>
Subject: Re: [RFC][PATCH 1/8] perf: Separate out trace-cmd parse-events from
 perf files
References: <20110805205921.909038487@goodmis.org>  <20110805211300.324726820@goodmis.org>  <4E4945F8.2080004@gmail.com> <1313425364.15704.9.camel@gandalf.stny.rr.com>
In-Reply-To: <1313425364.15704.9.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2011 10:22 AM, Steven Rostedt wrote:
> On Mon, 2011-08-15 at 10:14 -0600, David Ahern wrote:
>> Hi Steve:
>>
>> On 08/05/2011 02:59 PM, Steven Rostedt wrote:
>>> From: Steven Rostedt <srostedt@redhat.com>
>>>
>>> Move the trace-event-parse.c code that originally came from trace-cmd into
>>> their own files. The new file will be called trace-parse-events.c, as
>>> the name of trace-cmd's file was parse-events.c too, but it conflicted
>>> with the parse-events.c file in perf that parses the command line.
>>>
>>> This tries to update the code with mimimal changes.
>>>
>>> Perf specific code stays in the trace-event-parse.[ch] files and
>>> the common parsing code is now in trace-parse-events.c and
>>> trace-parse-events.h.
>>
>> What branch should these apply cleanly to?
> 
> They are based off of v3.0. You can get these patches from my repo as
> described in the 0/8 announce email.

Unfortunately I hastily deleted the 0/8 thread while on vacation last
week (gmail on Android thing), so I apologize for shifting the discussion.

With a little bit of hacking on top of your patches I was able to get
the trace-cmd plugins working with perf. e.g.,
        qemu-kvm 11971 [001] 30401.777391: kvm_apic_accept_irq: apicid 0
vec 239 (Fixed|edge)
        qemu-kvm 11971 [001] 30401.777405: kvm_inj_virq: irq 239
        qemu-kvm 11971 [001] 30401.777415: kvm_entry: vcpu 0
        qemu-kvm 11971 [001] 30401.777430: kvm_exit: reason APIC_ACCESS
rip 0xffffffff8101dbe4 info 10b0 0

So, what is the next step for making this a reality -- i.e., getting the
common code into a lib in tools?

David

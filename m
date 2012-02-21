Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752347Ab2BUQSv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Feb 2012 11:18:51 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5367 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751913Ab2BUQSu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Feb 2012 11:18:50 -0500
Message-ID: <4F43C3CF.7000101@redhat.com>
Date: Tue, 21 Feb 2012 14:18:23 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120209 Thunderbird/10.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@amd64.org>
CC: Steven Rostedt <rostedt@goodmis.org>, Ingo Molnar <mingo@elte.hu>,
        Tony Luck <tony.luck@intel.com>,
        edac-devel <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: RAS trace event proto
References: <20120220145920.GB5728@aftab> <4F438CE9.7080807@redhat.com> <20120221141231.GA15515@aftab> <1329835698.25686.60.camel@gandalf.stny.rr.com> <20120221145943.GB15515@aftab>
In-Reply-To: <20120221145943.GB15515@aftab>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 21-02-2012 12:59, Borislav Petkov escreveu:
> On Tue, Feb 21, 2012 at 09:48:18AM -0500, Steven Rostedt wrote:
>> On Tue, 2012-02-21 at 15:12 +0100, Borislav Petkov wrote:
>>
>>>> Also, folding everything into just one string prevents (or make hard) the usage of
>>>> the perf filters, for example, to filter only the errors at the memory controller 1.
>>>
>>> Huh, because you can't grep through the trace anymore...?
>>>
>>
>> I believe Mauro is talking about the tracing filters used by both perf
>> and ftrace that lets you ignore trace events when the contents of the
>> event does not match the filter. This is filtering out events before
>> they go to the buffer.

Yes, that's what I'm talking about.

Another advantage of using separate fields for the silkscreen label and for
the additional details is that the userspace program that it is displaying
it (trace-cmd or whatever) could have different profiles to either display
just the error message and the silkscreen label or to print the entire error
message.

> Oh ok, in that case we could filter the errors - if needed - before they
> get even reported. I say "if needed" because normally we want to collect
> all hw errors in the trace, IMHO.



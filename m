Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755673Ab1BIVXL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 16:23:11 -0500
Received: from terminus.zytor.com ([198.137.202.10]:41178 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752630Ab1BIVXI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 16:23:08 -0500
Message-ID: <4D53057B.6020008@zytor.com>
Date: Wed, 09 Feb 2011 13:22:03 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Andi Kleen <andi@firstfloor.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Michal Marek <mmarek@suse.cz>
Subject: Re: [RFC][PATCH 2/4] ftrace: Add -mfentry to Makefile on function
 tracer
References: <20110209200249.111932716@goodmis.org>	 <20110209201029.772571775@goodmis.org> <1297283332.23343.29.camel@gandalf.stny.rr.com>
In-Reply-To: <1297283332.23343.29.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/09/2011 12:28 PM, Steven Rostedt wrote:
> On Wed, 2011-02-09 at 15:02 -0500, Steven Rostedt wrote:
> 
>>  ifdef CONFIG_FUNCTION_TRACER
>> -KBUILD_CFLAGS	+= -pg
>> +ifdef CONFIG_HAVE_FENTRY
>> +CC_HAS_FENTRY	:= $(call cc-option, -mfentry -DCC_HAS_FENTRY)
> 
> I should include a thanks to H. Peter Anvin in the change log for
> telling me about the cc-option trick.
> 

Actually we should probably calling this -DCC_USING_FENTRY or something
like that, since as coded above it includes the CONFIG_FUNCTION_TRACER
dependency.  This is a good thing -- it makes the conditionals easier --
we just also want to make sure they don't get misunderstood.

	-hpa

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758719Ab2EVOUl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 10:20:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:42576 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756683Ab2EVOUf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 10:20:35 -0400
Message-ID: <4FBBA094.3090703@redhat.com>
Date: Tue, 22 May 2012 17:20:04 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Paul Turner <pjt@google.com>, Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Subject: Re: NMI vs #PF clash
References: <4FBB8C40.6080304@redhat.com>  <1337693441.13348.36.camel@gandalf.stny.rr.com>  <4FBB986F.5030306@redhat.com> <1337695780.13348.41.camel@gandalf.stny.rr.com>
In-Reply-To: <1337695780.13348.41.camel@gandalf.stny.rr.com>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/22/2012 05:09 PM, Steven Rostedt wrote:
>> > 
>> > Or we could just have the NMI always restore the cr2 register.
>> 
>> IMO that's best.
> 
> OK, I can whip up a patch, but I wont push that in till 3.6.
> 

Thanks.  Something I've noticed is that writing cr2 is slow, so you may
want to write it only if it has changed (which should be very rare).


-- 
error compiling committee.c: too many arguments to function

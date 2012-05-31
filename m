Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933164Ab2EaT2A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 May 2012 15:28:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:57217 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933128Ab2EaT17 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 May 2012 15:27:59 -0400
Message-ID: <4FC7C62C.1020807@zytor.com>
Date: Thu, 31 May 2012 12:27:40 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Dave Jones <davej@redhat.com>, Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 4/5] x86: Allow nesting of the debug stack IDT setting
References: <20120531012829.160060586@goodmis.org>  <20120531020441.500105258@goodmis.org> <4FC7BF59.3070906@zytor.com> <1338492300.13348.384.camel@gandalf.stny.rr.com>
In-Reply-To: <1338492300.13348.384.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2012 12:25 PM, Steven Rostedt wrote:
>> void debug_stack_set_zero(void)
>> {
>> 	if (this_cpu_inc_return(debug_stack_use_ctr) == 1)
> 
> If an NMI comes in here, it will not update the IDT and will corrupt the
> stack. The load_idt() must happen for all calls. There's only two static
> IDT tables. It's either one or the other. Thus, if it loads it twice, it
> will just set it to the same value. The counter is to know when to set
> it back.
> 

Now I'm really confused.  Why would it have to set it if it is already set?

	-hpa


-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.


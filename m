Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752511Ab2GSWxl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jul 2012 18:53:41 -0400
Received: from terminus.zytor.com ([198.137.202.10]:43400 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752384Ab2GSWxj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jul 2012 18:53:39 -0400
Message-ID: <50088FD4.4060401@zytor.com>
Date: Thu, 19 Jul 2012 15:53:08 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        yrl.pp-manager.tt@hitachi.com
Subject: Re: [RFC][PATCH 2/4 v4] ftrace/x86: Add save_regs for i386 function
 calls
References: <20120711195048.885039013@goodmis.org>  <20120711195745.379060003@goodmis.org> <4FFEC58E.5070202@hitachi.com>  <1342205273.30075.19.camel@gandalf.stny.rr.com>  <1342627145.11900.7.camel@gandalf.stny.rr.com>  <50076ED9.3000100@hitachi.com>  <1342702344.12353.16.camel@gandalf.stny.rr.com> <1342702682.12353.20.camel@gandalf.stny.rr.com>
In-Reply-To: <1342702682.12353.20.camel@gandalf.stny.rr.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2012 05:58 AM, Steven Rostedt wrote:
>>
>> also, because lea is faster than add (and doesn't even modify flags), I
>> changed the last part to use lea instead of addl.
> 
> Now I'm told that this is not always the case (at least not for Atom),
> so I reverted this part and put back the addl. But can you still give
> you reviewed by for the first part?
> 

lea is not typically faster than add, but in the case of Atom, it is
done in an earlier pipeline stage (AGU instead of ALU) which means lea
is faster if its inputs are already available as address expressions and
is consumed by address expressions; the goal is to avoid the ALU->AGU
forwarding latency.

	-hpa



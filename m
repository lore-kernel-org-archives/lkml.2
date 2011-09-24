Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753366Ab1IXDrB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 23:47:01 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42102 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302Ab1IXDq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 23:46:59 -0400
Message-ID: <4E7D52AE.4000106@gmail.com>
Date: Fri, 23 Sep 2011 21:46:54 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>,
        Darren Hart <dvhart@linux.intel.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric B Munson <emunson@mgebm.net>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ian Munsie <imunsie@au1.ibm.com>, Ingo Molnar <mingo@elte.hu>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Mike Galbraith <efault@gmx.de>, Paul Mackerras <paulus@samba.org>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Peter Zijlstra <peterz@infradead.org>,
        Robert Richter <robert.richter@amd.com>,
        Stephane Eranian <eranian@google.com>,
        Thomas Gleixner <tglx@linutronix.de>, yrl.pp-manager.tt@hitachi.com
Subject: Re: [GIT PULL 00/12] perf tools fixes
References: <1316809586-28529-1-git-send-email-acme@infradead.org> <CA+55aFwVrvMa1z7P5q0kUN3QAwZzTdL1mhLaF7+etHYQm511vA@mail.gmail.com> <CA+55aFysPyDCjs3MTwHBRWVq5OTU=-aWCRiJP=VZL-EdCGNU0w@mail.gmail.com> <20110923211158.GC27519@ghostprotocols.net> <20110923212523.GD27519@ghostprotocols.net> <CA+55aFwfobHqXYJbKZTn_6Z_wEhqHxpZO4rRMgOUtJW=L5pzYg@mail.gmail.com> <20110923234621.GC8543@ghostprotocols.net>
In-Reply-To: <20110923234621.GC8543@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 09/23/2011 05:46 PM, Arnaldo Carvalho de Melo wrote:
> Em Fri, Sep 23, 2011 at 04:12:54PM -0700, Linus Torvalds escreveu:
>> On Fri, Sep 23, 2011 at 2:25 PM, Arnaldo Carvalho de Melo
>> <acme@infradead.org> wrote:
>>>
>>> Sorry about the noise, there is a problem in the way the python binding
>>> is built, i.e. it should notice that the header changed and rebuild the
>>> python binding, I bet this was what made David not notice it :-\
>>
>> Can you please make sure that gets fixed at some point too? No huge
>> hurry, it can wait for the next merge window, but bugs like that not
>> only cause this kind of stupid compile errors, they also cause really
>> odd "why doesn't it work" problems that people can spend tons and tons
>> of time debugging, because they don't really "exist" - they're just a
>> result of a stale object file that didn't get properly recompiled.
> 
> Will get that fixed. Its a hell of a lot annoying to me.

My sincere apologies for introducing such a dumb failure; I always test
the hell out of my patches before submitting them.

In this case I did not have the python-devel rpm installed, so the
python path in perf was not traversed and I did not trip on this.
Situation remedied on my end.

Yes, the correct arg is 0.

David


>  
>>> You noticed it probably because it was the first build of the tool on
>>> your local repo or used a new O= output dir.
>>
>> I do "git clean -dqfx" every once in a while (especially after having
>> done "make allmodconfig" builds before -rc releases etc), and I don't
>> recompile the perf tools very often. So yeah, this was the first build
>> after a cleanout event.
> 
> Thanks for testing it that way. I'll do my best not to fail in such last
> minute -rc tests. <expletives about world-as-whe-known-it-falling-apart>
> removed. :-P
> 
> - Arnaldo

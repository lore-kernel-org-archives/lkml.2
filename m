Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756662Ab0JYV4A (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 17:56:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35239 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753373Ab0JYVz7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 17:55:59 -0400
Message-ID: <4CC5FC99.8090203@zytor.com>
Date: Mon, 25 Oct 2010 14:54:33 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Thunderbird/3.1.4
MIME-Version: 1.0
To: Jason Baron <jbaron@redhat.com>
CC: Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Koki Sanagi <sanagi.koki@jp.fujitsu.com>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>,
        Frederic Weisbecker <fweisbec@gmail.com>, nhorman@tuxdriver.com,
        scott.a.mcmillan@intel.com, laijs@cn.fujitsu.com,
        LKML <linux-kernel@vger.kernel.org>, eric.dumazet@gmail.com,
        kaneshige.kenji@jp.fujitsu.com, David Miller <davem@davemloft.net>,
        izumi.taku@jp.fujitsu.com, kosaki.motohiro@jp.fujitsu.com,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        "Luck, Tony" <tony.luck@intel.com>
Subject: Re: [PATCH] tracing: Cleanup the convoluted softirq tracepoints
References: <alpine.LFD.2.00.1010191558250.6815@localhost6.localdomain6> <20101019142820.GA14520@Krystal> <alpine.LFD.2.00.1010191842270.6815@localhost6.localdomain6> <1287521757.16971.397.camel@gandalf.stny.rr.com> <alpine.LFD.2.00.1010192302000.6815@localhost6.localdomain6> <1287523439.16971.433.camel@gandalf.stny.rr.com> <4CBE122B.9020807@zytor.com> <20101019224126.GD3519@Krystal> <4CBE206A.20702@zytor.com> <1287529515.16971.538.camel@gandalf.stny.rr.com> <20101020152745.GA7348@redhat.com>
In-Reply-To: <20101020152745.GA7348@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20/2010 08:27 AM, Jason Baron wrote:
> 
> sure. The idea of the 'jmp 0' was simply to be an lcd for x86, if
> there's a better lcd for x86, I'll update it. But note, that since the
> 'jmp 0' is patched to a better nop at boot, we wouldn't see much gain.
> And in the boot path we are using 'text_poke_early()', so avoiding that
> isn't going to improve things much.
> 

It's still a completely unnecessary waste of startup time some
potentially significant fraction of the time.  Startup time matters,
especially as the number of tracepoints grow.

	-hpa

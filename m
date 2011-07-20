Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751951Ab1GTTDw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 15:03:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:50071 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751545Ab1GTTDu convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 15:03:50 -0400
MIME-Version: 1.0
In-Reply-To: <1311187978.29152.58.camel@twins>
References: <20110720001738.GA16369@linux.vnet.ibm.com> <201107192130.02080.edt@aei.ca>
 <201107192207.33813.edt@aei.ca> <20110720044435.GB2400@linux.vnet.ibm.com>
 <CA+55aFyaCY=qzFKswi2NR097KZtb5x98sba3rHJ7B0rchtzm2g@mail.gmail.com>
 <20110720133443.GG2400@linux.vnet.ibm.com> <4E270A0E.6090902@candelatech.com>
 <20110720171532.GB2313@linux.vnet.ibm.com> <20110720184413.GD17977@elte.hu> <1311187978.29152.58.camel@twins>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 20 Jul 2011 12:02:47 -0700
Message-ID: <CA+55aFyuKTj3zEvWJEx4_RDzLQ+ipJ58UWFYH84nmcwGF_c4aA@mail.gmail.com>
Subject: Re: [PATCH rcu/urgent 0/6] Fixes for RCU/scheduler/irq-threads trainwreck
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@elte.hu>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ben Greear <greearb@candelatech.com>, Ed Tomlinson <edt@aei.ca>,
        linux-kernel@vger.kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@polymtl.ca, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, rostedt@goodmis.org, Valdis.Kletnieks@vt.edu,
        dhowells@redhat.com, eric.dumazet@gmail.com, darren@dvhart.com,
        patches@linaro.org, edward.tomlinson@aero.bombardier.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:52 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>>  6 files changed, 105 insertions(+), 30 deletions(-)
>>
>> looks very scary to me.
>
> A lot of that is also relevant to !BOOST.

Can we limit this somehow? Or split it up? Which part of this is "fix
new BOOST features, not ever even executed without BOOST", and which
part of this is "fixes core stuff"?

I *really* hate the timing of this. The code that is only impacted by
BOOST I cannot find it in myself to care about, and I'd be willing to
consider it basically EXPERIMENTAL and just pulling it.

IOW, is the core non-boost fix just a few obvious oneliners?

The "it all broke completely" in previous version of this also doesn't
make me get all the warm fuzzies. Which all makes me go "what is
minimal and really really SAFE?"

            Linus

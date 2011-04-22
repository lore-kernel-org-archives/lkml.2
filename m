Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756430Ab1DVRhC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 13:37:02 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:52282 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756210Ab1DVRg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 13:36:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=tZkXSxWODJOT3AuQYlTCBiK4R20xKyJG2DNJQTzyhRlGPgUexv0ycuWGnoIR759Mmd
         /bb6kJ0HC5E98lkCAxOO6KPzU/FcIANJKl4wDWcH/mfSMdYZhnlSVgDxBNjJrVlwfuOb
         k0DU8D+iULjuaZbQm+KJcimoLB/QA5ZXJqTAc=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110422150222.GA2300@linux.vnet.ibm.com>
References: <BANLkTikVW9Z=WxD7=w9c=Z6kHO-Za2ru8A@mail.gmail.com>
	<20110414224411.GF2141@linux.vnet.ibm.com>
	<20110421050823.GA4487@linux.vnet.ibm.com>
	<BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
	<BANLkTi=c=+JnU9dQsVhgjZbOtArhHQz+EQ@mail.gmail.com>
	<BANLkTimEWqBVdq8MWbjAAfXCLPQdiHkuNg@mail.gmail.com>
	<20110421142853.GA2235@linux.vnet.ibm.com>
	<BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
	<20110422005046.GQ2235@linux.vnet.ibm.com>
	<BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
	<20110422150222.GA2300@linux.vnet.ibm.com>
Date: Fri, 22 Apr 2011 19:36:58 +0200
Message-ID: <BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 22, 2011 at 5:02 PM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Fri, Apr 22, 2011 at 11:40:54AM +0200, Sedat Dilek wrote:
>> On Fri, Apr 22, 2011 at 2:50 AM, Paul E. McKenney
>> <paulmck@linux.vnet.ibm.com> wrote:
>> > On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
>> >> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
>> >> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
>> >> >> <sedat.dilek@googlemail.com> wrote:
>> >
>> > [ . . . ]
>> >
>> >> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
>> >> >
>> >> > OK, and the grace periods clearly stopped advancing early on.
>> >> >
>> >> > Beyond that point, the per-CPU kthread is blocked, but RCU has some
>> >> > work for it to do.  So someone has called invoke_rcu_cpu_kthread(),
>> >> > but rcu_cpu_kthread() is still blocked.  I don't see a bug right
>> >> > off-hand, but it is early in the morning for me, so I might easily
>> >> > be missing something.
>> >> >
>> >> > Hmmm...
>> >> >
>> >> > The synchronization between these two assumes that the per-CPU
>> >> > kthread is always bound to the respective CPU, so if was somehow
>> >> > being migrated off, that might explain these results.
>> >> >
>> >> > I will add some more diagnostics, test them locally, then push
>> >> > out an update.  Seem reasonable?
>> >> >
>> >> > And thank you again for the testing!!!
>> >>
>> >> Ping me when you have new stuff for testing.
>> >> Tomorrow (friday), here is public holiday and monday, too.
>> >> So a looong weekend.
>> >
>> > ;-)
>> >
>> > OK, I have a new sedat.2011.04.21a branch in the -rcu git tree:
>> >
>> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>> >
>> > This is against 2.6.39-rc3, as before.  (Yes, I do need to rebase to
>> > 2.6.39-rc4, but didn't want to change any more than I had to.)
>> >
>> > I also have an updated script, which is attached.  The output is similar
>> > to the earlier one, and it operated is pretty much the same way.
>> >
>> > Have a great weekend, and I look forward to seeing what shows up on
>> > this round.  I confess to still being quite puzzled!
>> >
>> >                                                        Thanx, Paul
>> >
>>
>> Here are the results of the Sedat's vote (European song contest :-)).
>
> ;-)
>
> Very strange.  RCU has told the per-CPU kthread that it needs to get
> to work, but this kthread is still waiting from RCU's viewpoint.
> Yet the "ps" command believes that this kthread is in fact runnable
> at SCHED_FIFO priority 1.
>
> I can tell that this one will require some thought...  And more
> diagnostics...
>
>                                                        Thanx, Paul
>

"We are with you in spirit."

( Level XX from Hybris shooter-game on Amiga (1989) )

- Sedat -

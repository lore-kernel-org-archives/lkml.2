Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756269Ab1DXJgt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Apr 2011 05:36:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38306 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755854Ab1DXJgq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Apr 2011 05:36:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=ohggD44YCnjONc1bRTX+0CYuPxipivaVm2ZAS/Wj1WV708GyLWEs/3z3zaHjo62rKm
         0B2nIGCXK9ziL5OyYTk1AbjNJvzwCi5FyRYFvM4++9q6hJI9ZUq5h0Jfk6KSkv8uUrlS
         0P1N7psxAr/mMpmKrNtmNvnYZrphMnLsToyfw=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20110424062728.GM2628@linux.vnet.ibm.com>
References: <20110421142853.GA2235@linux.vnet.ibm.com>
	<BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
	<20110422005046.GQ2235@linux.vnet.ibm.com>
	<BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
	<20110422150222.GA2300@linux.vnet.ibm.com>
	<BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
	<20110423210539.GI2628@linux.vnet.ibm.com>
	<BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
	<BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
	<BANLkTim9H1k4c7xSZZJ09WXs8WCeCQQJJg@mail.gmail.com>
	<20110424062728.GM2628@linux.vnet.ibm.com>
Date: Sun, 24 Apr 2011 11:36:44 +0200
Message-ID: <BANLkTinTd10K6Ho6FhuynROT7yDLHNLojw@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=000e0cd5cff43e928204a1a6d4c5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--000e0cd5cff43e928204a1a6d4c5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sun, Apr 24, 2011 at 8:27 AM, Paul E. McKenney
<paulmck@linux.vnet.ibm.com> wrote:
> On Sun, Apr 24, 2011 at 01:08:42AM +0200, Sedat Dilek wrote:
>> On Sun, Apr 24, 2011 at 1:04 AM, Sedat Dilek <sedat.dilek@googlemail.com=
> wrote:
>> > On Sat, Apr 23, 2011 at 11:16 PM, Sedat Dilek
>> > <sedat.dilek@googlemail.com> wrote:
>> >> On Sat, Apr 23, 2011 at 11:05 PM, Paul E. McKenney
>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >>> On Fri, Apr 22, 2011 at 07:36:58PM +0200, Sedat Dilek wrote:
>> >>>> On Fri, Apr 22, 2011 at 5:02 PM, Paul E. McKenney
>> >>>> <paulmck@linux.vnet.ibm.com> wrote:
>> >>>> > On Fri, Apr 22, 2011 at 11:40:54AM +0200, Sedat Dilek wrote:
>> >>>> >> On Fri, Apr 22, 2011 at 2:50 AM, Paul E. McKenney
>> >>>> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >>>> >> > On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
>> >>>> >> >> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
>> >>>> >> >> <paulmck@linux.vnet.ibm.com> wrote:
>> >>>> >> >> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote=
:
>> >>>> >> >> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
>> >>>> >> >> >> <sedat.dilek@googlemail.com> wrote:
>> >>>> >> >
>> >>>> >> > [ . . . ]
>> >>>> >> >
>> >>>> >> >> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
>> >>>> >> >> >
>> >>>> >> >> > OK, and the grace periods clearly stopped advancing early o=
n.
>> >>>> >> >> >
>> >>>> >> >> > Beyond that point, the per-CPU kthread is blocked, but RCU =
has some
>> >>>> >> >> > work for it to do. =C2=A0So someone has called invoke_rcu_c=
pu_kthread(),
>> >>>> >> >> > but rcu_cpu_kthread() is still blocked. =C2=A0I don't see a=
 bug right
>> >>>> >> >> > off-hand, but it is early in the morning for me, so I might=
 easily
>> >>>> >> >> > be missing something.
>> >>>> >> >> >
>> >>>> >> >> > Hmmm...
>> >>>> >> >> >
>> >>>> >> >> > The synchronization between these two assumes that the per-=
CPU
>> >>>> >> >> > kthread is always bound to the respective CPU, so if was so=
mehow
>> >>>> >> >> > being migrated off, that might explain these results.
>> >>>> >> >> >
>> >>>> >> >> > I will add some more diagnostics, test them locally, then p=
ush
>> >>>> >> >> > out an update. =C2=A0Seem reasonable?
>> >>>> >> >> >
>> >>>> >> >> > And thank you again for the testing!!!
>> >>>> >> >>
>> >>>> >> >> Ping me when you have new stuff for testing.
>> >>>> >> >> Tomorrow (friday), here is public holiday and monday, too.
>> >>>> >> >> So a looong weekend.
>> >>>> >> >
>> >>>> >> > ;-)
>> >>>> >> >
>> >>>> >> > OK, I have a new sedat.2011.04.21a branch in the -rcu git tree=
:
>> >>>> >> >
>> >>>> >> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.=
6-rcu.git
>> >>>> >> >
>> >>>> >> > This is against 2.6.39-rc3, as before. =C2=A0(Yes, I do need t=
o rebase to
>> >>>> >> > 2.6.39-rc4, but didn't want to change any more than I had to.)
>> >>>> >> >
>> >>>> >> > I also have an updated script, which is attached. =C2=A0The ou=
tput is similar
>> >>>> >> > to the earlier one, and it operated is pretty much the same wa=
y.
>> >>>> >> >
>> >>>> >> > Have a great weekend, and I look forward to seeing what shows =
up on
>> >>>> >> > this round. =C2=A0I confess to still being quite puzzled!
>> >>>> >> >
>> >>>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>> >>>> >> >
>> >>>> >>
>> >>>> >> Here are the results of the Sedat's vote (European song contest =
:-)).
>> >>>> >
>> >>>> > ;-)
>> >>>> >
>> >>>> > Very strange. =C2=A0RCU has told the per-CPU kthread that it need=
s to get
>> >>>> > to work, but this kthread is still waiting from RCU's viewpoint.
>> >>>> > Yet the "ps" command believes that this kthread is in fact runnab=
le
>> >>>> > at SCHED_FIFO priority 1.
>> >>>> >
>> >>>> > I can tell that this one will require some thought... =C2=A0And m=
ore
>> >>>> > diagnostics...
>> >>>> >
>> >>>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>> >>>> >
>> >>>>
>> >>>> "We are with you in spirit."
>> >>>>
>> >>>> ( Level XX from Hybris shooter-game on Amiga (1989) )
>> >>>
>> >>> OK, I added a few more diagnostics: sedat.2011.04.23a in -rcu:
>> >>>
>> >>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.=
git
>> >>>
>> >>> When you get a chance, could you please give it a try?
>> >>>
>> >>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>> >>>
>> >>
>> >> As soon as I can clone/pull from new GIT repo/branch.
>> >> Currently, I don't see it only, but kernel-mirrors are sometimes slow=
.
>> >>
>> >> I will report later.
>> >>
>> >> - Sedat -
>> >>
>> >
>> > Hi Paul,
>> >
>> > I have seen CONFIG_DEBUG_OBJECTS_RCU_HEAD mentionned in the commits,
>> > so I enabled it here together with CONFIG_DEBUG_OBJECTS=3Dy.
>> > Hope this is OK.
>> > Am I missing other useful (*DEBUG_OBJECT*) kernel options?
>> >
>> > - Sedat -
>> >
>> > P.S.: Enabled CONFIG_DEBUG_OBJECTS=3Dy and
>> > CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy (and some more)
>> >
>> > # diff -uprN for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.2=
1a+
>> > for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
>> > --- for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.21a+
>> > =C2=A02011-04-22 10:25:42.000000000 +0200
>> > +++ for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
>> > =C2=A02011-04-24 00:35:37.000000000 +0200
>> > @@ -1,7 +1,7 @@
>> > =C2=A0#
>> > =C2=A0# Automatically generated make config: don't edit
>> > =C2=A0# Linux/i386 2.6.39-rc3 Kernel Configuration
>> > -# Fri Apr 22 09:54:37 2011
>> > +# Sat Apr 23 23:58:52 2011
>> > =C2=A0#
>> > =C2=A0# CONFIG_64BIT is not set
>> > =C2=A0CONFIG_X86_32=3Dy
>> > @@ -3065,7 +3065,14 @@ CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
>> > =C2=A0CONFIG_SCHED_DEBUG=3Dy
>> > =C2=A0# CONFIG_SCHEDSTATS is not set
>> > =C2=A0CONFIG_TIMER_STATS=3Dy
>> > -# CONFIG_DEBUG_OBJECTS is not set
>> > +CONFIG_DEBUG_OBJECTS=3Dy
>> > +# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
>> > +# CONFIG_DEBUG_OBJECTS_FREE is not set
>> > +CONFIG_DEBUG_OBJECTS_TIMERS=3Dy
>> > +# CONFIG_DEBUG_OBJECTS_WORK is not set
>> > +CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy
>> > +CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=3Dy
>> > +CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=3D1
>> > =C2=A0# CONFIG_SLUB_DEBUG_ON is not set
>> > =C2=A0# CONFIG_SLUB_STATS is not set
>> > =C2=A0# CONFIG_DEBUG_KMEMLEAK is not set
>> >
>>
>> Oops, forget the dmesg output.
>
> OK, this looks unrelated, but just in case, could you please try it
> again with the following patch? =C2=A0(Not mainlinable, debug only.)
>
> Also, it does look like you are still seeing a grace-period hang.
> Could you please send the output of the script? =C2=A0Same one as last ti=
me.
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>
> ------------------------------------------------------------------------
>
> =C2=A0debugobjects.c | =C2=A0 =C2=A08 +++++---
> =C2=A01 file changed, 5 insertions(+), 3 deletions(-)
>
> diff --git a/lib/debugobjects.c b/lib/debugobjects.c
> index 9d86e45..10a7c7a 100644
> --- a/lib/debugobjects.c
> +++ b/lib/debugobjects.c
> @@ -289,10 +289,12 @@ static void debug_object_is_on_stack(void *addr, in=
t onstack)
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>
> =C2=A0 =C2=A0 =C2=A0 =C2=A0limit++;
> - =C2=A0 =C2=A0 =C2=A0 if (is_on_stack)
> + =C2=A0 =C2=A0 =C2=A0 if (is_on_stack) {
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 struct rcu_head *p =3D=
 (struct rcu_head *)addr;
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_WARNIN=
G
> - =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"ODEBUG: object is on stack, but not annotated\n");
> - =C2=A0 =C2=A0 =C2=A0 else
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0"ODEBUG: object is on stack, but not annotated: %p\n",
> + =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0p->func);
> + =C2=A0 =C2=A0 =C2=A0 } else
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0printk(KERN_WARNIN=
G
> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 "ODEBUG: object is not on stack, but annotated\n");
> =C2=A0 =C2=A0 =C2=A0 =C2=A0WARN_ON(1);
>

Somehow your attached patch was not applicable.
As the changes were a few lines I applied it by myself.
Attached are log, dmesg and patches (orig + mine)

- Sedat -

--000e0cd5cff43e928204a1a6d4c5
Content-Type: application/octet-stream; name="for-paulk-5.tar.xz"
Content-Disposition: attachment; filename="for-paulk-5.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmvs8zfk0

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
--000e0cd5cff43e928204a1a6d4c5
Content-Type: application/octet-stream; name="for-paulk-5.tar.xz.sha256sum"
Content-Disposition: attachment; filename="for-paulk-5.tar.xz.sha256sum"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmvs93qx1

MTM4MjFmYTdhOTc5MWQwYmNhNThkZDU1NGY2OWY5MGY4YTg3ZTM2YmNmYzliODIxODU2MjYwYjRi
YTAwZTcxMyAgZm9yLXBhdWxrLTUudGFyLnh6Cg==
--000e0cd5cff43e928204a1a6d4c5--

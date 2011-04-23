Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932127Ab1DWXEf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Apr 2011 19:04:35 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:49025 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab1DWXEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Apr 2011 19:04:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type;
        b=PvbMHYhYpp53Wf20CBzsOMJ2gtKHzdoBROX8d4ERMs0S184PBHEDsEfk3b6x+j5wyf
         o3joAOZOHn4IUtwKLlRmoq/vtpN5XTnV6W1/+oD+wyRCOCqebHeFM+ZOpL5mG697Tw2s
         16fzwW/SJWXuaPQoEAGsjAbWLQC7inqMKQrfs=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
References: <20110421050823.GA4487@linux.vnet.ibm.com>
	<BANLkTinFmG5GVq6D8+wq_89OPF8snsQ=Jw@mail.gmail.com>
	<BANLkTi=c=+JnU9dQsVhgjZbOtArhHQz+EQ@mail.gmail.com>
	<BANLkTimEWqBVdq8MWbjAAfXCLPQdiHkuNg@mail.gmail.com>
	<20110421142853.GA2235@linux.vnet.ibm.com>
	<BANLkTineNYTXffcNT59STsk5nkLhi=o-kA@mail.gmail.com>
	<20110422005046.GQ2235@linux.vnet.ibm.com>
	<BANLkTi=W=s876U===LVfp59Nnfui8d-1RQ@mail.gmail.com>
	<20110422150222.GA2300@linux.vnet.ibm.com>
	<BANLkTind84Gf8JA9Fa4QL2GbaF8nMNhDzw@mail.gmail.com>
	<20110423210539.GI2628@linux.vnet.ibm.com>
	<BANLkTimXW2=PYOXkKjnLuH+eN2TjZBqAxw@mail.gmail.com>
Date: Sun, 24 Apr 2011 01:04:31 +0200
Message-ID: <BANLkTi=ntjm-5D=OD1oFogpNjmJSJiZygQ@mail.gmail.com>
Subject: Re: linux-next: Tree for April 14 (Call-traces: RCU/ACPI/WQ related?)
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: multipart/mixed; boundary=0016e64aefda4136be04a19dff42
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--0016e64aefda4136be04a19dff42
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Sat, Apr 23, 2011 at 11:16 PM, Sedat Dilek
<sedat.dilek@googlemail.com> wrote:
> On Sat, Apr 23, 2011 at 11:05 PM, Paul E. McKenney
> <paulmck@linux.vnet.ibm.com> wrote:
>> On Fri, Apr 22, 2011 at 07:36:58PM +0200, Sedat Dilek wrote:
>>> On Fri, Apr 22, 2011 at 5:02 PM, Paul E. McKenney
>>> <paulmck@linux.vnet.ibm.com> wrote:
>>> > On Fri, Apr 22, 2011 at 11:40:54AM +0200, Sedat Dilek wrote:
>>> >> On Fri, Apr 22, 2011 at 2:50 AM, Paul E. McKenney
>>> >> <paulmck@linux.vnet.ibm.com> wrote:
>>> >> > On Thu, Apr 21, 2011 at 04:47:31PM +0200, Sedat Dilek wrote:
>>> >> >> On Thu, Apr 21, 2011 at 4:28 PM, Paul E. McKenney
>>> >> >> <paulmck@linux.vnet.ibm.com> wrote:
>>> >> >> > On Thu, Apr 21, 2011 at 02:49:37PM +0200, Sedat Dilek wrote:
>>> >> >> >> On Thu, Apr 21, 2011 at 12:24 PM, Sedat Dilek
>>> >> >> >> <sedat.dilek@googlemail.com> wrote:
>>> >> >
>>> >> > [ . . . ]
>>> >> >
>>> >> >> >> Here the results from the 2nd-run (PREEMPT_RCU enabled).
>>> >> >> >
>>> >> >> > OK, and the grace periods clearly stopped advancing early on.
>>> >> >> >
>>> >> >> > Beyond that point, the per-CPU kthread is blocked, but RCU has =
some
>>> >> >> > work for it to do. =C2=A0So someone has called invoke_rcu_cpu_k=
thread(),
>>> >> >> > but rcu_cpu_kthread() is still blocked. =C2=A0I don't see a bug=
 right
>>> >> >> > off-hand, but it is early in the morning for me, so I might eas=
ily
>>> >> >> > be missing something.
>>> >> >> >
>>> >> >> > Hmmm...
>>> >> >> >
>>> >> >> > The synchronization between these two assumes that the per-CPU
>>> >> >> > kthread is always bound to the respective CPU, so if was someho=
w
>>> >> >> > being migrated off, that might explain these results.
>>> >> >> >
>>> >> >> > I will add some more diagnostics, test them locally, then push
>>> >> >> > out an update. =C2=A0Seem reasonable?
>>> >> >> >
>>> >> >> > And thank you again for the testing!!!
>>> >> >>
>>> >> >> Ping me when you have new stuff for testing.
>>> >> >> Tomorrow (friday), here is public holiday and monday, too.
>>> >> >> So a looong weekend.
>>> >> >
>>> >> > ;-)
>>> >> >
>>> >> > OK, I have a new sedat.2011.04.21a branch in the -rcu git tree:
>>> >> >
>>> >> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rc=
u.git
>>> >> >
>>> >> > This is against 2.6.39-rc3, as before. =C2=A0(Yes, I do need to re=
base to
>>> >> > 2.6.39-rc4, but didn't want to change any more than I had to.)
>>> >> >
>>> >> > I also have an updated script, which is attached. =C2=A0The output=
 is similar
>>> >> > to the earlier one, and it operated is pretty much the same way.
>>> >> >
>>> >> > Have a great weekend, and I look forward to seeing what shows up o=
n
>>> >> > this round. =C2=A0I confess to still being quite puzzled!
>>> >> >
>>> >> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>>> >> >
>>> >>
>>> >> Here are the results of the Sedat's vote (European song contest :-))=
.
>>> >
>>> > ;-)
>>> >
>>> > Very strange. =C2=A0RCU has told the per-CPU kthread that it needs to=
 get
>>> > to work, but this kthread is still waiting from RCU's viewpoint.
>>> > Yet the "ps" command believes that this kthread is in fact runnable
>>> > at SCHED_FIFO priority 1.
>>> >
>>> > I can tell that this one will require some thought... =C2=A0And more
>>> > diagnostics...
>>> >
>>> > =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0=
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>>> >
>>>
>>> "We are with you in spirit."
>>>
>>> ( Level XX from Hybris shooter-game on Amiga (1989) )
>>
>> OK, I added a few more diagnostics: sedat.2011.04.23a in -rcu:
>>
>> git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-2.6-rcu.git
>>
>> When you get a chance, could you please give it a try?
>>
>> =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0Thanx, Paul
>>
>
> As soon as I can clone/pull from new GIT repo/branch.
> Currently, I don't see it only, but kernel-mirrors are sometimes slow.
>
> I will report later.
>
> - Sedat -
>

Hi Paul,

I have seen CONFIG_DEBUG_OBJECTS_RCU_HEAD mentionned in the commits,
so I enabled it here together with CONFIG_DEBUG_OBJECTS=3Dy.
Hope this is OK.
Am I missing other useful (*DEBUG_OBJECT*) kernel options?

- Sedat -

P.S.: Enabled CONFIG_DEBUG_OBJECTS=3Dy and
CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy (and some more)

# diff -uprN for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.21a+
for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
--- for-paulk-3/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.21a+
 2011-04-22 10:25:42.000000000 +0200
+++ for-paulk-4/config-2.6.39-rc3-preempt-rcu-sedat.2011.04.23a+
 2011-04-24 00:35:37.000000000 +0200
@@ -1,7 +1,7 @@
 #
 # Automatically generated make config: don't edit
 # Linux/i386 2.6.39-rc3 Kernel Configuration
-# Fri Apr 22 09:54:37 2011
+# Sat Apr 23 23:58:52 2011
 #
 # CONFIG_64BIT is not set
 CONFIG_X86_32=3Dy
@@ -3065,7 +3065,14 @@ CONFIG_BOOTPARAM_HUNG_TASK_PANIC_VALUE=3D0
 CONFIG_SCHED_DEBUG=3Dy
 # CONFIG_SCHEDSTATS is not set
 CONFIG_TIMER_STATS=3Dy
-# CONFIG_DEBUG_OBJECTS is not set
+CONFIG_DEBUG_OBJECTS=3Dy
+# CONFIG_DEBUG_OBJECTS_SELFTEST is not set
+# CONFIG_DEBUG_OBJECTS_FREE is not set
+CONFIG_DEBUG_OBJECTS_TIMERS=3Dy
+# CONFIG_DEBUG_OBJECTS_WORK is not set
+CONFIG_DEBUG_OBJECTS_RCU_HEAD=3Dy
+CONFIG_DEBUG_OBJECTS_PERCPU_COUNTER=3Dy
+CONFIG_DEBUG_OBJECTS_ENABLE_DEFAULT=3D1
 # CONFIG_SLUB_DEBUG_ON is not set
 # CONFIG_SLUB_STATS is not set
 # CONFIG_DEBUG_KMEMLEAK is not set

--0016e64aefda4136be04a19dff42
Content-Type: application/octet-stream; name="for-paulk-4.tar.xz"
Content-Disposition: attachment; filename="for-paulk-4.tar.xz"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmv5nd4m0

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
--0016e64aefda4136be04a19dff42
Content-Type: application/octet-stream; name="for-paulk-4.tar.xz.sha256sum"
Content-Disposition: attachment; filename="for-paulk-4.tar.xz.sha256sum"
Content-Transfer-Encoding: base64
X-Attachment-Id: f_gmv5nkeq1

ZDFlNjZhNjhhMmJlN2JiYTJhNDU0ZTQ2MDBlOTMyOTgwMzE2YmJiYjAwNDg1Zjg2NzkxMzhiZDZm
ZWQ4YjE5NSAgZm9yLXBhdWxrLTQudGFyLnh6Cg==
--0016e64aefda4136be04a19dff42--

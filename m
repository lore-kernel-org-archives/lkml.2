Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754661Ab1GLSHt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 14:07:49 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:54603 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754621Ab1GLSHs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 14:07:48 -0400
MIME-Version: 1.0
In-Reply-To: <20110712171706.GA18414@tugrik.mns.mnsspb.ru>
References: <201105201306.31204.luke@dashjr.org>
	<BANLkTimOqhNEsBEg6f=nMiMJqYGNyFJmeQ@mail.gmail.com>
	<013811$4lfs6@fmsmga002.fm.intel.com>
	<201105211123.56053.luke@dashjr.org>
	<aefc95$1usaq@orsmga001.jf.intel.com>
	<20110528131920.GA10467@tugrik.mns.mnsspb.ru>
	<20110712171706.GA18414@tugrik.mns.mnsspb.ru>
Date: Tue, 12 Jul 2011 21:07:47 +0300
X-Google-Sender-Auth: 39qZKA1ssWCnAkVlFaqd1Gqh9tg
Message-ID: <CAOJsxLEz-fPnb9oYnLMk9UbGqgsfm-g1d2yH=TrEiEk7HvyQzA@mail.gmail.com>
Subject: Re: [Intel-gfx] Major 2.6.38 / 2.6.39 regression ignored?
From: Pekka Enberg <penberg@kernel.org>
To: Kirill Smelkov <kirr@mns.spb.ru>
Cc: Chris Wilson <chris@chris-wilson.co.uk>, Luke-Jr <luke@dashjr.org>,
        intel-gfx@lists.freedesktop.org, LKML <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ray Lee <ray-lk@madrabbit.org>,
        Herbert Xu <herbert@gondor.hengli.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 12, 2011 at 8:17 PM, Kirill Smelkov <kirr@mns.spb.ru> wrote:
> On Sat, May 28, 2011 at 05:19:20PM +0400, Kirill Smelkov wrote:
>> Hello Chris, everyone,
>>
>> On Sat, May 21, 2011 at 04:40:17PM +0100, Chris Wilson wrote:
>> > On Sat, 21 May 2011 11:23:53 -0400, "Luke-Jr" <luke@dashjr.org> wrote:
>> > > On Saturday, May 21, 2011 4:41:45 AM Chris Wilson wrote:
>> > > > On Fri, 20 May 2011 11:08:56 -0700, Ray Lee <ray-lk@madrabbit.org> wrote:
>> > > > > [ Adding Chris Wilson (author of the problematic patch) and Rafael
>> > > > > Wysocki to the message ]
>> > > > >
>> > > > > On Fri, May 20, 2011 at 10:06 AM, Luke-Jr <luke@dashjr.org> wrote:
>> > > > > > I submitted https://bugzilla.kernel.org/show_bug.cgi?id=33662 a month
>> > > > > > ago against 2.6.38. Now 2.6.39 was just released without the
>> > > > > > regression being addressed. This bug makes the system unusable... Some
>> > > > > > guys on IRC suggested I
>> > > > > > email, so here it is.
>> > > > >
>> > > > > See the bugzilla entry for the bisection history.
>> > > >
>> > > > Which has nothing to do with Luke's bug. Considering the thousand things
>> > > > that can go wrong during X starting, without a hint as to which it is nigh
>> > > > on impossible to debug except by trial and error. If you set up
>> > > > netconsole, does the kernel emit an OOPS with it's last dying breath?
>> > >
>> > > Why assume it's a different bug? I would almost wonder if it might affect
>> > > all Sandy Bridge GPUs. In any case, I no longer have the original
>> > > motherboard (it was recalled, as I said in the first post), nor even the
>> > > revision of it (it had other issues that weren't being fixed). I *assume* I
>> > > will have the same problem with my new motherboard (Intel DQ67SW), but I
>> > > haven't verified that yet. I'll be sure to try a netconsole when I have to
>> > > reboot next and get a chance to try the most recent 2.6.38 and .39 kernels,
>> > > but at the moment it seems reasonable to address the problem bisected in the
>> > > bug, even if it turns out to be different.
>> >
>> > The bisection is into an old DRI1 bug on 945GM. That DRI has inadequate
>> > locking between release and IRQ and so is prone to such races as befell
>> > Kirill should not surprise anyone. As neither UMS nor DRI supported SNB,
>> > I can quite confidently state they are separate bugs.
>> > -Chris
>>
>> I see DRI1 is maybe buggy and old, but still, pre-kms X used to work ok
>> on kernels < 2.6.38, and starting from 2.6.38 the system is just
>> unusable because X either crashes the kernel (2.6.38), or does not start
>> at all (2.6.39):
>>
>> https://bugzilla.kernel.org/show_bug.cgi?id=36052
>>
>>
>> It's a regression. It's blocking me to upgrade to newer kernels. I've
>> done my homework -- digged it and came with detailed OOPS on netconsole
>> and bisected to single commit. Could this please be fixed?
>
> Silence...
>
> Still, reverting the bisected patch helps even for 3.0:
>
> https://bugzilla.kernel.org/show_bug.cgi?id=36052#c4

Keith, Chris, what's up with this regression from 2.6.38? It seems
commit e8616b6 ("drm/i915: Initialise ring vfuncs for old DRI paths")
caused problems on other machines.

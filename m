Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754783Ab0HKVZz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 17:25:55 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45383 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752877Ab0HKVZy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 17:25:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=ib0nKs8vmLNNlS5iPYE47qOtvRyfHW621EZvY3o8AZmcoa1dDfG+un3f3vWs4W5u5W
         1T1wRtcj4rc8ENGc0dvBg89EVuM/wdA1xedpEfxRqH7O8PbVGoHqJYT+zYCqoxlBgp0+
         L7d8o0bkhaMeXGaHNoj3af+IJ3hvq8d08+wtY=
MIME-Version: 1.0
In-Reply-To: <20100811193106.GB24435@thunk.org>
References: <20100806225453.GA3947@linux.vnet.ibm.com>
	<alpine.DEB.2.00.1008061651530.30564@asgard.lang.hm>
	<AANLkTikyRhtfX4R3x_NDgHnXssmfVuhjC5PbhRZ0a7su@mail.gmail.com>
	<alpine.DEB.2.00.1008062010510.30564@asgard.lang.hm>
	<20100807061558.GA28087@thunk.org>
	<AANLkTi=sMVjya9CH6UoZwJCXJTDRgBhnPXmApU_RHVTi@mail.gmail.com>
	<20100808155719.GB3635@thunk.org>
	<AANLkTinM5e2HGOFavODPZNzZx4KshDSjsvKN4pLpGGgr@mail.gmail.com>
	<20100808213821.GD3635@thunk.org>
	<AANLkTinNc1SWmz8pE_4k6vThxQCJfCR_UqV6OM=OsJOf@mail.gmail.com>
	<20100811193106.GB24435@thunk.org>
Date: Thu, 12 Aug 2010 00:25:50 +0300
Message-ID: <AANLkTinBrp1iHWAi=vk_eaEHMs+Xcub6rg8PgT_LK2c9@mail.gmail.com>
Subject: Re: Attempted summary of suspend-blockers LKML thread, take three
From: Felipe Contreras <felipe.contreras@gmail.com>
To: "Ted Ts'o" <tytso@mit.edu>, Felipe Contreras <felipe.contreras@gmail.com>,
        david@lang.hm, Brian Swetland <swetland@google.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
        arve@android.com, mjg59@srcf.ucam.org, pavel@ucw.cz,
        florian@mickler.org, rjw@sisk.pl, stern@rowland.harvard.edu,
        peterz@infradead.org, tglx@linutronix.de, alan@lxorguk.ukuu.org.uk,
        menage@google.com, david-b@pacbell.net, James.Bottomley@suse.de,
        arjan@infradead.org, swmike@swm.pp.se, galibert@pobox.com,
        dipankar@in.ibm.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 11, 2010 at 10:31 PM, Ted Ts'o <tytso@mit.edu> wrote:
> On Wed, Aug 11, 2010 at 07:57:32PM +0300, Felipe Contreras wrote:
>> Let's concentrate; Android is the only mobile platform that has
>> expressed interested in suspend blockers. UI applications in Android
>> are written specifically for Android. Period.
>>
>> Other platforms, such as MeeGo, rely on Qt API, not suspend blockers.
>
> I think you're wrong that this will be sufficient, but I've already
> stated my position before, namely that what you do when you only have
> 800mWh has very different performance/battery tradeoffs than when you
> have 94,000mWh batteries.  One of the reasons why my mail archive for
> this discussion has over 1800 messages and is close to 10MB is that
> everyone keeps saying the same thing over and over again.  So I'm not
> going to say it again.

Applications need to take smart decisions to save power based on a
number of things: is the screen on? is the ear close to the speaker?
is there a network available? is it a cellular connection? has the
user decided to automatically disconnect from the network after
certain time, or at night? etc. I think that, and range timers / ip
heartbeat is enough. But that, as you say has been discussed before.

Now, only Android has decided to use suspend blockers, that's a
*fact*, and I wanted to narrow the discussion to Android in order to
make it easier to understand that Android doesn't need suspend
blockers, once we have agreed that, then I'd gladly discuss it's
merits outside Android.

> I was thinking that the only way we can tell is for us to go away and
> come back in two years, and we can see whether or not Meego is getting
> the same 200,000 activations per day that Android is, and maybe *then*
> people will understand.

Are you kidding? Even if MeeGo fails in being as popular as Android,
that doesn't saying anything about whether suspend-blockers are
sensible or not. Besides, there is also the possibility that Android
people realize they don't need suspend-blockers.

> However, earlier today, I had a very productive conversation with an
> engineer from Nokia who has had many years of experience of doing
> power management for cell phones, and who is now trying to make Meego
> power efficient enough for cell phones, and he seemed to think that
> problem which suspend blockers or wakelocks are trying to solve was
> valid.

So? I'm sure there's some people in Google that believe that
suspend-blockers are not needed.

> I now believe that part of the problem is that is that many Meego
> folks only have an experience with Netbooks or Laptops, and don't
> appreciate that sometimes, when you make such a radical change in
> battery capacity to a mobile handset, things become qualitatively
> different, and not just quantitatively different.  Put another way, a
> laptop has six hours of battery lifetime with 94,000 mWh worth of
> battery; a cell phone needs to be able to be usable over a 20-24 hour
> period of despite having a 800-1200 mWh battery --- and what you need
> do for these two are different.

Right. Nokia people only have experience with laptops. Surely my N900
lasts days because it's receiving energy from another dimension.

> This is very similar to how trying to make a kernel scale to 512 NUMA
> nodes is quite different to trying make a kernel work with 4-8 SMP
> cpu's.  Until you've actually tried doing it, you might think that all
> you have to do is just throw in a bunch of spinlocks and rw spinlocks.
> But it turns out it's a lot harder than that --- but it's very hard to
> convince someone who hasn't had that experience to understand why that
> is true.

We are talking about user-space.

> So it may very well be that we should just agree to disagree, and if
> there are one or more Nokia engineers who are interested in doing
> something that would help their cell phones (I will let them speak up
> and clarify their positions for themselves), that they work directly
> with those who agree that there _is_ a problem.

Yeah, there is a problem, and the solution doesn't require suspend-blockers.

> At that point, we can either keep these patches out of tree, much like
> how the SGI Altix has patches that are needed so that the Linux kernel
> scales enough so it will even successfully complete its kernel
> initialization successfully.  Or if there is consensus between people
> who are interested at Linaro (if any), Nokia (if any), and Android (if
> any), maybe we take this directly to Linus, and he can say yes or no.
>
> But for those who are unwilling to believe it isn't even a problem, I
> don't know that another 2000 e-mail messages, and another 10MB of mail
> archives, is going to achieve anything.  Let's just agree to disagree.

I argued to you that suspend-blockers are not required in Android, and
suddenly you decide we should agree to disagree without arguing back?
Well, suit yourself. I still maintain that suspend-blockers is just an
expensive workaround, and in some cases actually degrades power
consumption; the right solution is much more sophisticated.

-- 
Felipe Contreras

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab0FFKCQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:02:16 -0400
Received: from www.tglx.de ([62.245.132.106]:52634 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754186Ab0FFKCO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:02:14 -0400
Date: Sun, 6 Jun 2010 12:01:29 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: =?ISO-8859-15?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Peter Zijlstra <peterz@infradead.org>,
       Ingo Molnar <mingo@elte.hu>, tytso@mit.edu,
       Brian Swetland <swetland@google.com>, Neil Brown <neilb@suse.de>,
       Alan Stern <stern@rowland.harvard.edu>,
       Felipe Balbi <felipe.balbi@nokia.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Florian Mickler <florian@mickler.org>,
       Linux OMAP Mailing List <linux-omap@vger.kernel.org>,
       Linux PM <linux-pm@lists.linux-foundation.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>,
       James Bottomley <James.Bottomley@suse.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       "H. Peter Anvin" <hpa@zytor.com>,
       Arjan van de Ven <arjan@infradead.org>
Subject: Re: suspend blockers & Android integration
In-Reply-To: <AANLkTilxr9vsMmE7LLoOcTIlhXLctWolC2VAsVeoLgnW@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006061144350.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins> <201006050138.30859.rjw@sisk.pl> <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain> <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
 <alpine.LFD.2.00.1006050246350.2933@localhost.localdomain> <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com> <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain> <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
 <alpine.LFD.2.00.1006052348200.2933@localhost.localdomain> <AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com> <alpine.LFD.2.00.1006060220400.2933@localhost.localdomain> <AANLkTilxr9vsMmE7LLoOcTIlhXLctWolC2VAsVeoLgnW@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-1857924037-1275818491=:2933"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-1857924037-1275818491=:2933
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT

On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> > On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> >> That is too simple. You also have to prevent A from being frozen while
> >> it is processing the event or the result would be the same as if it
> >> was frozen beforehand.
> >
> > The framework decides when to freeze the app in the first place (as
> > your framework does now when it decides to suspend)
> >
> >     So it knows whether the app is frozen or not.
> >
> >     So it knows damend well whether it processed the event or not.
> >
> 
> Our user-space code is not single-threaded. So just because an app was
> not frozen when you checked does not mean it will remain unfrozen. We
> can use the same user-space wakelock api we have now to prevent
> freezing apps instead of preventing suspend, but we loose any
> advantage we get from freezing just a subset of processes this way.

Errm. That does not matter whether its single threaded or not. And
right, you have to prevent that it gets frozen while you are calling
into it.

But that does not change the fact that you can do finer grained power
control even in the case when suspend is impossible because a
background application has work to finish and does that without
requiring interaction with the frozen part.

That's what I pointed out in the first place and you just argue in
circles why it is impossible to do so.

Let me recapitulate:

   Full on state:	No difference because everything runs
   Full suspend state:	No difference because everything is down

   Screen off, background work active:

   	  Suspend blocker held by the active background work lets
   	  other applications which are unrelated consume CPU cycles
   	  and power.

	  versus

	  Frozen apps restrict the CPU cycles and power consumption to
	  the background work (if there are no interactions with
	  frozen tasks) and therefor save more power than the on/off
	  approach.

	  If your user space stack cannot be distangled that way, then
	  it's a problem of your user space stack and not changing the
	  fact, that a well designedd system allows you to do that.

Any objections ?

Thanks,

	tglx







--8323328-1857924037-1275818491=:2933--

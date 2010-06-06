Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754965Ab0FFKhF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jun 2010 06:37:05 -0400
Received: from www.tglx.de ([62.245.132.106]:47000 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751115Ab0FFKhC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jun 2010 06:37:02 -0400
Date: Sun, 6 Jun 2010 12:36:21 +0200 (CEST)
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
In-Reply-To: <AANLkTikdM79nmARagK9gLveMWEiT6rlk44UELes1k8Ch@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1006061202351.2933@localhost.localdomain>
References: <20100603193045.GA7188@elte.hu> <20100603232302.GA16184@elte.hu> <1275644619.27810.39462.camel@twins> <201006050138.30859.rjw@sisk.pl> <alpine.LFD.2.00.1006050148080.2933@localhost.localdomain> <AANLkTikGDSzaENwg_0BAtsYf3ulGd_6sGPR30WsvUxMi@mail.gmail.com>
 <alpine.LFD.2.00.1006050246350.2933@localhost.localdomain> <AANLkTikU21xF49Z-_Lnrq7U7buNmqw_gyEEST8LuN24z@mail.gmail.com> <alpine.LFD.2.00.1006051736040.2933@localhost.localdomain> <AANLkTinD39rI47innPbGz1Gi8PsXV5HqkmaQuJ70oQ63@mail.gmail.com>
 <alpine.LFD.2.00.1006052348200.2933@localhost.localdomain> <AANLkTikmWDHYJ8wWF2cZapbkHHjV09R39I37yvQXFmor@mail.gmail.com> <alpine.LFD.2.00.1006060148470.2933@localhost.localdomain> <AANLkTikdM79nmARagK9gLveMWEiT6rlk44UELes1k8Ch@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="8323328-339667858-1275819785=:2933"
Content-ID: <alpine.LFD.2.00.1006061233360.2933@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

--8323328-339667858-1275819785=:2933
Content-Type: TEXT/PLAIN; CHARSET=ISO-8859-15
Content-Transfer-Encoding: 8BIT
Content-ID: <alpine.LFD.2.00.1006061233361.2933@localhost.localdomain>

On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> > On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> >> 2010/6/5 Thomas Gleixner <tglx@linutronix.de>:
> >> > On Sat, 5 Jun 2010, Arve Hjønnevåg wrote:
> >> >> >> > That download might take a minute or two, but that's not an
> >> >> >> > justification for the crapplication to run unconfined and prevent
> >> >> >> > lower power states.
> >> >> >> >
> >> >> >>
> >> >> >> I agree, but this is not a simple problem to solve.
> >> >> >
> >> >> > Not with suspend blockers, but with cgroup confinement of crap, it's
> >> >> > straight forward.
> >> >> >
> >> >>
> >> >> I don't think is is straight forward. If the a process in the frozen
> >> >> group holds a resource that a process in the unfrozen group needs, how
> >> >> do deal with that?
> >> >
> >> > I'm going to fix the framework which puts the group into freeze state
> >> > w/o making sure that there is no held shared resource. Come on it's
> >> > not rocket science.
> >> >
> >>
> >> I'm not sure which framework you are talking about here, but I don't
> >> think there is a single framework that knows about all shared
> >> resources.
> >
> > Damn, it's not me talking about "our framework", you are mentioning
> > when it fits your needs.
> 
> You said you were going to fix the framework. I did know if you were
> talking about the cgroup framework, or the android user-space
> frameworks. I don't think either has knowledge about all shared
> resources.

The cgroup freezer makes sure that there are no in kernel resources
blocked. Of course the user space side has to do the same and it's not
rocket science.
 
> >
> > If you do not have a clearly defined user space framework, then we
> > talk about a completely random conglomeration of applications which
> > need to be brought into submission by some global brute force
> > approach.
> >
> > I'm tired of this, really. You just use terminlology as it fits to
> > defend the complete design failure of android. But you fail to trick
> > me :)
> >
> > Can you please explain in a consistent way how the application stack
> > and the underlying framework (which exists according to android docs)
> > is handling events and how the separation of trust level works ?
> >
> 
> I don't think I can, since I only know small parts of it. I know some

Sigh. That's the main reason why this discussion goes nowhere.

How in heavens sake can we make a decision whether suspend blockers
are the right and only way to go, when the people 

> events like input event go though a single thread in our system
> process, while other events like network packets (which are also
> wakeup events) goes directly to the app.

--8323328-339667858-1275819785=:2933--

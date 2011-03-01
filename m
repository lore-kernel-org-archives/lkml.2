Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757402Ab1CAUOr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 15:14:47 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:46706 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756258Ab1CAUOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 15:14:45 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Bo0bce06zwwge01mo8R3gdKlYJhB/MInZLaQ2Dhxeur2MuRiBQIPL8sPjp8MZwbjET
         0dAu7TSiJjDd8e/WbGStp3dbecxmsLObaASlo+McJOrx6ejrUFT6X8vrhmyK7r92/NOu
         xVdypyBAKejE8QbRxUX4Dx6+Cgk4WvtE+lqTM=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: David Miller <davem@davemloft.net>, johnwheffner@gmail.com,
        linville@tuxdriver.com, jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <AANLkTimWMZHVQSHEUPuQgFXxNg85dEOesqhZE=e6x8kb@mail.gmail.com>
References: <20110228165501.GC2515@tuxdriver.com>
	 <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	 <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	 <20110228.201852.193726064.davem@davemloft.net>
	 <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
	 <1298964381.2676.58.camel@edumazet-laptop>
	 <AANLkTimWMZHVQSHEUPuQgFXxNg85dEOesqhZE=e6x8kb@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 21:14:39 +0100
Message-ID: <1299010479.2930.1.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 14:37 -0500, Albert Cahalan a écrit :
> On Tue, Mar 1, 2011 at 2:26 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > Le mardi 01 mars 2011 à 01:54 -0500, Albert Cahalan a écrit :
> >> On Mon, Feb 28, 2011 at 11:18 PM, David Miller <davem@davemloft.net> wrote:
> >> > From: Albert Cahalan <acahalan@gmail.com>
> 
> >> >> It sounds like you need a callback or similar, so that TCP can be
> >> >> informed later that the drop has occurred.
> >> >
> >> > By that point we could have already sent an entire RTT's worth
> >> > of data, or more.
> >> >
> >> > It needs to be synchronous, otherwise performance suffers.
> >>
> >> Ouch. OTOH, the current situation: performance suffers.
> >>
> >> In case it makes you feel any better, consider two cases
> >> where synchronous feedback is already impossible.
> >> One is when you're routing packets that merely pass through.
> >> The other is when some other box is doing that to you.
> >> Either way, packets go bye-bye and nobody tells TCP.
> >
> > So in a hurry we decide to drop packets blindly because kernel took the
> > cpu to perform an urgent task ?
> 
> Yes. If the system can't handle the load, it needs to fess up.
> 
> > Bufferbloat is a configuration/tuning problem, not a "everything must be
> > redone" problem. We add new qdiscs (CHOKe, SFB, QFQ, ...) and let admins
> > do their job. Problem is most admins are unaware of the problems, and
> > only buy more bandwidth.
> 
> We could at least do as well as Windows. >:-)
> 
> You can not expect some random Linux user to tune things
> every time the link changes speed or the app mix changes.
> What person NOT ON THIS MAILING LIST is going to mess
> with their qdisc when they connect to a new access point
> or switch from running Skype to running Netflix? Heck, how
> many have any awareness of what a qdisk even is? Linux
> networking needs to be excellent for people with no clue.
> 
> > We might need some changes (including new APIs).
> 
> If an app can't specify latency, adding the ability could
> be nice. Still, stuff needs to JUST WORK more of the time.
> 
> > ECN is a forward step. Blindly dropping packets before ever sending them
> > is a step backward.
> 
> Last I knew, ECN defaulted to a setting of "2" which means
> it is only used in response. Perhaps it's time to change that.
> It's been a while, with defective firewalls being replaced
> by faster hardware.
> 
> > We should allow some trafic spikes, or many applications will stop
> > working. Unless all applications are fixed, we are stuck.
> 
> Such applications would stop working...
> 
> 1. across a switch
> 2. across an older router
> 
> We certainly should allow some traffic spikes. 1 to 10 ms of
> traffic ought to do nicely. Hundreds or thousands of ms is
> getting way beyond "spike".

OK.


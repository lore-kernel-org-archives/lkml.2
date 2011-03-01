Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755519Ab1CAH02 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Mar 2011 02:26:28 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:45301 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab1CAH01 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Mar 2011 02:26:27 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=Rdxh7uNzT072Foc+Jz5hJYP33948pbdIt5vCecFuU7RwqON1ufAe/u2CPLgYh1s4a+
         6jIQ2PdoopJMDXa1WXjppiuDFlk4vfVEmKRvXTRzmXhVdDDrETCcJ8DujlW9Tooyc3Rt
         IxAEKTaxZUh7ieYm/4oPd9qcq3fSIAhRv5SPE=
Subject: Re: txqueuelen has wrong units; should be time
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Albert Cahalan <acahalan@gmail.com>
Cc: David Miller <davem@davemloft.net>, johnwheffner@gmail.com,
        linville@tuxdriver.com, jussi.kivilinna@mbnet.fi, swmike@swm.pp.se,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
In-Reply-To: <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
References: <20110228165501.GC2515@tuxdriver.com>
	 <AANLkTinj5szpStmA+fZ1xggdyTS+sd8Y9jXaYquDNEjs@mail.gmail.com>
	 <AANLkTinFZu5AgfhO6PoA7C1NTGSfD8HH0KXq_o-mHEJF@mail.gmail.com>
	 <20110228.201852.193726064.davem@davemloft.net>
	 <AANLkTi=eDQh9Kvr9N_dTC5Cnbcfb+DbO-6tLxkZiEp9v@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Mar 2011 08:26:21 +0100
Message-ID: <1298964381.2676.58.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le mardi 01 mars 2011 à 01:54 -0500, Albert Cahalan a écrit :
> On Mon, Feb 28, 2011 at 11:18 PM, David Miller <davem@davemloft.net> wrote:
> > From: Albert Cahalan <acahalan@gmail.com>
> > Date: Mon, 28 Feb 2011 23:11:13 -0500
> >
> >> It sounds like you need a callback or similar, so that TCP can be
> >> informed later that the drop has occurred.
> >
> > By that point we could have already sent an entire RTT's worth
> > of data, or more.
> >
> > It needs to be synchronous, otherwise performance suffers.
> 
> Ouch. OTOH, the current situation: performance suffers.
> 
> In case it makes you feel any better, consider two cases
> where synchronous feedback is already impossible.
> One is when you're routing packets that merely pass through.
> The other is when some other box is doing that to you.
> Either way, packets go bye-bye and nobody tells TCP.

So in a hurry we decide to drop packets blindly because kernel took the
cpu to perform an urgent task ?

Bufferbloat is a configuration/tuning problem, not a "everything must be
redone" problem. We add new qdiscs (CHOKe, SFB, QFQ, ...) and let admins
do their job. Problem is most admins are unaware of the problems, and
only buy more bandwidth.

And no, there is no "generic" solution, unless you have a lab with two
machines back to back (private link) and a known workload.

We might need some changes (including new APIs).

ECN is a forward step. Blindly dropping packets before ever sending them
is a step backward.

We should allow some trafic spikes, or many applications will stop
working. Unless all applications are fixed, we are stuck.

Only if the queue stay loaded a long time (yet another parameter) we can
try to drop packets.



Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756145Ab0KCUyt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 16:54:49 -0400
Received: from waste.org ([173.11.57.241]:43844 "EHLO waste.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab0KCUys (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 16:54:48 -0400
Subject: Re: [PATCH v1 00/12] netoops support
From: Matt Mackall <mpm@selenic.com>
To: Mike Waychison <mikew@google.com>
Cc: Greg KH <greg@kroah.com>, simon.kagstrom@netinsight.net,
        davem@davemloft.net, adurbin@google.com, akpm@linux-foundation.org,
        chavey@google.com, linux-kernel@vger.kernel.org,
        linux-api@vger.kernel.org
In-Reply-To: <4CD1C612.5080902@google.com>
References: <20101103012917.4641.57113.stgit@crlf.mtv.corp.google.com>
	 <20101103023422.GB5782@kroah.com>
	 <AANLkTi=Oe4oJ0imCh1eoJLS0QYqSBM4pLo=dEUSiJcQb@mail.gmail.com>
	 <20101103181634.GF7441@kroah.com>
	 <AANLkTimKWCWtuPeZhMZ75gTxB8LwAhJfy2FZnnRwthft@mail.gmail.com>
	 <4CD1C612.5080902@google.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 03 Nov 2010 15:54:45 -0500
Message-ID: <1288817685.26428.1129.camel@calx>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-11-03 at 13:29 -0700, Mike Waychison wrote:
> Mike Waychison wrote:
> > FWIW, another semantic difference between netconsole and netoops (that
> > I had missed in the last email) is filtering: we really do want to get
> > the whole log when a crash happens, debug messages and all.
> > Netconsole is subject to console filtering (which we _do_ want as
> > debug messages going out the uart slows the whole world down).
> > 
> > netconsole and netoops _do_ have bits in common, for instance the
> > handling of NETDEV events and source+target configuration.  I'd rather
> > those bits become common between the two than figure out how to jam
> > the semantics we need into netconsole.
> 
> Hi Matt,
> 
> I've been reading through the netconsole driver in response to Greg's 
> comments on this thread, and it is definitely more robust in terms of 
> configuration and handling of network device events than the netoops 
> driver I proposed.

I've been following the discussion to see if it went anywhere
interesting..

> What are your thoughts on extending netconsole with the same sort of 
> semantics that are in the netoops patchset?

My first thought is that it's a bit unfortunate that some of the the
netconsole configgy bits weren't implemented in a generic way that would
be applicable to other netpoll clients. Some people have never gotten it
into their heads that netconsole isn't the only client.

> I'd still like to have blit-dmesg-to-the-network-on-oops semantics, 
> which seems doable by having a per-target flag for streaming of console 
> messages (enabled by default) and a flag to emit a structured full dmesg 
> dump (disabled by default).

I'd actually like to see you go forward with netoops. It's clear to me
that it's a different beast and complexifying netconsole with a bunch of
weird new options doesn't really sit well. If that means abstracting
some of the sysfs crap from netconsole, great. 

That said, I don't think netoops is an ideal name, given how closely
bound oops _events_ are with their textual output. Presumably it covers
events other than oopsen like panics too. 

Regarding rolling oopses: lots of machines regularly survive oopses, so 
I think you ought to consider rate-limiting them (to a configurable rate
with a very low default) rather than suppressing all but the first.

-- 
Mathematics is the supreme nostalgia of our time.



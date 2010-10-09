Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab0JIMx2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Oct 2010 08:53:28 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:37773 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755663Ab0JIMx1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Oct 2010 08:53:27 -0400
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast
 frames
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@google.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Matt Smith <Matt.Smith@atheros.com>,
        Srinivasa Duvvuri <Srinivasa.Duvvuri@atheros.com>,
        Carolyn Waller <Carolyn.Waller@atheros.com>,
        Amod Bodas <Amod.Bodas@atheros.com>,
        David Quan <David.Quan@atheros.com>,
        Bennyam Malavazi <Bennyam.Malavazi@atheros.com>,
        Cliff Holden <Cliff.Holden@atheros.com>,
        Aeolus Yang <Aeolus.Yang@atheros.com>, Kevin Hayes <kevin@atheros.com>
In-Reply-To: <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com>
	 <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 09 Oct 2010 14:53:21 +0200
Message-ID: <1286628801.3530.98.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-10-08 at 17:08 -0700, Paul Stewart wrote:

> > Userspace may want to force a roam when this deadzone event hits.
> 
> Why not just disassociate at this point?  I'm not sure what the
> difference is between a "dead zone" situation and a reason to
> completely disconnect.

I'd tend to agree -- what point is there in receiving data when you
can't even ACK it any more.. you'll just hurt everybody else by using
huge amounts of airtime, and if the situation persists hopefully the AP
will kick you off quickly anyway.

> > Once we have these two in place we can then ignore bgscan requests
> > (when associated) unless a force scan command has been issued by
> > userspace, or unless we are idle.
> 
> By "ignore" do you mean "postpone" or or "return an appropriate error
> to userspace"?  Either of those are acceptable.  Not doing anything at
> all wouldn't be good.  There's an additional issue about what happens
> when we are in the middle of a bgscan and new tx traffic appears.

I really don't want to add API for "force" to userspace -- it's entirely
pointless. If userspace wants their scan, so they'll always have to set
the force flag anyway. Postponing it for a bit seems much saner. I think
you're trying to solve a problem with say an existing NM that tries to
scan every two minutes -- but that problem need not be solved at this
layer.

> > In the worst case scenario and unfortunately this seems to be the most
> > common one, a DTIM of 1 is used and we will have to be on channel and
> > awake every beacon interval. In this case we may want to optimize scan
> > time by not scanning passive scan channels.
> 
> A compromise would be to go off-channel for less than a full beacon
> interval when doing background passive channel scans in DTIM=1
> networks.  It's certainly better than (a) not scanning at all and (b)
> arguably better than intentionally dropping mcast.  An 80% beacon-time
> passive listen will get you 80% of the beacons, assuming linear
> probability, and even more over time if you account for beacon skew
> between networks.

Skew between APs is minimal -- the clocks are required to be accurate to
5ppm IIRC.

And in any case, there's no way to achieve perfect multicast reliability
_anyway_, so I don't see why you're even trying? Can somebody actually
come up with a problem statement? All I've seen so far is DHCP, but for
just that, what's wrong with doing what you already do now?

johannes


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756810Ab0JKW2T (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 18:28:19 -0400
Received: from smtp-out.google.com ([74.125.121.35]:59771 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756587Ab0JKW2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 18:28:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=W9WQGrUiZmPE7R4DDIpzMfpAfQ+rBcP6c3FwZVGS/eE1a9OrWNSwAyb8aAEHUkKbo8
         3f8lzC0PjLVdjLaIUbSg==
MIME-Version: 1.0
In-Reply-To: <1286628801.3530.98.camel@jlt3.sipsolutions.net>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com>
	<AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
	<1286628801.3530.98.camel@jlt3.sipsolutions.net>
Date: Mon, 11 Oct 2010 15:28:13 -0700
Message-ID: <AANLkTin_nraU0Ma2N4OMejCX4DW+nyXFU3uGXM-dH_XP@mail.gmail.com>
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast frames
From: Paul Stewart <pstew@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
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
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Whoops.  I didn't reply-all here and only sent to Johannes]

On Sat, Oct 9, 2010 at 5:53 AM, Johannes Berg <johannes@sipsolutions.net> wrote:
> And in any case, there's no way to achieve perfect multicast reliability
> _anyway_, so I don't see why you're even trying? Can somebody actually
> come up with a problem statement? All I've seen so far is DHCP, but for
> just that, what's wrong with doing what you already do now?

I think this brings up a fairly fundamental difference in outlook
here, but I think it is completely resolvable.  The argument "this is
an unreliable medium / class of traffic -- why spend any extra effort
on receiving it" doesn't personally wash with me.  I think the term
used for traffic of this sort is "best effort".  Especially in the
situation where the background scan was triggered just for
informational purposes ("what other channels does this ESS exist on?
I may want to look there first when things start getting nasty on this
channel"), I see no reason to either hurry the scan or knowingly
interrupt any form of traffic (no matter how low on the totem pole
they may appear to be).

I spent a lot of effort in an an earlier life in supporting multicast
and writing various multicast protocols, and I have to admit that
being in position to have to defend "best effort" as such is a little
distressing. :-)  There are tons of different uses for multicast, and
while the use cases all have to consider a situation where frames are
lost on the medium, there is always a cost to their loss.  In many
situations it might be better from the standpoint of ultimate channel
utilization to have received all multicast ("best effort") than to
have left it all on the floor.  As I said above, there are classes of
background scan where loss of fidelity in the scan is much more
tolerable.

Even in the 80% passive scan case, I consider a passive-only scan
channel with an AP with a beacon interval synchronized such that we
will never hear from it unless we choose not to listen to our "home"
beacon to be marginalized enough that I'd prefer to never see it while
I'm successfully connected to a separate AP.

I propose to resolve this difference in outlook by proposing another
flag (orthogonal to passive/active) which describes whether the scan
should be "seamless", which is to say "prioritize all traffic on the
home channel above scanning".  This could include the TX enhancements
(abort/postpone scan immediately if transmit traffic appears) as well
as receiving all multicast traffic regardless of the possible
detriment to the efficacy of the scan.

This may be paired with one additional feature -- progressive return
of scan results.  Since the scan may take a while (in some senses it
already does).  It would be nice to get nl80211 messages with each BSS
as it is acquired, much in the same way as wpa_supplicant now does in
its new DBus API.

--
Paul

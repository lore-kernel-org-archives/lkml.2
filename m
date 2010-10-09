Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759968Ab0JIAIc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 20:08:32 -0400
Received: from smtp-out.google.com ([216.239.44.51]:41090 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751729Ab0JIAIa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 20:08:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=QIXc0DBzE55PgP9L9L2/2ZoOZwLPP8mREGG3mvdqDy7rTXefte96WyhdUTMHUqWnmp
         ErQodlYgkMSu4MsYWNHA==
MIME-Version: 1.0
In-Reply-To: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com>
References: <AANLkTin9AwTa8x6faFEXBbrGZa4mg3AeDfeEmmdaF9_d@mail.gmail.com>
Date: Fri, 8 Oct 2010 17:08:28 -0700
Message-ID: <AANLkTika+07mD==fPioanurwD-_s8aaJFc+nb4ZZOL0J@mail.gmail.com>
Subject: Re: Roaming / offchannel enhancements for broadcast / multicast frames
From: Paul Stewart <pstew@google.com>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
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

On Fri, Oct 8, 2010 at 12:54 PM, Luis R. Rodriguez <mcgrof@gmail.com> wrote:
> We spoke about how to handle broadcast / multicast frames when going
> offchannel at the Wireless Summit [1]. A lot of these talks were lead
> due to a Chrome side open bug [2].

Thanks for getting the ball rolling, Luis.  Technically the bug is in
ChromumOS ("Chrome" is a web browser).

> Userspace may want to force a roam when this deadzone event hits.

Why not just disassociate at this point?  I'm not sure what the
difference is between a "dead zone" situation and a reason to
completely disconnect.

> Once we have these two in place we can then ignore bgscan requests
> (when associated) unless a force scan command has been issued by
> userspace, or unless we are idle.

By "ignore" do you mean "postpone" or or "return an appropriate error
to userspace"?  Either of those are acceptable.  Not doing anything at
all wouldn't be good.  There's an additional issue about what happens
when we are in the middle of a bgscan and new tx traffic appears.

> In the worst case scenario and unfortunately this seems to be the most
> common one, a DTIM of 1 is used and we will have to be on channel and
> awake every beacon interval. In this case we may want to optimize scan
> time by not scanning passive scan channels.

A compromise would be to go off-channel for less than a full beacon
interval when doing background passive channel scans in DTIM=1
networks.  It's certainly better than (a) not scanning at all and (b)
arguably better than intentionally dropping mcast.  An 80% beacon-time
passive listen will get you 80% of the beacons, assuming linear
probability, and even more over time if you account for beacon skew
between networks.

--
Paul

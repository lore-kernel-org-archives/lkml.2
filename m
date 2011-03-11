Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab1CKAaO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Mar 2011 19:30:14 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52273 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751251Ab1CKAaM convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Mar 2011 19:30:12 -0500
MIME-Version: 1.0
In-Reply-To: <20110310.155556.48513201.davem@davemloft.net>
References: <20110310.153444.115930379.davem@davemloft.net>
 <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com> <20110310.155556.48513201.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 10 Mar 2011 16:29:30 -0800
Message-ID: <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
Subject: Re: [GIT] Networking
To: David Miller <davem@davemloft.net>
Cc: akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 3:55 PM, David Miller <davem@davemloft.net> wrote:
> I should have put:
>
>        Merge to get commit 8909c9ad8ff03611c9c96c9a92656213e4bb495b
>        ("net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules")
>        so that we can add Stephen Hemminger's fix to handle ip6 tunnels
>        as well, which uses the MODULE_ALIAS_NETDEV() macro created by
>        that change.

Yeah, that would have explained it. That said, if you are merging for
something like that, may I suggest actually starting off with

   git merge 8909c9ad8ff03611c9c96c9a92656213e4bb495b

that then actually makes the history itself also show the relationship
(you'd still have to write the commit message explaining why,
otherwise git will try to be "helpful" by making the merge commit
message be

   Merge commit '8909c9ad8ff03611c9c96c9a92656213e4bb495b'

which while _technically_ more useful and indicative of what you
wanted to do isn't actually any more readable than the one you have
now.

But the reason it would have been better is that it would literally
have made the git commit parenthood point to the commit you actually
care about.

Of course, since 'gitk' ends up highlighting the SHA1 pointers in the
commit message, even just mentioning it in the message is often almost
equivalent to having the parenthood be explicit. But it would show in
the actual history graph too, which I think would have been a good
thing.

Oh well. Water under the bridge. I think I'll try --no-ff this once,
despite my misgivings about the concept.

                Linus

[ The reason I don't like "--no-ff" is that it can cause endless "I'm
going to add my own merge message" wars where people want to write
their name in the snow, and then doing cross-merges doesn't ever
actually converge on a single end-result. Fast-forward merges means
that people merging back-and-forth will always end up converging.

But I guess the whole notion of "upstream" vs "downstream" is the
thing that should be considered to be the real way to avoid that, and
if a project cannot agree on what's upstream and what is downstream, I
suspect the project has deeper problems than a few extra merge
messages ;^) ]

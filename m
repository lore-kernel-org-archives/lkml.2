Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754616Ab1CKUs2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 15:48:28 -0500
Received: from fieldses.org ([174.143.236.118]:44099 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab1CKUs0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 15:48:26 -0500
Date: Fri, 11 Mar 2011 15:48:23 -0500
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
Message-ID: <20110311204823.GB7906@fieldses.org>
References: <20110310.153444.115930379.davem@davemloft.net>
 <AANLkTimnHtVS=SFopgyjAAQDW8bXDKDXf+YvEtPdpPsA@mail.gmail.com>
 <20110310.155556.48513201.davem@davemloft.net>
 <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik3AyFTNoytebmOOZ=JSFMkt0bw7au-CSncUHJu@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
From: "J. Bruce Fields" <bfields@fieldses.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 04:29:30PM -0800, Linus Torvalds wrote:
> On Thu, Mar 10, 2011 at 3:55 PM, David Miller <davem@davemloft.net> wrote:
> > I should have put:
> >
> >        Merge to get commit 8909c9ad8ff03611c9c96c9a92656213e4bb495b
> >        ("net: don't allow CAP_NET_ADMIN to load non-netdev kernel modules")
> >        so that we can add Stephen Hemminger's fix to handle ip6 tunnels
> >        as well, which uses the MODULE_ALIAS_NETDEV() macro created by
> >        that change.
> 
> Yeah, that would have explained it. That said, if you are merging for
> something like that, may I suggest actually starting off with
> 
>    git merge 8909c9ad8ff03611c9c96c9a92656213e4bb495b
> 
> that then actually makes the history itself also show the relationship
> (you'd still have to write the commit message explaining why,

By the way, I occasionally wonder whether it would make sense to make a
habit of committing bugfixes on top of the commit that introduced the
bug (at least in cases where there *is* a single commit that introduced
the bug).

As with the above, it'd make the history a little more self-documenting.
It might simplify life for backporters.  (In theory, they could do
merges instead of a cherry-picks if they wanted to.)  The set of "bad"
commits would be described by "fix^...fix".

But then I had some mental image if your saying "WTF?" the first time I
send you a post-rc1 pull request that looks like an octopus merge of a
dozen little 1- or 2- commit branches based all over the place.

I dunno, would it be annoying?

--b.

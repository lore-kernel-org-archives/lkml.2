Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933229Ab1JZOYh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 10:24:37 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:47953 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933120Ab1JZOYg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 10:24:36 -0400
Date: Wed, 26 Oct 2011 15:23:01 +0100
From: Mark Einon <mark.einon@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Greg KH <greg@kroah.com>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        Jiri Pirko <jpirko@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ian Campbell <ian.campbell@citrix.com>
Subject: Re: [GIT PATCH] big staging merge for 3.2
Message-ID: <20111026142301.GA4732@marke.airties>
References: <20111026120725.GA23142@kroah.com>
 <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+55aFxRETDCVs=2pLSbc1qkhUYbfexVO9KG64EP2LKNdXGCeQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 03:59:40PM +0200, Linus Torvalds wrote:
> On Wed, Oct 26, 2011 at 2:07 PM, Greg KH <greg@kroah.com> wrote:
> >
> > Here is the big staging merge for 3.2
> >
> > Note, I ended up merging this with your 3.1 release to resolve a merge
> > issue with one of the comedi drivers to fix a build issue.  If you want
> > me to redo the tree without this merge, I'll be glad to do so and let
> > you do it :)
> 
> I don't hate merges that make sense, and that one looks fine. You
> picked a logical merge point, and you wrote a merge message that
> explains it. No problem.
> 
> > There's a lot of patches in here, and the overall diff is quite
> > impressive:
> >  834 files changed, 103718 insertions(+), 230262 deletions(-)
> 
> Hmm... I only get
> 
>  725 files changed, 103936 insertions(+), 180480 deletions(-)
> 
> Which is still good, but nothing like your numbers. Where did you find
> the extra 50k lines?
> 
> > All patches have been in the -next releases for a while now.
> 
> So I got several conflicts with the networking tree. Most of them were
> trivial (eg driver removal conflicting with somebody trying to fix up
> the now dead driver), but I really hope somebody looks at the
> resulting drivers/staging/et131x/et131x.c file.
> 
> That driver wasn't removed, it was consolidated as one big file, and
> so the fixes to the original files needed to be resolved. I tried to
> do that correctly, but there's the skb_frag_dma_map() change and the
> removal of .ndo_set_multicast_list, and while I think I did it right,
> I really want somebody who knows that code to double check me.
> 
> Appropriate people to do that added to the cc,
> 
>                  Linus

Hi Linus,

The code changes look good, but it also needs the removal of a NETDEV_1000 dependency in the Kconfig file.

I sent a patch for these changes yesterday, you can find it here :
http://www.spinics.net/lists/netdev/msg177938.html

It's practically identical to your fixes, except for the Kconfig change.

Cheers,

Mark

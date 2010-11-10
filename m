Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098Ab0KJCAg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 21:00:36 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51995 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752202Ab0KJCAf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 21:00:35 -0500
Date: Tue, 9 Nov 2010 18:00:18 -0800
From: Kees Cook <kees.cook@canonical.com>
To: Joe Perches <joe@perches.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Jiri Slaby <jslaby@suse.cz>,
        "David S. Miller" <davem@davemloft.net>,
        Hugh Dickins <hughd@google.com>,
        Manfred Spraul <manfred@colorfullife.com>
Subject: Re: [PATCH] ipc: explicitly clear stack memory in user structs
Message-ID: <20101110020018.GH5876@outflux.net>
References: <20101025235804.GA11760@outflux.net>
 <AANLkTi=c4kt46Pa1FA-e8=36Vn0KcmZgHHKWKZ_bgvzL@mail.gmail.com>
 <20101109205008.GU5876@outflux.net>
 <AANLkTint3yM44CouOvG_oA2K=_iC9AJuw-sJoB_HTUMT@mail.gmail.com>
 <20101109234852.GC5876@outflux.net>
 <AANLkTinCLMGWWD=8do9pv0vnFMX8njYyNgsMS+VeRfpQ@mail.gmail.com>
 <1289351010.28590.81.camel@Joe-Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1289351010.28590.81.camel@Joe-Laptop>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 09, 2010 at 05:03:30PM -0800, Joe Perches wrote:
> On Tue, 2010-11-09 at 16:54 -0800, Linus Torvalds wrote:
> > On Tue, Nov 9, 2010 at 3:48 PM, Kees Cook <kees.cook@canonical.com> wrote:
> > >> I don't quite see where you got the particular collection of people from.
> > > I used scripts/get_maintainer.pl
> > Hmm. I get totally different results. You had
> >   linux-kernel@vger.kernel.org
> >   Al Viro <viro@zeniv.linux.org.uk>,
> >   Andrew Morton <akpm@linux-foundation.org>,
> >   Jiri Slaby <jslaby@suse.cz>,
> >   "David S. Miller" <davem@davemloft.net>
> > and I get
> >   Al Viro <viro@ZenIV.linux.org.uk>
> >   Andrew Morton <akpm@linux-foundation.org>
> >   Helge Deller <deller@gmx.de>
> >   David Howells <dhowells@redhat.com>
> >   Hugh Dickins <hughd@google.com>
> >   linux-kernel@vger.kernel.org
> > so there is something odd going on there.
> 
> I'd like to know as well.

Well, let's see what happens. If I rewind the tree to roughly
542181d3769d001c59cd17573dd4381e87d215f2 taking a wild guess at where my
tree was when I send the patch, and run it, here's what I get:

$ ./scripts/get_maintainer.pl 0001-ipc-initialize-structure-memory-to-zero-in-shm.patch
Al Viro <viro@zeniv.linux.org.uk>
Andrew Morton <akpm@linux-foundation.org>
Jiri Slaby <jslaby@suse.cz>
"Serge E. Hallyn" <serue@us.ibm.com>
"David S. Miller" <davem@davemloft.net>
linux-kernel@vger.kernel.org

And since I know Serge's address isn't at ibm any more, I dropped it from
Cc, assuming he didn't care about ipc structure fixups.

If I fast-forward to today and run it, I get the same output you do.

-Kees

-- 
Kees Cook
Ubuntu Security Team

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753405Ab1KAKQi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Nov 2011 06:16:38 -0400
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:36940 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752475Ab1KAKQh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Nov 2011 06:16:37 -0400
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
        Sasha Levin <levinsasha928@gmail.com>,
        Christoph Hellwig <hch@infradead.org>,
        David Rientjes <rientjes@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, ngupta@vflare.org,
        Chris Mason <chris.mason@oracle.com>, JBeulich@novell.com,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <20111031181651.GF3466@redhat.com>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	 <75efb251-7a5e-4aca-91e2-f85627090363@default>
	 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
	 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
	 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
	 <20111031181651.GF3466@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 01 Nov 2011 14:16:30 +0400
Message-ID: <1320142590.7701.64.camel@dabdike>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-10-31 at 19:16 +0100, Andrea Arcangeli wrote:
> On Fri, Oct 28, 2011 at 08:21:31AM -0700, Dan Magenheimer wrote:
> > real users and real distros and real products waiting, so if there
> > are any real issues, let's get them resolved.
> 
> We already told you the real issues there are and you did nothing so
> far to address those, so much was built on top of a flawed API that I
> guess an heartquake of massive scale has to come in to actually
> convince Xen to change any of the huge amount of code built on the
> flawed API.
> 
> I don't know the exact Xen details (it's possible Xen design doesn't
> allow these below 4 issues to be fixed, I've no idea) but for all
> other non-virt usages (compressed-swap/compressed-pagecache, ramster)
> I doubt it is impossible to change the design of the tmem API to
> address at least one of those basic huge troubles that such an API
> imposes:

Actually, I think there's an unexpressed fifth requirement:

5. The optimised use case should be for non-paging situations.

The problem here is that almost every data centre person tries very hard
to make sure their systems never tip into the swap zone.  A lot of
hosting datacentres use tons of cgroup controllers for this and
deliberately never configure swap which makes transcendent memory
useless to them under the current API.  I'm not sure this is fixable,
but it's the reason why a large swathe of users would never be
interested in the patches, because they by design never operate in the
region transcended memory is currently looking to address.

This isn't an inherent design flaw, but it does ask the question "is
your design scope too narrow?"

James



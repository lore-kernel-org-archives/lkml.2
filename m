Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab1J3UGp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 Oct 2011 16:06:45 -0400
Received: from e37.co.us.ibm.com ([32.97.110.158]:32788 "EHLO
	e37.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751876Ab1J3UGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 Oct 2011 16:06:44 -0400
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: John Stoffel <john@stoffel.org>, Johannes Weiner <jweiner@redhat.com>,
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
        Jonathan Corbet <corbet@lwn.net>
In-Reply-To: <3ac142d4-a4ca-4a24-bf0b-69a90bd1d1a0@default>
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>
	 <75efb251-7a5e-4aca-91e2-f85627090363@default>
	 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
	 <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
	 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>
	 <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com>
	 <20111028163053.GC1319@redhat.com>
	 <b86860d2-3aac-4edd-b460-bd95cb1103e6@default>
	 <20138.62532.493295.522948@quad.stoffel.home>
	 <3982e04f-8607-4f0a-b855-2e7f31aaa6f7@default 20139.5644.583790.903531@quad.stoffel.home>
	 <3ac142d4-a4ca-4a24-bf0b-69a90bd1d1a0@default>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 30 Oct 2011 13:06:02 -0700
Message-ID: <1320005162.15403.14.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
x-cbid: 11103020-7408-0000-0000-00000075200B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-10-30 at 12:18 -0700, Dan Magenheimer wrote:
> > since they're the ones who will have to understand this stuff and know
> > how to maintain it.  And keeping this maintainable is a key goal.
> 
> Absolutely agree.  Count the number of frontswap lines that affect
> the current VM core code and note also how they are very clearly
> identified.  It really is a very VERY small impact to the core VM
> code (e.g. in the files swapfile.c and page_io.c). 

Granted, the impact on the core VM in lines of code is small.  But, I
think the behavioral impact is potentially huge since tmem's hooks add
non-trivial amounts of framework underneath the VM in core paths.  In
zcache's case, this means a bunch of allocations and an entirely new
allocator memory allocator being used in the swap paths.

We're certainly still shaking bugs out of the interactions there like
with zcache_direct_reclaim_lock.  Granted, that's not a
tmem/frontswap/cleancache bug, but it does speak to the difficulty and
subtlety of writing one of those frameworks underneath the tmem API.

-- Dave


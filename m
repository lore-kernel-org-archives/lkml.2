Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753325Ab1KCWaI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Nov 2011 18:30:08 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:56610 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752233Ab1KCWaH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Nov 2011 18:30:07 -0400
MIME-Version: 1.0
Message-ID: <69ed0521-cda2-4fc2-b51b-7bcc39d65afd@default>
Date: Thu, 3 Nov 2011 15:29:34 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: Pekka Enberg <penberg@kernel.org>, Cyclonus J <cyclonusj@gmail.com>,
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
Subject: RE: [GIT PULL] mm: frontswap (for 3.2 window)
References: <75efb251-7a5e-4aca-91e2-f85627090363@default>
 <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>
 <CAOzbF4fnD=CGR-nizZoBxmFSuAjFC3uAHf3wDj5RLneJvJhrOQ@mail.gmail.comCAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>
 <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default20111031181651.GF3466@redhat.com>
 <60592afd-97aa-4eaf-b86b-f6695d31c7f1@default20111031223717.GI3466@redhat.com>
 <1b2e4f74-7058-4712-85a7-84198723e3ee@default20111101012017.GJ3466@redhat.com>
 <6a9db6d9-6f13-4855-b026-ba668c29ddfa@default20111101180702.GL3466@redhat.com>
 <b8a0ca71-a31b-488a-9a92-2502d4a6e9bf@default20111102013122.GA18879@redhat.com>
 <2bc86220-1e48-40e5-b502-dcd093956fd5@default
 20111103003254.GE18879@redhat.com>
In-Reply-To: <20111103003254.GE18879@redhat.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.4.1.0  (410211) [OL
 12.0.6562.5003]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4EB315D8.00E9,ss=1,re=0.000,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Andrea Arcangeli [mailto:aarcange@redhat.com]
> Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)

Hi Andrea --

Sorry for the delayed response... and for continuing this
thread further, but I want to ensure I answer your
points.

First, did you see my reply to Rik that suggested a design
as to how KVM could do batching with no change to the
hooks or frontswap_ops API?  (Basically a guest-side
cache and add a batching op to the KVM-tmem ABI.)  I think
it resolves your last remaining concern (too many vmexits),
so am eager to see if you agree.

> Like somebody already pointed out (and I agree) it'd be nice to get
> the patches posted to the mailing list (with git send-emails/hg

Frontswap v10 https://lkml.org/lkml/2011/9/15/367 as last posted
to linux-mm has identical code to the git commits... in response
to Konrad and Kame, the commit-set was slightly reorganized and
extended from 6 commits to 8, but absolutely no code differences.
Since no code was changed between v10 and v11, I didn't repost v11
to linux-mm.

Note, every version of frontswap was posted to linux-mm and
cc'ed to Andrew, Hugh, Nick and Rik and I was very diligent
in responding to all comments...  Wish I would have
cc'ed you all along as this has been a great discussion.

> email/quilt) and get them merged into -mm first.

Sorry, I'm still a newbie on this process, but just to clarify,
"into -mm" means Andrew merges the patches, right?  Andrew
said in the first snippet of https://lkml.org/lkml/2011/11/1/317 
that linux-next is fine, so I'm not sure whether to follow your
advice or not.

> Thanks. So this overall sounds fairly positive (or at least better
> than neutral) to me.

Excellent!

> On my side I hope it get improved over time to get the best out of
> it. I've not been hugely impressed so far because at this point in
> time it doesn't seem a vast improvement in runtime behavior compared
> to what zram could provide, like Rik said there's no iov/SG/vectored
> input to tmem_put (which I'd find more intuitive renamed to
> tmem_store), like Avi said ramster is synchronous and not good having
> to wait a long time. But if we can make these plugins stackable and we
> can put a storage backend at the end we could do
> storage+zcache+frontswap.

This thread has been so long, I don't even remember what I've
replied to who, so just to clarify on these several points,
in case you didn't see these elsewhere in the thread:

- Nitin Gupta, author of zram, thinks zcache is an improvement
  over zram because it is more flexible/dynamic
- KVM can do batching fairly easily with no changes to the
  hooks or frontswap_ops with the design I recently proposed
- RAMster is synchronous, but the requirement is _only_ on the
  "local" put... once the data is "in tmem", asynchronous threads
  can do other things with it (like RAMster moving the pages
  to a tmem pool on a remote system)
- the plugins as they exist today (Xen, zcache) aren't stackable,
  but the frontswap_ops registration already handles stacking,
  so it is certainly a good future enhancement... RAMster
  already does "stacking", but by incorporating a copy of
  the zcache code.  (I think that's just a code organization
  issue that can be resolved if/when RAMster goes into staging.)

With these in mind, I hope you will now be even a "lot more
happy now" with frontswap and MUCH better than neutral. :-) :-)

Dan

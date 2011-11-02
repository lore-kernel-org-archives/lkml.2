Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1KBTqm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 15:46:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4244 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750778Ab1KBTqk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 15:46:40 -0400
Message-ID: <4EB19DE5.4080108@redhat.com>
Date: Wed, 02 Nov 2011 15:45:41 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110906 Thunderbird/6.0.2
MIME-Version: 1.0
To: Dave Hansen <dave@linux.vnet.ibm.com>
CC: Dan Magenheimer <dan.magenheimer@oracle.com>,
        John Stoffel <john@stoffel.org>, Johannes Weiner <jweiner@redhat.com>,
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
Subject: Re: [GIT PULL] mm: frontswap (for 3.2 window)
References: <b2fa75b6-f49c-4399-ba94-7ddf08d8db6e@default>  <75efb251-7a5e-4aca-91e2-f85627090363@default>  <20111027215243.GA31644@infradead.org> <1319785956.3235.7.camel@lappy>  <CAOJsxLGOTw7rtFnqeHvzFxifA0QgPVDHZzrEo=-uB2Gkrvp=JQ@mail.gmail.com>  <552d2067-474d-4aef-a9a4-89e5fd8ef84f@default>  <CAOJsxLEE-qf9me1SAZLFiEVhHVnDh7BDrSx1+abe9R4mfkhD=g@mail.gmail.com>  <20111028163053.GC1319@redhat.com>  <b86860d2-3aac-4edd-b460-bd95cb1103e6@default>  <20138.62532.493295.522948@quad.stoffel.home>  <3982e04f-8607-4f0a-b855-2e7f31aaa6f7@default 20139.5644.583790.903531@quad.stoffel.home>  <3ac142d4-a4ca-4a24-bf0b-69a90bd1d1a0@default> <1320005162.15403.14.camel@nimitz>
In-Reply-To: <1320005162.15403.14.camel@nimitz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/30/2011 04:06 PM, Dave Hansen wrote:
> On Sun, 2011-10-30 at 12:18 -0700, Dan Magenheimer wrote:
>>> since they're the ones who will have to understand this stuff and know
>>> how to maintain it.  And keeping this maintainable is a key goal.
>>
>> Absolutely agree.  Count the number of frontswap lines that affect
>> the current VM core code and note also how they are very clearly
>> identified.  It really is a very VERY small impact to the core VM
>> code (e.g. in the files swapfile.c and page_io.c).
>
> Granted, the impact on the core VM in lines of code is small.  But, I
> think the behavioral impact is potentially huge since tmem's hooks add
> non-trivial amounts of framework underneath the VM in core paths.  In
> zcache's case, this means a bunch of allocations and an entirely new
> allocator memory allocator being used in the swap paths.

My only real behaviour concern with tmem is that
/proc/sys/overcommit_memory will no longer be able
to do anything useful, since we'll never know in
advance how much memory is available.

That may be outweighed by the benefits of having
more memory available than before, and a reasonable
tradeoff to make for the users.

That leaves us with having the code cleaned up to
reasonable standards.  To be honest, I would rather
have larger hooks in the existing mm code, than
exported variables and having the hooks live elsewhere
(where people changing the "normal" mm code won't see
it, and are more likely to break it).

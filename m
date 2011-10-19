Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1JSTm0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Oct 2011 15:42:26 -0400
Received: from smtp-out.google.com ([74.125.121.67]:3241 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049Ab1JSTmZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Oct 2011 15:42:25 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=rb7qOt64UhAm0jFw8ciHoPL5aaQ79Bo53IflwhE3IjYDrlCmzwCpJFE7gP9tdI4Jk
	/oUVBf/rmuGexqJrDCaPQ==
Date: Wed, 19 Oct 2011 12:42:15 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Mel Gorman <mgorman@suse.de>, Andrea Arcangeli <aarcange@redhat.com>,
        Pawel Sikora <pluto@agmk.net>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org,
        jpiszcz@lucidpixels.com, arekm@pld-linux.org,
        linux-kernel@vger.kernel.org
Subject: Re: kernel 3.0: BUG: soft lockup: find_get_pages+0x51/0x110
In-Reply-To: <CA+55aFwf75oJ3JJ2aCR8TJJm_oLireD6SDO+43GveVVb8vGw1w@mail.gmail.com>
Message-ID: <alpine.LSU.2.00.1110191234570.6900@sister.anvils>
References: <201110122012.33767.pluto@agmk.net> <alpine.LSU.2.00.1110131547550.1346@sister.anvils> <alpine.LSU.2.00.1110131629530.1410@sister.anvils> <20111016235442.GB25266@redhat.com> <alpine.LSU.2.00.1110171111150.2545@sister.anvils> <20111019074336.GB3410@suse.de>
 <CA+55aFwf75oJ3JJ2aCR8TJJm_oLireD6SDO+43GveVVb8vGw1w@mail.gmail.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 19 Oct 2011, Linus Torvalds wrote:
> On Wed, Oct 19, 2011 at 12:43 AM, Mel Gorman <mgorman@suse.de> wrote:
> >
> > My vote is with the migration change. While there are occasionally
> > patches to make migration go faster, I don't consider it a hot path.
> > mremap may be used intensively by JVMs so I'd loathe to hurt it.
> 
> Ok, everybody seems to like that more, and it removes code rather than
> adds it, so I certainly prefer it too. Pawel, can you test that other
> patch (to mm/migrate.c) that Hugh posted? Instead of the mremap vma
> locking patch that you already verified for your setup?
> 
> Hugh - that one didn't have a changelog/sign-off, so if you could
> write that up, and Pawel's testing is successful, I can apply it...
> Looks like we have acks from both Andrea and Mel.

Yes, I'm glad to have that input from Andrea and Mel, thank you.

Here we go.  I can't add a Tested-by since Pawel was reporting on the
alternative patch, but perhaps you'll be able to add that in later.

I may have read too much into Pawel's mail, but it sounded like he
would have expected an eponymous find_get_pages() lockup by now,
and was pleased that this patch appeared to have cured that.

I've spent quite a while trying to explain find_get_pages() lockup by
a missed migration entry, but I just don't see it: I don't expect this
(or the alternative) patch to do anything to fix that problem.  I won't
mind if it magically goes away, but I expect we'll need more info from
the debug patch I sent Justin a couple of days ago.

Ah, I'd better send the patch separately as
"[PATCH] mm: fix race between mremap and removing migration entry":
Pawel's "l" makes my old alpine setup choose quoted printable when
I reply to your mail.

Hugh

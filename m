Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757190Ab3AIEYB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 23:24:01 -0500
Received: from mail-pa0-f43.google.com ([209.85.220.43]:35877 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757132Ab3AIEX7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 23:23:59 -0500
Date: Tue, 8 Jan 2013 20:23:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Andrea Arcangeli <aarcange@redhat.com>
cc: Linus Torvalds <torvalds@linux-foundation.org>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Hillf Danton <dhillf@gmail.com>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Linux-MM <linux-mm@kvack.org>,
        Rik van Riel <riel@redhat.com>
Subject: Re: oops in copy_page_rep()
In-Reply-To: <20130108173747.GF9163@redhat.com>
Message-ID: <alpine.LNX.2.00.1301082020280.2351@eggly.anvils>
References: <20130105152208.GA3386@redhat.com> <CAJd=RBCb0oheRnVCM4okVKFvKGzuLp9GpZJCkVY3RR-J=XEoBA@mail.gmail.com> <alpine.LNX.2.00.1301061037140.28950@eggly.anvils> <CAJd=RBAps4Qk9WLYbQhLkJd8d12NLV0CbjPYC6uqH_-L+Vu0VQ@mail.gmail.com>
 <CA+55aFyYAf6ztDLsxWFD+6jb++y0YNjso-9j+83Mm+3uQ=8PdA@mail.gmail.com> <CAJd=RBDTvCcYV8qAd-++_DOyDSypQD4Dvt216pG9nTQnWA2uCA@mail.gmail.com> <CA+55aFzfUABPycR82aNQhHNasQkL1kmxLN1rD0DJcByFtead3g@mail.gmail.com> <20130108163141.GA27555@shutemov.name>
 <CA+55aFzaTvF7nYxWBT-G_b=xGz+_akRAeJ=U9iHy+Y=ZPo=pbA@mail.gmail.com> <20130108173747.GF9163@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 8 Jan 2013, Andrea Arcangeli wrote:
> 
> Looking at this, one thing that isn't clear is where the page_count is
> checked in migrate_misplaced_transhuge_page. Ok that it's unable to
> migrate anon transhuge COW shared pages so it doesn't need to mess
> with rmap (the mapcount check makes it safe), but it shouldn't be
> allowed to migrate memory that has gup direct-IO in flight (and that
> can only be detected with a page_count vs mapcount check). Real
> migrate does page_freeze_refs to be safe. Mel comments?

Yes, I protested to Mel about that before the holidays, and he
quickly provided a patch, now in akpm's tree; but checking it again
today, I believe it's still not quite right yet - see other mail.

Hugh

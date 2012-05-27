Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753242Ab2E0Upx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 16:45:53 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:63013 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750871Ab2E0Upu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 16:45:50 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LSU.2.00.1205261317310.2488@eggly.anvils>
References: <1337884054.3292.22.camel@lappy> <20120524120727.6eab2f97.akpm@linux-foundation.org>
 <CA+1xoqcbZWLpvHkOsZY7rijsaryFDvh=pqq=QyDDgo_NfPyCpA@mail.gmail.com> <alpine.LSU.2.00.1205261317310.2488@eggly.anvils>
From: Sasha Levin <levinsasha928@gmail.com>
Date: Sun, 27 May 2012 22:45:28 +0200
Message-ID: <CA+1xoqfGeQjrVWM3p4M0hV=hAwzx18bcoH7Bcn1mv_vOE8hDRw@mail.gmail.com>
Subject: Re: mm: kernel BUG at mm/memory.c:1230
To: Hugh Dickins <hughd@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, viro <viro@zeniv.linux.org.uk>,
        oleg@redhat.com, "a.p.zijlstra" <a.p.zijlstra@chello.nl>,
        mingo <mingo@kernel.org>, Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Andrea Arcangeli <aarcange@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 26, 2012 at 10:26 PM, Hugh Dickins <hughd@google.com> wrote:
> I'm keeping off the linux-next for the moment; I'll worry about this
> more if it shows up when we try 3.5-rc1.  Your fuzzing tells that my
> logic above is wrong, but maybe it's just a passing defect in next.

I have a theory about this, which might explain it.

After a couple of days of not being able to reproduce it, I've decided
to revert Mel Gorman's patch related to memory corruption in mbind().
Once I've reverted it, I wasn't able to reproduce this exact case, but
did observe several other interesting things:

 - The original mbind() memory corruption.
 - Corruption in eventfd related structures (same dump as the mbind
one, but about eventfd structure).
 - Same as above, but with flock.
 - Hit a different BUG() in mm/mempolicy.c (The one at the end of slab_node()).

Is it possible that this issue could be explained by a corruption
related to the mbind() issue?

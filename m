Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759872Ab2FANnd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jun 2012 09:43:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:61484 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758209Ab2FANnc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jun 2012 09:43:32 -0400
Date: Fri, 1 Jun 2012 09:43:23 -0400
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>, Cong Wang <amwang@redhat.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990
 __set_page_dirty_nobuffers+0x13a/0x170()
Message-ID: <20120601134323.GA5214@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>,
	Hugh Dickins <hughd@google.com>, Cong Wang <amwang@redhat.com>
References: <20120530163317.GA13189@redhat.com>
 <20120531005739.GA4532@redhat.com>
 <20120601023107.GA19445@redhat.com>
 <CA+55aFyNSUbTfY4YdH4OcrrRnwkw-sHy3aT18ynf-YXRXSJQ8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFyNSUbTfY4YdH4OcrrRnwkw-sHy3aT18ynf-YXRXSJQ8Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 31, 2012 at 07:43:25PM -0700, Linus Torvalds wrote:
 > On Thu, May 31, 2012 at 7:31 PM, Dave Jones <davej@redhat.com> wrote:
 > >
 > > So I bisected it anyway, and it led to ...
 > 
 > Ok, that doesn't sound entirely unlikely, but considering that you're
 > nervous about the bisection, please just try to revert it and see if
 > that fixes your testcase.
 > 
 > You'll obviously need to revert the commit that removes
 > vmtruncate_range() too, since reverting 3f31d07571ee will re-introduce
 > the use of it (it's the next one:
 > 17cf28afea2a1112f240a3a2da8af883be024811), but it looks like those two
 > commits revert cleanly and the end result seems to compile ok.

crap, so much for that theory.  I ran latest with those two reverted
overnight, and woke up to a dead box.  Over serial console, I see
a bunch of those same compaction oopses (Via sys_mmap_pgoff),
and then kernel BUG at include/linux/mm.h:448! was the last thing
it said before it choked.

I'll redo the bisect. It's possible that one of the 'good' paths just
didn't run for long enough.

	Dave


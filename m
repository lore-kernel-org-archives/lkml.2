Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754839Ab2FCV7q (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 17:59:46 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:47649 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751037Ab2FCV7p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 17:59:45 -0400
MIME-Version: 1.0
In-Reply-To: <20120603205332.GA5412@redhat.com>
References: <20120601023107.GA19445@redhat.com> <alpine.LSU.2.00.1206010030050.8462@eggly.anvils>
 <20120601161205.GA1918@redhat.com> <20120601171606.GA3794@redhat.com>
 <alpine.LSU.2.00.1206011511560.12839@eggly.anvils> <CA+55aFy2-X92EqpiuyvkBp_2-UaYDUpaC2c3XT3gXMN1O+T7sw@mail.gmail.com>
 <alpine.LSU.2.00.1206012108430.11308@eggly.anvils> <20120603181548.GA306@redhat.com>
 <CA+55aFwZ5PsBLqM7K8vDQdbS3sf+vi3yeoWx6XKV=nF8k2r7DQ@mail.gmail.com>
 <20120603183139.GA1061@redhat.com> <20120603205332.GA5412@redhat.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 3 Jun 2012 14:59:22 -0700
X-Google-Sender-Auth: 26yaPxQEQNrG8IG020bsSgI0LxU
Message-ID: <CA+55aFzjuPTBNGkMohmy+AzvvB9S_aEUOpG2nD-WjS9YGdQV0w@mail.gmail.com>
Subject: Re: WARNING: at mm/page-writeback.c:1990 __set_page_dirty_nobuffers+0x13a/0x170()
To: Dave Jones <davej@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Mel Gorman <mgorman@suse.de>, Minchan Kim <minchan@kernel.org>,
        Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <amwang@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 3, 2012 at 1:53 PM, Dave Jones <davej@redhat.com> wrote:
>
> running just over two hours with that commit reverted with no obvious ill effects so far.

And how quickly have you usually seen the problems? Would you have
considered two ours "good" in your bisection thing?

Also, just to check: Hugh sent out a patch called "mm: fix warning in
__set_page_dirty_nobuffers". Is that applied in your tree too, or did
the __set_page_dirty_nobuffers() warning go away with just the revert?

I'm just trying to figure out exactly what you are testing. When you
said "test with that (and Hugh's last patch) backed out", the "and
Hugh's last patch" part was a bit ambiguous. Do you mean the trial
patch in this thread (backed out) or do you mean "*with* Hugh's patch
for the __set_page_dirty_nobuffers() warning".

              Linus

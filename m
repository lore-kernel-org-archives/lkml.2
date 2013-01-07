Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3AGAh1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Jan 2013 19:37:27 -0500
Received: from mx1.redhat.com ([209.132.183.28]:4462 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752294Ab3AGAhZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Jan 2013 19:37:25 -0500
Date: Sun, 6 Jan 2013 19:37:18 -0500
From: Dave Jones <davej@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: oops in copy_page_rep()
Message-ID: <20130107003718.GA1336@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
References: <20130105152208.GA3386@redhat.com>
 <CA+55aFwkP=nA32pBO0gNm51nPxqWiq1e1zWzGEJoVQ1gP=CgDQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwkP=nA32pBO0gNm51nPxqWiq1e1zWzGEJoVQ1gP=CgDQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jan 05, 2013 at 07:57:39PM -0800, Linus Torvalds wrote:
 > Adding more people in case somebody else has any idea. Anybody?
 > 
 > On Sat, Jan 5, 2013 at 7:22 AM, Dave Jones <davej@redhat.com> wrote:
 > > I have no idea what happened here, but this is the first time I've seen this one.
 > > This was running a tree pulled yesterday afternoon.
 > >
 > > BUG: unable to handle kernel paging request at ffff880100201000
 > 
 > This is %rsi, which is the source for the page copy:
 > 
 >   copy_user_highpage()->
 >     copy_user_page()->
 >       copy_page()->
 >         copy_page_rep
 > 
 > I don't know exactly which copy_user_highpage() case this is from, the
 > call trace implies this *could* be a hugepage, and those functions do
 > copy pages individually in a loop too.

investigating the huge page theory a little further I'm a bit confused.
The kernel on that machine has THP enabled, and the cpu supports it (an old amd64), but..

$ cat /sys/kernel/mm/hugepages/hugepages-2048kB/*
0
0
0
0
0
0

I was expecting at least one of those to be non-zero.

/sys/kernel/mm/transparent_hugepage/khugepaged/full_scans and pages_collapsed
are both non-zero, so it's been busy doing _something_.

Is this expected behaviour ?

	Dave


Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2CBAq5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 19:46:57 -0500
Received: from mga03.intel.com ([143.182.124.21]:4861 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753990Ab2CBAq4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 19:46:56 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="72566016"
From: Andi Kleen <andi@firstfloor.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: .. anybody know of any filesystems that depend on the exact VFS 'namehash' implementation?
References: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
Date: Thu, 01 Mar 2012 16:46:46 -0800
In-Reply-To: <CA+55aFyv=OKUuAV6pqdmbHeUL7Motsh+n026nWqaT63aEgBjBQ@mail.gmail.com>
	(Linus Torvalds's message of "Wed, 29 Feb 2012 15:36:09 -0800")
Message-ID: <m2ipinq16x.fsf@firstfloor.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Torvalds <torvalds@linux-foundation.org> writes:

> So I'm doing my normal profiling ("empty kernel build" is my favorite
> one), and link_path_walk() and __d_lookup_rcu() remain some of the
> hottest kernel functions due to their per-character loops.
>
> I can improve __d_lookup_rcu() on my machine by what appears to be
> around 15% by doing things a "unsigned long" at a time (it would be an
> option that only works on little-endian and with cheap unaligned
> accesses, although the big-endian modifications should be pretty
> trivial).

There should be generally better modern general hash algorithms around,
like murmur, cityhash or snoopy. Perhaps even the fnv we have in tree,
but it's somewhat dated by know.

They all have larger code, but if it's really that hot it would be worth
it.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only

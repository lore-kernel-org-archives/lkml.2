Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752576Ab0LJGVp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Dec 2010 01:21:45 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33625 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750769Ab0LJGVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Dec 2010 01:21:44 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
References: <1291335412-16231-1-git-send-email-walken@google.com>
	<1291335412-16231-2-git-send-email-walken@google.com>
	<20101208152740.ac449c3d.akpm@linux-foundation.org>
	<AANLkTikYZi0=c+yM1p8H18u+9WVbsQXjAinUWyNt7x+t@mail.gmail.com>
Date: Thu, 9 Dec 2010 22:11:30 -0800
Message-ID: <AANLkTinY0pcTcd+OxPLyvsJgHgh=cTaB1-8VbEA2tstb@mail.gmail.com>
Subject: Re: [PATCH 1/6] mlock: only hold mmap_sem in shared mode when
 faulting in pages
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Hugh Dickins <hughd@google.com>, Rik van Riel <riel@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>, Nick Piggin <npiggin@kernel.dk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 8, 2010, Michel Lespinasse <walken@google.com> wrote:
>
> Yes, patch 1/6 changes the long hold time to be in read mode instead
> of write mode, which is only a band-aid. But, this prepares for patch
> 5/6, which releases mmap_sem whenever there is contention on it or
> when blocking on disk reads.

I have to say that I'm not a huge fan of that horribly kludgy
contention check case.

The "move page-in to read-locked sequence" and the changes to
get_user_pages look fine, but the contention thing is just disgusting.
I'd really like to see some other approach if at all possible.

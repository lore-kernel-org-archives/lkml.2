Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933139Ab1CWPsY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 11:48:24 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:43192 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753184Ab1CWPsX convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 11:48:23 -0400
MIME-Version: 1.0
In-Reply-To: <20110323153727.GB12003@htj.dyndns.org>
References: <20110323153727.GB12003@htj.dyndns.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 23 Mar 2011 08:48:01 -0700
Message-ID: <AANLkTik4iG+Ssb+JU3YRB4C11CEZeVozqoiz4rvezFLL@mail.gmail.com>
Subject: Re: [RFC PATCH] mutex: Apply adaptive spinning on mutex_trylock()
To: Tejun Heo <tj@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Mason <chris.mason@oracle.com>, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 23, 2011 at 8:37 AM, Tejun Heo <tj@kernel.org> wrote:
>
> Currently, mutex_trylock() doesn't use adaptive spinning.  It tries
> just once.  I got curious whether using adaptive spinning on
> mutex_trylock() would be beneficial and it seems so, at least for
> btrfs anyway.

Hmm. Seems reasonable to me. The patch looks clean, although part of
that is just the mutex_spin() cleanup that is independent of actually
using it in trylock.

So no objections from me.

                    Linus

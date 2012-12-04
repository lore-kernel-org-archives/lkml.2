Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754692Ab2LDOnZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Dec 2012 09:43:25 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:48008 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754227Ab2LDOnX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Dec 2012 09:43:23 -0500
MIME-Version: 1.0
In-Reply-To: <1354473824-19229-50-git-send-email-mingo@kernel.org>
References: <1354473824-19229-1-git-send-email-mingo@kernel.org>
	<1354473824-19229-50-git-send-email-mingo@kernel.org>
Date: Tue, 4 Dec 2012 06:43:22 -0800
Message-ID: <CANN689GwAuFcGsH54Ao=MBrAKJda+62XgkiUQ8MsBDgFYtEERw@mail.gmail.com>
Subject: Re: [PATCH 49/52] mm/rmap: Convert the struct anon_vma::mutex to an rwsem
From: Michel Lespinasse <walken@google.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Christoph Lameter <cl@linux.com>, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 2, 2012 at 10:43 AM, Ingo Molnar <mingo@kernel.org> wrote:
> Convert the struct anon_vma::mutex to an rwsem, which will help
> in solving a page-migration scalability problem. (Addressed in
> a separate patch.)
>
> The conversion is simple and straightforward: in every case
> where we mutex_lock()ed we'll now down_write().

Looks good.

Reviewed-by: Michel Lespinasse <walken@google.com>

-- 
Michel "Walken" Lespinasse
A program is never fully debugged until the last user dies.

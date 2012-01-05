Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758269Ab2AET12 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 14:27:28 -0500
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62498 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932498Ab2AET10 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 14:27:26 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1201051210040.25706@router.home>
References: <alpine.LFD.2.02.1111292001420.4019@tux.localdomain>
 <CAOJsxLEHT4D4rfMvWe5iPFpunOaLWZD9fJxbOJ6_qMwt_rd7eg@mail.gmail.com>
 <20111220162315.GC10752@google.com> <CA+55aFwwjAtiiM5V3LfebmtKAOzxZXk-VzJ3U7PJAc1VjxK69Q@mail.gmail.com>
 <20111220202854.GH10752@google.com> <alpine.DEB.2.00.1112210851230.9601@router.home>
 <20111221170535.GB9213@google.com> <alpine.DEB.2.00.1112220854440.31315@router.home>
 <20111222160822.GE17084@google.com> <alpine.DEB.2.00.1112221154380.11787@router.home>
 <CA+55aFzY_6QYVyjAmP+w8D0Xy1Pq++XEUaBJRcCN9SbDE-pOhw@mail.gmail.com>
 <alpine.DEB.2.00.1112231031001.3482@router.home> <CA+55aFzCY7TyEgkWFn6wxUMjBBaKGcx0hdV6gTdta5u8eK=Ymg@mail.gmail.com>
 <alpine.DEB.2.00.1201040906090.27157@router.home> <CA+55aFwOp1UbeexKSdQC6YwrA9pS-J5qdqs-68=H8T1GS4Nr1A@mail.gmail.com>
 <alpine.DEB.2.00.1201041046290.29775@router.home> <CA+55aFwgN4QGowU1+5NO0QWr4nT9KDyk8opiVgzmULJG-2eKzg@mail.gmail.com>
 <alpine.DEB.2.00.1201051210040.25706@router.home>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 5 Jan 2012 11:27:04 -0800
X-Google-Sender-Auth: zmE7PKsQzhKr5wCtDRIXZOlCGlM
Message-ID: <CA+55aFy8DpY-Cuq8B7pOLEjZkiiaxCUE0sEQv8uTX_WZXnUJwg@mail.gmail.com>
Subject: Re: [GIT PULL] slab fixes for 3.2-rc4
To: Christoph Lameter <cl@linux.com>
Cc: Tejun Heo <tj@kernel.org>, Pekka Enberg <penberg@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 5, 2012 at 11:15 AM, Christoph Lameter <cl@linux.com> wrote:
>
> XADD and ADD have the same cycle count if the ADD is used to add to a
> memory location. Both use 4 microops.

Christ, stop counting uops. They are some random internal
microarchitectural detail, and ignores things like processor uop
scheduling and decoding issues.

The thing that matters is (a) performance and (b) code sanity.

The "local_cpu_return()" operations fail *seriously* in the code
sanity department. They are a fundamentally insane operation.

And nothing you have said says "it's a huge performance win" to me.
First off, there aren't even very many users, and the users there are
seem to not even be all that performance-critical.

For statistics, just regular "add" is the normal thing to do. The
add_return thing is insane, for all the reasons I already outlined. It
*fundamentally* doesn't have any sane semantics. Just remove it.

                         Linus

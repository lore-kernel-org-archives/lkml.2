Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753708Ab1HXSCg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Aug 2011 14:02:36 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:33456 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753649Ab1HXSCc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Aug 2011 14:02:32 -0400
MIME-Version: 1.0
In-Reply-To: <39551c1e0ae3e4963ad9ac119edf78dbd25a32d9.1314207974.git.jeremy.fitzhardinge@citrix.com>
References: <cover.1314207974.git.jeremy.fitzhardinge@citrix.com> <39551c1e0ae3e4963ad9ac119edf78dbd25a32d9.1314207974.git.jeremy.fitzhardinge@citrix.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 24 Aug 2011 11:01:52 -0700
Message-ID: <CA+55aFzN8753+nnfk11uf_vv1JddQSh3ZRe9-cpe+e5UmhmWtg@mail.gmail.com>
Subject: Re: [PATCH 03/18] x86/ticketlock: Use C for __ticket_spin_unlock
To: Jeremy Fitzhardinge <jeremy@goop.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@elte.hu>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nick Piggin <npiggin@kernel.dk>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 24, 2011 at 10:52 AM, Jeremy Fitzhardinge <jeremy@goop.org> wrote:
> From: Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
>
> If we don't need to use a locked inc for unlock, then implement it in C.

Ok, so I really hate this patch.

What the f&*^ is the point of doing it this way? It just ends up being
incredibly ugly, with a mixture of C, asm, and barriers. The "C"
version is actually *uglier* than the non-C version, so why do it in C
at all?

Just get rid of this one.  It adds lines of code, makes the code
harder to read, and is just a disaster.

                        Linus

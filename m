Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752528Ab1G3SdG (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:33:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36483 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab1G3Sc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFzut1tF6CLAPJUUh2H_7M4wcDpp2+Zb85Lqvofe+3v_jQ@mail.gmail.com>
References: <alpine.DEB.2.00.1107290145080.3279@tiger> <CA+55aFzut1tF6CLAPJUUh2H_7M4wcDpp2+Zb85Lqvofe+3v_jQ@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 08:32:10 -1000
Message-ID: <CA+55aFw9V-VM5TBwqdKiP0E_g8urth+08nX-_inZ8N1_gFQF4w@mail.gmail.com>
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
To: Pekka Enberg <penberg@kernel.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org, rientjes@google.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 30, 2011 at 8:27 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Do we allocate the page map array sufficiently aligned that we
> actually don't ever have the case of straddling a cacheline? I didn't
> check.

Oh, and another thing worth checking: did somebody actually check the
timings for:

 - *just* the alignment change?

   IOW, maybe some of the netperf improvement isn't from the lockless
path, but exactly from 'struct page' always being in a single
cacheline?

 - check performance with cmpxchg16b *without* the alignment.

   Sometimes especially intel is so good at unaligned accesses that
you wouldn't see an issue. Now, locked ops are usually special (and
crossing cachelines with a locked op is dubious at best), so there may
actually be correctness issues involved too, but it would be
interesting to hear if anybody actually just tried it.

Hmm?

            Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754601Ab1BPUwP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 15:52:15 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56878 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754388Ab1BPUwM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 15:52:12 -0500
MIME-Version: 1.0
In-Reply-To: <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
References: <20110216185234.GA11636@tiehlicka.suse.cz> <20110216193700.GA6377@elte.hu>
 <AANLkTinDxxbVjrUViCs=UaMD9Wg9PR7b0ShNud5zKE3w@mail.gmail.com> <AANLkTi=xnbcs5BKj3cNE_aLtBO7W5m+2uaUacu7M8g_S@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Wed, 16 Feb 2011 12:51:21 -0800
Message-ID: <AANLkTikgTsktn3DBEweQd1bH=NKoSsXwNai92F_zM_H1@mail.gmail.com>
Subject: Re: BUG: Bad page map in process udevd (anon_vma: (null)) in 2.6.38-rc4
To: Ingo Molnar <mingo@elte.hu>
Cc: Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 16, 2011 at 12:09 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> That said, neither 0x1e68 nor 0xe68 seems to be in the main vmlinux
> file. But I haven't checked modules yet.

There's no obvious clues in modules either. Sad. I was really hoping
for some "oh, there's a list_head at offset 0x1e68 of structure 'xyz',
that's obviously it".

So maybe it really is something like a pointer to some on-stack data,
and the 0x1e68 offset is just a random offset off the beginning of the
stack (it's in the right range). The stack is still one of the few
obvious 8kB allocations we have...

CONFIG_DEBUG_PAGEALLOC really should catch it in that case, though.

                            Linus

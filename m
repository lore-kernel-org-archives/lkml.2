Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569Ab1G3S2Q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 30 Jul 2011 14:28:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:47191 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752271Ab1G3S2J (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 30 Jul 2011 14:28:09 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1107290145080.3279@tiger>
References: <alpine.DEB.2.00.1107290145080.3279@tiger>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sat, 30 Jul 2011 08:27:47 -1000
Message-ID: <CA+55aFzut1tF6CLAPJUUh2H_7M4wcDpp2+Zb85Lqvofe+3v_jQ@mail.gmail.com>
Subject: Re: [GIT PULL] Lockless SLUB slowpaths for v3.1-rc1
To: Pekka Enberg <penberg@kernel.org>
Cc: cl@linux-foundation.org, akpm@linux-foundation.org, rientjes@google.com,
        hughd@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 28, 2011 at 12:47 PM, Pekka Enberg <penberg@kernel.org> wrote:
>
> This pull request has patches to make SLUB slowpaths lockless like we
> already did for the fastpaths. They have been sitting in linux-next for a
> while now and should be fine. David Rientjes reports improved performance:

So I'm not excited about the growth of the data structure, but I'll
pull this. The performance numbers seem to be solid, and dang it, it
is wonderful to finally hear about netperf performance *improvements*
due to slab changes, rather than things getting slower.

And 'struct page' is largely random-access, so the fact that the
growth makes it basically one cacheline in size sounds like a good
thing.

Do we allocate the page map array sufficiently aligned that we
actually don't ever have the case of straddling a cacheline? I didn't
check.

                                   Linus

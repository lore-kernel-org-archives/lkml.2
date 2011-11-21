Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1KUQBf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 11:01:35 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:63156 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752143Ab1KUQBe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 11:01:34 -0500
Date: Mon, 21 Nov 2011 17:02:44 +0100
From: Daniel Vetter <daniel@ffwll.ch>
To: Ben Widawsky <ben@bwidawsk.net>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx <intel-gfx@lists.freedesktop.org>,
        linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: [Intel-gfx] [PATCH 02/13] drm/i915: rewrite shmem_pwrite_slow to
 use copy_from_user
Message-ID: <20111121160244.GA3807@phenom.ffwll.local>
Mail-Followup-To: Ben Widawsky <ben@bwidawsk.net>,
	intel-gfx <intel-gfx@lists.freedesktop.org>,
	linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org
References: <1320606840-21132-1-git-send-email-daniel.vetter@ffwll.ch>
 <1320606840-21132-3-git-send-email-daniel.vetter@ffwll.ch>
 <20111120215632.6982c55c@bwidawsk.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111120215632.6982c55c@bwidawsk.net>
X-Operating-System: Linux phenom 3.1.0+
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Nov 20, 2011 at 09:56:32PM -0800, Ben Widawsky wrote:
[snip the patch]
> Bikeshed, but I would much prefer a #define for the swizzle
> bit/cacheline size.

I've looked at this stuff way too long, so I'm biased, but 64 = cacheline
= dram fetch size = 1 << 64 feels about as natural for me as 4096 =
PAGE_SIZE ...

[snip the patch]

> I must be missing something obvious here...
> Can you explain how this can possibly be considered safe without holding
> struct_mutex?

That's the reason why the commit msg goes through every case and explains
why I think it's safe. The large thing here is that we need to drop the
mutex when calling copy_*_user (at least in the non-atomic slow-paths)
because otherwise we might deadlock with our own pagefault handler.
-Daniel
-- 
Daniel Vetter
Mail: daniel@ffwll.ch
Mobile: +41 (0)79 365 57 48

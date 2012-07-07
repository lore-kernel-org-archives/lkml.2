Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752004Ab2GGXUs (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Jul 2012 19:20:48 -0400
Received: from smtp.outflux.net ([198.145.64.163]:36606 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751725Ab2GGXUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Jul 2012 19:20:47 -0400
Date: Sat, 7 Jul 2012 16:20:40 -0700
From: Kees Cook <keescook@chromium.org>
To: "Theodore Ts'o" <tytso@mit.edu>, Kees Cook <keescook@chromium.org>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        ewust@umich.edu, zakir@umich.edu, nadiah@cs.ucsd.edu,
        jhalderm@umich.edu, stable@vger.kernel.org
Subject: Re: [PATCH] random: only use gathered bytes from arch_get_random_long
Message-ID: <20120707232040.GE28340@outflux.net>
References: <1341614704-24965-1-git-send-email-tytso@mit.edu>
 <1341614704-24965-8-git-send-email-tytso@mit.edu>
 <20120707171122.GD28340@outflux.net>
 <20120707182316.GA3681@thunk.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120707182316.GA3681@thunk.org>
Organization: Outflux
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 07, 2012 at 02:23:16PM -0400, Theodore Ts'o wrote:
> On Sat, Jul 07, 2012 at 10:11:22AM -0700, Kees Cook wrote:
> > While very unlikely, it is possible for arch_get_random_long() to fail
> > in the middle of the loop in xfer_secondary_pool(), which would mean
> > that the loop could stop with only part of u.hwrand populated, leading
> > to mix_pool_bytes() injecting uninitialized or already injected bytes
> > instead of fresh bytes. This changes the mix_pool_bytes() call to only
> > inject the successfully gathered bytes.
> 
> I don't believe there is a major problem with injecting uninitialized
> or even known bytes into the pool; worst case we're wastiing a tiny
> amount of CPU in this unlikely case (versus the CPU costs of doing the
> multiplication each time).  Not that I think really matters one way or
> the other... 
> 
> Is there a reason why you're particularly concerned about what might
> happen in the case where arch_get_random_long() fails mid-loop (which
> can happen if RDRAND returns an error for whatever reason, granted)?

Not really, but it seems like poor form to try to mix in data that wasn't
actually what you were expecting. I don't exactly see a problem with what
you've already got, but it seems like it's better to not have the bug at
all.

-Kees

-- 
Kees Cook
Chrome OS Security

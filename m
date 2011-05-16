Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752676Ab1EPQtl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 12:49:41 -0400
Received: from one.firstfloor.org ([213.235.205.2]:51645 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752292Ab1EPQtk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 12:49:40 -0400
Date: Mon, 16 May 2011 18:49:39 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andi Kleen <andi@firstfloor.org>, Andy Lutomirski <luto@MIT.EDU>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@elte.hu>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Borislav Petkov <bp@amd64.org>
Subject: Re: [PATCH v4 0/6] Micro-optimize vclock_gettime
Message-ID: <20110516164939.GD25898@one.firstfloor.org>
References: <cover.1305560561.git.luto@mit.edu> <20110516160943.GC25898@one.firstfloor.org> <alpine.LFD.2.02.1105161817120.3078@ionos>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.02.1105161817120.3078@ionos>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> And unless you or someone else changes the primitive state of the
> kernel, framepointers are going to stay simply because removing them
> breaks profiling backtraces when the hit is inside vread().

This doesn't work anyways because the glibc stub code calling vgettimeofday
normally doesn't set up a frame pointer frame.

The only way to unwind there is dwarf2.

-Andi

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756300Ab0DETlR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 15:41:17 -0400
Received: from mail-pz0-f193.google.com ([209.85.222.193]:39946 "EHLO
	mail-pz0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756104Ab0DETlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 15:41:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=KZE/N+/qsY6j1umjXO/BEvZK7khMyZrp9hZvpF8VN5qZqsURWblus4CkmgN4vFQ21B
         5aLrXdZDTvx5OvqEe2fwEDBSNGS1zGE7VKCSHFRJUby21WNGrOdm+YPZX2+KQT0NAtcp
         6UCFJ8Pzj34Smabk7PqROTuOxzE0dPFQT88m8=
Date: Mon, 5 Apr 2010 21:40:58 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: David Miller <davem@davemloft.net>
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@elte.hu,
       acme@redhat.com, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: Random scheduler/unaligned accesses crashes with perf lock
	events on sparc 64
Message-ID: <20100405194055.GA5265@nowhere>
References: <20100404122113.GD5177@nowhere> <20100404.180057.109331958.davem@davemloft.net> <20100405065701.GC5127@nowhere> <20100405.122233.188421941.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100405.122233.188421941.davem@davemloft.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05, 2010 at 12:22:33PM -0700, David Miller wrote:
> From: Frederic Weisbecker <fweisbec@gmail.com>
> Date: Mon, 5 Apr 2010 08:57:04 +0200
> 
> > It seems to happen after an unaligned access fixup.
> 
> You shouldn't be getting the unaligned fixup in the first place,
> especially in the locations where you see them.  I suspect that
> once you see first fixup, all of the registers in the cpu have
> been corrupted in one way or another.
> 
> I suspect something fundamental gets corrupted, for example the
> current register window (%cwp) is corrupted and that screws up all of
> the registers so every single function starts accessing garbage.
> 
> My suspicions lie in three places, the ftrace mcount()
> stubs, stack_trace_flush(), or the new perf_arch_save_caller_regs()
> since those are the three places offhand that could make
> us potentially make us return to function in the wrong
> register window.


It happens without CONFIG_FUNCTION_TRACER as well (but it happens
when the function tracer runs). And I hadn't your perf_arch_save_caller_regs()
when I triggered this.


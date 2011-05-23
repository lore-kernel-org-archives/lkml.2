Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1EWKVZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 06:21:25 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58448 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751767Ab1EWKVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 06:21:23 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mE5wJzK3Bj6PMPiN+baevNnJi+VtaRi+dmp4+Gw20hcGtK69O32heZCHipk2a0MWi3
         oGkLDyIjxvmNMy6/NejU3Ez3ysir8Yh/Jrex/8H6JBE5FLNxUADlzP9GGk6XcUuB17QU
         5A6XRuLSCkz3yO/Eseuc9J/YLPrkxWsntq/EQ=
MIME-Version: 1.0
In-Reply-To: <20110523090918.GA5474@elte.hu>
References: <20110520161210.81bbef3a.sfr@canb.auug.org.au>
	<BANLkTi=Dn_jvJ8mLY0Bc6C1Ptoqa-kJrCg@mail.gmail.com>
	<20110523090918.GA5474@elte.hu>
Date: Mon, 23 May 2011 13:21:22 +0300
Message-ID: <BANLkTi=Vbr+DRBy6sa7omGpvAb0uGunYMA@mail.gmail.com>
Subject: Re: [bloat] Measuring header file bloat effects on kernel build
 performance: a more than 2x slowdown ...
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        David Miller <davem@davemloft.net>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 23, 2011 at 12:09 PM, Ingo Molnar <mingo@elte.hu> wrote:
>      24594a2bfcaa: [PATCH] x86-64 merge
>
>     - Remove some unneeded prefetches.  Just two are enough to kickstart
>       the hardware prefetcher.
>
>   But despite touching prefetches explicitly, this too sloppily left the (now
>   dangling) prefetch.h include file around.

Well, developer removes include, developer risks compile breakage.

> Anway, what i tried to demonstrate with this mail how much *real* slowdown in
> the kernel build our current header file bloat is causing. We could literally
> halve our kernel build times if we fixed this!

News at 11!

Ingo, you're running x86 compile tests nonstop, you can very well make asm-x86
headers the strictest ones to make problem less problematic.

You (x86 merge people), removed header guards from quite a lot of asm-x86/*.h
files breaking gcc "do not open(2) second time" heuristics. It became better
since last I've noticed it, but maybe start with that?

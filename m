Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755030Ab2GKF33 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jul 2012 01:29:29 -0400
Received: from ozlabs.org ([203.10.76.45]:57468 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751512Ab2GKF32 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jul 2012 01:29:28 -0400
From: Rusty Russell <rusty@ozlabs.org>
To: Arnd Bergmann <arnd@arndb.de>, Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, Ingo Molnar <mingo@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <linux@arm.linux.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 00/36] AArch64 Linux kernel port
In-Reply-To: <201207101652.18401.arnd@arndb.de>
References: <1341608777-12982-1-git-send-email-catalin.marinas@arm.com> <20120710101018.GE15120@arm.com> <20120710163358.6ae4a576@pyramind.ukuu.org.uk> <201207101652.18401.arnd@arndb.de>
User-Agent: Notmuch/0.12 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Wed, 11 Jul 2012 14:56:49 +0930
Message-ID: <877guarhpi.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 10 Jul 2012 16:52:18 +0000, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 10 July 2012, Alan Cox wrote:
> > > In the AArch32 kernel port many implementation decisions newer
> > > architectures were made in a way that preserves backwards compatibility
> > > to over 15 years ago (and for good reasons, ARMv4 hardware is still in
> > > use). But keeping the same decisions in AArch64 is wrong.
> > 
> > Same argument as x86-32 v x86-64. Same issues about compatibility.
> 
> Similar but not the same. In case of x86-64 the hardware was actually
> meant to run old 32 bit kernel binaries and still can. I don't

I know it's a crazy idea, but why don't we try some actual analysis?

In 2.5.5, when arch/x86_64 was introduced it was 35412 lines of code.
hashmatch (http://www.samba.org/~tridge/hashmatch) says that about 24642
are identical with arch/i386 in the same kernel.  That's 70%.  Some of
that's boilerplate: 9610 lines are in common with arch/sparc64 (27%),
so let's say that 43% of x86-64 was specifically sharable with i386.

arch/aarch64/ is 22016 line of code.  Hashmatch says 12509 (57%) is in
common with arch/arm.  But only 3232 lines (15%) are in common with
sparc.  So let's say that 42% of aarch64 is specifically sharable with
arm.

Looks equivalent to me.  They will merge eventually.

That said:
1) It's nice to have a clear division of maintainer responsibilities in
   the near term.

2) PowerPC only "merged" by removing a raft of older platforms, and I
   don't think ARM is ready for that.

And yes, aarch64 is a stupid name.

Cheers,
Rusty.

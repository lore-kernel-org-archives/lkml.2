Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756083Ab1F1B0L (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 21:26:11 -0400
Received: from ozlabs.org ([203.10.76.45]:42097 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755674Ab1F1BYT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 21:24:19 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>, Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Jonas Bonn <jonas@southpole.se>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] modules: add default loader hook implementations
In-Reply-To: <201106271305.44746.arnd@arndb.de>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se> <87hb7b7ic6.fsf@rustcorp.com.au> <BANLkTinmhQT=__WP+10cr2HZPy1TvdxZ=w@mail.gmail.com> <201106271305.44746.arnd@arndb.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 28 Jun 2011 10:53:33 +0930
Message-ID: <87mxh2lpey.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011 13:05:44 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Monday 27 June 2011, Geert Uytterhoeven wrote:
> > >> I don't care much either way, you would get my Ack for both solutions.
> > >> The __weak approach would definitely make a simpler patch, and the
> > >> patch you sent adds extra complexity because of the
> > >> asm_generic_moduleloader_hooks macro you used to avoid having to
> > >> change all other architectures.
> > >
> > > I think you misread me.  If all else is equal, I dislike weak functions.
> > > But AFAICT the two standard mechanisms are #ifdef HAVE_ARCH and __weak.
> > > Inventing a third one is not going to be a win.
> > 
> > It's not inventing a new one, the third one is already in use.
> 
> True. In fact, we are (slowly) migrating away from HAVE_ARCH_* elsewhere.
> In include/asm-generic/*.h, the common method is now to #define the exact
> symbol if an architecture wants to override the generic version.
> 
> Weak symbols are fairly obscure in comparison, but they are actively
> used by a few architectures (mips, sh) and some core code in kernel/
> and mm/.

I stand corrected.  It seems to be done one way or another pretty much
on a whim.

To avoid more bikeshedding, smallest patch wins.  That's __weak, right?

Thanks,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab1F0JLT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 05:11:19 -0400
Received: from ozlabs.org ([203.10.76.45]:46222 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757442Ab1F0JJ5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 05:09:57 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Arnd Bergmann <arnd@arndb.de>, Jonas Bonn <jonas@southpole.se>
Cc: Ingo Molnar <mingo@elte.hu>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, monstr@monstr.eu, cmetcalf@tilera.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] modules: add default loader hook implementations
In-Reply-To: <201106251508.50129.arnd@arndb.de>
References: <1308987512-6583-1-git-send-email-jonas@southpole.se> <20110625100449.GA19097@elte.hu> <1308998367.6699.30.camel@localhost> <201106251508.50129.arnd@arndb.de>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 27 Jun 2011 18:37:53 +0930
Message-ID: <87hb7b7ic6.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 25 Jun 2011 15:08:49 +0200, Arnd Bergmann <arnd@arndb.de> wrote:
> On Saturday 25 June 2011, Jonas Bonn wrote:
> > On Sat, 2011-06-25 at 12:04 +0200, Ingo Molnar wrote:
> > > Also, and more importantly, don't we generally do such things via 
> > > __weak aliases, because the result looks cleaner and needs no changes 
> > > for architectures beyond the removal of the generic functions? We 
> > > have excluded broken toolchains that miscompile/mislink __weak IIRC 
> > > so __weak ought to work.
> > 
> > When we discussed this briefly yesterday, both Rusty and Arnd showed a
> > preference for not using __weak aliases... I'll leave it to them to
> > comment further.
> > 
> > The alternative patch that just provides __weak implementations for
> > these hooks is much less invasive than the patch I sent, effectively
> > touching only kernel/module.c
> > 
> > Let me know which is preferable.
> 
> I don't care much either way, you would get my Ack for both solutions.
> The __weak approach would definitely make a simpler patch, and the
> patch you sent adds extra complexity because of the
> asm_generic_moduleloader_hooks macro you used to avoid having to
> change all other architectures.

I think you misread me.  If all else is equal, I dislike weak functions.
But AFAICT the two standard mechanisms are #ifdef HAVE_ARCH and __weak.
Inventing a third one is not going to be a win.

And given where we are, __weak seems the easier path than HAVE_ARCH.
A followup patch to toss out the now-unneeded empty arch functions would
be nice, too.

Thanks,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753667Ab1GDFeQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jul 2011 01:34:16 -0400
Received: from ozlabs.org ([203.10.76.45]:58247 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751939Ab1GDFeL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jul 2011 01:34:11 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Jonas Bonn <jonas@southpole.se>,
        Linus Torvalds <torvalds@linux-foundation.org>
Cc: arnd@arndb.de, geert@linux-m68k.org, mingo@elte.hu,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        monstr@monstr.eu, cmetcalf@tilera.com, akpm@linux-foundation.org
Subject: Re: [PATCH 1/2] modules: add default loader hook implementations
In-Reply-To: <1309496433.24186.25.camel@localhost>
References: <201106281245.19457.arnd@arndb.de> <1309461732-2875-1-git-send-email-jonas@southpole.se> <BANLkTim3k+eRZHnpWLVHe0Q9SoU9w4zm=A@mail.gmail.com> <1309496433.24186.25.camel@localhost>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Mon, 04 Jul 2011 14:04:37 +0930
Message-ID: <87oc1aslya.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 01 Jul 2011 07:00:33 +0200, Jonas Bonn <jonas@southpole.se> wrote:
> 
> On Thu, 2011-06-30 at 13:02 -0700, Linus Torvalds wrote:
> > On Thu, Jun 30, 2011 at 12:22 PM, Jonas Bonn <jonas@southpole.se> wrote:
> > >
> > > The module loader code allows architectures to hook into the code by
> > > providing a small number of entry points that each arch must implement.
> > > This patch provides __weakly linked generic implementations of these
> > > entry points for architectures that don't need to do anything special.
> > 
> > Hmm. I know we used to have problems with gcc versions (or maybe
> > binutils) that had bugs wrt "weak" functions being declared in the
> > same compilation unit they were used. They would either inline the
> > weak function, or bind it early, and never let the linker see the
> > weak/strong functions and do the right thing.
> > 
> > I just don't remember if we disallowed those gcc/binutils versions and
> > check for it, or whether we decided that __weak function smust be
> > defined in a compilation unit separate from the user.
> > 
> > Because you now added all the weak functions to the same file
> > (module.c) that actually uses them.
> 
> There was precedent for this.  The function arch_mod_section_prepend was
> already defined as __weak in kernel/module.c.
> 
> And just looking around the kernel tree, there are lots of other files
> that have their weak variants in the same file as the functions that
> rely on them.  'git grep __weak' turns up a whole slew of them.

OK, I've applied these.

Thanks,
Rusty.

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755273Ab2EBOOI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 10:14:08 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:55989 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754616Ab2EBOOF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 10:14:05 -0400
Date: Wed, 2 May 2012 15:14:01 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Matt Fleming <matt@console-pimps.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120502141401.GK6871@ZenIV.linux.org.uk>
References: <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427175434.GA31524@redhat.com>
 <1335955070.18999.37.camel@mfleming-mobl1.ger.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1335955070.18999.37.camel@mfleming-mobl1.ger.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 02, 2012 at 11:37:50AM +0100, Matt Fleming wrote:
> > > The last thing. Matt, could you please look at
> > > git://git.kernel.org/pub/scm/linux/kernel/git/viro/signal.git ? It seems to me
> > > you already sent some of these changes (use set_current_blocked/block_sigmask).
> > > Perhaps there are alreay in -mm or linux-next?
> > 
> > Forgot to add Matt, sorry for noise...
> 
> Any of the changes that aren't in Linus' tree will be in -mm and
> linux-next. The ones currently in linux-next are,
> 
> 07d969a parisc: use set_current_blocked() and block_sigmask()
> 5becb45 frv: use set_current_blocked() and block_sigmask()
> 3608417 blackfin: use set_current_blocked() and block_sigmask()
> cd21f1a unicore32: use block_sigmask()
> 2bb36fd h8300: use set_current_blocked() and block_sigmask()
> a624f4f score: use set_current_blocked() and block_sigmask()
> 2326e2e score: don't mask signals if we fail to setup signal stack
> b2f6181 microblaze: use set_current_blocked() and block_sigmask()
> f557a56 microblaze: fix signal masking
> 9ff7b4a microblaze: no need to reset handler if SA_ONESHOT
> 6cb49f5 microblaze: don't reimplement force_sigsegv()
> bd9767f ia64: use set_current_blocked() and block_sigmask()
> cdbc96c cris: use set_current_blocked() and block_sigmask()
> 295f127 mn10300: use set_current_blocked() and block_sigmask()
> 524987e m68k: use set_current_blocked() and block_sigmask()
> f0c96a3 m32r: use set_current_blocked() and block_sigmask()
> f0f0acd avr32: use block_sigmask()
> ef64059 avr32: don't mask signals in the error path
> 
> ... and this one from you, Oleg, that was sent as part of my series,
> 
> 3e6c120 avr32: use set_current_blocked() in handle_signal/sys_rt_sigreturn

OK, those commits cherry-picked into the beginning of the queue, the
rest rebased on top of them, dropping my duplicates.

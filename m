Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753656Ab2D2SJa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 29 Apr 2012 14:09:30 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:34742 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696Ab2D2SJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 29 Apr 2012 14:09:28 -0400
Date: Sun, 29 Apr 2012 19:09:26 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org, Roland McGrath <roland@hack.frob.com>
Subject: Re: [RFC] TIF_NOTIFY_RESUME, arch/*/*/*signal*.c and all such
Message-ID: <20120429180926.GA6871@ZenIV.linux.org.uk>
References: <20120420164239.GH6871@ZenIV.linux.org.uk>
 <CA+55aFzuTspDyyLaOA-g-dTWydaUeeWo9uVGR+rZ=ZJzPW_Ocw@mail.gmail.com>
 <20120420180748.GI6871@ZenIV.linux.org.uk>
 <20120423180150.GA6871@ZenIV.linux.org.uk>
 <20120424072617.GB6871@ZenIV.linux.org.uk>
 <20120426183742.GA324@redhat.com>
 <20120426231942.GJ6871@ZenIV.linux.org.uk>
 <20120427172444.GA30267@redhat.com>
 <20120427184528.GL6871@ZenIV.linux.org.uk>
 <20120429164155.GC15792@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120429164155.GC15792@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 29, 2012 at 06:41:55PM +0200, Oleg Nesterov wrote:
> On 04/27, Al Viro wrote:
> >
> > 	BTW, I'm somewhat tempted to do the following: *ALL* calls of
> > tracehook_signal_handler() are now immediately preceded by block_signals().
> > Moreover, tracehook_signal_handler(...., 0) is currently a no-op, so
> > it could be painlessly added after the remaining block_signals() instances.
> > How about *folding* block_signals() (along with clear_restore_sigmask())
> > into tracehook_signal_handler()?
> 
> Oh, please no. Imho, these two have nothing to do with each other.
> 
> Besides, at least on x86 tracehook_signal_handler's logic is not exactly
> right and should be fixed.

Details, please...

> And we are going to kill tracehook.h. While personally I do not think
> this is the good idea, but the matter of fact is that tracehooks are
> already destroyed.

See signal.git#master.  I ended up with
	signal_delivered(<tracehook_signal_handler arguments>)
and that sucker does both things.  The funny thing is, block_sigmask()
(apologies for typo above) is not used anywhere else...

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753962Ab2GPVxZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:53:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37035 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752476Ab2GPVxX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:53:23 -0400
Date: Mon, 16 Jul 2012 17:53:18 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 dentry related GPF
Message-ID: <20120716215318.GA14629@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20120711183239.GA7122@redhat.com>
 <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
 <20120716213218.GQ31729@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120716213218.GQ31729@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 16, 2012 at 10:32:18PM +0100, Al Viro wrote:
 > On Wed, Jul 11, 2012 at 12:10:12PM -0700, Linus Torvalds wrote:
 > >   rdi = 54415541e5894855
 > > 
 > > which looks like some odd corrupted ASCII to me ("UH\211\345AUAT") but
 > > that makes no sense either.
 > 
 > 	It makes a lot of sense as amd64 code, though:
 > 
 >    55                      push   %rbp
 >    48 89 e5                mov    %rsp,%rbp
 >    41 55                   push   %r13
 >    41 54                   push   %r12
 > 
 > IOW, it's the first 8 bytes from a fairly sane beginning of some function.
 > So &(inode->i_fop->owner) (and thus inode->i_fop - owner is the first field)
 > is some spot in .text.  Would be interesting to find out what function
 > was that from (i.e. what's the value of inode->i_fop); with any luck it
 > might've still been in some register.  Could you post objdump of
 > do_dentry_open() from your kernel?

I've done a few rebuilds since posting that, but hopefully things haven't
moved around too much in that area recently..

http://fpaste.org/Pw5d/ is the whole open.o disassembly.

	Dave


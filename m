Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754321Ab2GPVcX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jul 2012 17:32:23 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:49594 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753466Ab2GPVcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jul 2012 17:32:22 -0400
Date: Mon, 16 Jul 2012 22:32:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: 3.5-rc6 dentry related GPF
Message-ID: <20120716213218.GQ31729@ZenIV.linux.org.uk>
References: <20120711183239.GA7122@redhat.com>
 <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFz5E4NMDF+OXDoGkHz2Mr2sBXf6nYcOXomDZHmnUSdWHA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 11, 2012 at 12:10:12PM -0700, Linus Torvalds wrote:
>   rdi = 54415541e5894855
> 
> which looks like some odd corrupted ASCII to me ("UH\211\345AUAT") but
> that makes no sense either.

	It makes a lot of sense as amd64 code, though:

   55                      push   %rbp
   48 89 e5                mov    %rsp,%rbp
   41 55                   push   %r13
   41 54                   push   %r12

IOW, it's the first 8 bytes from a fairly sane beginning of some function.
So &(inode->i_fop->owner) (and thus inode->i_fop - owner is the first field)
is some spot in .text.  Would be interesting to find out what function
was that from (i.e. what's the value of inode->i_fop); with any luck it
might've still been in some register.  Could you post objdump of
do_dentry_open() from your kernel?

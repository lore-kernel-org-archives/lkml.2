Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932129Ab2BHMnB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 07:43:01 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:43434 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932104Ab2BHMnA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 07:43:00 -0500
Date: Wed, 8 Feb 2012 16:42:54 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Pedro Alves <palves@redhat.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Pavel Emelyanov <xemul@parallels.com>,
        Jan Kratochvil <jan.kratochvil@redhat.com>, Tejun Heo <tj@kernel.org>,
        Andrew Vagin <avagin@openvz.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ptrace: add ability to get clear_tid_address
Message-ID: <20120208124254.GD7009@moon>
References: <1328267483-3225342-1-git-send-email-avagin@openvz.org>
 <20120203162519.GB805@google.com>
 <4F2C0F13.70709@parallels.com>
 <20120203165132.GA5636@redhat.com>
 <4F31848A.9070406@redhat.com>
 <20120207205639.GJ27437@moon>
 <4F31945B.5000304@redhat.com>
 <20120207215121.GB29773@moon>
 <4F326AF7.3060203@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F326AF7.3060203@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 08, 2012 at 12:30:47PM +0000, Pedro Alves wrote:
> > 
> > Yes, could be, but it means you have to install pthread debug libs, right?
> > (have no idea actually since I personally use debug printing instead of
> >  breakpoints).
> 
> Not really more than what we need today.  Just some exported function name
> in the elf symbol tables.  Assuming a the program is using clear_child_tid
> address for pthread_join as glibc is may not be a good idea.  It's doing
> things at the wrong layer.  Also, hardware watchpoints are a scarse
> resource.

It's pretty precious resource still incredibly useful. ok, i see
what you mean, thanks.

> 
> >> It's the kernel that writes to this address, so I've no
> >> idea if the watchpoint trap ends up visible on userspace. Which thread
> >> would it be reported to, given that this is cleared when the child
> >> is gone, I have no idea either.
> > 
> > Yeah, need some help from someone who wrote hw-breakpoints support in
> > kernel (i don't remember the details).
> 
> I just tried it.  This is &pthread->tid in glibc/libpthread, so with debug
> info it's easy to figure out where to set the watchpoint manually with gdb
> without asking the kernel.  Doesn't work.  ptrace doesn't show any trap
> for the kernel writes.
>

Thanks for info. 

	Cyrill

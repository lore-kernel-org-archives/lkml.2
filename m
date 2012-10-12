Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759542Ab2JLAQg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:16:36 -0400
Received: from ozlabs.org ([203.10.76.45]:41020 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758436Ab2JLAQe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:16:34 -0400
Date: Fri, 12 Oct 2012 11:16:33 +1100
From: Paul Mackerras <paulus@samba.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-arch@vger.kernel.org, David Miller <davem@davemloft.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [RFC][CFT][CFReview] execve and kernel_thread unification work
Message-ID: <20121012001633.GA29883@bloggs.ozlabs.ibm.com>
References: <20121001213809.GA31155@ZenIV.linux.org.uk>
 <20121011090023.GA28427@bloggs.ozlabs.ibm.com>
 <20121011125306.GF2616@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121011125306.GF2616@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 11, 2012 at 01:53:06PM +0100, Al Viro wrote:

> 	Umm...  Maybe, but let's do that as subsequent cleanup.  Again,
> we almost certainly don't need to mess with TOC at all - the callbacks
> are in the main kernel, there are very few of them and they really are
> low-level details of exported mechanisms (i.e. kthread_create/run/etc.
> in kthread.h and call_usermode... in kmod.h).  Again, we are talking
> about out-of-tree modules, they had better mechanism for at least
> 6 years and conversion to it is bloody trivial.  Hell, it was even
> in late unlamented feature-removal-schedule.txt - since 2006.  If that's
> not enough to retire an export, what is?

OK... yes we can fix things up in a subsequent cleanup.

We will need to fix the TOC handling when we go to using multiple TOCs
in the main kernel, with the linker managing the transitions between
TOCs.  Our toolchain guys have been pushing us to do that for years,
because it should make things run faster, but first we'll have to stop
using ld -r to combine objects in subdirectories.

Paul.

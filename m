Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821Ab0DLMDE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 08:03:04 -0400
Received: from mtagate3.de.ibm.com ([195.212.17.163]:44809 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753255Ab0DLMDA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 08:03:00 -0400
Date: Mon, 12 Apr 2010 14:03:30 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: David VomLehn <dvomlehn@cisco.com>
Cc: to@dvomlehn-lnx2.corp.sa.net, "linux-arch@vger.kernel.org"@cisco.com,
       linux-arch@vger.kernel.org, akpm@linux-foundation.org,
       linux-kernel@vger.kernel.org, maint_arch@dvomlehn-lnx2.corp.sa.net
Subject: Re: [PATCH 1/23] Make register values available to panic notifiers
Message-ID: <20100412120330.GA2566@osiris.boeblingen.de.ibm.com>
References: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100412060609.GA25273@dvomlehn-lnx2.corp.sa.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 11:06:09PM -0700, David VomLehn wrote:
> This patch makes panic() and die() registers available to, for example,
> panic notifier functions.  Panic notifier functions are quite useful
> for recording crash information, but they don't get passed the register
> values. This makes it hard to print register contents, do stack
> backtraces, etc. The changes in this patch save the register state when
> panic() is called and introduce a function for die() to call that allows
> it to pass in the registers it was passed.
> 
> Following this patch are more patches, one per architecture. These include
> two types of changes:
> o  A save_ptregs() function for the processor. I've taken a whack at
>    doing this for all of the processors. I have tested x86 and MIPS
>    versions. I was able to find cross compilers for ARM, ... and the
>    code compiles cleanly. Everything else, well, what you see is sheer
>    fantasy. You are welcome to chortle with merriment.
> o  When I could figure it out, I replaced the calls to panic() in
>    exception handling functions with calls to panic_with_regs() so
>    that everyone can leverage these changes without much effort. Again,
>    not all the code was transparent, so there are likely some places
>    that should have additional work done.
> 
> Note that the pointer to the struct pt_regs may be NULL. This is to
> accomodate those processors which don't have a working save_ptregs(). I'd
> love to eliminate this case by providing a save_ptregs() for all
> architectures, but I'll need help to so.

Wouldn't it be much easier to implement panic with an illegal op and let
the exception handler set up the pt regs structure instead? Just like some
architectures do that already for warnings.
Have a look at lib/bug.c and at various arch/<...>/include/asm/bug.h.
BUG_FLAG_PANIC would do the trick.

But I'm still wondering what the use case would be. You haven't posted any
code that would actually use this.

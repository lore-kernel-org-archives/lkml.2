Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751131Ab0HLE37 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 00:29:59 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:44257 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750912Ab0HLE34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 00:29:56 -0400
Date: Wed, 11 Aug 2010 21:30:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Randy Dunlap <randy.dunlap@oracle.com>, linux-kernel@vger.kernel.org,
        gcosta@redhat.com, lenb@kernel.org, mingo@elte.hu, tglx@linutronix.de,
        ying.huang@intel.com,
        Linux Arch Mailing List <linux-arch@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: +
 drivers-acpi-apei-erst-dbgc-get_useru64-doesnt-work-on-i386.patch added to
 -mm tree
Message-Id: <20100811213013.ab501c6e.akpm@linux-foundation.org>
In-Reply-To: <4C63771B.6030005@zytor.com>
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
	<20100811164310.a4790773.randy.dunlap@oracle.com>
	<20100811173327.3ae325ff.akpm@linux-foundation.org>
	<4C63771B.6030005@zytor.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 21:22:51 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> [Adding Linux and linux-arch.  The context is that get_user/put_user
> don't work on 64 bit values on i386.]
> 
> On 08/11/2010 05:33 PM, Andrew Morton wrote:
> > 
> > Anyway, this should be fixed in x86 core, I suspect.
> 
> After looking at it -- and suffering a bad case of d__j__ vu -- I'm
> reluctant to change it, as get/put_user are specified to work only on
> locally atomic data:
> 
>  * This macro copies a single simple variable from user space to kernel
>  * space.  It supports simple types like char and int, but not larger
>  * data types like structures or arrays.
> 
> Given that u64 is not a simple type on 32 bits, it would appear that the
> behavior is intentional.
> 
> A user might very well find that supporting u64 and/or structure types
> would be beneficial, but it would a) be a semantic change, and b) would
> introduce the possibility of a partially completed transfer.  That is a
> semantic change to the interface.  However, it may very well be nicer to
> have a generally available get_user()/put_user() for the cases which
> would just kick an EFAULT up the stack when they fail anyway.
> 
> If there is consensus for making get_user/put_user a general interface,
> I'm more than willing to do the x86 changes, but I don't want to do them
> a) unilaterally and b) for 2.6.36.  This seems like .37 material at this
> point.

It occurs so rarely that it's probably not worth bothering about, IMO.

However we should arrange for it to fail at compile time rather than
at link time, please.




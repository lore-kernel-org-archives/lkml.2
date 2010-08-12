Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753777Ab0HLGCj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Aug 2010 02:02:39 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54284 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752724Ab0HLGCg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Aug 2010 02:02:36 -0400
Date: Wed, 11 Aug 2010 23:03:53 -0700
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
Message-Id: <20100811230353.6cb87afd.akpm@linux-foundation.org>
In-Reply-To: <4C638140.1080202@zytor.com>
References: <201008112336.o7BNaNEj020805@imap1.linux-foundation.org>
	<20100811164310.a4790773.randy.dunlap@oracle.com>
	<20100811173327.3ae325ff.akpm@linux-foundation.org>
	<4C63771B.6030005@zytor.com>
	<20100811213013.ab501c6e.akpm@linux-foundation.org>
	<4C638140.1080202@zytor.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 11 Aug 2010 22:06:08 -0700 "H. Peter Anvin" <hpa@zytor.com> wrote:

> On 08/11/2010 09:30 PM, Andrew Morton wrote:
> > 
> > It occurs so rarely that it's probably not worth bothering about, IMO.
> > 
> 
> I think the real question is if we want people to convert:
> 
> 	if (copy_from_user(foo, bar, sizeof *foo))
> 		return -EFAULT;
> 
> ... into ...
> 
> 	if (get_user(*foo, bar))
> 		return -EFAULT;
> 
> ... or ...
> 
> 	rv = get_user(*foo, bar);
> 	if (rv)
> 		return rv;
> 
> ... where *foo is a structure type.  It does have the advantage that a
> single API does everything, simple or not, but has the disadvantage that
> the partial-access semantics are now less explicit.
> 

Well, anyone who does get_user() on a struct while expecting it to be
atomic gets to own both pieces.  I think the problem here is
specifically u64/s64.  These work on 64-bit but don't work on 32-bit.

Is the atomicity really a problem?  If userspace updates the 64-bit
number while the kernel is copying it, the kernel gets a garbage
number.  But so what?  Userspace can feed the kernel garbage numbers in
lots of ways, and the kernel must be able to cope with it
appropriately.


<I suspect you can do get_user() on a 4-byte or 8-byte struct right now
and it'll work>

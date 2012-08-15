Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755217Ab2HOOIR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 10:08:17 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:34109 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065Ab2HOOIP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 10:08:15 -0400
Date: Wed, 15 Aug 2012 07:08:08 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nico@linaro.org>, Shan Kang <kangshan0910@gmail.com>,
        Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 20/82] ARM: 7467/1: mutex: use generic xchg-based
 implementation for ARMv6+
Message-ID: <20120815140808.GD22871@kroah.com>
References: <20120813201746.448504360@linuxfoundation.org>
 <20120813201748.202917513@linuxfoundation.org>
 <1345038982.824.216.camel@deadeye.wl.decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345038982.824.216.camel@deadeye.wl.decadent.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 02:56:22PM +0100, Ben Hutchings wrote:
> On Mon, 2012-08-13 at 13:18 -0700, Greg Kroah-Hartman wrote:
> > From: Greg KH <gregkh@linuxfoundation.org>
> > 
> > 3.5-stable review patch.  If anyone has any objections, please let me know.
> > 
> > ------------------
> > 
> > From: Will Deacon <will.deacon@arm.com>
> > 
> > commit a76d7bd96d65fa5119adba97e1b58d95f2e78829 upstream.
> > 
> > The open-coded mutex implementation for ARMv6+ cores suffers from a
> > severe lack of barriers, so in the uncontended case we don't actually
> > protect any accesses performed during the critical section.
> > 
> > Furthermore, the code is largely a duplication of the ARMv6+ atomic_dec
> > code but optimised to remove a branch instruction, as the mutex fastpath
> > was previously inlined. Now that this is executed out-of-line, we can
> > reuse the atomic access code for the locking (in fact, we use the xchg
> > code as this produces shorter critical sections).
> > 
> > This patch uses the generic xchg based implementation for mutexes on
> > ARMv6+, which introduces barriers to the lock/unlock operations and also
> > has the benefit of removing a fair amount of inline assembly code.
> [...]
> 
> Here also, I think this should be deferred.

"also"?  Am I missing some context here?  Why should we deferr this one?
What do we need to wait for?

confused,

greg k-h

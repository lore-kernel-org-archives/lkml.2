Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751629Ab0GAXM3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 19:12:29 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:49028 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750792Ab0GAXM1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 19:12:27 -0400
Date: Fri, 2 Jul 2010 00:12:07 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: g@shutemov.name, Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
       stable@kernel.org, stable-review@kernel.org,
       torvalds@linux-foundation.org, akpm@linux-foundation.org,
       alan@lxorguk.ukuu.org.uk, Anfei Zhou <anfei.zhou@gmail.com>
Subject: Re: [patch 071/149] ARM: 6166/1: Proper prefetch abort handling on
	pre-ARMv6
Message-ID: <20100701231207.GB27389@flint.arm.linux.org.uk>
References: <20100701175144.GA2116@kroah.com> <20100701173212.785441106@clark.site> <20100701221420.GA10481@shutemov.name> <20100701221728.GA12187@suse.de> <20100701222541.GB10481@shutemov.name> <20100701224837.GA27389@flint.arm.linux.org.uk> <20100701225911.GC10481@shutemov.name>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100701225911.GC10481@shutemov.name>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 02, 2010 at 01:59:11AM +0300, Kirill A. Shutemov wrote:
> On Thu, Jul 01, 2010 at 11:48:37PM +0100, Russell King wrote:
> > One possibility is that for some reason you're using the legacy prefetch
> > abort code or pre-IFSR code, which will always tell the kernel that its
> > a translation fault - and in this case, this patch would improve the
> > situation.  What kernel version are you using?
> 
> 2.6.32

Should be recent enough.

> If you run this test in loop on kernel without the patch you'll finally
> get hung instead SIGSEGV.
> 
> It seems the patch fixes more than it was written for. :)

Have you investigated the IFSR and IFAR values, and the corresponding
page table state?  I'm not going to be able to run your test code for
a few days.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:

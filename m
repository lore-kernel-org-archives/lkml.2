Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936307Ab0CONpc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:45:32 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:45438 "EHLO
	eddie.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936195Ab0CONp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:45:28 -0400
Date: Mon, 15 Mar 2010 14:44:49 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: David Miller <davem@davemloft.net>, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com, drepper@redhat.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
Message-ID: <20100315134449.GB1653@linux-mips.org>
References: <1268628493.2355.2.camel@pasglop>
 <20100314.220646.190065794.davem@davemloft.net>
 <1268630313.2335.2.camel@pasglop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268630313.2335.2.camel@pasglop>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 15, 2010 at 04:18:33PM +1100, Benjamin Herrenschmidt wrote:

> On Sun, 2010-03-14 at 22:06 -0700, David Miller wrote:
> > From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> > Date: Mon, 15 Mar 2010 15:48:13 +1100
> > 
> > > As it is, any 32-bit app using syscall() on any of the syscalls that
> > > takes 64-bit arguments will be broken, unless the app itself breaks up
> > > the argument, but the the order of the hi and lo part is different
> > > between BE and LE architectures ;-)
> > 
> > I think it is even different on the same endian architectures,
> > f.e. mips I think.

MIPS passes arguments in the endian order that is low/high for little
endian rsp high/low for big endian.

> > There is no way to do this without some arch specific code
> > to handle things properly, really.
> 
> Right, but to what extent ? IE. do we always need the callers using
> syscall() directly to know it all, or can we to some extent handle some
> of it inside glibc ?
> 
> For example, if powerpc glibc is fixed so that syscall() takes a 64-bit
> first argument (or calls via some macro to add a dummy 32-bit argument),
> the register alignment will be preserved, and things will work just
> fine.
> 
> IE. It may not fix all problems with all archs, but in this case, it
> will fix the common cases for powerpc at least :-) And any other arch
> that has the exact same alignment problem.
> 
> Or is there any good reason -not- to do that in glibc ?

Syscall is most often used for new syscalls that have no syscall stub in
glibc yet, so the user of syscall() encodes this ABI knowledge.  If at a
later stage syscall() is changed to have this sort of knowledge we break
the API.  This is something only the kernel can get right.

  Ralf

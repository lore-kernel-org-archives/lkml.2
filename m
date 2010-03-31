Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932559Ab0CaVn4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:43:56 -0400
Received: from nlpi157.sbcis.sbc.com ([207.115.36.171]:51081 "EHLO
	nlpi157.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758136Ab0CaVny (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:43:54 -0400
Date: Wed, 31 Mar 2010 16:42:25 -0500 (CDT)
From: Christoph Lameter <cl@linux-foundation.org>
X-X-Sender: cl@router.home
To: Matthew Wilcox <matthew@wil.cx>
cc: "H. Peter Anvin" <hpa@zytor.com>, Yinghai Lu <yinghai@kernel.org>,
       Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, penberg@cs.helsinki.fi,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
In-Reply-To: <20100331211754.GC32165@parisc-linux.org>
Message-ID: <alpine.DEB.2.00.1003311640410.30456@router.home>
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org> <4BB3B8FC.1020608@zytor.com> <20100331211754.GC32165@parisc-linux.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010, Matthew Wilcox wrote:

> On Wed, Mar 31, 2010 at 02:05:00PM -0700, H. Peter Anvin wrote:
> > What I note is that lib/rwsem-spinlock.c seems to be rather inconsistent
> > in its use of spin_lock_irqsave/spin_lock_irqrestore versus
> > spin_lock_irq/spin_unlock_irq... in fact, __down_read is the *only*
> > place where we use the latter as opposed to the former.
> >
> > Is that a bug?  If so, it would certainly explain this behavior.
>
> It's based on down_read() and down_write() not being callable from
> interrupt context, or with interrupts disabled (since they can sleep).
> up_read(), up_write(), down_read_trylock(), down_write_trylock(),
> downgrade_write() can all be called from interrupt context since they
> cannot sleep.

Do not run the checks while we are in a single threaded context?

I thought we had some dynamic code patching thingamy that could change
those when we go to smp mode?


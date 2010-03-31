Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0CaVBt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:01:49 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:52780 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753207Ab0CaVBr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:01:47 -0400
Date: Wed, 31 Mar 2010 15:01:45 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Rabin Vincent <rabin@rab.in>,
       lkml <linux-kernel@vger.kernel.org>, hpa@zytor.com,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100331210145.GB32165@parisc-linux.org>
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3B4DB.7040904@kernel.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 01:47:23PM -0700, Yinghai Lu wrote:
> >> > This appears to be caused by:
> >> > 
> >> >   start_kernel -> radix_tree_init -> kmem_cache_create (slub) ->
> >> >    down_write -> __down_write (lib/rwsem-spinlock.c) -> spin_unlock_irq
> >> > 
> > That's going to be hard to fix.
> > 
> spin_unlock_irq from arm is different from other archs?

Not all arches use lib/rwsem-spinlock.c.  In particular, x86 doesn't
when X86_XADD is set.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

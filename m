Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932382Ab0CaVR7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 17:17:59 -0400
Received: from palinux.external.hp.com ([192.25.206.14]:44469 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758188Ab0CaVR4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 17:17:56 -0400
Date: Wed, 31 Mar 2010 15:17:55 -0600
From: Matthew Wilcox <matthew@wil.cx>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Yinghai Lu <yinghai@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
       Rabin Vincent <rabin@rab.in>, lkml <linux-kernel@vger.kernel.org>,
       penberg@cs.helsinki.fi, cl@linux-foundation.org,
       Benjamin Herrenschmidt <benh@kernel.crashing.org>,
       linux-arch@vger.kernel.org
Subject: Re: start_kernel(): bug: interrupts were enabled early
Message-ID: <20100331211754.GC32165@parisc-linux.org>
References: <20100325194100.GA2364@debian> <20100331134048.da4e35a7.akpm@linux-foundation.org> <4BB3B4DB.7040904@kernel.org> <20100331210145.GB32165@parisc-linux.org> <4BB3B8FC.1020608@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB3B8FC.1020608@zytor.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 31, 2010 at 02:05:00PM -0700, H. Peter Anvin wrote:
> What I note is that lib/rwsem-spinlock.c seems to be rather inconsistent
> in its use of spin_lock_irqsave/spin_lock_irqrestore versus
> spin_lock_irq/spin_unlock_irq... in fact, __down_read is the *only*
> place where we use the latter as opposed to the former.
> 
> Is that a bug?  If so, it would certainly explain this behavior.

It's based on down_read() and down_write() not being callable from
interrupt context, or with interrupts disabled (since they can sleep).
up_read(), up_write(), down_read_trylock(), down_write_trylock(),
downgrade_write() can all be called from interrupt context since they
cannot sleep.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."

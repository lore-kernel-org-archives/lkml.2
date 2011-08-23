Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754615Ab1HWDyN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 23:54:13 -0400
Received: from ozlabs.org ([203.10.76.45]:37371 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752530Ab1HWDxk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 23:53:40 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Cc: x86@kernel.org, rostedt@goodmis.org, jbaron@redhat.com,
        akpm@linux-foundation.org, vapier@gentoo.org,
        user-mode-linux-devel@lists.sourceforge.net
Subject: Re: [RFC] UML/x86_64 module loader
In-Reply-To: <4E52CC63.5070201@nod.at>
References: <4E52CC63.5070201@nod.at>
User-Agent: Notmuch/0.5 (http://notmuchmail.org) Emacs/23.2.1 (i686-pc-linux-gnu)
Date: Tue, 23 Aug 2011 13:22:18 +0930
Message-ID: <878vqk4wel.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 23:38:43 +0200, Richard Weinberger <richard@nod.at> wrote:
> Hi!
> 
> UserModeLinux is using the arch specific module functions from 
> arch/x86/kernel/module.c.
> On i386 this works perfectly fine but on x86_64 it causes problems.
> 
> apply_relocate_add() assumes modules compiled with -mcmodel=kernel 
> because the kernel lives in the negative 2GiB of the address space.
> This assumption is not true for UML.
> On an UML instance with more than 512MiB of memory no modules can be 
> loaded because vmalloc() locates the module near the 2GiB limit and the
> ELF relocations causes an overflow. (Detected by "if ((s64)val != *(s32 
> *)loc)" in apply_relocate_add()).
> 
> Now I'm not sure how to fix this.
> Mostly because I'm not a module loader nor an ELF expert. 8-)

I think you need to write your own routines.  It shouldn't be that hard,
just keep implementing relocations until you're done :)

Cheers,
Rusty.

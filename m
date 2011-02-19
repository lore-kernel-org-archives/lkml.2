Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758789Ab1BSAOl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 19:14:41 -0500
Received: from gate.crashing.org ([63.228.1.57]:58191 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1BSAOh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 19:14:37 -0500
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in
 module versions
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Miller <davem@davemloft.net>, dtor@vmware.com,
        linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
In-Reply-To: <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
	 <20110217.140119.39175251.davem@davemloft.net>
	 <20110217221957.GA11244@dtor-ws.eng.vmware.com>
	 <20110217.142320.102554706.davem@davemloft.net>
	 <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
	 <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Feb 2011 18:14:15 -0600
Message-ID: <1298074455.2460.85.camel@pasglop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-02-17 at 15:08 -0800, Linus Torvalds wrote:
> On Thu, Feb 17, 2011 at 2:48 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > Gaah, I didn't realize that we've never had to do anything like this
> > before, and that the exception table is all arch-specific code. So we
> > don't have any way to "output that damned pointer and stop whining
> > about it" model at all.
> 
> Actually, I don't think the problem is about ".word" vs ".xword". We
> should be able to just use ".long" everywhere.
> 
> But the symbol _name_ may have different prefixes, and when we use
> "asm()" at the top level, we can't use the expressions to fix it up.
> So a
> 
>   asm(".long %0":'i" (symbol))
> 
> doesn't work (ignore the lack of section naming, that's not
> important), and neither can we just do something like
> 
>   #define output_asm_pointer(section, symbol) \
>        asm(".long " #symbol)
> 
> portably, because some linker formats want to see prepended underscores etc.

Except that .long is 32-bit on ppc64 :-( You need .llong for 64-bit.

Cheers,
Ben.


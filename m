Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752862Ab1BVCEJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:04:09 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46278 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750885Ab1BVCEH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:04:07 -0500
MIME-Version: 1.0
In-Reply-To: <1298339909.8833.135.camel@pasglop>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net> <20110217221957.GA11244@dtor-ws.eng.vmware.com>
 <20110217.142320.102554706.davem@davemloft.net> <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
 <AANLkTikd-OBhe6-wK7-Xvv-asNSeVKs+0-a0d3FF2KVu@mail.gmail.com>
 <1298074455.2460.85.camel@pasglop> <87pqqmrq9q.fsf@rustcorp.com.au> <1298339909.8833.135.camel@pasglop>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 21 Feb 2011 18:03:16 -0800
Message-ID: <AANLkTimyaA+JdBHekm69R5Y2A2DEdPdndFLrKJAaz=vt@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>, David Miller <davem@davemloft.net>,
        dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        linux-m68k@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 21, 2011 at 5:58 PM, Benjamin Herrenschmidt
<benh@kernel.crashing.org> wrote:
>
> The only sane thing I can see is make sure that such structures that
> we put into sections "arrays" like that are naturally aligned with
> padding.

The sad part is, that assuming I read the gcc sources correctly (see
the earlier emails where David pointed to it), that alignment is:
 - architecture-specific
 - depends on the size of the structure
 - seems to depend on the version of gcc itself.

The _one_ safe case is likely to be "structure size is a power of
two". And it does look like using a pointer is going to be safe, not
only because the gcc auto-alignment only triggers for things like
structs/unions/arrays, but because at least the x86 code only does it
if the structure was bigger than the alignment size itself.

So using pointer indirection is likely to be safe. It's still ugly and
annoying as heck, though.

                      Linus

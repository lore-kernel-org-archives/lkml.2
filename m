Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754025Ab1BQWtK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 17:49:10 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34310 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752643Ab1BQWtF convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 17:49:05 -0500
MIME-Version: 1.0
In-Reply-To: <20110217.142320.102554706.davem@davemloft.net>
References: <AANLkTi=nQ4c6fgk9_-974QOu=kQkJiGpdzpOa_U6ZZcs@mail.gmail.com>
 <20110217.140119.39175251.davem@davemloft.net> <20110217221957.GA11244@dtor-ws.eng.vmware.com>
 <20110217.142320.102554706.davem@davemloft.net>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 14:48:15 -0800
Message-ID: <AANLkTinMfTss+9K7fPQbxoMD7d-U_AyCc29_RRPRija3@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: David Miller <davem@davemloft.net>
Cc: dtor@vmware.com, linux-kernel@vger.kernel.org, geert@linux-m68k.org,
        rusty@rustcorp.com.au, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 2:23 PM, David Miller <davem@davemloft.net> wrote:
>
> You have to also pick .word vs. .xword, or whatever the appropriate
> sized pointer mnenomic is for a given architecture.  I know .word
> works for 32-bit sparc, and .xword works for 64-bit sparc.

Gaah, I didn't realize that we've never had to do anything like this
before, and that the exception table is all arch-specific code. So we
don't have any way to "output that damned pointer and stop whining
about it" model at all.

I really detest gcc sometimes. All these "clever" things that just
make things harder to do. If the user explicitly tells it the section
and the alignment, it should damn well not think that it knows better
and change it. Damn.

Maybe we have to take the "just confuse gcc enough and pray" approach
on those pointers after all.

                      Linus

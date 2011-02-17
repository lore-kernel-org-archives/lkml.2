Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757574Ab1BQSHf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 13:07:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48158 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757444Ab1BQSHb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 13:07:31 -0500
MIME-Version: 1.0
In-Reply-To: <20110217180042.GA30530@dtor-ws.eng.vmware.com>
References: <1297123347-2170-1-git-send-email-dtor@vmware.com>
 <AANLkTim_BL_Cw=X0iuatgw1F4n50CyXv0uqx9n=5=Bq+@mail.gmail.com>
 <20110217173136.GA28486@dtor-ws.eng.vmware.com> <AANLkTikGVS9EM=7uhwYfXrGHg9yzes7m0pxAinRxivPC@mail.gmail.com>
 <20110217180042.GA30530@dtor-ws.eng.vmware.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 17 Feb 2011 10:06:40 -0800
Message-ID: <AANLkTi=bgmRwGXEE_wriYo-5gmyaB43pMUzHf7idiK0k@mail.gmail.com>
Subject: Re: [PATCH 1/3] module: deal with alignment issues in built-in module versions
To: Dmitry Torokhov <dtor@vmware.com>
Cc: LKML <linux-kernel@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Linux/m68k" <linux-m68k@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 10:00 AM, Dmitry Torokhov <dtor@vmware.com> wrote:
>
> The problem is that on m68k size of the struct module_version_attribute
> is not evenly divisible by sizeof(void *), thus when we lay out the
> __modver section we align on 4 bytes but when we iterate we think that
> the alignment is 2.

So mark the struct properly.

> I/Geert tried adding __attribute__ (aligned(sizeof(void *))) to the type
> definition itself so we have matching alignment everywhere, but DaveM
> said that this only guarantees minimum alignment and that using
> structures like we do shown to break from time to time in kprobes and
> that only pointers worked reliably.

That sounds totally bogus. Minimum alignment is all it needs, and we
do that in other places too. I really don't see the reason to add some
broken indirection for totally broken reasons. We don't do that with
anything else.

David, why are you saying that regular "just mark the structure
alignment correctly" doesn't work?

                                Linus

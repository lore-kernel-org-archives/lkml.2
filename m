Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754431Ab0JERoM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:44:12 -0400
Received: from www.tglx.de ([62.245.132.106]:43680 "EHLO www.tglx.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751800Ab0JERoK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:44:10 -0400
Date: Tue, 5 Oct 2010 19:43:33 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Linus Torvalds <torvalds@linux-foundation.org>
cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
In-Reply-To: <AANLkTinCgGDxhuUf1a+gO-xdVi9bU0Shmo-KejC+eU4o@mail.gmail.com>
Message-ID: <alpine.LFD.2.00.1010051923140.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6> <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6> <201010051544.52269.rusty@rustcorp.com.au> <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
 <AANLkTino8StCF7OZvzxeFrs0a4JVnxRK-deJ4XUU41Ef@mail.gmail.com> <alpine.LFD.2.00.1010051816260.2556@localhost6.localdomain6> <AANLkTinCgGDxhuUf1a+gO-xdVi9bU0Shmo-KejC+eU4o@mail.gmail.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Oct 2010, Linus Torvalds wrote:

> On Tue, Oct 5, 2010 at 9:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
> >
> > Hmm, with this patch the corruption triggers at every boot (5 of
> > 5). Without it it's just happening randomly (1 of 10)
> >
> > Digging further. Dammit, I fear my evil plan fires back now due to
> > some even more lazy person who doesn't use modules. :)
> 
> Sre you sure you used the second version? The first version missed the
> cleanup at module unload time, and would have caused the symptoms you
> see.

Crap, yes. Stupid me managed to pick the wrong one though I'm sure I
double checked.

> I just tried my own machine with modules (and list debugging), and it
> seemed fine. And it show now all happen under the module mutex, so I
> don't see how it would be timing-sensitive.
> 
> But hey, maybe I'm missing something really silly.

Nah. Works fine. Sorry for making you build modules :)

Tested-by: Thomas Gleixner <tglx@linutronix.de>

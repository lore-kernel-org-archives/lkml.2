Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752960Ab0JERSr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:18:47 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:42330 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751197Ab0JERSq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:18:46 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1010051816260.2556@localhost6.localdomain6>
References: <alpine.LFD.2.00.1010032141410.14550@localhost6.localdomain6>
 <201010041300.15234.arnd@arndb.de> <alpine.LFD.2.00.1010050026170.2556@localhost6.localdomain6>
 <201010051544.52269.rusty@rustcorp.com.au> <alpine.LFD.2.00.1010050927450.2556@localhost6.localdomain6>
 <AANLkTino8StCF7OZvzxeFrs0a4JVnxRK-deJ4XUU41Ef@mail.gmail.com> <alpine.LFD.2.00.1010051816260.2556@localhost6.localdomain6>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 10:17:48 -0700
Message-ID: <AANLkTinCgGDxhuUf1a+gO-xdVi9bU0Shmo-KejC+eU4o@mail.gmail.com>
Subject: Re: [BUG 2.6.36-rc6] list corruption in module_bug_finalize
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Arnd Bergmann <arnd@arndb.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay.sievers@vrfy.org>, Brandon Philips <brandon@ifup.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 9:40 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>
> Hmm, with this patch the corruption triggers at every boot (5 of
> 5). Without it it's just happening randomly (1 of 10)
>
> Digging further. Dammit, I fear my evil plan fires back now due to
> some even more lazy person who doesn't use modules. :)

Sre you sure you used the second version? The first version missed the
cleanup at module unload time, and would have caused the symptoms you
see.

I just tried my own machine with modules (and list debugging), and it
seemed fine. And it show now all happen under the module mutex, so I
don't see how it would be timing-sensitive.

But hey, maybe I'm missing something really silly.

                           Linus

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752389Ab0CXWGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 18:06:38 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:47581 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751208Ab0CXWGh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 18:06:37 -0400
Date: Wed, 24 Mar 2010 22:10:16 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
       Matthew Wilcox <matthew@wil.cx>, Thomas Gleixner <tglx@linutronix.de>,
       jblunck@suse.de, Alan Cox <alan@linux.intel.com>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [GIT, RFC] Killing the Big Kernel Lock
Message-ID: <20100324221016.0b444a23@lxorguk.ukuu.org.uk>
In-Reply-To: <201003242240.54907.arnd@arndb.de>
References: <201003242240.54907.arnd@arndb.de>
X-Mailer: Claws Mail 3.7.4 (GTK+ 2.18.6; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> - The most invasive change is in the TTY layer, which has a new global
>   mutex (sorry!). I know that Alan has plans of his own to remove the BKL
>   from this subsystem, so my patches may not go anywhere, but they seem
>   to work fine for me.
>   I've called the new lock the 'Big TTY Mutex' (BTM), a name that probably
>   makes more sense if you happen to speak German.

Chuckle (I don't but I looked it up)

>   The basic idea here is to make recursive locking and the release-on-sleep
>   explicit, so every mutex_lock, wait_event, workqueue_flush and schedule
>   in the TTY layer now explicitly releases the BTM before blocking.

I'm not sure if that is actually the path of sanity (yours at least), nor
the right way to whack the other BKL users whose use is horrible but
essentially private.

It would be nice to get the other bits in first removing BKL from most of
the kernel and building kernels which are non BKL except for the tty
layer. That (after Ingo's box from hell has run it a bit) would
reasonably test the assertion that the tty layer has no BKL requirements
that are driven by external to tty layer code.

That to me would test the biggest question of all and be a reasonably
good base from which to then either apply the tty BTM patches or attack
the problem properly with the BKL localised to one subtree.

Alan

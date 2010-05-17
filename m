Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755457Ab0EQNfn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 09:35:43 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:57216 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1755303Ab0EQNfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 09:35:42 -0400
Date: Mon, 17 May 2010 14:41:30 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH v3 00/10] BKL conversion in tty layer
Message-ID: <20100517144130.1d8aa313@lxorguk.ukuu.org.uk>
In-Reply-To: <1273957196-13768-1-git-send-email-arnd@arndb.de>
References: <1273957196-13768-1-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 15 May 2010 22:59:46 +0200
Arnd Bergmann <arnd@arndb.de> wrote:

> This is the third attempt to get the BKL out of the
> TTY code. This version goes much further than the
> previous one, and eliminates most of the code I
> had introduced there.

At this point I think the only way to make further progress is to
actually push this stuff into the kernel on top of the BKL removal
patches for the drivers and see what happens. Something will no doubt
break but we can try and nail them in time or if not revert the series
and try again next kernel.

The big nasty remaining after this is drivers/serial, which probably
wants some serious reconstructive surgery to use kfifo etc. Either way
its an independent problem to the stuff this lot tackles.

So this series

Acked-by: Alan Cox <alan@linux.intel.com>

Alan

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754365Ab0EETyb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:54:31 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42861 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750701Ab0EETya (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:54:30 -0400
Date: Wed, 5 May 2010 20:59:05 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Greg KH <gregkh@suse.de>,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Thomas Gleixner <tglx@linutronix.de>,
       Andrew Morton <akpm@linux-foundation.org>,
       John Kacur <jkacur@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
       Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 10/13] tty: untangle locking of wait_until_sent
Message-ID: <20100505205905.3c87b403@lxorguk.ukuu.org.uk>
In-Reply-To: <1273012433-6125-11-git-send-email-arnd@arndb.de>
References: <1273012433-6125-1-git-send-email-arnd@arndb.de>
	<1273012433-6125-11-git-send-email-arnd@arndb.de>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Some wait_until_sent versions require the big
> tty mutex, others don't and some callers of
> wait_until_sent already hold it while other don't.
> That leads to recursive use of the BTM in these
> functions, which we're trying to get rid of.

I don't believe any of the currently live ones do.

>  drivers/char/amiserial.c      |    6 +++---
>  drivers/char/generic_serial.c |    2 +-

Both ex drivers

>  drivers/char/hvc_console.c    |    2 +-
>  drivers/char/hvcs.c           |    2 +-

Doesn't seemn to need it

>  drivers/char/ip2/ip2main.c    |   20 +++++++++++++++++---

I don't think we care - the driver is a mess, its probably not been used
in years

>  drivers/char/serial167.c      |    6 +++---

Historical value only and broken

>  drivers/char/specialix.c      |    2 +-

Broken

>  drivers/serial/68328serial.c  |    2 +-
>  drivers/serial/68360serial.c  |    5 ++---

Both defunct

>  drivers/serial/crisv10.c      |   12 +++++++-----

Defunct

>  net/irda/ircomm/ircomm_tty.c  |    2 +-

Semi-defunct at best

This makes me think that now might be a good time to consign the broken
crap to the bitbucket unless someone stands up with hardware and who
wants to maintain it.



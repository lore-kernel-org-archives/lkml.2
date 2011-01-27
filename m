Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753411Ab1A0Vxt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Jan 2011 16:53:49 -0500
Received: from moutng.kundenserver.de ([212.227.17.10]:49318 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1A0Vxs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Jan 2011 16:53:48 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Amit Shah <amit.shah@redhat.com>
Subject: Re: [PATCH 1/3] tty: move hvc drivers to drivers/tty/hvc/
Date: Thu, 27 Jan 2011 22:53:29 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc2+; KDE/4.5.1; x86_64; ; )
Cc: "Greg Kroah-Hartman" <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Rusty Russell <rusty@rustcorp.com.au>
References: <20110120174910.GA30124@kroah.com> <1295546625-30681-1-git-send-email-gregkh@suse.de> <20110127182916.GA4688@amit-x200.redhat.com>
In-Reply-To: <20110127182916.GA4688@amit-x200.redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101272253.29223.arnd@arndb.de>
X-Provags-ID: V02:K0:z8PRd77uVeSIRdInJy8pW2IESbLFf34s0inAKZDS0lj
 VHPQpNGsOdcUqTcufUWqM+qgNcswwx3mYiY7/otTsxEOVJmsTB
 XcKzWIDM21tOHScCWZzNP/zkL1PrLaUXu7vG2x9VLdvVbjQmor
 j+uKFhFmF/LEAEIVw542O6s1QN7uu0L1ICqt2hmuqprYxr86tL
 BKDuwdPWuPSVYpw7zTzpw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 27 January 2011 19:29:44 Amit Shah wrote:
> On (Thu) Jan 20 2011 [10:03:43], Greg Kroah-Hartman wrote:
> > As requested by Arnd Bergmann, the hvc drivers are now
> > moved to the drivers/tty/hvc/ directory.  The virtio_console.c driver
> > was also moved, as it required the hvc_console.h file to be able to be
> > built, and it really is a hvc driver.
> 
> I just saw this now as a result of this patch entering mainline.  I
> would have liked to be CC'ed to the patches.  Also, I don't like the
> move of the virtio_console.c file to drivers/tty/hvc.  virtio_console.c
> is not only an hvc driver; one of its functions is to hook some ports to
> hvc, but it's mostly a generic driver these days.

Sorry about this, the idea to move this file was mine and my original
patch did this as well. I remembered the code from when it was a simple
console driver based on hvc and never noticed that it had evolved into
a generic host/guest communication stack.

> Can you please move it back?

No objection from me here in general, though as Greg writes above, it's
a bit ugly when hvc_console.h is in a different directory.

> I could perhaps think of a way of splitting the file so the hvc bits can
> be moved to drivers/tty/hvc/ and having the core stay in drivers/char/,
> but that'll have to wait for the next cycle.

I think that's a really good idea. The main reason for moving the tty
drivers from drivers/char to drivers/tty was to separate the everything
related to tty from everything else. The common part should IMHO then not
be named "console", "tty" os similar but indicate that it's more generic
than that. Maybe virtio-pipe?

	Arnd

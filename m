Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab1KWVD3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:03:29 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54754 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753047Ab1KWVD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:03:28 -0500
MIME-Version: 1.0
In-Reply-To: <20111123194423.158002cf@bob.linux.org.uk>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<20111123192233.44f512b7@bob.linux.org.uk>
	<CAFQmdRYh3vSz4s-ks5dbz7bXJx-EZNHEGzsr5bcpEYquXmB6Fg@mail.gmail.com>
	<20111123194423.158002cf@bob.linux.org.uk>
Date: Wed, 23 Nov 2011 13:03:27 -0800
Message-ID: <CAFQmdRZEk53fxa6CdFxMNWFH4y9eUu+MeKRxFnnYrgn8J1sAvw@mail.gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
From: Havard Skinnemoen <hskinnemoen@google.com>
To: Alan Cox <alan@linux.intel.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 23, 2011 at 11:44 AM, Alan Cox <alan@linux.intel.com> wrote:
> Any data owned by the USB part needs to be handled by the USB driver.
> In the case of usb-serial it keeps its own krefs for that because the
> lifetime of the port/USB serial data is not the same as the lifetime of
> the tty itself.

Yes, exactly. But since tty_port already has a kref, why not use that?
It doesn't have any other use currently.

Hmm, a quick grep tells me tty_port_get() and tty_port_put() are
completely unused. What was the intention behind them?

Havard

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756219Ab1KWVrh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:47:37 -0500
Received: from mga03.intel.com ([143.182.124.21]:38643 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753146Ab1KWVrg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:47:36 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,561,1315206000"; 
   d="scan'208";a="78620305"
Date: Wed, 23 Nov 2011 21:59:09 +0000
From: Alan Cox <alan@linux.intel.com>
To: Havard Skinnemoen <hskinnemoen@google.com>
Cc: Jiri Slaby <jslaby@suse.cz>, Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@suse.de>, Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Message-ID: <20111123215909.5bec72bf@bob.linux.org.uk>
In-Reply-To: <CAFQmdRZEk53fxa6CdFxMNWFH4y9eUu+MeKRxFnnYrgn8J1sAvw@mail.gmail.com>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<20111123192233.44f512b7@bob.linux.org.uk>
	<CAFQmdRYh3vSz4s-ks5dbz7bXJx-EZNHEGzsr5bcpEYquXmB6Fg@mail.gmail.com>
	<20111123194423.158002cf@bob.linux.org.uk>
	<CAFQmdRZEk53fxa6CdFxMNWFH4y9eUu+MeKRxFnnYrgn8J1sAvw@mail.gmail.com>
Organization: Intel
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Nov 2011 13:03:27 -0800
Havard Skinnemoen <hskinnemoen@google.com> wrote:

> On Wed, Nov 23, 2011 at 11:44 AM, Alan Cox <alan@linux.intel.com>
> wrote:
> > Any data owned by the USB part needs to be handled by the USB
> > driver. In the case of usb-serial it keeps its own krefs for that
> > because the lifetime of the port/USB serial data is not the same as
> > the lifetime of the tty itself.
> 
> Yes, exactly. But since tty_port already has a kref, why not use that?
> It doesn't have any other use currently.

Indeed
 
> Hmm, a quick grep tells me tty_port_get() and tty_port_put() are
> completely unused. What was the intention behind them?

To provide a way to use the kref nicely.

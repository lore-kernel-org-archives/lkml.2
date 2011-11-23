Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756232Ab1KWVsa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Nov 2011 16:48:30 -0500
Received: from mga14.intel.com ([143.182.124.37]:62013 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755928Ab1KWVs2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Nov 2011 16:48:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.69,561,1315206000"; 
   d="scan'208";a="40659569"
Date: Wed, 23 Nov 2011 22:00:02 +0000
From: Alan Cox <alan@linux.intel.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Havard Skinnemoen <hskinnemoen@google.com>, Jiri Slaby <jslaby@suse.cz>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [RFC] cdc-acm: Fix potential deadlock (lockdep warning)
Message-ID: <20111123220002.63b6b12b@bob.linux.org.uk>
In-Reply-To: <201111232034.24280.oliver@neukum.org>
References: <CAFQmdRbkYiOArK09smfMvf2DJ8h-bYvKyXRN_nmX-bPG8ENmjA@mail.gmail.com>
	<1322074412-10873-1-git-send-email-hskinnemoen@google.com>
	<20111123192233.44f512b7@bob.linux.org.uk>
	<201111232034.24280.oliver@neukum.org>
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

On Wed, 23 Nov 2011 20:34:24 +0100
Oliver Neukum <oliver@neukum.org> wrote:

> Am Mittwoch, 23. November 2011, 20:22:33 schrieb Alan Cox:
> > and on the open side they provide their own install() method which
> > nicely avoids all the nasty locking problems and lets them use the
> > standard tty_port_open/close/hangup etc rather than the partial
> > ones.
> > 
> > It might be worth turning the ACM driver to work the same way as
> > it'll save doing that work later to achieve the same use of
> > tty_port_open/close/..
> > 
> > The main thing is the use of install - which lets you plug the USB
> > and tty bits together during the lookup of the device.
> 
> Which driver is the best example?

All the usb-serial drivers use the same core usb-serial.c to manage
all these bits. They just plug in additional I/O methods. So just look
at usb-serial.c

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758792Ab2HHPUi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 11:20:38 -0400
Received: from mga11.intel.com ([192.55.52.93]:34417 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758663Ab2HHPUg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 11:20:36 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.77,733,1336374000"; 
   d="scan'208";a="194665351"
Date: Wed, 8 Aug 2012 16:37:57 +0100
From: Alan Cox <alan@linux.intel.com>
To: Jiri Slaby <jslaby@suse.cz>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        jirislaby@gmail.com
Subject: Re: [PATCH 18/41] TTY: pty, switch to tty_alloc_driver
Message-ID: <20120808163757.28a28df1@bob.linux.org.uk>
In-Reply-To: <1344368886-24033-19-git-send-email-jslaby@suse.cz>
References: <1344368886-24033-1-git-send-email-jslaby@suse.cz>
	<1344368886-24033-19-git-send-email-jslaby@suse.cz>
Organization: Intel
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Organisation: Intel Corporation UK Ltd, registered no. 1134945 (England),
 Registered office Pipers Way, Swindon, SN3 1RJ
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  7 Aug 2012 21:47:43 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> Switch to the new driver allocation interface, as this is one of the
> special call-sites. Here, we need TTY_DRIVER_EXCESSIVE_LINES to not
> allocate tty_driver->ports, cdevs and potentially other structures
> because we reserve too many lines in pty. Instead, it provides the
> tty_port<->tty_struct link in tty->ops->install already.

This is the only thing I would quibble about in the entire patch set.

We've got a pile of things that the pty does and one or two other
drivers might want to do about dynamic allocation (termios objects is
the same problem).

I think it's a mistake to call it EXCESSIVE_LINES, better a name which
indicates what it implies - say TTY_DRIVER_DYNAMIC_ALLOC. Then it means
other drivers can move that way if they wish.

Otherwise

Acked-by: Alan Cox <alan@linux.intel.com>

for the entire series, and next time we are both at the same conference
I owe you a a couple of beers at least !


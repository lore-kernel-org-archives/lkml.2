Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754706Ab1B1POT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Feb 2011 10:14:19 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:37720 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754527Ab1B1POS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Feb 2011 10:14:18 -0500
Date: Mon, 28 Feb 2011 10:14:16 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jslaby@suse.cz>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <jirislaby@gmail.com>,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH 1/2] USB: serial/keyspan_pda, fix potential tty NULL
 dereferences
In-Reply-To: <1298885646-9293-1-git-send-email-jslaby@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1102281006560.2161-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011, Jiri Slaby wrote:

> Make sure that we check the return value of tty_port_tty_get.
> Sometimes it may return NULL and we later dereference that.
> 
> There are several places to check. For easier handling,
> tty_port_tty_get is moved directly to the palce where needed in
> keyspan_pda_rx_interrupt.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Alan Cox <alan@linux.intel.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>

I wonder about these changes.  Does it makes sense to add this checking
everywhere?  A more reasonable approach might be to make sure that
tty_port_tty_get is never called in a context where it could return
NULL.  Or would that involve just as much effort, making work routines
and so on check to see whether there's an open TTY device before doing
anything else?

Alan Stern


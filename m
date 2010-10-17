Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756878Ab0JQNu1 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 09:50:27 -0400
Received: from netrider.rowland.org ([192.131.102.5]:57611 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756407Ab0JQNu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 09:50:26 -0400
Date: Sun, 17 Oct 2010 09:50:23 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
cc: David Brownell <david-b@pacbell.net>, USB list <linux-usb@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.36-rc7: NULL pointer dereference in ehci_clear_tt_buffer_complete
In-Reply-To: <4CBA0C8C.6050909@s5r6.in-berlin.de>
Message-ID: <Pine.LNX.4.44L0.1010170944300.2318-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 16 Oct 2010, Stefan Richter wrote:

> > What I said above wasn't quite right.  This won't help trigger the 
> > oops, but it should trigger the line saying something like
> > 
> > 	ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00) state 5
> > 
> > That's the real bug.
> 
> # grep ' qh ' /var/log/messages
> Oct 11 22:29:21 stein kernel: ehci_hcd 0000:00:12.2: qh ffff880208f07af0 (#00)
> state 5
> 
> I.e. there was none anymore since the one which I reported on Monday.

Evidently this bug is pretty difficult to get hold of.  There has to be 
an URB that is unlinked at the time the endpoint gets disabled, and 
ideally it should have failed with a communications error (because the 
device was unplugged).  Going to the trouble to arrange all that 
doesn't seem worthwhile.

On the whole we shouldn't need to worry about it -- except that I think
the patch itself is worthwhile, pending review by David.

Alan Stern


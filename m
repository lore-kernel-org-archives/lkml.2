Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757262Ab1KOTUU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Nov 2011 14:20:20 -0500
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:36987 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751620Ab1KOTUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Nov 2011 14:20:17 -0500
X-Sasl-enc: f3lyKLF4U2UijkPwZy1eatYFiauBuU9ToHEEaa7Np2ED 1321384816
Date: Tue, 15 Nov 2011 11:18:37 -0800
From: Greg KH <greg@kroah.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: gregkh@suse.de, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH] serial/8250_pci: add a quirk for the kt serial controller
Message-ID: <20111115191837.GA27512@kroah.com>
References: <20111023222711.22713.11434.stgit@localhost6.localdomain6>
 <20111025022852.GB32457@kroah.com>
 <1319573794.9320.15.camel@dwillia2-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319573794.9320.15.camel@dwillia2-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 01:16:34PM -0700, Dan Williams wrote:
> From: Dan Williams <dan.j.williams@intel.com>
> Date: Sun, 23 Oct 2011 15:06:24 -0700
> Subject: [PATCH v2] serial/8250_pci: add a quirk for the kt serial controller
> 
> Workaround dropped notifications in the iir register.  Prevent reads
> coincident with new interrupt notifications by reading the iir at most
> once per interrupt.
> 
> Reported-by: Nhan H Mai <nhan.h.mai@intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> Cc: stable <stable@vger.kernel.org>
> ---
> On Tue, 2011-10-25 at 04:28 +0200, Greg KH wrote:
> On Sun, Oct 23, 2011 at 03:27:16PM -0700, Dan Williams wrote:
> > > --- a/include/linux/pci_ids.h
> > > +++ b/include/linux/pci_ids.h
> [..]
> > Based on the comment at the top of this file, you shouldn't add this
> > entry to it.
> > 
> > Care to redo the patch without that change?
> 
> Ok, moved it to drivers/tty/serial/8250_pci.c and cleaned up the
> conflicting "/* This should be in linux/pci_ids.h */" comment.

This doesn't apply to the 3.2-rc1 kernel at all:

patching file drivers/tty/serial/8250.c
Hunk #1 FAILED at 1652.
1 out of 1 hunk FAILED -- saving rejects to file drivers/tty/serial/8250.c.rej
patching file drivers/tty/serial/8250_pci.c
Hunk #2 succeeded at 1118 with fuzz 1 (offset 9 lines).
Hunk #3 succeeded at 1143 (offset 9 lines).
Hunk #4 succeeded at 1228 (offset 9 lines).
patching file include/linux/serial_core.h
Hunk #1 FAILED at 350.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/serial_core.h.rej
patching file drivers/tty/serial/8250.c
Hunk #1 FAILED at 1652.
1 out of 1 hunk FAILED -- saving rejects to file drivers/tty/serial/8250.c.rej
patching file drivers/tty/serial/8250_pci.c
Hunk #2 succeeded at 1118 with fuzz 1 (offset 9 lines).
Hunk #3 succeeded at 1143 (offset 9 lines).
Hunk #4 succeeded at 1228 (offset 9 lines).
patching file include/linux/serial_core.h
Hunk #1 FAILED at 350.
1 out of 1 hunk FAILED -- saving rejects to file include/linux/serial_core.h.rej


Care to fix it up and resend it?

thanks,

greg k-h

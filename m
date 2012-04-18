Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754118Ab2DRWMO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:12:14 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:46398 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753982Ab2DRWML (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:12:11 -0400
Date: Wed, 18 Apr 2012 15:12:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v4 2/3] serial/8250_pci: Clear FIFOs for Intel ME Serial
 Over Lan device on BI
Message-ID: <20120418221207.GA4489@kroah.com>
References: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
 <20120410211058.13805.75833.stgit@dwillia2-linux.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120410211058.13805.75833.stgit@dwillia2-linux.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 10, 2012 at 02:10:58PM -0700, Dan Williams wrote:
> From: Sudhakar Mamillapalli <sudhakar@fb.com>
> 
> When using Serial Over Lan (SOL) over the virtual serial port in a Intel
> management engine (ME) device, on device reset the serial FIFOs need to
> be cleared to keep the FIFO indexes in-sync between the host and the
> engine.
> 
> On a reset the serial device assertes BI, so using that as a cue FIFOs
> are cleared.  So for this purpose a new handle_break callback has been
> added.  One other problem is that the serial registers might temporarily
> go to 0 on reset of this device.  So instead of using the IER register
> read, if 0 returned use the ier value in uart_8250_port. This is hidden
> under a custom serial_in.
> 
> Cc: Nhan H Mai <nhan.h.mai@intel.com>
> Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
> Acked-by: Alan Cox <alan@linux.intel.com>
> Signed-off-by: Dan Williams <dan.j.williams@intel.com>

What tree did you make this against?

It fails with:
patching file drivers/tty/serial/8250/8250.c
patching file drivers/tty/serial/8250/8250.h
patching file drivers/tty/serial/8250/8250_pci.c
Hunk #2 FAILED at 1093.
1 out of 2 hunks FAILED -- saving rejects to file drivers/tty/serial/8250/8250_pci.c.rej

While that file hasn't been changed since it was moved to that location.

Any ideas?

Because of this, I've only applied your first patch in this series, not
the last two.

thanks,

greg k-h

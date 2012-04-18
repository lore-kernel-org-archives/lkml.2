Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754352Ab2DRXAO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 19:00:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55038 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab2DRXAL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 19:00:11 -0400
Date: Wed, 18 Apr 2012 16:00:07 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Subject: Re: [PATCH v4 2/3] serial/8250_pci: Clear FIFOs for Intel ME Serial
 Over Lan device on BI
Message-ID: <20120418230007.GA9329@kroah.com>
References: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
 <20120410211058.13805.75833.stgit@dwillia2-linux.jf.intel.com>
 <20120418221207.GA4489@kroah.com>
 <CABE8wwvw1R_ObcjGLfPXhGLq1g1H54QTRZf2Y-E3XHYg+v=APg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABE8wwvw1R_ObcjGLfPXhGLq1g1H54QTRZf2Y-E3XHYg+v=APg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 03:36:40PM -0700, Dan Williams wrote:
> On Wed, Apr 18, 2012 at 3:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Apr 10, 2012 at 02:10:58PM -0700, Dan Williams wrote:
> >> From: Sudhakar Mamillapalli <sudhakar@fb.com>
> >>
> >> When using Serial Over Lan (SOL) over the virtual serial port in a Intel
> >> management engine (ME) device, on device reset the serial FIFOs need to
> >> be cleared to keep the FIFO indexes in-sync between the host and the
> >> engine.
> >>
> >> On a reset the serial device assertes BI, so using that as a cue FIFOs
> >> are cleared.  So for this purpose a new handle_break callback has been
> >> added.  One other problem is that the serial registers might temporarily
> >> go to 0 on reset of this device.  So instead of using the IER register
> >> read, if 0 returned use the ier value in uart_8250_port. This is hidden
> >> under a custom serial_in.
> >>
> >> Cc: Nhan H Mai <nhan.h.mai@intel.com>
> >> Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
> >> Acked-by: Alan Cox <alan@linux.intel.com>
> >> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
> >
> > What tree did you make this against?
> >
> > It fails with:
> > patching file drivers/tty/serial/8250/8250.c
> > patching file drivers/tty/serial/8250/8250.h
> > patching file drivers/tty/serial/8250/8250_pci.c
> > Hunk #2 FAILED at 1093.
> > 1 out of 2 hunks FAILED -- saving rejects to file drivers/tty/serial/8250/8250_pci.c.rej
> >
> > While that file hasn't been changed since it was moved to that location.
> >
> > Any ideas?
> 
> Hmm, I think this is because this patch depends on the reverts went
> into 3.4 via tty-linus.

Ah, ok, that makes more sense, let me go merge 3.4-rc3 into tty-next and
see if that solves the problem...

Yup, it did, thanks, I'll go apply these two patches now, sorry for the
noise.

greg k-h

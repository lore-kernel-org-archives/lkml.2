Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab2DRWgo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 18:36:44 -0400
Received: from mga05.intel.com ([192.55.52.89]:13344 "EHLO
	fmsmga101.fm.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751639Ab2DRWgn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 18:36:43 -0400
MIME-Version: 1.0
In-Reply-To: <20120418221207.GA4489@kroah.com>
References: <20120410210438.13805.40525.stgit@dwillia2-linux.jf.intel.com>
	<20120410211058.13805.75833.stgit@dwillia2-linux.jf.intel.com>
	<20120418221207.GA4489@kroah.com>
Date: Wed, 18 Apr 2012 15:36:40 -0700
Message-ID: <CABE8wwvw1R_ObcjGLfPXhGLq1g1H54QTRZf2Y-E3XHYg+v=APg@mail.gmail.com>
Subject: Re: [PATCH v4 2/3] serial/8250_pci: Clear FIFOs for Intel ME Serial
 Over Lan device on BI
From: Dan Williams <dan.j.williams@intel.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: Sudhakar Mamillapalli <sudhakar@fb.com>, Nhan H Mai <nhan.h.mai@intel.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Alan Cox <alan@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 3:12 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> On Tue, Apr 10, 2012 at 02:10:58PM -0700, Dan Williams wrote:
>> From: Sudhakar Mamillapalli <sudhakar@fb.com>
>>
>> When using Serial Over Lan (SOL) over the virtual serial port in a Intel
>> management engine (ME) device, on device reset the serial FIFOs need to
>> be cleared to keep the FIFO indexes in-sync between the host and the
>> engine.
>>
>> On a reset the serial device assertes BI, so using that as a cue FIFOs
>> are cleared.  So for this purpose a new handle_break callback has been
>> added.  One other problem is that the serial registers might temporarily
>> go to 0 on reset of this device.  So instead of using the IER register
>> read, if 0 returned use the ier value in uart_8250_port. This is hidden
>> under a custom serial_in.
>>
>> Cc: Nhan H Mai <nhan.h.mai@intel.com>
>> Signed-off-by: Sudhakar Mamillapalli <sudhakar@fb.com>
>> Acked-by: Alan Cox <alan@linux.intel.com>
>> Signed-off-by: Dan Williams <dan.j.williams@intel.com>
>
> What tree did you make this against?
>
> It fails with:
> patching file drivers/tty/serial/8250/8250.c
> patching file drivers/tty/serial/8250/8250.h
> patching file drivers/tty/serial/8250/8250_pci.c
> Hunk #2 FAILED at 1093.
> 1 out of 2 hunks FAILED -- saving rejects to file drivers/tty/serial/8250/8250_pci.c.rej
>
> While that file hasn't been changed since it was moved to that location.
>
> Any ideas?

Hmm, I think this is because this patch depends on the reverts went
into 3.4 via tty-linus.

On my internal tree I have the following against 3.4-rc2

48013c6 Revert "serial/8250_pci: init-quirk msi support for kt serial
controller"
0f4149f Revert "serial/8250_pci: setup-quirk workaround for the kt
serial controller"
5580b22 serial/8250_pci: add a "force background timer" flag and use
it for the "kt" serial port
d8a8351 tegra, serial8250: add ->handle_break() uart_port op
1d9aafe serial/8250_pci: Clear FIFOs for Intel ME Serial Over Lan device on BI
d4cb218 serial/8250_pci: fix suspend/resume vs init/exit quirks

> Because of this, I've only applied your first patch in this series, not
> the last two.

Not sure how these things are handled in tty.git, backmerge?

--
Dan

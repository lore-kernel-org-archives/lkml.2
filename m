Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752968Ab1HAVUJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Aug 2011 17:20:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60268 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752448Ab1HAVUE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Aug 2011 17:20:04 -0400
Date: Mon, 1 Aug 2011 14:16:59 -0700
From: Greg KH <gregkh@suse.de>
To: Josh Boyer <jwboyer@redhat.com>
Cc: edwin_rong <edwin_rong@realsil.com.cn>, wwang <wei_wang@realsil.com.cn>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: ums-realtek driver uses stack memory for DMA
Message-ID: <20110801211659.GA13252@suse.de>
References: <20110801210905.GC2096@zod.bos.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110801210905.GC2096@zod.bos.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 01, 2011 at 05:09:06PM -0400, Josh Boyer wrote:
> Hello,
> 
> We have a report that the ums-realtek driver is generating a backtrace
> due to using stack variables for DMA buffers.  The backtrace is below
> and you can view the bug report here:
> https://bugzilla.redhat.com/show_bug.cgi?id=720054
> 
> Looking through the code, it seems that every call to rts51x_read_mem,
> rts51x_write_mem, and rts51x_read_status passes a stack variable to
> rts51x_bulk_transport, which then calls usb_stor_bulk_transfer_buf with
> this and generates the backtrace.  It is my understanding that the
> driver should be passing variables that are not on the stack and have
> been allocated with memory that will be suitable for the DMA api (e.g.
> kmalloc).

That is correct.

> Was this missed during the initial review and is anyone working on
> adapting the driver to be compliant?

Odds are it was missed.  Patches gladly accepted.

thanks,

greg k-h

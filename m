Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757626Ab2DFTO6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Apr 2012 15:14:58 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37658 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754495Ab2DFTOz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Apr 2012 15:14:55 -0400
Date: Fri, 6 Apr 2012 12:14:51 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        alan@linux.intel.com
Subject: Re: [PATCH 0/6] rework quirks for the "kt" serial port
Message-ID: <20120406191451.GA14211@kroah.com>
References: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120406184346.21744.18004.stgit@dwillia2-linux.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 06, 2012 at 11:44:22AM -0700, Dan Williams wrote:
> The kt serial port intermittently reports unreliable data in its IIR
> register and needs to reset fifos to stay in sync with firmware when the
> device is reset.
> 
> The IIR fixes that went into 3.3 were not complete so patch 3 replaces
> them with an explicit way to turn on UART_BUG_THRE (i.e. the "I don't
> trust my iir" flag).
> 

So the first 3 patches should go into 3.4 (and 3.3-stable) kernels,
right?

> A new fix for resetting the fifos on device reset is patch 5.  Alan
> asked to make this a new quirk rather than add more workarounds to the
> core (patch 4).

These can wait for 3.5?

> Patch 6 is an untested RFC / RFT from anyone that has a serial
> suspend/resume use case with an 'init' quirk that has resources that
> need de-allocation at 'exit'.

And I'll hold off on this one entirely for now, right?

greg k-h

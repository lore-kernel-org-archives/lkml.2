Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752206Ab0FCMTN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 08:19:13 -0400
Received: from mga09.intel.com ([134.134.136.24]:5484 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232Ab0FCMTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 08:19:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.53,354,1272870000"; 
   d="scan'208";a="627158259"
Date: Thu, 3 Jun 2010 12:32:25 +0100
From: Alan Cox <alan@linux.intel.com>
To: Daniel Mack <daniel@caiaq.de>
Cc: linux-kernel@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
       Johan Hovold <jhovold@gmail.com>, linux-usb@vger.kernel.org
Subject: Re: [PATCH] usb-serial/ftdi_sio: fix DTR/RTS line modes
Message-ID: <20100603123225.55f544ff@linux.intel.com>
In-Reply-To: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
References: <1275566102-5613-1-git-send-email-daniel@caiaq.de>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  3 Jun 2010 13:55:02 +0200
Daniel Mack <daniel@caiaq.de> wrote:

> Call set_mctrl() and clear_mctrl() according to the flow control mode
> selected. This makes serial communication for FT232 connected devices
> work when CRTSCTS is not set.
> 
> This fixes a regression introduced by 4175f3e31 ("tty_port: If we are
> opened non blocking we still need to raise the carrier"). This patch
> calls the low-level driver's dtr_rts() function which consequently
> sets TIOCM_DTR | TIOCM_RTS. A later call to set_termios() without
> CRTSCTS in cflags, however, does not reset these bits, and so data is
> not actually sent out on the serial wire.

If you've got hardware the other end expecting RTS/CTS signals you
really ought to set CRTSCTS. However you patch makes complete sense in
terms of which way it is best to end up.

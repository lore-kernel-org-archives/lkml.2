Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754188Ab1IVXIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Sep 2011 19:08:49 -0400
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:35136 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751560Ab1IVXIr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Sep 2011 19:08:47 -0400
X-Sasl-enc: ImgUyfNGtO8w/aijfufIgZbgZRuZ/KQjWr329C6/rf4n 1316732926
Date: Thu, 22 Sep 2011 16:06:40 -0700
From: Greg KH <greg@kroah.com>
To: Timur Tabi <timur@freescale.com>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
        linux-console@vger.kernel.org
Subject: Re: [PATCH] drivers/tty: don't use the byte channel handle as a
 parameter in ehv_bytechan.c
Message-ID: <20110922230640.GA16981@kroah.com>
References: <1316543217-13769-1-git-send-email-timur@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316543217-13769-1-git-send-email-timur@freescale.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 01:26:57PM -0500, Timur Tabi wrote:
> The ePAPR hypervisor byte channel console driver only supports one byte
> channel as a console, and the byte channel handle is stored in a global
> variable.  It doesn't make any sense to pass that handle as a parameter
> to the console functions, since these functions already have access to the
> global variable.
> 
> This change also fixes this compilation warning on a 64-bit kernel:
> 
>   CC      drivers/tty/ehv_bytechan.o
> drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_write':
> drivers/tty/ehv_bytechan.c:289:24: warning: cast from pointer to integer of different size
> drivers/tty/ehv_bytechan.c: In function 'ehv_bc_console_init':
> drivers/tty/ehv_bytechan.c:355:24: warning: cast to pointer from integer of different size
> 
> This warning is because the driver is converting the integer byte channel
> handle to/from the void* 'data' field of struct console.  Rather than fix
> the warning, we just eliminate the code altogether.
> 
> Signed-off-by: Timur Tabi <timur@freescale.com>
> ---
>  drivers/tty/ehv_bytechan.c |    7 ++-----

This patch doesn't apply at all to my tty tree, what was it made
against?

confused,

greg k-h

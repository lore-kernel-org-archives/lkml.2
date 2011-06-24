Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab1FXMNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 08:13:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59012 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756530Ab1FXMNk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 08:13:40 -0400
Date: Fri, 24 Jun 2011 14:13:38 +0200
From: Libor Pechacek <lpechacek@suse.cz>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: stable@kernel.org, linux-kernel@vger.kernel.org, stable-review@kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>
Subject: Re: [34-longterm 006/247] USB: serial: handle Data Carrier Detect
	changes
Message-ID: <20110624121337.GF20922@fm.suse.cz>
References: <1308849690-14530-1-git-send-email-paul.gortmaker@windriver.com> <1308849690-14530-7-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1308849690-14530-7-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.18-muttng (2008-05-17-r1399)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

> @@ -726,6 +726,10 @@ static void spcp8x5_read_bulk_callback(struct urb *urb)
>  		/* overrun is special, not associated with a char */
>  		if (status & UART_OVERRUN_ERROR)
>  			tty_insert_flip_char(tty, 0, TTY_OVERRUN);
> +		if (status & UART_DCD)
> +			usb_serial_handle_dcd_change(port, tty,
> +				   priv->line_status & MSR_STATUS_LINE_DCD);
> +
>  		tty_insert_flip_string_fixed_flag(tty, data, tty_flag,
>  							urb->actual_length);
>  		tty_flip_buffer_push(tty);

The above code is mistakenly placed inside the "if (tty && urb->actual_length)"
block.  Should be right after it.

For kernels v2.6.31 - v2.6.34 use the following patch
http://git.kernel.org/?p=linux/kernel/git/longterm/linux-2.6.32.y.git;a=commitdiff;h=6fe7015007299e14f5ea212a503bcba5958c7086

For kernels v2.6.35 - v2.6.37 use
http://git.kernel.org/?p=linux/kernel/git/stable/linux-2.6.37.y.git;a=commitdiff;h=2631217445b84e5d31341eaaf6e7951bf8907f52

Libor
-- 
Libor Pechacek
SUSE L3 Team, Prague

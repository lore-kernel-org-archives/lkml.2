Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab0JLSjm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Oct 2010 14:39:42 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43375 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754403Ab0JLSjl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Oct 2010 14:39:41 -0400
From: Kevin Hilman <khilman@deeprootsystems.com>
To: Vasiliy Kulikov <segooon@gmail.com>, Tony Lindgren <tony@atomide.com>
Cc: kernel-janitors@vger.kernel.org, "Govindraj.R" <govindraj.raja@ti.com>,
        Greg Kroah-Hartman <gregkh@suse.de>, Alan Cox <alan@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH] serial: omap-serial: fix signess error
Organization: Deep Root Systems, LLC
References: <1286731715-17908-1-git-send-email-segooon@gmail.com>
Date: Tue, 12 Oct 2010 11:39:36 -0700
In-Reply-To: <1286731715-17908-1-git-send-email-segooon@gmail.com> (Vasiliy
	Kulikov's message of "Sun, 10 Oct 2010 21:28:35 +0400")
Message-ID: <8739sb1cif.fsf@deeprootsystems.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[adding linux-omap list]

Vasiliy Kulikov <segooon@gmail.com> writes:

> "ret" is unsigned, so check for (ret < 0) made no sense.
> Made it signed.
>
> Signed-off-by: Vasiliy Kulikov <segooon@gmail.com>
> ---
>  I cannot compile this driver, so it is not tested.

Acked-by: Kevin Hilman <khilman@deeprootsystems.com>

Since the original driver is being queued via the omap tree, we can
queue this one as well.

Tony, can you add this one to the 2.6.37 queue?

Thanks,

Kevin

>  drivers/serial/omap-serial.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/omap-serial.c b/drivers/serial/omap-serial.c
> index 2ee1d32..14365f7 100644
> --- a/drivers/serial/omap-serial.c
> +++ b/drivers/serial/omap-serial.c
> @@ -1055,7 +1055,7 @@ static void serial_omap_rx_timeout(unsigned long uart_no)
>  {
>  	struct uart_omap_port *up = ui[uart_no];
>  	unsigned int curr_dma_pos, curr_transmitted_size;
> -	unsigned int ret = 0;
> +	int ret = 0;
>  
>  	curr_dma_pos = omap_get_dma_dst_pos(up->uart_dma.rx_dma_channel);
>  	if ((curr_dma_pos == up->uart_dma.prev_rx_dma_pos) ||

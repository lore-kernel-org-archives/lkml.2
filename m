Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755274Ab1FHVo3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 17:44:29 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58341 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752090Ab1FHVo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 17:44:26 -0400
Date: Wed, 8 Jun 2011 14:44:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Alexander Stein <alexander.stein@systec-electronic.com>
Cc: linux-kernel@vger.kernel.org, Greg KH <greg@kroah.com>
Subject: Re: [PATCH] pch_uart: Don't panic if dmi_get_system_info returns
 NULL
Message-Id: <20110608144419.e5b3034c.akpm@linux-foundation.org>
In-Reply-To: <1306930285-9977-1-git-send-email-alexander.stein@systec-electronic.com>
References: <1306930285-9977-1-git-send-email-alexander.stein@systec-electronic.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  1 Jun 2011 14:11:25 +0200
Alexander Stein <alexander.stein@systec-electronic.com> wrote:

> Signed-off-by: Alexander Stein <alexander.stein@systec-electronic.com>
> ---
>  drivers/tty/serial/pch_uart.c |    4 +++-
>  1 files changed, 3 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/pch_uart.c b/drivers/tty/serial/pch_uart.c
> index f2cb750..4652109 100644
> --- a/drivers/tty/serial/pch_uart.c
> +++ b/drivers/tty/serial/pch_uart.c
> @@ -1397,6 +1397,7 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>  	int fifosize, base_baud;
>  	int port_type;
>  	struct pch_uart_driver_data *board;
> +	const char *board_name;
>  
>  	board = &drv_dat[id->driver_data];
>  	port_type = board->port_type;
> @@ -1412,7 +1413,8 @@ static struct eg20t_port *pch_uart_init_port(struct pci_dev *pdev,
>  	base_baud = 1843200; /* 1.8432MHz */
>  
>  	/* quirk for CM-iTC board */
> -	if (strstr(dmi_get_system_info(DMI_BOARD_NAME), "CM-iTC"))
> +	board_name = dmi_get_system_info(DMI_BOARD_NAME);
> +	if (board_name && strstr(board_name, "CM-iTC"))
>  		base_baud = 192000000; /* 192.0MHz */
>  
>  	switch (port_type) {

Please changelog your patches.

A changelog for this patch would include info such as:

a) The code doesn't panic.  I think you meant "oops due to a NULL
   pointer dereference"

b) Under what circumstances will dmi_get_system_info() return NULL?

c) Has this bug been observed in the real world, or was it from code
   inspection?  If the former, under what circumstances?

The answer to c) will allow others to decide which kernel version(s)
the fix should be merged into.

Thanks.

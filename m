Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1BIJ4n (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Feb 2011 04:56:43 -0500
Received: from symlink.to.noone.org ([85.10.207.172]:51238 "EHLO sym.noone.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753816Ab1BIJ4m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Feb 2011 04:56:42 -0500
Date: Wed, 9 Feb 2011 10:56:41 +0100
From: Tobias Klauser <tklauser@distanz.ch>
To: Greg Kroah-Hartman <gregkh@suse.de>, linux-serial@vger.kernel.org
Cc: nios2-dev@sopc.et.ntust.edu.tw, linux-kernel@vger.kernel.org,
        Anton Vorontsov <cbouatmailru@gmail.com>
Subject: Re: [PATCH 1/4] tty: serial: altera_uart: Handle pdev->id == -1 in
	altera_uart_remove
Message-ID: <20110209095641.GU29757@distanz.ch>
References: <cover.1297244810.git.tklauser@distanz.ch> <9212990ebdb34f2b80d6858a9ba2a88b4d53a207.1297244810.git.tklauser@distanz.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9212990ebdb34f2b80d6858a9ba2a88b4d53a207.1297244810.git.tklauser@distanz.ch>
X-Editor: Vi IMproved 7.1
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-02-09 at 10:51:34 +0100, Tobias Klauser <tklauser@distanz.ch> wrote:
> Commit 6b5756f176568a710d008d3b478128fafb6707f0 introduced the
> possibility for pdev->id being -1 but the change was not done equally in
> altera_uart_remove. This patch fixes this.

Please disregard this patch. I'll send it again as a follow up to the
correct cover letter.

Sorry for the mess
Tobias

> 
> Cc: Anton Vorontsov <cbouatmailru@gmail.com>
> Signed-off-by: Tobias Klauser <tklauser@distanz.ch>
> ---
>  drivers/tty/serial/altera_uart.c |    8 +++++++-
>  1 files changed, 7 insertions(+), 1 deletions(-)
> 
> diff --git a/drivers/tty/serial/altera_uart.c b/drivers/tty/serial/altera_uart.c
> index 7212162..dee7a0e 100644
> --- a/drivers/tty/serial/altera_uart.c
> +++ b/drivers/tty/serial/altera_uart.c
> @@ -561,9 +561,15 @@ static int __devinit altera_uart_probe(struct platform_device *pdev)
>  
>  static int __devexit altera_uart_remove(struct platform_device *pdev)
>  {
> -	struct uart_port *port = &altera_uart_ports[pdev->id].port;
> +	struct uart_port *port;
> +	int i = pdev->id;
>  
> +	if (i == -1)
> +		i = 0;
> +
> +	port = &altera_uart_ports[i].port;
>  	uart_remove_one_port(&altera_uart_driver, port);
> +
>  	return 0;
>  }
>  
> -- 
> 1.7.0.4
> 

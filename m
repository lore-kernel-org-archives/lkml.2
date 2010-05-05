Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934646Ab0EEMku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 08:40:50 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:52315 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934433Ab0EEMks convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 08:40:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=JQU6sdWhH4eqc3iAHbbMTZOnW6ESouEE719guCQb7yPp2+BK8gurSmteBjSaV8SFpq
         xdqVnbildJFR5eCAk6eJaITU9tE5QzU8tosdppWehLmlMr71UodOa9roeYhftw/fBC21
         5IziP4WZhP5CAh7TwLB5Ap9tXGzqtOuKJhBVM=
MIME-Version: 1.0
In-Reply-To: <1273011539-13994-1-git-send-email-agust@denx.de>
References: <g2xc2d0b6ec1005041339r9c40822w7a642f9bba976820@mail.gmail.com>
	 <1273011539-13994-1-git-send-email-agust@denx.de>
Date: Wed, 5 May 2010 09:40:47 -0300
Message-ID: <s2ic2d0b6ec1005050540nb382fc0aj70c4f132543a66aa@mail.gmail.com>
Subject: Re: [PATCH] serial: mpc52xx_uart: fix null pointer dereference
From: Leonardo Chiquitto <leonardo.lists@gmail.com>
To: Anatolij Gustschin <agust@denx.de>
Cc: linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org,
       grant.likely@secretlab.ca, gregkh@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 4, 2010 at 7:18 PM, Anatolij Gustschin <agust@denx.de> wrote:
> Commit 6acc6833510db8f72b5ef343296d97480555fda9
> introduced NULL pointer dereference and kernel crash
> on ppc32 machines while booting. Fix this bug now.
>
> Reported-by: Leonardo Chiquitto <leonardo.lists@gmail.com>
> Signed-off-by: Anatolij Gustschin <agust@denx.de>
> ---
>  drivers/serial/mpc52xx_uart.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/serial/mpc52xx_uart.c b/drivers/serial/mpc52xx_uart.c
> index a176ab4..02469c3 100644
> --- a/drivers/serial/mpc52xx_uart.c
> +++ b/drivers/serial/mpc52xx_uart.c
> @@ -1467,7 +1467,7 @@ mpc52xx_uart_init(void)
>        /*
>         * Map the PSC FIFO Controller and init if on MPC512x.
>         */
> -       if (psc_ops->fifoc_init) {
> +       if (psc_ops && psc_ops->fifoc_init) {
>                ret = psc_ops->fifoc_init();
>                if (ret)
>                        return ret;
> --
> 1.7.0.4

Thanks for the quick fix, Anatolij. I just tested it and confirm it resolves
the problem.

Leonardo

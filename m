Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755741Ab2HFJ3u (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:29:50 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:53351 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755721Ab2HFJ3r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:29:47 -0400
MIME-Version: 1.0
In-Reply-To: <1343630652-7220-1-git-send-email-lliubbo@gmail.com>
References: <1343630652-7220-1-git-send-email-lliubbo@gmail.com>
Date: Mon, 6 Aug 2012 17:29:46 +0800
Message-ID: <CAA_GA1d=mXhcOh7UL+8thMcz8ueQ4PR1Ytz8KNj40=+py+X7tA@mail.gmail.com>
Subject: Re: [PATCH] drivers: net: irda: bfin_sir: fix compile error
From: Bob Liu <lliubbo@gmail.com>
To: samuel@sortiz.org
Cc: axel.lin@gmail.com, rmk+kernel@arm.linux.org.uk,
        gregkh@linuxfoundation.org, kuninori.morimoto.gx@renesas.com,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        sonic.zhang@analog.com, uclinux-dist-devel@blackfin.uclinux.org,
        Bob Liu <lliubbo@gmail.com>, davem@davemloft.net
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

Would you please take a look at this patch?
Since without this patch, regression test for blackfin will fail:
http://kisskb.ellerman.id.au/kisskb/matrix/

Thank you!

On Mon, Jul 30, 2012 at 2:44 PM, Bob Liu <lliubbo@gmail.com> wrote:
> From: Sonic Zhang <sonic.zhang@analog.com>
>
> Bit IREN is replaced by UMOD_IRDA and UMOD_MASK since blackfin 60x added, but
> this driver didn't update which will cause bfin_sir build error:
>
> drivers/net/irda/bfin_sir.c:161:9: error: 'IREN' undeclared (first use in this
> function)
> drivers/net/irda/bfin_sir.c:435:18: error: 'IREN' undeclared (first use in
> this function)
> drivers/net/irda/bfin_sir.c:521:11: error: 'IREN' undeclared (first use in
> this function)
>
> This patch fix it.
>
> Signed-off-by: Sonic Zhang <sonic.zhang@analog.com>
> Signed-off-by: Bob Liu <lliubbo@gmail.com>
> ---
>  drivers/net/irda/bfin_sir.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> diff --git a/drivers/net/irda/bfin_sir.c b/drivers/net/irda/bfin_sir.c
> index a561ae4..c6a0299 100644
> --- a/drivers/net/irda/bfin_sir.c
> +++ b/drivers/net/irda/bfin_sir.c
> @@ -158,7 +158,7 @@ static int bfin_sir_set_speed(struct bfin_sir_port *port, int speed)
>         /* If not add the 'RPOLC', we can't catch the receive interrupt.
>          * It's related with the HW layout and the IR transiver.
>          */
> -       val |= IREN | RPOLC;
> +       val |= UMOD_IRDA | RPOLC;
>         UART_PUT_GCTL(port, val);
>         return ret;
>  }
> @@ -432,7 +432,7 @@ static void bfin_sir_shutdown(struct bfin_sir_port *port, struct net_device *dev
>         bfin_sir_stop_rx(port);
>
>         val = UART_GET_GCTL(port);
> -       val &= ~(UCEN | IREN | RPOLC);
> +       val &= ~(UCEN | UMOD_MASK | RPOLC);
>         UART_PUT_GCTL(port, val);
>
>  #ifdef CONFIG_SIR_BFIN_DMA
> @@ -518,10 +518,10 @@ static void bfin_sir_send_work(struct work_struct *work)
>          * reset all the UART.
>          */
>         val = UART_GET_GCTL(port);
> -       val &= ~(IREN | RPOLC);
> +       val &= ~(UMOD_MASK | RPOLC);
>         UART_PUT_GCTL(port, val);
>         SSYNC();
> -       val |= IREN | RPOLC;
> +       val |= UMOD_IRDA | RPOLC;
>         UART_PUT_GCTL(port, val);
>         SSYNC();
>         /* bfin_sir_set_speed(port, self->speed); */
> --
> 1.7.9.5
>
>

-- 
Regards,
--Bob

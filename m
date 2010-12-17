Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753028Ab0LQMCy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Dec 2010 07:02:54 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:43612 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab0LQMCx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Dec 2010 07:02:53 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=S+WG/HCqK8YJv8pfc2rw5NjTDV6gBbxc0+CGONdUyenYF/BMSvVDJHk7hLVvLd4laM
         sj4sYR06dPT/YNlOOyrpszNPKAc18kGWwQgwyExhhOsBmu/0Ht+XVHtQGxwk+OlmX91l
         QeIWGagZz+ngWDPqUlzbXSCr77SPXKgIzBh1Y=
MIME-Version: 1.0
In-Reply-To: <1292585117-28584-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
References: <1292585117-28584-1-git-send-email-par-gunnar.p.hjalmdahl@stericsson.com>
Date: Fri, 17 Dec 2010 13:02:52 +0100
Message-ID: <AANLkTimjDCF4V9wGszVcuDYqZ8Qq0CYhCzxnxEKcibxN@mail.gmail.com>
Subject: Re: [PATCH 08/11] Bluetooth: Add support for CG2900 UART
From: Vitaly Wool <vitalywool@gmail.com>
To: Par-Gunnar Hjalmdahl <par-gunnar.p.hjalmdahl@stericsson.com>
Cc: Pavan Savoy <pavan_savoy@sify.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, Samuel Ortiz <sameo@linux.intel.com>,
        Marcel Holtmann <marcel@holtmann.org>, linux-kernel@vger.kernel.org,
        linux-bluetooth@vger.kernel.org,
        Lukasz Rymanowski <Lukasz.Rymanowski@tieto.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Par-Gunnar Hjalmdahl <pghatwork@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Par,

so on the top level: this is yet another H4 implementation plus
channel-based packet routing, right?

Could you please also elaborate

More comments on the code are inlined.

> +#define MAIN_DEV               (uart_info->dev)

What is that for?

> + * cg2900_uart_suspend() - Called by Linux PM to put the device in a low power mode.
> + * @pdev:      Pointer to platform device.
> + * @state:     New state.
> + *
> + * In UART case, CG2900 driver does nothing on suspend.
> + *
> + * Returns:
> + *   0 - Success.
> + */
> +static int cg2900_uart_suspend(struct platform_device *pdev, pm_message_t state)
> +{
> +       struct uart_info *uart_info = dev_get_drvdata(&pdev->dev);
> +
> +       if (uart_info->sleep_state == CHIP_POWERED_DOWN)
> +               return 0;
> +
> +       if (uart_info->sleep_state != CHIP_ASLEEP)
> +               return -EBUSY;
> +
> +       dev_dbg(MAIN_DEV, "New sleep_state: CHIP_SUSPENDED\n");
> +       uart_info->sleep_state = CHIP_SUSPENDED;
> +       return 0;
> +}

I don't think this is safe wrt work queue. What if it gets scheduled
when drivers are suspended?

Thanks,
   Vitaly

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757387Ab1F1LaP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 07:30:15 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64706 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318Ab1F1L3W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 07:29:22 -0400
MIME-Version: 1.0
In-Reply-To: <1309211120-2803-3-git-send-email-arnd@arndb.de>
References: <1309211120-2803-1-git-send-email-arnd@arndb.de>
	<1309211120-2803-3-git-send-email-arnd@arndb.de>
Date: Tue, 28 Jun 2011 13:29:19 +0200
Message-ID: <BANLkTin9=5Yp6W8S6hSuUZ8w08eUhRxxQw@mail.gmail.com>
Subject: Re: [PATCH 2/7] serial/8250: move alchemy I/O handler to platform code
From: Manuel Lauss <manuel.lauss@googlemail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Ralf Baechle <ralf@linux-mips.org>, linux-serial@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 11:45 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> Only one platform ever sets the UPIO_AU iotype, so it's
> cleaner to define the handlers in the code that actually
> requires it, rather than building the same logic into
> every 8250 driver.
>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> Cc: Ralf Baechle <ralf@linux-mips.org>
> Cc: Manuel Lauss <manuel.lauss@googlemail.com>
> Cc: Greg Kroah-Hartman <gregkh@suse.de>
> Cc: linux-serial@vger.kernel.org
> ---
>  arch/mips/alchemy/common/platform.c |   50 ++++++++++++++++++++++++++++++
>  drivers/tty/serial/8250.c           |   58 -----------------------------------
>  2 files changed, 50 insertions(+), 58 deletions(-)
>
> diff --git a/arch/mips/alchemy/common/platform.c b/arch/mips/alchemy/common/platform.c
> index 3b2c18b..750441f 100644
> --- a/arch/mips/alchemy/common/platform.c
> +++ b/arch/mips/alchemy/common/platform.c
[...]
> @@ -55,6 +103,8 @@ static void alchemy_8250_pm(struct uart_port *port, unsigned int state,
>                                  UPF_FIXED_TYPE,               \
>                .type           = PORT_16550A,                  \
>                .pm             = alchemy_8250_pm,              \
> +               .serial_in      = au_serial_in,                 \
> +               .serial_out     = au_serial_out                 \
>        }

This is very strange:  Just this part alone (leaving 8250.c intact)
screws everything up.
The assembly for au_serial_in/out is identical in both 8250.o and
arch/mips/alchemy/common/platform.o (renamed the functions here obviously)
I have no idea what's wrong...

Manuel

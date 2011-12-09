Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754301Ab1LIOqC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Dec 2011 09:46:02 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:61961 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752801Ab1LIOqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Dec 2011 09:46:00 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Sjur =?utf-8?q?Br=C3=A6ndeland?= <sjur.brandeland@stericsson.com>
Subject: Re: [PATCHv2 01/10] xshm: Shared Memory layout for ST-E M7400 driver.
Date: Fri, 9 Dec 2011 14:45:56 +0000
User-Agent: KMail/1.12.2 (Linux/3.2.0-rc1+; KDE/4.3.2; x86_64; ; )
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Paul Bolle <pebolle@tiscali.nl>,
        Dan Carpenter <dan.carpenter@oracle.com>
References: <1323439648-22697-1-git-send-email-sjur.brandeland@stericsson.com> <1323439648-22697-2-git-send-email-sjur.brandeland@stericsson.com>
In-Reply-To: <1323439648-22697-2-git-send-email-sjur.brandeland@stericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201112091445.56224.arnd@arndb.de>
X-Provags-ID: V02:K0:MkdHFrqpNB6zSDgRmjq+WziAtj9Rjl9a4l8Bx8SRVx/
 j+/pn1eJd7X6cLNINHZAKu9Yi3+nuklFkvHKGOPorTSB/dP8Gq
 4jekjcFUAHcMT4UDKqEY7wnx8Vrl8UlYTR1yDEw5oM6QsvUEFo
 wmoGdlGQSN1qCIUiLJlO5RAe5jjKmlW6CANavEqzglNI5L4wHF
 Nzz4oLqDpx+mFtLBqF48FA0hry0PENh/gxaCpj7vOUkRsr9urb
 G2RsGw8TwHZ7PXziWJrrc2Hespx/MpegrSLn7G96RYm7BtXILF
 i25LdoV/zpM6gbauGI5GezJ5jkqXRGLTwJuuyjxJ/FH6GXdnNI
 92paMVl9GFFqXpjcGftE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 09 December 2011, Sjur Brændeland wrote:
> Add structures defining the channel configuration and the
> shared memory layout used for ST-Ericsson M7400.
> 
> These data structures are shared between the Linux host and the
> M7400 modem.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> ---
>  include/linux/xshm/xshm_ipctoc.h |  160 ++++++++++++++++++++++++++++++++++++++
>  1 files changed, 160 insertions(+), 0 deletions(-)
>  create mode 100644 include/linux/xshm/xshm_ipctoc.h

Generally, the include/linux path is for interfaces between modules, while
hardware data structures should be in the same directory as the driver using
them to provide an abstract interface.

> diff --git a/include/linux/xshm/xshm_ipctoc.h b/include/linux/xshm/xshm_ipctoc.h
> new file mode 100644
> index 0000000..b008c23
> --- /dev/null
> +++ b/include/linux/xshm/xshm_ipctoc.h
> @@ -0,0 +1,160 @@
> +/*
> + * Copyright (C) ST-Ericsson AB 2011
> + * Author: Sjur Brendeland / sjur.brandeland@stericsson.com
> + * License terms: GNU General Public License (GPL) version 2
> + */
> +
> +#ifndef XSHM_TOC
> +#define XSHM_TOC
> +
> +/**
> + * DOC: XSHM Shared Memory Layout
> + *
> + * XSHM defines a set of structures describing the memory layout used
> + * for the Shared Memory IPC. In short &toc_entry points out &ipc_toc,
> + * which points out the &xshm_ipctoc_channel. &xshm_ipctoc_channel defines
> + * the channels used to communicate between host and external device (modem).
> + *
> + *  &xshm_ipctoc_channel can be used in packet-mode or stream-mode,
> + *  and points out &xshm_bufidx holding information about cirular
> + *  buffers, andtheir read/write indices etc.
> + */
> +
> +#pragma pack(1)

Better remove the #pragma. Marking data structures as packed when they
are already packed to start with only leads to worse optimizations in the
compiler, but does not have a functional impact.

	Arnd

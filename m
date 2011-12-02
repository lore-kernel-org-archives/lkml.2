Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab1LBLuO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 06:50:14 -0500
Received: from smtp-out0.tiscali.nl ([195.241.79.175]:53491 "EHLO
	smtp-out0.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754298Ab1LBLuM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 06:50:12 -0500
Message-ID: <1322826606.2313.14.camel@x61.thuisdomein>
Subject: Re: [RFCv2 9/9] caif-xshm: Add CAIF driver for Shared memory for
 M7400
From: Paul Bolle <pebolle@tiscali.nl>
To: Sjur =?ISO-8859-1?Q?Br=E6ndeland?= 
	<sjur.brandeland@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        sjurbren@gmail.com, netdev@vger.kernel.org
Date: Fri, 02 Dec 2011 12:50:06 +0100
In-Reply-To: <1322595550-6473-10-git-send-email-sjur.brandeland@stericsson.com>
References: <1322595550-6473-1-git-send-email-sjur.brandeland@stericsson.com>
	 <1322595550-6473-10-git-send-email-sjur.brandeland@stericsson.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2 (3.2.2-1.fc16) 
Content-Transfer-Encoding: 8BIT
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A few minor comments follow. They're basically identical to some of my
comments on v1 of 8/9 ("xshm: Makefile and Kconfig for M7400 Shared
Memory Drivers"). I guess I just didn't spot these the first time.

On Tue, 2011-11-29 at 20:39 +0100, Sjur Brændeland wrote:
> This patch introduces a caif shared memory link layer driver
> for ST-Ericsson's Thor M7400 LTE modem.
> 
> M7400 uses a ring-buffer in shared memory for transporting data from the modem.
> Each ring-buffer element contains an array of caif frames. caif_xshm calls
> napi_schedule() when receiving notification about incoming data.
> The napi-poll function copies data from the ring-buffer to SKBs until
> ring-buffer is empty, or quota is exceeded.
> 
> If transmit ring-buffer is full, it also uses napi for scheduling transmission
> of queued transmit buffer.
> 
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: netdev@vger.kernel.org
> ---
>  drivers/net/caif/Kconfig     |   10 +
>  drivers/net/caif/Makefile    |    1 +
>  drivers/net/caif/caif_xshm.c |  935 ++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 946 insertions(+), 0 deletions(-)
>  create mode 100644 drivers/net/caif/caif_xshm.c
> 
> diff --git a/drivers/net/caif/Kconfig b/drivers/net/caif/Kconfig
> index abf4d7a..2861374 100644
> --- a/drivers/net/caif/Kconfig
> +++ b/drivers/net/caif/Kconfig
> @@ -47,3 +47,13 @@ config CAIF_HSI
>         The caif low level driver for CAIF over HSI.
>         Be aware that if you enable this then you also need to
>         enable a low-level HSI driver.
> +
> +config CAIF_XSHM
> +	tristate "CAIF external memory protocol driver"
> +	depends on XSHM && CAIF
> +	default n
> +	---help---
> +	Say "yes" if you want to support CAIF over External Shared Memory (XSHM)

"Say Y"?

> +	IPC mechanism (e.g. over Chip to Chip).
> +	This will normally be built-in, loadable module is used for testing.

Perhaps something like: "Only say M here if you want to test CAIF over
XSHM and need to load and unload its module."?

> +	If unsure say N.
[...]


Paul Bolle


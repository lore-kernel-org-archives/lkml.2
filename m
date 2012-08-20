Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab2HTRAi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 13:00:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50176 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2HTRAg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 13:00:36 -0400
MIME-Version: 1.0
In-Reply-To: <1345459282-8666-1-git-send-email-makienko@ispras.ru>
References: <1345459282-8666-1-git-send-email-makienko@ispras.ru>
Date: Mon, 20 Aug 2012 21:00:35 +0400
Message-ID: <CAMo8Bf+cWRBW7ucJiqdcA0bp1Wd01_X6baGaNrG640-WmP_wFw@mail.gmail.com>
Subject: Re: [PATCH] staging: octeon: Add prevent NAPI from scheduling
From: Max Filippov <jcmvbkbc@gmail.com>
To: Marina Makienko <makienko@ispras.ru>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Daney <david.daney@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Roy.Li" <rongqing.li@windriver.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 2:41 PM, Marina Makienko <makienko@ispras.ru> wrote:
> Code inspection shows that this can
> only be triggered by calling napi_enable() without
> napi_disable().
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Marina Makienko <makienko@ispras.ru>
> ---
>  drivers/staging/octeon/ethernet-rx.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 34afc16..db81613 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -560,4 +560,5 @@ void cvm_oct_rx_shutdown(void)
>         /* Shutdown all of the NAPIs */
>         for_each_possible_cpu(i)
>                 netif_napi_del(&cvm_oct_napi[i].napi);
> +               napi_disable(&cvm_oct_napi[i].napi);
>  }

Looks like napi_disable is meant to be inside for_each_possible_cpu loop,
but curly braces are missing.

-- 
Thanks.
-- Max

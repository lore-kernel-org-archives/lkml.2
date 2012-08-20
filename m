Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932102Ab2HTQac (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 12:30:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:39361 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754672Ab2HTQ0m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 12:26:42 -0400
Message-ID: <5032653A.9090403@gmail.com>
Date: Mon, 20 Aug 2012 09:26:34 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Marina Makienko <makienko@ispras.ru>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Daney <david.daney@cavium.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        "Roy.Li" <rongqing.li@windriver.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, ldv-project@ispras.ru
Subject: Re: [PATCH] staging: octeon: Add prevent NAPI from scheduling
References: <1345459282-8666-1-git-send-email-makienko@ispras.ru>
In-Reply-To: <1345459282-8666-1-git-send-email-makienko@ispras.ru>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/20/2012 03:41 AM, Marina Makienko wrote:
> Code inspection shows that this can
> only be triggered by calling napi_enable() without
> napi_disable().
>
> Found by Linux Driver Verification project (linuxtesting.org).
>
> Signed-off-by: Marina Makienko <makienko@ispras.ru>
> ---
>   drivers/staging/octeon/ethernet-rx.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/staging/octeon/ethernet-rx.c b/drivers/staging/octeon/ethernet-rx.c
> index 34afc16..db81613 100644
> --- a/drivers/staging/octeon/ethernet-rx.c
> +++ b/drivers/staging/octeon/ethernet-rx.c
> @@ -560,4 +560,5 @@ void cvm_oct_rx_shutdown(void)
>   	/* Shutdown all of the NAPIs */
>   	for_each_possible_cpu(i)
>   		netif_napi_del(&cvm_oct_napi[i].napi);
> +		napi_disable(&cvm_oct_napi[i].napi);


Does the order of netif_napi_del() and napi_disable() matter?  If so, 
does this patch have the correct ordering?

I don't really want to apply the patch until we know the answer to these 
two questions.

David Daney



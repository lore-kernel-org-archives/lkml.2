Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753462Ab0KCWmZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 18:42:25 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:42247 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753311Ab0KCWmY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 18:42:24 -0400
MIME-Version: 1.0
In-Reply-To: <1288822281.2718.30.camel@edumazet-laptop>
References: <AANLkTi=mEzCMCC+K6oLOjW9xfws_+_hHq8DS3hpPB1zY@mail.gmail.com> <1288822281.2718.30.camel@edumazet-laptop>
From: Tom Gundersen <teg@jklm.no>
Date: Wed, 3 Nov 2010 23:42:02 +0100
Message-ID: <AANLkTimY+cC=bu6LDb_e-Qbghd-F0RNZejhKaeXJWbY7@mail.gmail.com>
Subject: Re: panic with 2.6.37-rc1
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 3, 2010 at 11:11 PM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le mercredi 03 novembre 2010 à 23:02 +0100, Tom Gundersen a écrit :
>> I get panic during boot both with 2.6.37-rc1 and with current head.
>>
>> Here is the error message:
>> <http://www.lix.polytechnique.fr/~tom/2.6.37-rc1-panic.jpg>. My
>> .config is below.
>>
>> Let me know if you want more info. If you want I can test patches or
>> bisect (if no one has any better suggestions).
>>
>
> Please test following patch, thanks
>
> [PATCH] atl1 : fix panic on load
>
> Its now illegal to call netif_stop_queue() before register_netdev()
>
> Reported-by: Tom Gundersen <teg@jklm.no>
> Signed-off-by: Eric Dumazet <eric.dumazet@gmail.com>
> ---
>  drivers/net/atlx/atl1.c |    1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/drivers/net/atlx/atl1.c b/drivers/net/atlx/atl1.c
> index 43579b3..5336310 100644
> --- a/drivers/net/atlx/atl1.c
> +++ b/drivers/net/atlx/atl1.c
> @@ -3043,7 +3043,6 @@ static int __devinit atl1_probe(struct pci_dev *pdev,
>        atl1_pcie_patch(adapter);
>        /* assume we have no link for now */
>        netif_carrier_off(netdev);
> -       netif_stop_queue(netdev);
>
>        setup_timer(&adapter->phy_config_timer, atl1_phy_config,
>                    (unsigned long)adapter);
>
>

The patch solves the problem. Thanks!

Tom

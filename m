Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752323Ab1ANVBk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 16:01:40 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:39325 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751519Ab1ANVBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 16:01:37 -0500
MIME-Version: 1.0
In-Reply-To: <20110114.124116.197952526.davem@davemloft.net>
References: <AANLkTin61iqrD0Jbax+cvQ1wxD8b=c4KJv7pBSvU7kbv@mail.gmail.com> <20110114.124116.197952526.davem@davemloft.net>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 14 Jan 2011 14:01:17 -0700
X-Google-Sender-Auth: TZC1Zfje5fCOkF1jJLXGxxKYqlY
Message-ID: <AANLkTi=dzWv5DLs8iMm4K8pdneo9aex68wzvwuhSHcG=@mail.gmail.com>
Subject: Re: Kernel 2.6.37-git10 build failure: cassini.c
To: David Miller <davem@davemloft.net>
Cc: anca.emanuel@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, joe@perches.com,
        siccegge@cs.fau.de, jpirko@redhat.com
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/1/14 David Miller <davem@davemloft.net>:
> From: Anca Emanuel <anca.emanuel@gmail.com>
> Date: Fri, 14 Jan 2011 10:09:43 +0200
>
>> drivers/net/cassini.c: In function ‘cas_get_vpd_info’:
>> drivers/net/cassini.c:3358: error: implicit declaration of function
>> ‘of_get_property’
>> drivers/net/cassini.c:3358: warning: assignment makes pointer from
>> integer without a cast
>> drivers/net/cassini.c: In function ‘cas_init_one’:
>> drivers/net/cassini.c:5035: error: implicit declaration of function
>> ‘pci_device_to_OF_node’
>> drivers/net/cassini.c:5035: warning: assignment makes pointer from
>> integer without a cast
>> make[3]: *** [drivers/net/cassini.o] Error 1
>> make[2]: *** [drivers/net] Error 2
>
> This is the fix I'll be using:
>
> --------------------
> cassini: Fix build bustage on x86.
>
> Unfortunately, not all CONFIG_OF platforms provide
> pci_device_to_OF_node().
>
> Change the test to CONFIG_SPARC for now to deal with
> the build regressions.
>
> Signed-off-by: David S. Miller <davem@davemloft.net>

Acked-by: Grant Likely <grant.likely@secretlab.ca>

pci_device_to_OF_node() will probably become available for all
CONFIG_OF users in 2.6.39.  In the meantime, I agree with this
solution.

g.

> ---
>  drivers/net/cassini.c |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/cassini.c b/drivers/net/cassini.c
> index 7206ab2..3437613 100644
> --- a/drivers/net/cassini.c
> +++ b/drivers/net/cassini.c
> @@ -3203,7 +3203,7 @@ static int cas_get_vpd_info(struct cas *cp, unsigned char *dev_addr,
>        int phy_type = CAS_PHY_MII_MDIO0; /* default phy type */
>        int mac_off  = 0;
>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_SPARC)
>        const unsigned char *addr;
>  #endif
>
> @@ -3354,7 +3354,7 @@ use_random_mac_addr:
>        if (found & VPD_FOUND_MAC)
>                goto done;
>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_SPARC)
>        addr = of_get_property(cp->of_node, "local-mac-address", NULL);
>        if (addr != NULL) {
>                memcpy(dev_addr, addr, 6);
> @@ -5031,7 +5031,7 @@ static int __devinit cas_init_one(struct pci_dev *pdev,
>        cp->msg_enable = (cassini_debug < 0) ? CAS_DEF_MSG_ENABLE :
>          cassini_debug;
>
> -#if defined(CONFIG_OF)
> +#if defined(CONFIG_SPARC)
>        cp->of_node = pci_device_to_OF_node(pdev);
>  #endif
>
> --
> 1.7.3.4
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.

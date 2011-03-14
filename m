Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753138Ab1CNIic (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 04:38:32 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64505 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab1CNIia convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 04:38:30 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=QkuNFAcdPbhFD/i4Uohyzsl6v9qsq8X8MK3Nwuz6eveOoaMWURoNwZP1zGG/zJANdK
         SLWoAS03XoqF3BUyc/UTT3kPca3Hhn47Xf5e5ydu945H+eBNOes5yHMnfpRcXmpfqjgf
         JCw4Js9oxcCNdq5pgxPRnLI8yL/5JRxtW//kI=
MIME-Version: 1.0
In-Reply-To: <1300047388.2761.48.camel@edumazet-laptop>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com> <1300047388.2761.48.camel@edumazet-laptop>
From: Po-Yu Chuang <ratbert.chuang@gmail.com>
Date: Mon, 14 Mar 2011 16:38:08 +0800
Message-ID: <AANLkTi==o78Xq3CxSNpycdPeUUcX6+LYQa=HPqthgbgD@mail.gmail.com>
Subject: Re: [PATCH] net: add Faraday FTGMAC100 Gigabit Ethernet driver
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Eric,

On Mon, Mar 14, 2011 at 4:16 AM, Eric Dumazet <eric.dumazet@gmail.com> wrote:
> Le jeudi 10 mars 2011 à 16:08 +0800, Po-Yu Chuang a écrit :
>> From: Po-Yu Chuang <ratbert@faraday-tech.com>
>>
>> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
>> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
>> including Faraday A369 and Andes AG102.
>
> Hi
>
> It seems very close from drivers/net/ftmac100.c one. Are you sure a
> factorization is not possible ?

First, the registers and descriptors of FTGMAC100 are not backward
compatible to FTMAC100.

Second, FTGMAC100 HW has some features new to FTMAC100
(jumbo packet, checksum offload... etc.) and not all of them are supported
in the current version. For example, NETIF_F_SG support might be the next
step to improve.

IMHO, it will be easier for me to maintain them and to add new features to
FTGMAC100 driver if we separate these two drivers. How do you think?

> BTW, it seems I missed the fact that ftmac100_alloc_rx_page() used a
> GFP_KERNEL allocation, while its called from softirq context (from
> ftmac100_rx_packet())

Tested. Thank you.

> Same problem of course in this Gigabit driver.

Will fix it.

Best regards,
Po-Yu Chuang

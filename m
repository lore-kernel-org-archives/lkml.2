Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756372Ab1CMUQh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Mar 2011 16:16:37 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50770 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755181Ab1CMUQf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Mar 2011 16:16:35 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=foMKaHQzxfoBEibJPA/T07X5q/02F0yGIz1YWknrgjOGM5dim1gxYyJbQCoQyG5Bap
         yHPxRoOVfJf10XF/m50AkA403/sCCMLqY+S/NLXORKL382R87zY6WpJJVShvrMQrS693
         ZRfLSJzGzFmmus1hkmxVaYFm5no0FXOg9ObaQ=
Subject: Re: [PATCH] net: add Faraday FTGMAC100 Gigabit Ethernet driver
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Po-Yu Chuang <ratbert.chuang@gmail.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Po-Yu Chuang <ratbert@faraday-tech.com>
In-Reply-To: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
References: <1299744517-1896-1-git-send-email-ratbert.chuang@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 13 Mar 2011 21:16:28 +0100
Message-ID: <1300047388.2761.48.camel@edumazet-laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le jeudi 10 mars 2011 à 16:08 +0800, Po-Yu Chuang a écrit :
> From: Po-Yu Chuang <ratbert@faraday-tech.com>
> 
> FTGMAC100 Ethernet Media Access Controller supports 10/100/1000 Mbps
> and MII/GMII.  This driver has been working on some ARM/NDS32 SoC's
> including Faraday A369 and Andes AG102.
> 

Hi

It seems very close from drivers/net/ftmac100.c one. Are you sure a
factorization is not possible ?

BTW, it seems I missed the fact that ftmac100_alloc_rx_page() used a
GFP_KERNEL allocation, while its called from softirq context (from
ftmac100_rx_packet()) 


Same problem of course in this Gigabit driver.




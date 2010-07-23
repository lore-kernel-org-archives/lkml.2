Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab0GWIEi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jul 2010 04:04:38 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:65443 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751624Ab0GWIEd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jul 2010 04:04:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Hpv+dQrO9bzNphHvfuehceOY1WqK3emL+fuwLrAvOtfPfpl+GmWsvERI/rXL1wGvIL
         tpIIAyxFDxHMiaNulwYfvEua1y7XmKGB9zw8n3e+m7RMyQI65Hk8RHsKKtzJuqdmZqzO
         MNrS7VPCv49qUFFpqaIfSwzMr8ohRv5+QKRHE=
MIME-Version: 1.0
In-Reply-To: <4C3D5F3F.7070901@odi.ch>
References: <4C3D5F3F.7070901@odi.ch>
Date: Fri, 23 Jul 2010 16:04:32 +0800
Message-ID: <AANLkTimn7Z3LqhLOt4_6ggFgjdzIZQPd_CznOIW-6D1N@mail.gmail.com>
Subject: Re: BUG at arch/x86/mm/physaddr.c:5
From: Jike Song <albcamus@gmail.com>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/14 Ortwin Glück <odi@odi.ch>:
> There is also a DMA warning later on.
>

Seems to be a logical error?  Does the following patch remove your Oops?


diff --git a/drivers/net/wireless/ath/ath9k/recv.c
b/drivers/net/wireless/ath/ath9k/recv.c
index ca6065b..e3e5291 100644
--- a/drivers/net/wireless/ath/ath9k/recv.c
+++ b/drivers/net/wireless/ath/ath9k/recv.c
@@ -844,9 +844,9 @@ int ath_rx_tasklet(struct ath_softc *sc, int flush, bool hp)
 	int dma_type;

 	if (edma)
-		dma_type = DMA_FROM_DEVICE;
-	else
 		dma_type = DMA_BIDIRECTIONAL;
+	else
+		dma_type = DMA_FROM_DEVICE;

 	qtype = hp ? ATH9K_RX_QUEUE_HP : ATH9K_RX_QUEUE_LP;
 	spin_lock_bh(&sc->rx.rxbuflock);

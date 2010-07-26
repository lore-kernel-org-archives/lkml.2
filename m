Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753385Ab0GZGNt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jul 2010 02:13:49 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54530 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753175Ab0GZGNs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jul 2010 02:13:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=M25lPEyxjqg+fcdlgYejYN7p70hA1szYKzaxc2jLcMdDc+C5PJjwyANk0r2R5xmy9t
         mvn6mwevbg9TOD31cmfsm4dCp54Fe2EDb0fbjF+FjYDs/RyPM04j+wdaZJARNs4goYUi
         c6t16TRhc7jVNtsCSHDAwenb3Uy48tLuWfMhU=
MIME-Version: 1.0
In-Reply-To: <4C499E6F.8030507@odi.ch>
References: <4C3D5F3F.7070901@odi.ch>
	<AANLkTimn7Z3LqhLOt4_6ggFgjdzIZQPd_CznOIW-6D1N@mail.gmail.com>
	<4C499E6F.8030507@odi.ch>
Date: Mon, 26 Jul 2010 14:13:47 +0800
Message-ID: <AANLkTikrmM0pwBLLMWTCO-stRnoCxwQf0M3ZByc7=8_b@mail.gmail.com>
Subject: Re: BUG at arch/x86/mm/physaddr.c:5
From: Jike Song <albcamus@gmail.com>
To: =?UTF-8?Q?Ortwin_Gl=C3=BCck?= <odi@odi.ch>
Cc: linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>,
        Vasanthakumar Thiagarajan <vasanth@atheros.com>,
        lrodriguez@atheros.com, jmalinen@atheros.com,
        Sujith.Manoharan@atheros.com, senthilkumar@atheros.com,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/7/23 Ortwin Glück <odi@odi.ch>:
> On 23.07.2010 10:04, Jike Song wrote:
>> Seems to be a logical error?  Does the following patch remove your Oops?
>
> Looking at the init code I agree. Yes, the patch fixes the OOPS. I am sure
> because the OOPS occurred at every boot and now it's gone.
>
> Thanks!
>
> Ortwin

Hi Maintainers,

 Since Ortwin has confirmed this patch , would you give me an ACK/NAK please?


-- 
Thanks,
Jike


>From 1414829dcc5b53ef4802f5de2b9be58e2ca0fb23 Mon Sep 17 00:00:00 2001
From: Jike Song <albcamus@gmail.com>
Date: Mon, 26 Jul 2010 13:42:41 +0800
Subject: [PATCH] ath9k: fix wrong DMA direction in RX tasklet
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit

Commit b5c80475abaad015699384ca64ef8229fdd88758 introduced edma
support for RX, hence bidirectional DMA support. But it
specified the DMA type as DMA_FROM_DEVICE by mistake.

Reported-and-tested-by: Ortwin Glück <odi@odi.ch>
Signed-off-by: Jike Song <albcamus@gmail.com>
---
 drivers/net/wireless/ath/ath9k/recv.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

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
-- 
1.6.2

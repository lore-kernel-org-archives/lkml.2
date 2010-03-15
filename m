Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936372Ab0CONzr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 09:55:47 -0400
Received: from ey-out-2122.google.com ([74.125.78.24]:48263 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936249Ab0CONzq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 09:55:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=bmX4p+NQfYPhsMR/RWK4VPmpDruFJNdhVUC3J1Now0JKvSSb+j8ftl+KGO6rmvskNx
         zwzDqBNGrWgh4F5C7beANZRIrKPdUEW+lzdTf7Ei8fXaXqN44jsLy910JJrU/9OuLhrS
         0MhNQ9MoR9dVU/+BT7lTtZs0mpD3wKin+SouE=
Message-ID: <4B9E3CBC.8020106@gmail.com>
Date: Mon, 15 Mar 2010 14:57:16 +0100
From: Roel Kluin <roel.kluin@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: =?ISO-8859-1?Q?Richard_R=F6jfors?= <richard.rojfors@pelagicore.com>
CC: linux-serial@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Alan Cox <alan@lxorguk.ukuu.org.uk>
Subject: Re: [PATCH] serial: Two branches the same in timbuart_set_mctrl()
References: <4B532CF5.7080000@gmail.com> <20100117181702.026269e9@lxorguk.ukuu.org.uk> <4B535ED8.2050703@gmail.com> <4B9E0160.5000900@pelagicore.com> <4B9E3747.9060400@gmail.com> <4B9E391A.5050808@pelagicore.com>
In-Reply-To: <4B9E391A.5050808@pelagicore.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

CTS is a read only bit and we are to stop signal RTS if modem line
TIOCM_RTS is not set.

Thanks for suggestions by Richard Röjfors.

Acked-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
---
diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 7bf1026..823b9c5 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -219,7 +219,7 @@ static void timbuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	if (mctrl & TIOCM_RTS)
 		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
 	else
-		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
+		iowrite8(0, port->membase + TIMBUART_CTRL);
 }
 
 static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier)

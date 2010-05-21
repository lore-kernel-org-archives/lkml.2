Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934203Ab0EUQyE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 12:54:04 -0400
Received: from kroah.org ([198.145.64.141]:50335 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934121Ab0EUQwL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 12:52:11 -0400
From: Greg Kroah-Hartman <gregkh@suse.de>
To: linux-kernel@vger.kernel.org
Cc: Roel Kluin <roel.kluin@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
       Andrew Morton <akpm@linux-foundation.org>,
       Greg Kroah-Hartman <gregkh@suse.de>
Subject: [PATCH 18/25] serial: two branches the same in timbuart_set_mctrl()
Date: Fri, 21 May 2010 09:51:47 -0700
Message-Id: <1274460714-11277-18-git-send-email-gregkh@suse.de>
X-Mailer: git-send-email 1.7.0.3
In-Reply-To: <20100521165113.GB11216@kroah.com>
References: <20100521165113.GB11216@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roel Kluin <roel.kluin@gmail.com>

CTS is a read only bit and we are to stop signal RTS if modem line
TIOCM_RTS is not set.

Thanks for suggestions by Richard Röjfors.

Signed-off-by: Roel Kluin <roel.kluin@gmail.com>
Acked-by: Richard Röjfors <richard.rojfors@pelagicore.com>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@suse.de>
---
 drivers/serial/timbuart.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/serial/timbuart.c b/drivers/serial/timbuart.c
index 786ba85..62f389f 100644
--- a/drivers/serial/timbuart.c
+++ b/drivers/serial/timbuart.c
@@ -220,7 +220,7 @@ static void timbuart_set_mctrl(struct uart_port *port, unsigned int mctrl)
 	if (mctrl & TIOCM_RTS)
 		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
 	else
-		iowrite8(TIMBUART_CTRL_RTS, port->membase + TIMBUART_CTRL);
+		iowrite8(0, port->membase + TIMBUART_CTRL);
 }
 
 static void timbuart_mctrl_check(struct uart_port *port, u32 isr, u32 *ier)
-- 
1.7.0.3


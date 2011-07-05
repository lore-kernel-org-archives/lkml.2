Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752804Ab1GETHy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:07:54 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:55278 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751794Ab1GETHx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:07:53 -0400
Date: Tue, 5 Jul 2011 20:53:47 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 1/6] r8169: adjust some registers
Message-ID: <20110705185347.GA5105@electric-eye.fr.zoreil.com>
References: <1309859095-32031-1-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309859095-32031-1-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
> Define new registers and modify some existing ones.
> 
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/r8169.c |   30 +++++++++++++++++++++++-------
>  1 files changed, 23 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/r8169.c b/drivers/net/r8169.c
> index fbd6838..701ab6b 100644
> --- a/drivers/net/r8169.c
> +++ b/drivers/net/r8169.c
> @@ -327,7 +327,7 @@ enum rtl8168_8101_registers {
>  #define	EPHYAR_REG_SHIFT		16
>  #define	EPHYAR_DATA_MASK		0xffff
>  	DLLPR			= 0xd0,
> -#define	PM_SWITCH			(1 << 6)
> +#define	PFM_EN				(1 << 6)
>  	DBG_REG			= 0xd1,
>  #define	FIX_NAK_1			(1 << 4)
>  #define	FIX_NAK_2			(1 << 3)
> @@ -335,6 +335,7 @@ enum rtl8168_8101_registers {
>  	MCU			= 0xd3,
>  #define	EN_NDP				(1 << 3)
>  #define	EN_OOB_RESET			(1 << 2)
> +#define NOW_IS_OOB			(1 << 7)
         ^^^ there should be a tab, not a space.

Nit : 3, 2, 7 is a bit surprizing. 7, 3, 2 ?

@@ -345,18 +346,31 @@ enum rtl8168_8101_registers {
 };
 
 enum rtl8168_registers {
+	LED_FREQ		= 0x1a,
+	EEE_LED			= 0x1b,
+
+	/* TxConfig */
+#define AUTO_FIFO			(1 << 7)
+#define TX_EMPTY			(1 << 11)

Eventually move these close to the existing TxConfig register as :

+#define TXCFG_AUTO_FIFO		(1 <<  7) /* 8168e (?) */
+#define TXCFG_EMPTY			(1 << 11) /* 8168e (?) */

-- 
Ueimor

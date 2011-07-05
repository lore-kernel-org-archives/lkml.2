Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633Ab1GETJt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 15:09:49 -0400
Received: from violet.fr.zoreil.com ([92.243.8.30]:55288 "EHLO
	violet.fr.zoreil.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753580Ab1GETJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 15:09:48 -0400
Date: Tue, 5 Jul 2011 20:55:45 +0200
From: Francois Romieu <romieu@fr.zoreil.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] r8169: add ERI functions
Message-ID: <20110705185545.GD5105@electric-eye.fr.zoreil.com>
References: <1309859095-32031-1-git-send-email-hayeswang@realtek.com> <1309859095-32031-4-git-send-email-hayeswang@realtek.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309859095-32031-4-git-send-email-hayeswang@realtek.com>
User-Agent: Mutt/1.4.2.2i
X-Organisation: Land of Sunshine Inc.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hayes Wang <hayeswang@realtek.com> :
[...]
> @@ -1046,6 +1046,49 @@ static u32 rtl_csi_read(void __iomem *ioaddr, int addr)
>  	return value;
>  }
>  
> +static
> +void rtl_eri_write(void __iomem *ioaddr, int addr, u32 mask, u32 val, int type)
> +{
> +	unsigned int i;
> +
> +	BUG_ON((addr & 3) || (mask == 0));
> +	RTL_W32(ERIDR, val);
> +	RTL_W32(ERIAR, ERIAR_WRITE_CMD | type | mask | addr);
> +
> +	for (i = 0; i < 100; i++) {
> +		udelay(100);
> +		if (!(RTL_R32(ERIAR) & ERIAR_FLAG))
> +			break;

I'd rather reverse those if possible : implicit posted write flushing read,
then udelay.

-- 
Ueimor

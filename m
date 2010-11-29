Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753960Ab0K2M46 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Nov 2010 07:56:58 -0500
Received: from mail.sysgo.com ([195.145.229.155]:42793 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753752Ab0K2M44 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Nov 2010 07:56:56 -0500
Date: Mon, 29 Nov 2010 13:57:05 +0100
From: Pavel Machek <pma@sysgo.com>
To: Sujith <m.sujith@gmail.com>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        "ath9k-devel@venema.h4ckr.net" <ath9k-devel@venema.h4ckr.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        "chunkeey@googlemail.com" <chunkeey@googlemail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "rudolf.marek@sysgo.com" <rudolf.marek@sysgo.com>,
        "cko@sysgo.com" <cko@sysgo.com>, "mfa@sysgo.com" <mfa@sysgo.com>,
        "anl@sysgo.com" <anl@sysgo.com>
Subject: Re: ath9k_htc vs. powerpc (was Re: working usb wifi card, that is
 still possible to buy)
Message-ID: <20101129125705.GB31518@pma.sysgo.com>
References: <20101124081616.GA30595@pma.sysgo.com>
 <20101124131320.GA2611@pma.sysgo.com>
 <4CED33E0.5040000@lwfinger.net>
 <20101126083125.GA28982@pma.sysgo.com>
 <20101126102026.GA11857@pma.sysgo.com>
 <20101126112737.GB11857@pma.sysgo.com>
 <19695.40541.335361.81396@gargle.gargle.HOWL>
 <20101126123706.GA19755@pma.sysgo.com>
 <20101129100159.GC28833@pma.sysgo.com>
 <19699.40557.302196.832862@gargle.gargle.HOWL>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19699.40557.302196.832862@gargle.gargle.HOWL>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > ...so I indentified two endianness problems in eeprom, but even with
> > both fixed, it still will not associate. Is there some way to dump USB
> > packets, then compare them between PC and PowerPC versions? Should I
> > expect them to match?
> 
> Does this patch help ?

Actually I wonder...

> diff --git a/drivers/net/wireless/ath/ath9k/htc_drv_main.c b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> index e9761c2..1b435d4 100644
> --- a/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> +++ b/drivers/net/wireless/ath/ath9k/htc_drv_main.c
> @@ -204,7 +204,7 @@ static int ath9k_htc_add_station(struct ath9k_htc_priv *priv,
>  		ista = (struct ath9k_htc_sta *) sta->drv_priv;
>  		memcpy(&tsta.macaddr, sta->addr, ETH_ALEN);
>  		memcpy(&tsta.bssid, common->curbssid, ETH_ALEN);
> -		tsta.associd = common->curaid;
> +		tsta.associd = cpu_to_be16(common->curaid);
>  		tsta.is_vif_sta = 0;
>  		tsta.valid = true;
>  		ista->index = priv->nstations;

We know the code currently works on PC; but this adds conversions that
are nop on PowerPC and do something on PC... so they should have no
effect on PowerPC and could break PC...?
									Pavel

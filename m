Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222Ab1FVIkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 04:40:24 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53373 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754184Ab1FVIkV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 04:40:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=subject:from:to:cc:in-reply-to:references:content-type:date
         :message-id:mime-version:x-mailer:content-transfer-encoding;
        b=MTmwftLuWhuWp9Hz/CgXXnhr6FIbQDwzarURU8SF/3dpCODkWPUkbNRh9B+iC9bTIK
         WKcbxKIIFDaeVBRJmo8zFtXartXLgpheQAE4Ig3C3smsHPBCyXpz4++i9EUgo8lV28l6
         NoppagDD9FzRgMfbD7QmpwaswPrk38PZdMzyo=
Subject: Re: [PATCH 1/3] drivers:rtl8187se:remove the use of obsolete
 create_workqueue in ieee80211_softmac.c
From: Wanlong Gao <wanlong.gao@gmail.com>
To: Greg Kroah-Hartman <gregkh@suse.de>
Cc: Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Stefan Weil <weil@mail.berlios.de>,
        Xiaochen Wang <wangxiaochen0@gmail.com>,
        Ilia Mirkin <imirkin@alum.mit.edu>, Dan Carpenter <error27@gmail.com>,
        David Chosrova <dada2372@gmail.com>,
        Uwe =?ISO-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Ben Hutchings <ben@decadent.org.uk>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
References: <1308478318-8462-1-git-send-email-wanlong.gao@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 22 Jun 2011 16:40:01 +0800
Message-ID: <1308732001.2198.0.camel@Tux>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 日, 2011-06-19 at 18:11 +0800, Wanlong Gao wrote:
> Remove the use of obsolete create_workqueue(name, 0) in
> ieee80211_softmac.c, since the create_workqueue interface has changed.
> 
> Signed-off-by: Wanlong Gao <wanlong.gao@gmail.com>
> ---
>  .../rtl8187se/ieee80211/ieee80211_softmac.c        |    5 +----
>  1 files changed, 1 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> index 736a140..8925989 100644
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> @@ -2568,11 +2568,8 @@ void ieee80211_softmac_init(struct ieee80211_device *ieee)
>  	ieee->beacon_timer.data = (unsigned long) ieee;
>  	ieee->beacon_timer.function = ieee80211_send_beacon_cb;
>  
> -#ifdef PF_SYNCTHREAD
> -	ieee->wq = create_workqueue(DRV_NAME,0);
> -#else
>  	ieee->wq = create_workqueue(DRV_NAME);
> -#endif
> +
>  	INIT_DELAYED_WORK(&ieee->start_ibss_wq,(void*) ieee80211_start_ibss_wq);
>  	INIT_WORK(&ieee->associate_complete_wq,(void*) ieee80211_associate_complete_wq);
>  	INIT_WORK(&ieee->associate_procedure_wq,(void*) ieee80211_associate_procedure_wq);
Any comments?


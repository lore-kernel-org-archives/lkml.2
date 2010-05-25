Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755271Ab0EYMJW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 08:09:22 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6895 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754245Ab0EYMJU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 08:09:20 -0400
From: Andreas Schwab <schwab@redhat.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Jassi Brar <jassisinghbrar@gmail.com>, devel@driverdev.osuosl.org,
       Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: remove all code dependent on LINUX_VERSION_CODE
References: <alpine.LNX.2.00.1005251200410.28092@pobox.suse.cz>
	<AANLkTik-k5lECpQtbsQy8DLJJ3DOPrAz_e5XPPMzgr2o@mail.gmail.com>
	<alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz>
X-Yow: ..  I don't know why but, suddenly, I want to discuss declining I.Q.
 LEVELS with a blue ribbon SENATE SUB-COMMITTEE!
Date: Tue, 25 May 2010 14:09:12 +0200
In-Reply-To: <alpine.LNX.2.00.1005251355100.28092@pobox.suse.cz> (Jiri
	Kosina's message of "Tue, 25 May 2010 13:55:44 +0200 (CEST)")
Message-ID: <m3eih0dvyv.fsf@hase.home>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jiri Kosina <jkosina@suse.cz> writes:

> diff --git a/drivers/staging/cxt1e1/linux.c b/drivers/staging/cxt1e1/linux.c
> index 134e756..ace28c7 100644
> --- a/drivers/staging/cxt1e1/linux.c
> +++ b/drivers/staging/cxt1e1/linux.c

> @@ -1341,9 +1226,6 @@ module_exit (c4_mod_remove);
>  
>  #ifndef SBE_INCLUDE_SYMBOLS
>  #ifndef CONFIG_SBE_WANC24_NCOMM
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> -EXPORT_NO_SYMBOLS;
> -#endif
>  #endif
>  #endif

This is now empty.

> diff --git a/drivers/staging/cxt1e1/sbecom_inline_linux.h b/drivers/staging/cxt1e1/sbecom_inline_linux.h
> index c65172d..5a72cb5 100644
> --- a/drivers/staging/cxt1e1/sbecom_inline_linux.h
> +++ b/drivers/staging/cxt1e1/sbecom_inline_linux.h

> @@ -60,12 +57,8 @@
>  
>  #ifdef MODULE
>  #ifdef MODVERSIONS
> -#if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
> -#include <linux/modversions.h>
> -#else
>  #include <config/modversions.h>
>  #endif
> -#endif

This should be removed altogether.

> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211.h b/drivers/staging/rtl8192e/ieee80211/ieee80211.h
> index 50728f6..02594fd 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211.h
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211.h

> @@ -2329,36 +2246,20 @@ struct ieee80211_device {
>  
>  	/* used if IEEE_SOFTMAC_BEACONS is set */
>  	struct timer_list beacon_timer;
> -#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
>          struct work_struct associate_complete_wq;
>          struct work_struct associate_procedure_wq;
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
>          struct delayed_work softmac_scan_wq;
>          struct delayed_work associate_retry_wq;
>  	 struct delayed_work start_ibss_wq;
>  	 struct delayed_work hw_wakeup_wq;
>  	struct delayed_work hw_sleep_wq;
> -#else
>          struct work_struct softmac_scan_wq;
>          struct work_struct associate_retry_wq;
>  	struct work_struct start_ibss_wq;
>  	struct work_struct hw_wakeup_wq;
>  	struct work_struct hw_sleep_wq;
> -#endif

The #else branch needs to be fully removed.

> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
> index 46b6e8c..a60b001 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c

> @@ -704,16 +658,10 @@ void ieee80211_rtl_start_scan(struct ieee80211_device *ieee)
>  	if (ieee->softmac_features & IEEE_SOFTMAC_SCAN){
>  		if (ieee->scanning == 0){
>  			ieee->scanning = 1;
> -#if LINUX_VERSION_CODE > KERNEL_VERSION(2,5,0)
> -#if LINUX_VERSION_CODE >= KERNEL_VERSION(2,6,20)
>  			queue_delayed_work(ieee->wq, &ieee->softmac_scan_wq, 0);
> -#else
>  
>  			queue_work(ieee->wq, &ieee->softmac_scan_wq);
> -#endif
> -#else
>  			ieee80211_softmac_scan(ieee);
> -#endif

Likewise.

Andreas.

-- 
Andreas Schwab, schwab@redhat.com
GPG Key fingerprint = D4E8 DBE3 3813 BB5D FA84  5EC7 45C6 250E 6F00 984E
"And now for something completely different."

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753705Ab0EZVk3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 17:40:29 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:50457 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753076Ab0EZVk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 17:40:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:to:subject:date:user-agent:cc:references:in-reply-to
         :mime-version:content-type:content-transfer-encoding
         :content-disposition:message-id;
        b=nboFadlGAnV4TSreO+20mBg7HtBYiCoV0TfG2nBtHuncNsJRm6AHo+in1OQAMQvoJ+
         ryUGe+sb3vioH39///s1/ptBrZO/pxxd3DbpWycXuosv/89RJUAVLp9Ns4vlvC3hmZ65
         OU7DVZPtuWzrKheqdBD5MyFhVLSPSUF0Mma50=
From: "Sergey V." <sftp.mtuci@gmail.com>
To: Bashlykov Arthur <madness@xakep.ru>
Subject: Re: [PATCH] Staging: rtl8192su: ieee80211: fix brace coding style issue and other issues in ieee80211_softmac_wx.c Signed-off-by: Bashlykov Arthur <madness@xakep.ru>
Date: Thu, 27 May 2010 01:40:15 +0400
User-Agent: KMail/1.11.4 (Linux/2.6.32.12; KDE/4.2.4; x86_64; ; )
Cc: gregkh@suse.de, wfp5p@virginia.edu, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
References: <1274891337-7783-1-git-send-email-madness@xakep.ru>
In-Reply-To: <1274891337-7783-1-git-send-email-madness@xakep.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201005270140.16354.sftp.mtuci@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 26 May 2010 20:28:57  Bashlykov Arthur wrote:

Hi Arthur

> @@ -87,15 +87,15 @@ int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
>                            struct iw_request_info *a,
>                            union iwreq_data *wrqu, char *b)
>  {
> -     struct iw_freq *fwrq = & wrqu->freq;
> +     struct iw_freq *fwrq = &wrqu->freq;
>  
>       if (ieee->current_network.channel == 0)
>               return -1;
> -     //NM 0.7.0 will not accept channel any more.
> +     /* NM 0.7.0 will not accept channel any more. */
>       fwrq->m = ieee80211_wlan_frequencies[ieee->current_network.channel-1] * 100000;
>       fwrq->e = 1;
> -//   fwrq->m = ieee->current_network.channel;
> -//   fwrq->e = 0;
> +     /* fwrq->m = ieee->current_network.channel; */
> +     /* fwrq->e = 0; */
May be just remove dead code?

  
> @@ -230,13 +230,12 @@ int ieee80211_wx_get_rate(struct ieee80211_device *ieee,
>                            union iwreq_data *wrqu, char *extra)
>  {
>       u32 tmp_rate = 0;
> -     //printk("===>mode:%d, halfNmode:%d\n", ieee->mode, ieee->bHalfWirelessN24GMode);
> +     /* printk("===>mode:%d, halfNmode:%d\n", ieee->mode, ieee->bHalfWirelessN24GMode); */
Same


> @@ -529,33 +520,33 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
>  {
>       int ret = 0;
>  #if 1
> -     if(
> +     if {
>               (!ieee->sta_wake_up) ||
> -     //      (!ieee->ps_request_tx_ack) ||
> +     /*      (!ieee->ps_request_tx_ack) || */
Same
>               (!ieee->enter_sleep_state) ||
> -             (!ieee->ps_is_queue_empty)){
> +             (!ieee->ps_is_queue_empty)) {
>  
> -     //      printk("ERROR. PS mode is tryied to be use but driver missed a callback\n\n");
> +     /* printk("ERROR. PS mode is tryied to be use but driver missed a callback\n\n"); */
Same
>  
>               return -1;
>       }
>  #endif
>       down(&ieee->wx_sem);
>  
> -     if (wrqu->power.disabled){
> +     if (wrqu->power.disabled) {
>               ieee->ps = IEEE80211_PS_DISABLED;
>               goto exit;
>       }
>       if (wrqu->power.flags & IW_POWER_TIMEOUT) {
> -             //ieee->ps_period = wrqu->power.value / 1000;
> +             /*ieee->ps_period = wrqu->power.value / 1000; */
Same
>               ieee->ps_timeout = wrqu->power.value / 1000;
>       }
>  
>       if (wrqu->power.flags & IW_POWER_PERIOD) {
>  
> -             //ieee->ps_timeout = wrqu->power.value / 1000;
> +             /* ieee->ps_timeout = wrqu->power.value / 1000; */
Same
>               ieee->ps_period = wrqu->power.value / 1000;
> -             //wrq->value / 1024;
> +             /* wrq->value / 1024; */
Same
>  
>       }
>       switch (wrqu->power.flags & IW_POWER_MODE) {
> @@ -570,7 +561,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
>               break;
>  
>       case IW_POWER_ON:
> -     //      ieee->ps = IEEE80211_PS_DISABLED;
> +      /* ieee->ps = IEEE80211_PS_DISABLED; */
Same


> @@ -604,15 +595,15 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
>               wrqu->power.flags = IW_POWER_TIMEOUT;
>               wrqu->power.value = ieee->ps_timeout * 1000;
>       } else {
> -//           ret = -EOPNOTSUPP;
> -//           goto exit;
> +             /* ret = -EOPNOTSUPP; */
> +             /* goto exit; */
Same
>               wrqu->power.flags = IW_POWER_PERIOD;
>               wrqu->power.value = ieee->ps_period * 1000;
> -//ieee->current_network.dtim_period * ieee->current_network.beacon_interval * 1024;
> +/*ieee->current_network.dtim_period * ieee->current_network.beacon_interval * 1024; */
Same

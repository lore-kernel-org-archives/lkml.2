Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934209Ab0EZSqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 May 2010 14:46:17 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:60767 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932536Ab0EZSqP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 May 2010 14:46:15 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=W/XK2hA8bUNLS0zlqpbfgSKj2LFPmM4WNlDdigY+J8NvyTcZoQs8Kl2gOteEF4GMF/
         Ksr2f9+0tn5jzuCJhJUjo0qHw8oZH44sFKj8OQz3FiltEV74g+coy8uKRQBUNtEzDtQi
         txICetVZemSPvVxTMz6EUbLKn7DfH0fm43OXQ=
Date: Wed, 26 May 2010 22:48:08 +0400
From: Denis Kirjanov <kirjanov@gmail.com>
To: Bashlykov Arthur <madness@xakep.ru>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] Staging: rtl8192su: ieee80211: fix brace coding style
 issue and other issues in ieee80211_softmac_wx.c Signed-off-by: Bashlykov
 Arthur <madness@xakep.ru>
Message-ID: <20100526184808.GA6031@coldcone>
References: <1274891337-7783-1-git-send-email-madness@xakep.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=koi8-r
Content-Disposition: inline
In-Reply-To: <1274891337-7783-1-git-send-email-madness@xakep.ru>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 26, 2010 at 20:28 +0400, Bashlykov Arthur wrote:
> ---
>  .../rtl8192su/ieee80211/ieee80211_softmac_wx.c     |  149 +++++++++-----------
>  1 files changed, 70 insertions(+), 79 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
> index 9ded253..3e0527c 100644
> --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
> +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac_wx.c
> @@ -30,11 +30,11 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
>  			     union iwreq_data *wrqu, char *b)
>  {
>  	int ret;
> -	struct iw_freq *fwrq = & wrqu->freq;
> +	struct iw_freq *fwrq = &wrqu->freq;
>  
>  	down(&ieee->wx_sem);
>  
> -	if(ieee->iw_mode == IW_MODE_INFRA){
> +	if (ieee->iw_mode == IW_MODE_INFRA) {
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  	}
> @@ -55,11 +55,11 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
>  		}
>  	}
>  
> -	if (fwrq->e > 0 || fwrq->m > 14 || fwrq->m < 1 ){
> +	if (fwrq->e > 0 || fwrq->m > 14 || fwrq->m < 1) {
>  		ret = -EOPNOTSUPP;
>  		goto out;
>  
> -	}else { /* Set the channel */
> +	} else { /* Set the channel */
Could you please put comment before statements?
>  
>  		if (!(GET_DOT11D_INFO(ieee)->channel_map)[fwrq->m]) {
>  			ret = -EINVAL;
> @@ -68,8 +68,8 @@ int ieee80211_wx_set_freq(struct ieee80211_device *ieee, struct iw_request_info
>  		ieee->current_network.channel = fwrq->m;
>  		ieee->set_chan(ieee->dev, ieee->current_network.channel);
>  
> -		if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
> -			if(ieee->state == IEEE80211_LINKED){
> +		if (ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
> +			if (ieee->state == IEEE80211_LINKED) {
>  
>  			ieee80211_stop_send_beacons(ieee);
>  			ieee80211_start_send_beacons(ieee);
> @@ -87,15 +87,15 @@ int ieee80211_wx_get_freq(struct ieee80211_device *ieee,
>  			     struct iw_request_info *a,
>  			     union iwreq_data *wrqu, char *b)
>  {
> -	struct iw_freq *fwrq = & wrqu->freq;
> +	struct iw_freq *fwrq = &wrqu->freq;
>  
>  	if (ieee->current_network.channel == 0)
>  		return -1;
> -	//NM 0.7.0 will not accept channel any more.
> +	/* NM 0.7.0 will not accept channel any more. */
>  	fwrq->m = ieee80211_wlan_frequencies[ieee->current_network.channel-1] * 100000;
>  	fwrq->e = 1;
> -//	fwrq->m = ieee->current_network.channel;
> -//	fwrq->e = 0;
> +	/* fwrq->m = ieee->current_network.channel; */
> +	/* fwrq->e = 0; */
>  
>  	return 0;
>  }
> @@ -136,22 +136,22 @@ int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
>  {
>  
>  	int ret = 0;
> -	u8 zero[] = {0,0,0,0,0,0};
> +	u8 zero[] = {0, 0, 0, 0, 0, 0};
>  	unsigned long flags;
>  
> -	short ifup = ieee->proto_started;//dev->flags & IFF_UP;
> +	short ifup = ieee->proto_started; /* dev->flags & IFF_UP; */
>  	struct sockaddr *temp = (struct sockaddr *)awrq;
>  
>  	ieee->sync_scan_hurryup = 1;
>  
>  	down(&ieee->wx_sem);
>  	/* use ifconfig hw ether */
> -	if (ieee->iw_mode == IW_MODE_MASTER){
> +	if (ieee->iw_mode == IW_MODE_MASTER) {
>  		ret = -1;
>  		goto out;
>  	}
>  
> -	if (temp->sa_family != ARPHRD_ETHER){
> +	if (temp->sa_family != ARPHRD_ETHER) {
>  		ret = -EINVAL;
>  		goto out;
>  	}
> @@ -165,7 +165,7 @@ int ieee80211_wx_set_wap(struct ieee80211_device *ieee,
>  	spin_lock_irqsave(&ieee->lock, flags);
>  
>  	memcpy(ieee->current_network.bssid, temp->sa_data, ETH_ALEN);
> -	ieee->wap_set = memcmp(temp->sa_data, zero,ETH_ALEN)!=0;
> +	ieee->wap_set = memcmp(temp->sa_data, zero, ETH_ALEN) != 0;
>  
>  	spin_unlock_irqrestore(&ieee->lock, flags);
>  
> @@ -176,9 +176,9 @@ out:
>  	return ret;
>  }
>  
> - int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a,union iwreq_data *wrqu,char *b)
> + int ieee80211_wx_get_essid(struct ieee80211_device *ieee, struct iw_request_info *a, union iwreq_data *wrqu, char 
*b)
It probably would be better to break a long string into several.
>  {
> -	int len,ret = 0;
> +	int len, ret = 0;
>  	unsigned long flags;
>  
>  	if (ieee->iw_mode == IW_MODE_MONITOR)
> @@ -201,7 +201,7 @@ out:
>  	}
>  	len = ieee->current_network.ssid_len;
>  	wrqu->essid.length = len;
> -	strncpy(b,ieee->current_network.ssid,len);
> +	strncpy(b, ieee->current_network.ssid, len);
>  	wrqu->essid.flags = 1;
>  
>  out:
> @@ -219,7 +219,7 @@ int ieee80211_wx_set_rate(struct ieee80211_device *ieee,
>  	u32 target_rate = wrqu->bitrate.value;
>  
>  	ieee->rate = target_rate/100000;
> -	//FIXME: we might want to limit rate also in management protocols.
> +	/* FIXME: we might want to limit rate also in management protocols. */
>  	return 0;
>  }
>  
> @@ -230,13 +230,12 @@ int ieee80211_wx_get_rate(struct ieee80211_device *ieee,
>  			     union iwreq_data *wrqu, char *extra)
>  {
>  	u32 tmp_rate = 0;
> -	//printk("===>mode:%d, halfNmode:%d\n", ieee->mode, ieee->bHalfWirelessN24GMode);
> +	/* printk("===>mode:%d, halfNmode:%d\n", ieee->mode, ieee->bHalfWirelessN24GMode); */
>  	if (ieee->mode & (IEEE_A | IEEE_B | IEEE_G))
>  		tmp_rate = ieee->rate;
>  	else if (ieee->mode & IEEE_N_5G)
>  		tmp_rate = 580;
> -	else if (ieee->mode & IEEE_N_24G)
> -	{
> +	else if (ieee->mode & IEEE_N_24G) {
>  		if (ieee->GetHalfNmodeSupportByAPsHandler(ieee->dev))
>  			tmp_rate = HTHalfMcsToDataRate(ieee, 15);
>  		else
> @@ -254,8 +253,7 @@ int ieee80211_wx_set_rts(struct ieee80211_device *ieee,
>  {
>  	if (wrqu->rts.disabled || !wrqu->rts.fixed)
>  		ieee->rts = DEFAULT_RTS_THRESHOLD;
> -	else
> -	{
> +	else {
>  		if (wrqu->rts.value < MIN_RTS_THRESHOLD ||
>  				wrqu->rts.value > MAX_RTS_THRESHOLD)
>  			return -EINVAL;
> @@ -284,16 +282,14 @@ int ieee80211_wx_set_mode(struct ieee80211_device *ieee, struct iw_request_info
>  	if (wrqu->mode == ieee->iw_mode)
>  		goto out;
>  
> -	if (wrqu->mode == IW_MODE_MONITOR){
> -
> +	if (wrqu->mode == IW_MODE_MONITOR)
>  		ieee->dev->type = ARPHRD_IEEE80211;
> -	}else{
> +	} else {
>  		ieee->dev->type = ARPHRD_ETHER;
> -	}
>  
> -	if (!ieee->proto_started){
> +	if (!ieee->proto_started) {
>  		ieee->iw_mode = wrqu->mode;

I guess we can drop braces with single else statement
> -	}else{
> +	} else {
>  		ieee80211_stop_protocol(ieee);
>  		ieee->iw_mode = wrqu->mode;
>  		ieee80211_start_protocol(ieee);
> @@ -308,8 +304,8 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
>  {
>          struct ieee80211_device *ieee = container_of(work, struct ieee80211_device, wx_sync_scan_wq);
>  	short chan;
> -	HT_EXTCHNL_OFFSET chan_offset=0;
> -	HT_CHANNEL_WIDTH bandwidth=0;
> +	HT_EXTCHNL_OFFSET chan_offset = 0;
> +	HT_CHANNEL_WIDTH bandwidth = 0;
>  	int b40M = 0;
>  	static int count = 0;
>  	chan = ieee->current_network.channel;
> @@ -322,9 +318,8 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
>  
>  	ieee->state = IEEE80211_LINKED_SCANNING;
>  	ieee->link_change(ieee->dev);
> -	ieee->InitialGainHandler(ieee->dev,IG_Backup);
> -	if (ieee->SetFwCmdHandler)
> -	{
> +	ieee->InitialGainHandler(ieee->dev, IG_Backup);
> +	if (ieee->SetFwCmdHandler) {
>  		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_DIG_HALT);
>  		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_HIGH_PWR_DISABLE);
>  	}
> @@ -349,24 +344,22 @@ void ieee80211_wx_sync_scan_wq(struct work_struct *work)
>  		ieee->set_chan(ieee->dev, chan);
>  	}
>  
> -	ieee->InitialGainHandler(ieee->dev,IG_Restore);
> -	if (ieee->SetFwCmdHandler)
> -	{
> +	ieee->InitialGainHandler(ieee->dev, IG_Restore);
> +	if (ieee->SetFwCmdHandler) {
>  		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_DIG_RESUME);
>  		ieee->SetFwCmdHandler(ieee->dev, FW_CMD_HIGH_PWR_ENABLE);
>  	}
>  	ieee->state = IEEE80211_LINKED;
>  	ieee->link_change(ieee->dev);
> -	// To prevent the immediately calling watch_dog after scan.
> -	if(ieee->LinkDetectInfo.NumRecvBcnInPeriod==0||ieee->LinkDetectInfo.NumRecvDataInPeriod==0 )
> -	{
> +	/* To prevent the immediately calling watch_dog after scan. */
> +	if (ieee->LinkDetectInfo.NumRecvBcnInPeriod == 0 || ieee->LinkDetectInfo.NumRecvDataInPeriod == 0) {
I think that this line also is more than 80 characters long :)
>  		ieee->LinkDetectInfo.NumRecvBcnInPeriod = 1;
> -		ieee->LinkDetectInfo.NumRecvDataInPeriod= 1;
> +		ieee->LinkDetectInfo.NumRecvDataInPeriod = 1;
>  	}
>  	if (ieee->data_hard_resume)
>  		ieee->data_hard_resume(ieee->dev);
>  
> -	if(ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
> +	if (ieee->iw_mode == IW_MODE_ADHOC || ieee->iw_mode == IW_MODE_MASTER)
>  		ieee80211_start_send_beacons(ieee);
>  
>  	netif_carrier_on(ieee->dev);
> @@ -382,12 +375,12 @@ int ieee80211_wx_set_scan(struct ieee80211_device *ieee, struct iw_request_info
>  
>  	down(&ieee->wx_sem);
>  
> -	if (ieee->iw_mode == IW_MODE_MONITOR || !(ieee->proto_started)){
> +	if (ieee->iw_mode == IW_MODE_MONITOR || !(ieee->proto_started)) {
>  		ret = -1;
>  		goto out;
>  	}
>  
> -	if ( ieee->state == IEEE80211_LINKED){
> +	if (ieee->state == IEEE80211_LINKED) {
>  		queue_work(ieee->wq, &ieee->wx_sync_scan_wq);
>  		/* intentionally forget to up sem */
>  		return 0;
> @@ -403,7 +396,7 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
>  			      union iwreq_data *wrqu, char *extra)
>  {
>  
> -	int ret=0,len;
> +	int ret = 0, len;
>  	short proto_started;
>  	unsigned long flags;
>  
> @@ -412,17 +405,17 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
>  
>  	proto_started = ieee->proto_started;
>  
> -	if (wrqu->essid.length > IW_ESSID_MAX_SIZE){
> -		ret= -E2BIG;
> +	if (wrqu->essid.length > IW_ESSID_MAX_SIZE) {
> +		ret = -E2BIG;
>  		goto out;
>  	}
>  
> -	if (ieee->iw_mode == IW_MODE_MONITOR){
> -		ret= -1;
> +	if (ieee->iw_mode == IW_MODE_MONITOR) {
> +		ret = -1;
>  		goto out;
>  	}
>  
> -	if(proto_started)
> +	if (proto_started)
>  		ieee80211_stop_protocol(ieee);
>  
>  
> @@ -432,13 +425,12 @@ int ieee80211_wx_set_essid(struct ieee80211_device *ieee,
>  	spin_lock_irqsave(&ieee->lock, flags);
>  
>  	if (wrqu->essid.flags && wrqu->essid.length) {
> -		//first flush current network.ssid
> +		/* first flush current network.ssid */
>  		len = ((wrqu->essid.length-1) < IW_ESSID_MAX_SIZE) ? (wrqu->essid.length-1) : IW_ESSID_MAX_SIZE;
>  		strncpy(ieee->current_network.ssid, extra, len+1);
>  		ieee->current_network.ssid_len = len+1;
>  		ieee->ssid_set = 1;
> -	}
> -	else{
> +	} else {
>  		ieee->ssid_set = 0;
>  		ieee->current_network.ssid[0] = '\0';
>  		ieee->current_network.ssid_len = 0;
> @@ -471,7 +463,7 @@ out:
>  
>  	down(&ieee->wx_sem);
>  
> -	if(enable)
> +	if (enable)
>  		ieee->raw_tx = 1;
>  	else
>  		ieee->raw_tx = 0;
> @@ -479,16 +471,15 @@ out:
>  	printk(KERN_INFO"raw TX is %s\n",
>  	      ieee->raw_tx ? "enabled" : "disabled");
>  
> -	if(ieee->iw_mode == IW_MODE_MONITOR)
> -	{
> -		if(prev == 0 && ieee->raw_tx){
> +	if (ieee->iw_mode == IW_MODE_MONITOR) {
> +		if (prev == 0 && ieee->raw_tx) {
>  			if (ieee->data_hard_resume)
>  				ieee->data_hard_resume(ieee->dev);
>  
>  			netif_carrier_on(ieee->dev);
>  		}
>  
> -		if(prev && ieee->raw_tx == 1)
> +		if (prev && ieee->raw_tx == 1)
>  			netif_carrier_off(ieee->dev);
>  	}
>  
> @@ -502,19 +493,19 @@ int ieee80211_wx_get_name(struct ieee80211_device *ieee,
>  			     union iwreq_data *wrqu, char *extra)
>  {
>  	strlcpy(wrqu->name, "802.11", IFNAMSIZ);
> -	if(ieee->modulation & IEEE80211_CCK_MODULATION){
> +	if (ieee->modulation & IEEE80211_CCK_MODULATION) {
>  		strlcat(wrqu->name, "b", IFNAMSIZ);
> -		if(ieee->modulation & IEEE80211_OFDM_MODULATION)
> +		if (ieee->modulation & IEEE80211_OFDM_MODULATION)
>  			strlcat(wrqu->name, "/g", IFNAMSIZ);
> -	}else if(ieee->modulation & IEEE80211_OFDM_MODULATION)
> +	} else if (ieee->modulation & IEEE80211_OFDM_MODULATION)
>  		strlcat(wrqu->name, "g", IFNAMSIZ);
>  	if (ieee->mode & (IEEE_N_24G | IEEE_N_5G))
>  		strlcat(wrqu->name, "/n", IFNAMSIZ);
>  
> -	if((ieee->state == IEEE80211_LINKED) ||
> +	if ((ieee->state == IEEE80211_LINKED) ||
>  		(ieee->state == IEEE80211_LINKED_SCANNING))
>  		strlcat(wrqu->name, "  link", IFNAMSIZ);
> -	else if(ieee->state != IEEE80211_NOLINK)
> +	else if (ieee->state != IEEE80211_NOLINK)
>  		strlcat(wrqu->name, " .....", IFNAMSIZ);
>  
>  
> @@ -529,33 +520,33 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
>  {
>  	int ret = 0;
>  #if 1
> -	if(
> +	if {
Looks like syntax error	
>  		(!ieee->sta_wake_up) ||
> -	//	(!ieee->ps_request_tx_ack) ||
> +	/*	(!ieee->ps_request_tx_ack) || */
>  		(!ieee->enter_sleep_state) ||
> -		(!ieee->ps_is_queue_empty)){
> +		(!ieee->ps_is_queue_empty)) {
>  
> -	//	printk("ERROR. PS mode is tryied to be use but driver missed a callback\n\n");
> +	/* printk("ERROR. PS mode is tryied to be use but driver missed a callback\n\n"); */
>  
>  		return -1;
>  	}
>  #endif
>  	down(&ieee->wx_sem);
>  
> -	if (wrqu->power.disabled){
> +	if (wrqu->power.disabled) {
>  		ieee->ps = IEEE80211_PS_DISABLED;
>  		goto exit;
>  	}
>  	if (wrqu->power.flags & IW_POWER_TIMEOUT) {
> -		//ieee->ps_period = wrqu->power.value / 1000;
> +		/*ieee->ps_period = wrqu->power.value / 1000; */
>  		ieee->ps_timeout = wrqu->power.value / 1000;
>  	}
>  
>  	if (wrqu->power.flags & IW_POWER_PERIOD) {
>  
> -		//ieee->ps_timeout = wrqu->power.value / 1000;
> +		/* ieee->ps_timeout = wrqu->power.value / 1000; */
>  		ieee->ps_period = wrqu->power.value / 1000;
> -		//wrq->value / 1024;
> +		/* wrq->value / 1024; */
>  
>  	}
>  	switch (wrqu->power.flags & IW_POWER_MODE) {
> @@ -570,7 +561,7 @@ int ieee80211_wx_set_power(struct ieee80211_device *ieee,
>  		break;
>  
>  	case IW_POWER_ON:
> -	//	ieee->ps = IEEE80211_PS_DISABLED;
> +	 /* ieee->ps = IEEE80211_PS_DISABLED; */
>  		break;
>  
>  	default:
> @@ -589,11 +580,11 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
>  				 struct iw_request_info *info,
>  				 union iwreq_data *wrqu, char *extra)
>  {
> -	int ret =0;
> +	int ret = 0;
>  
>  	down(&ieee->wx_sem);
>  
> -	if(ieee->ps == IEEE80211_PS_DISABLED){
> +	if (ieee->ps == IEEE80211_PS_DISABLED) {
>  		wrqu->power.disabled = 1;
>  		goto exit;
>  	}
> @@ -604,15 +595,15 @@ int ieee80211_wx_get_power(struct ieee80211_device *ieee,
>  		wrqu->power.flags = IW_POWER_TIMEOUT;
>  		wrqu->power.value = ieee->ps_timeout * 1000;
>  	} else {
> -//		ret = -EOPNOTSUPP;
> -//		goto exit;
> +		/* ret = -EOPNOTSUPP; */
> +		/* goto exit; */
>  		wrqu->power.flags = IW_POWER_PERIOD;
>  		wrqu->power.value = ieee->ps_period * 1000;
> -//ieee->current_network.dtim_period * ieee->current_network.beacon_interval * 1024;
> +/*ieee->current_network.dtim_period * ieee->current_network.beacon_interval * 1024; */
>  	}
>  
>         if ((ieee->ps & (IEEE80211_PS_MBCAST | IEEE80211_PS_UNICAST)) == (IEEE80211_PS_MBCAST | IEEE80211_PS_UNICAST))
> -	   	wrqu->power.flags |= IW_POWER_ALL_R;
> +		wrqu->power.flags |= IW_POWER_ALL_R;
>  	else if (ieee->ps & IEEE80211_PS_MBCAST)
>  		wrqu->power.flags |= IW_POWER_MULTICAST_R;
>  	else
> -- 
> 1.7.0.4
> 
> _______________________________________________
> devel mailing list
> devel@linuxdriverproject.org
> http://driverdev.linuxdriverproject.org/mailman/listinfo/devel

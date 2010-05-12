Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0ELH13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:27:29 -0400
Received: from mx01.sz.bfs.de ([194.94.69.103]:32085 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750894Ab0ELH11 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:27:27 -0400
Message-ID: <4BEA5856.9040704@bfs.de>
Date: Wed, 12 May 2010 09:27:18 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Thunderbird 2.0.0.24 (X11/20100302)
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Greg Kroah-Hartman <gregkh@suse.de>, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 3/5] drivers/staging: Drop memory allocation cast
References: <Pine.LNX.4.64.1005112026300.4330@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1005112026300.4330@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Julia Lawall schrieb:
> From: Julia Lawall <julia@diku.dk>
> 
> Drop cast on the result of kmalloc and similar functions.
> 
> The semantic patch that makes this change is as follows:
> (http://coccinelle.lip6.fr/)
> 
> // <smpl>
> @@
> type T;
> @@
> 
> - (T *)
>   (\(kmalloc\|kzalloc\|kcalloc\|kmem_cache_alloc\|kmem_cache_zalloc\|
>    kmem_cache_alloc_node\|kmalloc_node\|kzalloc_node\)(...))
> // </smpl>
> 
> Signed-off-by: Julia Lawall <julia@diku.dk>
> 
> ---
>  drivers/staging/comedi/drivers/unioxx5.c                |    2 +-
>  drivers/staging/crystalhd/crystalhd_misc.c              |    2 +-
>  drivers/staging/cx25821/cx25821-audio-upstream.c        |    6 ++----
>  drivers/staging/cx25821/cx25821-video-upstream-ch2.c    |    6 ++----
>  drivers/staging/cx25821/cx25821-video-upstream.c        |    4 ++--
>  drivers/staging/et131x/et1310_rx.c                      |    2 +-
>  drivers/staging/et131x/et1310_tx.c                      |    2 +-
>  drivers/staging/rt2860/common/cmm_data.c                |    2 +-
>  drivers/staging/rt2860/common/cmm_mac_pci.c             |    2 +-
>  drivers/staging/rt2860/common/cmm_mac_usb.c             |    2 +-
>  drivers/staging/rt2860/rt_linux.c                       |    2 +-
>  drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c |    7 +++----
>  drivers/staging/rtl8192e/ieee80211/ieee80211_module.c   |    2 +-
>  drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c       |    2 +-
>  drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c  |    7 +++----
>  drivers/staging/rtl8192e/r8192E_core.c                  |    2 +-
>  drivers/staging/rtl8192su/ieee80211/ieee80211_module.c  |    2 +-
>  drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c      |    2 +-
>  drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c |    7 +++----
>  drivers/staging/rtl8192su/r8192U_core.c                 |    2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_module.c   |    2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c       |    2 +-
>  drivers/staging/rtl8192u/ieee80211/ieee80211_softmac.c  |    7 +++----
>  drivers/staging/rtl8192u/r8192U_core.c                  |   10 ++++++----
>  drivers/staging/vme/bridges/vme_ca91cx42.c              |    3 +--
>  drivers/staging/vme/bridges/vme_tsi148.c                |    2 +-
>  drivers/staging/vt6655/device_main.c                    |    2 +-
>  drivers/staging/vt6655/hostap.c                         |    4 ++--
>  drivers/staging/vt6655/wpactl.c                         |    2 +-
>  drivers/staging/vt6656/hostap.c                         |    4 ++--
>  drivers/staging/vt6656/main_usb.c                       |    2 +-
>  drivers/staging/vt6656/wpactl.c                         |    2 +-
>  drivers/staging/wlags49_h2/wl_priv.c                    |    4 ++--
>  33 files changed, 52 insertions(+), 59 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/unioxx5.c b/drivers/staging/comedi/drivers/unioxx5.c
> index be1d83d..16d4c9f 100644
> --- a/drivers/staging/comedi/drivers/unioxx5.c
> +++ b/drivers/staging/comedi/drivers/unioxx5.c
> @@ -285,7 +285,7 @@ static int __unioxx5_subdev_init(struct comedi_subdevice *subdev,
>  		return -EIO;
>  	}
>  
> -	usp = (struct unioxx5_subd_priv *)kzalloc(sizeof(*usp), GFP_KERNEL);
> +	usp = kzalloc(sizeof(*usp), GFP_KERNEL);
>  
>  	if (usp == NULL) {
>  		printk(KERN_ERR "comedi%d: erorr! --> out of memory!\n", minor);
> diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
> index d134667..548dc09 100644
> --- a/drivers/staging/crystalhd/crystalhd_misc.c
> +++ b/drivers/staging/crystalhd/crystalhd_misc.c
> @@ -887,7 +887,7 @@ int crystalhd_create_dio_pool(struct crystalhd_adp *adp, uint32_t max_pages)
>  	       BC_LINK_SG_POOL_SZ, max_pages, asz, adp->fill_byte_pool);
>  
>  	for (i = 0; i < BC_LINK_SG_POOL_SZ; i++) {
> -		temp = (uint8_t *)kzalloc(asz, GFP_KERNEL);
> +		temp = kzalloc(asz, GFP_KERNEL);
>  		if ((temp) == NULL) {
>  			BCMLOG_ERR("Failed to alloc %d mem\n", asz);
>  			return -ENOMEM;
> diff --git a/drivers/staging/cx25821/cx25821-audio-upstream.c b/drivers/staging/cx25821/cx25821-audio-upstream.c
> index ac13ba9..dbd7bc6 100644
> --- a/drivers/staging/cx25821/cx25821-audio-upstream.c
> +++ b/drivers/staging/cx25821/cx25821-audio-upstream.c
> @@ -753,8 +753,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>  
>  	if (dev->input_audiofilename) {
>  		str_length = strlen(dev->input_audiofilename);
> -		dev->_audiofilename =
> -		    (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_audiofilename)
>  			goto error;
> @@ -768,8 +767,7 @@ int cx25821_audio_upstream_init(struct cx25821_dev *dev, int channel_select)
>  		}
>  	} else {
>  		str_length = strlen(_defaultAudioName);
> -		dev->_audiofilename =
> -		    (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_audiofilename = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_audiofilename)
>  			goto error;
> diff --git a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> index cc51618..343df66 100644
> --- a/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> +++ b/drivers/staging/cx25821/cx25821-video-upstream-ch2.c
> @@ -769,8 +769,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  
>  	if (dev->input_filename_ch2) {
>  		str_length = strlen(dev->input_filename_ch2);
> -		dev->_filename_ch2 =
> -		    (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_filename_ch2)
>  			goto error;
> @@ -779,8 +778,7 @@ int cx25821_vidupstream_init_ch2(struct cx25821_dev *dev, int channel_select,
>  		       str_length + 1);
>  	} else {
>  		str_length = strlen(dev->_defaultname_ch2);
> -		dev->_filename_ch2 =
> -		    (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_filename_ch2 = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_filename_ch2)
>  			goto error;
this look like the begin of kstrdup()



> diff --git a/drivers/staging/cx25821/cx25821-video-upstream.c b/drivers/staging/cx25821/cx25821-video-upstream.c
> index a22a569..09f4756 100644
> --- a/drivers/staging/cx25821/cx25821-video-upstream.c
> +++ b/drivers/staging/cx25821/cx25821-video-upstream.c
> @@ -831,7 +831,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
>  
>  	if (dev->input_filename) {
>  		str_length = strlen(dev->input_filename);
> -		dev->_filename = (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_filename)
>  			goto error;

this look like the begin of kstrdup()
> @@ -839,7 +839,7 @@ int cx25821_vidupstream_init_ch1(struct cx25821_dev *dev, int channel_select,
>  		memcpy(dev->_filename, dev->input_filename, str_length + 1);
>  	} else {
>  		str_length = strlen(dev->_defaultname);
> -		dev->_filename = (char *)kmalloc(str_length + 1, GFP_KERNEL);
> +		dev->_filename = kmalloc(str_length + 1, GFP_KERNEL);
>  
>  		if (!dev->_filename)
>  			goto error;

this look like the begin of kstrdup()

> diff --git a/drivers/staging/et131x/et1310_rx.c b/drivers/staging/et131x/et1310_rx.c
> index 8f5dceb..8e04bdd 100644
> --- a/drivers/staging/et131x/et1310_rx.c
> +++ b/drivers/staging/et131x/et1310_rx.c
> @@ -547,7 +547,7 @@ int et131x_init_recv(struct et131x_adapter *adapter)
>  
>  	/* Setup each RFD */
>  	for (rfdct = 0; rfdct < rx_ring->NumRfd; rfdct++) {
> -		rfd = (MP_RFD *) kmem_cache_alloc(rx_ring->RecvLookaside,
> +		rfd = kmem_cache_alloc(rx_ring->RecvLookaside,
>  						     GFP_ATOMIC | GFP_DMA);
>  
>  		if (!rfd) {
> diff --git a/drivers/staging/et131x/et1310_tx.c b/drivers/staging/et131x/et1310_tx.c
> index b6ff20f..0f3473d 100644
> --- a/drivers/staging/et131x/et1310_tx.c
> +++ b/drivers/staging/et131x/et1310_tx.c
> @@ -112,7 +112,7 @@ int et131x_tx_dma_memory_alloc(struct et131x_adapter *adapter)
>  	struct tx_ring *tx_ring = &adapter->tx_ring;
>  
>  	/* Allocate memory for the TCB's (Transmit Control Block) */
> -	adapter->tx_ring.tcb_ring = (struct tcb *)
> +	adapter->tx_ring.tcb_ring =
>  		kcalloc(NUM_TCB, sizeof(struct tcb), GFP_ATOMIC | GFP_DMA);
>  	if (!adapter->tx_ring.tcb_ring) {
>  		dev_err(&adapter->pdev->dev, "Cannot alloc memory for TCBs\n");
> diff --git a/drivers/staging/rt2860/common/cmm_data.c b/drivers/staging/rt2860/common/cmm_data.c
> index 65b00e6..93a5347 100644
> --- a/drivers/staging/rt2860/common/cmm_data.c
> +++ b/drivers/staging/rt2860/common/cmm_data.c
> @@ -1424,7 +1424,7 @@ u32 deaggregate_AMSDU_announce(struct rt_rtmp_adapter *pAd,
>  		if ((Header802_3[12] == 0x88) && (Header802_3[13] == 0x8E)) {
>  			/* avoid local heap overflow, use dyanamic allocation */
>  			struct rt_mlme_queue_elem *Elem =
> -			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
> +			    kmalloc(sizeof(struct rt_mlme_queue_elem),
>  							MEM_ALLOC_FLAG);
>  			if (Elem != NULL) {
>  				memmove(Elem->Msg +
> diff --git a/drivers/staging/rt2860/common/cmm_mac_pci.c b/drivers/staging/rt2860/common/cmm_mac_pci.c
> index 560ebd3..e26ba49 100644
> --- a/drivers/staging/rt2860/common/cmm_mac_pci.c
> +++ b/drivers/staging/rt2860/common/cmm_mac_pci.c
> @@ -1558,7 +1558,7 @@ void RT28xxPciMlmeRadioOFF(struct rt_rtmp_adapter *pAd)
>  		if (INFRA_ON(pAd) || ADHOC_ON(pAd)) {
>  			struct rt_mlme_disassoc_req DisReq;
>  			struct rt_mlme_queue_elem *pMsgElem =
> -			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
> +			    kmalloc(sizeof(struct rt_mlme_queue_elem),
>  							MEM_ALLOC_FLAG);
>  
>  			if (pMsgElem) {
> diff --git a/drivers/staging/rt2860/common/cmm_mac_usb.c b/drivers/staging/rt2860/common/cmm_mac_usb.c
> index 9dd6959..8aec70f 100644
> --- a/drivers/staging/rt2860/common/cmm_mac_usb.c
> +++ b/drivers/staging/rt2860/common/cmm_mac_usb.c
> @@ -1087,7 +1087,7 @@ void RT28xxUsbMlmeRadioOFF(struct rt_rtmp_adapter *pAd)
>  		if (INFRA_ON(pAd) || ADHOC_ON(pAd)) {
>  			struct rt_mlme_disassoc_req DisReq;
>  			struct rt_mlme_queue_elem *pMsgElem =
> -			    (struct rt_mlme_queue_elem *)kmalloc(sizeof(struct rt_mlme_queue_elem),
> +			    kmalloc(sizeof(struct rt_mlme_queue_elem),
>  							MEM_ALLOC_FLAG);
>  
>  			if (pMsgElem) {
> diff --git a/drivers/staging/rt2860/rt_linux.c b/drivers/staging/rt2860/rt_linux.c
> index 27b7810..0029b2d 100644
> --- a/drivers/staging/rt2860/rt_linux.c
> +++ b/drivers/staging/rt2860/rt_linux.c
> @@ -154,7 +154,7 @@ void RTMP_GetCurrentSystemTime(LARGE_INTEGER *time)
>  /* pAd MUST allow to be NULL */
>  int os_alloc_mem(struct rt_rtmp_adapter *pAd, u8 ** mem, unsigned long size)
>  {
> -	*mem = (u8 *)kmalloc(size, GFP_ATOMIC);
> +	*mem = kmalloc(size, GFP_ATOMIC);
>  	if (*mem)
>  		return NDIS_STATUS_SUCCESS;
>  	else
> diff --git a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> index e099a5f..b7426fe 100644
> --- a/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8187se/ieee80211/ieee80211_softmac.c
> @@ -1435,7 +1435,7 @@ static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
>  
>  		if(*(t++) == MFIE_TYPE_CHALLENGE){
>  			*chlen = *(t++);
> -			*challenge = (u8*)kmalloc(*chlen, GFP_ATOMIC);
> +			*challenge = kmalloc(*chlen, GFP_ATOMIC);
>  			memcpy(*challenge, t, *chlen);
>  		}
>  	}

kmalloc() will succeed ?



> @@ -2861,8 +2861,7 @@ static int ieee80211_wpa_set_encryption(struct ieee80211_device *ieee,
>  
>  		ieee80211_crypt_delayed_deinit(ieee, crypt);
>  
> -		new_crypt = (struct ieee80211_crypt_data *)
> -			kmalloc(sizeof(*new_crypt), GFP_KERNEL);
> +		new_crypt = kmalloc(sizeof(*new_crypt), GFP_KERNEL);
>  		if (new_crypt == NULL) {
>  			ret = -ENOMEM;
>  			goto done;
> @@ -2953,7 +2952,7 @@ int ieee80211_wpa_supplicant_ioctl(struct ieee80211_device *ieee, struct iw_poin
>  		goto out;
>  	}
>  
> -	param = (struct ieee_param *)kmalloc(p->length, GFP_KERNEL);
> +	param = kmalloc(p->length, GFP_KERNEL);
>  	if (param == NULL){
>  		ret = -ENOMEM;
>  		goto out;
> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
> index f43a7db..c7aa1c6 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_module.c
> @@ -170,7 +170,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
>  	ieee80211_softmac_init(ieee);
>  
>  #if (LINUX_VERSION_CODE > KERNEL_VERSION(2,6,13))
> -	ieee->pHTInfo = (RT_HIGH_THROUGHPUT*)kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
> +	ieee->pHTInfo = kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
>  #else
>  	ieee->pHTInfo = (RT_HIGH_THROUGHPUT*)kmalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
>  	memset(ieee->pHTInfo,0,sizeof(RT_HIGH_THROUGHPUT));
> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
> index ce265ae..da10067 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_rx.c
> @@ -1397,7 +1397,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
>  	/* skb: hdr + (possible reassembled) full plaintext payload */
>  	payload = skb->data + hdrlen;
>  	//ethertype = (payload[6] << 8) | payload[7];
> -	rxb = (struct ieee80211_rxb*)kmalloc(sizeof(struct ieee80211_rxb),GFP_ATOMIC);
> +	rxb = kmalloc(sizeof(struct ieee80211_rxb), GFP_ATOMIC);
>  	if(rxb == NULL)
>  	{
>  		IEEE80211_DEBUG(IEEE80211_DL_ERR,"%s(): kmalloc rxb error\n",__FUNCTION__);
> diff --git a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
> index b4beb20..4f6ce06 100644
> --- a/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192e/ieee80211/ieee80211_softmac.c
> @@ -1800,7 +1800,7 @@ static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
>  
>  		if(*(t++) == MFIE_TYPE_CHALLENGE){
>  			*chlen = *(t++);
> -			*challenge = (u8*)kmalloc(*chlen, GFP_ATOMIC);
> +			*challenge = kmalloc(*chlen, GFP_ATOMIC);
>  			memcpy(*challenge, t, *chlen);
>  		}
>  	}

kmalloc() will succeed ?


> @@ -3459,8 +3459,7 @@ static int ieee80211_wpa_set_encryption(struct ieee80211_device *ieee,
>  
>  		ieee80211_crypt_delayed_deinit(ieee, crypt);
>  
> -		new_crypt = (struct ieee80211_crypt_data *)
> -			kmalloc(sizeof(*new_crypt), GFP_KERNEL);
> +		new_crypt = kmalloc(sizeof(*new_crypt), GFP_KERNEL);
>  		if (new_crypt == NULL) {
>  			ret = -ENOMEM;
>  			goto done;
> @@ -3592,7 +3591,7 @@ int ieee80211_wpa_supplicant_ioctl(struct ieee80211_device *ieee, struct iw_poin
>  		goto out;
>  	}
>  
> -	param = (struct ieee_param *)kmalloc(p->length, GFP_KERNEL);
> +	param = kmalloc(p->length, GFP_KERNEL);
>  	if (param == NULL){
>  		ret = -ENOMEM;
>  		goto out;
> diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
> index 604c691..533be48 100644
> --- a/drivers/staging/rtl8192e/r8192E_core.c
> +++ b/drivers/staging/rtl8192e/r8192E_core.c
> @@ -5040,7 +5040,7 @@ static int rtl8192_ioctl(struct net_device *dev, struct ifreq *rq, int cmd)
>               goto out;
>       }
>  
> -     ipw = (struct ieee_param *)kmalloc(p->length, GFP_KERNEL);
> +     ipw = kmalloc(p->length, GFP_KERNEL);
>       if (ipw == NULL){
>               ret = -ENOMEM;
>               goto out;
> diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
> index c024fa6..73de3ba 100644
> --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
> +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_module.c
> @@ -161,7 +161,7 @@ struct net_device *alloc_ieee80211(int sizeof_priv)
>  
>  	ieee80211_softmac_init(ieee);
>  
> -	ieee->pHTInfo = (RT_HIGH_THROUGHPUT*)kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
> +	ieee->pHTInfo = kzalloc(sizeof(RT_HIGH_THROUGHPUT), GFP_KERNEL);
>  	if (ieee->pHTInfo == NULL)
>  	{
>  		IEEE80211_DEBUG(IEEE80211_DL_ERR, "can't alloc memory for HTInfo\n");
> diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
> index cc80faf..d3b34cc 100644
> --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
> +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_rx.c
> @@ -1191,7 +1191,7 @@ int ieee80211_rtl_rx(struct ieee80211_device *ieee, struct sk_buff *skb,
>  	/* skb: hdr + (possible reassembled) full plaintext payload */
>  	payload = skb->data + hdrlen;
>  	//ethertype = (payload[6] << 8) | payload[7];
> -	rxb = (struct ieee80211_rxb*)kmalloc(sizeof(struct ieee80211_rxb),GFP_ATOMIC);
> +	rxb = kmalloc(sizeof(struct ieee80211_rxb), GFP_ATOMIC);
>  	if(rxb == NULL)
>  	{
>  		IEEE80211_DEBUG(IEEE80211_DL_ERR,"%s(): kmalloc rxb error\n",__FUNCTION__);
> diff --git a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> index 3cf5fdf..660aee2 100644
> --- a/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> +++ b/drivers/staging/rtl8192su/ieee80211/ieee80211_softmac.c
> @@ -1557,7 +1557,7 @@ static inline u16 auth_parse(struct sk_buff *skb, u8** challenge, int *chlen)
>  
>  		if(*(t++) == MFIE_TYPE_CHALLENGE){
>  			*chlen = *(t++);
> -			*challenge = (u8*)kmalloc(*chlen, GFP_ATOMIC);
> +			*challenge = kmalloc(*chlen, GFP_ATOMIC);
>  			memcpy(*challenge, t, *chlen);
>  		}
>  	}

kmalloc() will succeed ?



hope that helps,

re,
 wh


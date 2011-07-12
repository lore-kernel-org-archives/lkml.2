Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753032Ab1GLKle (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jul 2011 06:41:34 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:40303 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751525Ab1GLKld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jul 2011 06:41:33 -0400
Date: Tue, 12 Jul 2011 16:27:29 +0530
From: "Prashant P. Shah" <pshah.mumbai@gmail.com>
To: gregkh@suse.de
Cc: mikem@ring3k.org, pshah.mumbai@gmail.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/3] Staging: rtl8192e: fixed style issues found by
	checkpatch.pl
Message-ID: <20110712105729.GA18292@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a patch to the r8192E_core.c file that fixes whitespace
related style issues found by the checkpatch.pl tool

Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>
---
 drivers/staging/rtl8192e/r8192E_core.c |  196 ++++++++++++++++----------------
 1 files changed, 98 insertions(+), 98 deletions(-)

diff --git a/drivers/staging/rtl8192e/r8192E_core.c b/drivers/staging/rtl8192e/r8192E_core.c
index 58d800f..ef0d520 100644
--- a/drivers/staging/rtl8192e/r8192E_core.c
+++ b/drivers/staging/rtl8192e/r8192E_core.c
@@ -71,12 +71,12 @@ MODULE_DESCRIPTION("Linux driver for Realtek RTL819x WiFi cards");
 
 
 module_param_string(ifname, ifname, sizeof(ifname), S_IRUGO|S_IWUSR);
-module_param(hwwep,int, S_IRUGO|S_IWUSR);
-module_param(channels,int, S_IRUGO|S_IWUSR);
+module_param(hwwep, int, S_IRUGO|S_IWUSR);
+module_param(channels, int, S_IRUGO|S_IWUSR);
 
-MODULE_PARM_DESC(ifname," Net interface name, wlan%d=default");
-MODULE_PARM_DESC(hwwep," Try to use hardware WEP support. Still broken and not available on all cards");
-MODULE_PARM_DESC(channels," Channel bitmask for specific locales. NYI");
+MODULE_PARM_DESC(ifname, "Net interface name, wlan%d=default");
+MODULE_PARM_DESC(hwwep, "Try to use hardware WEP support. Still broken and not available on all cards");
+MODULE_PARM_DESC(channels, "Channel bitmask for specific locales. NYI");
 
 static int __devinit rtl8192_pci_probe(struct pci_dev *pdev,
 			 const struct pci_device_id *id);
@@ -108,7 +108,7 @@ static void rtl8192_update_ratr_table(struct r8192_priv *priv);
 static void rtl8192_restart(struct work_struct *work);
 static void watch_dog_timer_callback(unsigned long data);
 static int _rtl8192_up(struct r8192_priv *priv);
-static void rtl8192_cancel_deferred_work(struct r8192_priv* priv);
+static void rtl8192_cancel_deferred_work(struct r8192_priv *priv);
 static short rtl8192_tx(struct r8192_priv *priv, struct sk_buff* skb);
 
 #ifdef ENABLE_DOT11D
@@ -117,7 +117,7 @@ typedef struct _CHANNEL_LIST
 {
 	u8	Channel[32];
 	u8	Len;
-}CHANNEL_LIST, *PCHANNEL_LIST;
+} CHANNEL_LIST, *PCHANNEL_LIST;
 
 static const CHANNEL_LIST ChannelPlan[] = {
 	{{1,2,3,4,5,6,7,8,9,10,11,36,40,44,48,52,56,60,64,149,153,157,161,165},24},  		//FCC
@@ -133,10 +133,10 @@ static const CHANNEL_LIST ChannelPlan[] = {
 	{{1,2,3,4,5,6,7,8,9,10,11,12,13,14},14}					//For Global Domain. 1-11:active scan, 12-14 passive scan. //+YJ, 080626
 };
 
-static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
+static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv *priv)
 {
-	int i, max_chan=-1, min_chan=-1;
-	struct ieee80211_device* ieee = priv->ieee80211;
+	int i, max_chan = -1, min_chan = -1;
+	struct ieee80211_device *ieee = priv->ieee80211;
 	switch (channel_plan)
 	{
 		case COUNTRY_CODE_FCC:
@@ -152,18 +152,18 @@ static void rtl819x_set_channel_map(u8 channel_plan, struct r8192_priv* priv)
 		{
 			Dot11d_Init(ieee);
 			ieee->bGlobalDomain = false;
-                        //acturally 8225 & 8256 rf chip only support B,G,24N mode
+			//acturally 8225 & 8256 rf chip only support B,G,24N mode
 			min_chan = 1;
 			max_chan = 14;
 
-			if (ChannelPlan[channel_plan].Len != 0){
+			if (ChannelPlan[channel_plan].Len != 0) {
 				// Clear old channel map
 				memset(GET_DOT11D_INFO(ieee)->channel_map, 0, sizeof(GET_DOT11D_INFO(ieee)->channel_map));
 				// Set new channel map
-				for (i=0;i<ChannelPlan[channel_plan].Len;i++)
+				for (i = 0; i < ChannelPlan[channel_plan].Len; i++)
 				{
-	                                if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
-					    break;
+					if (ChannelPlan[channel_plan].Channel[i] < min_chan || ChannelPlan[channel_plan].Channel[i] > max_chan)
+						break;
 					GET_DOT11D_INFO(ieee)->channel_map[ChannelPlan[channel_plan].Channel[i]] = 1;
 				}
 			}
@@ -191,78 +191,78 @@ static inline bool rx_hal_is_cck_rate(prx_fwinfo_819x_pci pdrvinfo)
 		!pdrvinfo->RxHT;
 }
 
-void CamResetAllEntry(struct r8192_priv* priv)
+void CamResetAllEntry(struct r8192_priv *priv)
 {
 	write_nic_dword(priv, RWCAM, BIT31|BIT30);
 }
 
 void write_cam(struct r8192_priv *priv, u8 addr, u32 data)
 {
-        write_nic_dword(priv, WCAMI, data);
-        write_nic_dword(priv, RWCAM, BIT31|BIT16|(addr&0xff) );
+	write_nic_dword(priv, WCAMI, data);
+	write_nic_dword(priv, RWCAM, BIT31|BIT16|(addr&0xff));
 }
 
 u32 read_cam(struct r8192_priv *priv, u8 addr)
 {
-        write_nic_dword(priv, RWCAM, 0x80000000|(addr&0xff) );
-        return read_nic_dword(priv, 0xa8);
+	write_nic_dword(priv, RWCAM, 0x80000000|(addr&0xff));
+	return read_nic_dword(priv, 0xa8);
 }
 
 u8 read_nic_byte(struct r8192_priv *priv, int x)
 {
-        return 0xff & readb(priv->mem_start + x);
+	return 0xff & readb(priv->mem_start + x);
 }
 
 u32 read_nic_dword(struct r8192_priv *priv, int x)
 {
-        return readl(priv->mem_start + x);
+	return readl(priv->mem_start + x);
 }
 
 u16 read_nic_word(struct r8192_priv *priv, int x)
 {
-        return readw(priv->mem_start + x);
+	return readw(priv->mem_start + x);
 }
 
-void write_nic_byte(struct r8192_priv *priv, int x,u8 y)
+void write_nic_byte(struct r8192_priv *priv, int x, u8 y)
 {
-        writeb(y, priv->mem_start + x);
+	writeb(y, priv->mem_start + x);
 	udelay(20);
 }
 
-void write_nic_dword(struct r8192_priv *priv, int x,u32 y)
+void write_nic_dword(struct r8192_priv *priv, int x, u32 y)
 {
-        writel(y, priv->mem_start + x);
+	writel(y, priv->mem_start + x);
 	udelay(20);
 }
 
-void write_nic_word(struct r8192_priv *priv, int x,u16 y)
+void write_nic_word(struct r8192_priv *priv, int x, u16 y)
 {
-        writew(y, priv->mem_start + x);
+	writew(y, priv->mem_start + x);
 	udelay(20);
 }
 
 u8 rtl8192e_ap_sec_type(struct ieee80211_device *ieee)
 {
-	static const u8 ccmp_ie[4] = {0x00,0x50,0xf2,0x04};
+	static const u8 ccmp_ie[4] = {0x00, 0x50, 0xf2, 0x04};
 	static const u8 ccmp_rsn_ie[4] = {0x00, 0x0f, 0xac, 0x04};
-	int wpa_ie_len= ieee->wpa_ie_len;
-	struct ieee80211_crypt_data* crypt;
+	int wpa_ie_len = ieee->wpa_ie_len;
+	struct ieee80211_crypt_data *crypt;
 	int encrypt;
 
 	crypt = ieee->crypt[ieee->tx_keyidx];
 
 	encrypt = (ieee->current_network.capability & WLAN_CAPABILITY_PRIVACY) ||
 		  (ieee->host_encrypt && crypt && crypt->ops &&
-		   (0 == strcmp(crypt->ops->name,"WEP")));
+		   (0 == strcmp(crypt->ops->name, "WEP")));
 
 	/* simply judge  */
-	if(encrypt && (wpa_ie_len == 0)) {
+	if (encrypt && (wpa_ie_len == 0)) {
 		// wep encryption, no N mode setting */
 		return SEC_ALG_WEP;
-	} else if((wpa_ie_len != 0)) {
+	} else if ((wpa_ie_len != 0)) {
 		// parse pairwise key type */
-		if (((ieee->wpa_ie[0] == 0xdd) && (!memcmp(&(ieee->wpa_ie[14]),ccmp_ie,4))) ||
-				((ieee->wpa_ie[0] == 0x30) && (!memcmp(&ieee->wpa_ie[10],ccmp_rsn_ie, 4))))
+		if (((ieee->wpa_ie[0] == 0xdd) && (!memcmp(&(ieee->wpa_ie[14]), ccmp_ie, 4))) ||
+				((ieee->wpa_ie[0] == 0x30) && (!memcmp(&ieee->wpa_ie[10], ccmp_rsn_ie, 4))))
 			return SEC_ALG_CCMP;
 		else
 			return SEC_ALG_TKIP;
@@ -275,12 +275,12 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 {
 	struct r8192_priv *priv = ieee80211_priv(ieee80211->dev);
 
-	switch(variable)
+	switch (variable)
 	{
 
 		case HW_VAR_BSSID:
-			write_nic_dword(priv, BSSIDR, ((u32*)(val))[0]);
-			write_nic_word(priv, BSSIDR+2, ((u16*)(val+2))[0]);
+			write_nic_dword(priv, BSSIDR, ((u32 *)(val))[0]);
+			write_nic_word(priv, BSSIDR+2, ((u16 *)(val+2))[0]);
 		break;
 
 		case HW_VAR_MEDIA_STATUS:
@@ -290,7 +290,7 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 
 			btMsr &= 0xfc;
 
-			switch(OpMode)
+			switch (OpMode)
 			{
 			case RT_OP_MODE_INFRASTRUCTURE:
 				btMsr |= MSR_INFRA;
@@ -317,7 +317,7 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 		{
 			u32	RegRCR, Type;
 
-			Type = ((u8*)(val))[0];
+			Type = ((u8 *)(val))[0];
 			RegRCR = read_nic_dword(priv, RCR);
 			priv->ReceiveConfig = RegRCR;
 
@@ -326,7 +326,7 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 			else if (Type == false)
 				RegRCR &= (~RCR_CBSSID);
 
-			write_nic_dword(priv, RCR,RegRCR);
+			write_nic_dword(priv, RCR, RegRCR);
 			priv->ReceiveConfig = RegRCR;
 
 		}
@@ -343,7 +343,7 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 		case HW_VAR_ACK_PREAMBLE:
 		{
 			u32 regTmp = 0;
-			priv->short_preamble = (bool)(*(u8*)val );
+			priv->short_preamble = (bool)(*(u8 *)val);
 			regTmp = priv->basic_rate;
 			if (priv->short_preamble)
 				regTmp |= BRSR_AckShortPmb;
@@ -352,7 +352,7 @@ void rtl8192e_SetHwReg(struct ieee80211_device *ieee80211, u8 variable, u8 *val)
 		break;
 
 		case HW_VAR_CPU_RST:
-			write_nic_dword(priv, CPU_GEN, ((u32*)(val))[0]);
+			write_nic_dword(priv, CPU_GEN, ((u32 *)(val))[0]);
 		break;
 
 		default:
@@ -372,21 +372,21 @@ static int proc_get_stats_ap(char *page, char **start,
 	struct ieee80211_network *target;
 	int len = 0;
 
-        list_for_each_entry(target, &ieee->network_list, list) {
+	list_for_each_entry(target, &ieee->network_list, list) {
 
 		len += snprintf(page + len, count - len,
-                "%s ", target->ssid);
+			"%s ", target->ssid);
 
-		if(target->wpa_ie_len>0 || target->rsn_ie_len>0){
-	                len += snprintf(page + len, count - len,
-        	        "WPA\n");
+		if (target->wpa_ie_len > 0 || target->rsn_ie_len > 0) {
+			len += snprintf(page + len, count - len,
+				"WPA\n");
+		}
+		else {
+			len += snprintf(page + len, count - len,
+				"non_WPA\n");
 		}
-		else{
-                        len += snprintf(page + len, count - len,
-                        "non_WPA\n");
-                }
 
-        }
+	}
 
 	*eof = 1;
 	return len;
@@ -398,46 +398,46 @@ static int proc_get_registers(char *page, char **start,
 {
 	struct r8192_priv *priv = data;
 	int len = 0;
-	int i,n;
-	int max=0xff;
+	int i, n;
+	int max = 0xff;
 
 	/* This dump the current register page */
 	len += snprintf(page + len, count - len,
-                        "\n####################page 0##################\n ");
+		"\n####################page 0##################\n");
 
-	for(n=0;n<=max;)
+	for (n = 0; n <= max;)
 	{
 		len += snprintf(page + len, count - len,
-			"\nD:  %2x > ",n);
+			"\nD:  %2x > ", n);
 
-		for(i=0;i<16 && n<=max;i++,n++)
-		len += snprintf(page + len, count - len,
-			"%2x ",read_nic_byte(priv,n));
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len,
+				"%2x ", read_nic_byte(priv, n));
 	}
-	len += snprintf(page + len, count - len,"\n");
+	len += snprintf(page + len, count - len, "\n");
 	len += snprintf(page + len, count - len,
-                        "\n####################page 1##################\n ");
-        for(n=0;n<=max;)
-        {
-                len += snprintf(page + len, count - len,
-                        "\nD:  %2x > ",n);
+		"\n####################page 1##################\n");
+	for(n = 0; n <= max;)
+	{
+		len += snprintf(page + len, count - len,
+			"\nD:  %2x > ", n);
 
-                for(i=0;i<16 && n<=max;i++,n++)
-                len += snprintf(page + len, count - len,
-                        "%2x ",read_nic_byte(priv,0x100|n));
-        }
+		for(i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len,
+				"%2x ", read_nic_byte(priv, 0x100|n));
+	}
 
 	len += snprintf(page + len, count - len,
-                        "\n####################page 3##################\n ");
-        for(n=0;n<=max;)
+		"\n####################page 3##################\n ");
+	for(n = 0; n <= max;)
         {
-                len += snprintf(page + len, count - len,
-                        "\nD:  %2x > ",n);
+		len += snprintf(page + len, count - len,
+			"\nD:  %2x > ", n);
 
-                for(i=0;i<16 && n<=max;i++,n++)
-                len += snprintf(page + len, count - len,
-                        "%2x ",read_nic_byte(priv,0x300|n));
-        }
+		for (i = 0; i < 16 && n <= max; i++, n++)
+			len += snprintf(page + len, count - len,
+				"%2x ", read_nic_byte(priv, 0x300|n));
+	}
 
 	*eof = 1;
 	return len;
@@ -506,7 +506,7 @@ static int proc_get_stats_rx(char *page, char **start,
 static void rtl8192_proc_module_init(void)
 {
 	RT_TRACE(COMP_INIT, "Initializing proc filesystem\n");
-	rtl8192_proc=create_proc_entry(RTL819xE_MODULE_NAME, S_IFDIR, init_net.proc_net);
+	rtl8192_proc = create_proc_entry(RTL819xE_MODULE_NAME, S_IFDIR, init_net.proc_net);
 }
 
 
@@ -520,7 +520,7 @@ static void rtl8192_proc_remove_one(struct r8192_priv *priv)
 {
 	struct net_device *dev = priv->ieee80211->dev;
 
-	printk("dev name=======> %s\n",dev->name);
+	printk("dev name=======> %s\n", dev->name);
 
 	if (priv->dir_dev) {
 		remove_proc_entry("stats-tx", priv->dir_dev);
@@ -550,7 +550,7 @@ static void rtl8192_proc_init_one(struct r8192_priv *priv)
 				   priv->dir_dev, proc_get_stats_rx, priv);
 
 	if (!e) {
-		RT_TRACE(COMP_ERR,"Unable to initialize "
+		RT_TRACE(COMP_ERR, "Unable to initialize "
 		      "/proc/net/rtl8192/%s/stats-rx\n",
 		      dev->name);
 	}
@@ -585,13 +585,13 @@ static void rtl8192_proc_init_one(struct r8192_priv *priv)
 
 static short check_nic_enough_desc(struct ieee80211_device *ieee, int prio)
 {
-    struct r8192_priv *priv = ieee80211_priv(ieee->dev);
-    struct rtl8192_tx_ring *ring = &priv->tx_ring[prio];
+	struct r8192_priv *priv = ieee80211_priv(ieee->dev);
+	struct rtl8192_tx_ring *ring = &priv->tx_ring[prio];
 
-    /* for now we reserve two free descriptor as a safety boundary
-     * between the tail and the head
-     */
-    return (ring->entries - skb_queue_len(&ring->queue) >= 2);
+	/* for now we reserve two free descriptor as a safety boundary
+	 * between the tail and the head
+	 */
+	return (ring->entries - skb_queue_len(&ring->queue) >= 2);
 }
 
 static void tx_timeout(struct net_device *dev)
@@ -625,14 +625,14 @@ static void rtl8192_update_msr(struct r8192_priv *priv)
 	u8 msr;
 
 	msr  = read_nic_byte(priv, MSR);
-	msr &= ~ MSR_LINK_MASK;
+	msr &= ~MSR_LINK_MASK;
 
 	/* do not change in link_state != WLAN_LINK_ASSOCIATED.
 	 * msr must be updated if the state is ASSOCIATING.
 	 * this is intentional and make sense for ad-hoc and
 	 * master (see the create BSS/IBSS func)
 	 */
-	if (priv->ieee80211->state == IEEE80211_LINKED){
+	if (priv->ieee80211->state == IEEE80211_LINKED) {
 
 		if (priv->ieee80211->iw_mode == IW_MODE_INFRA)
 			msr |= (MSR_LINK_MANAGED<<MSR_LINK_SHIFT);
@@ -641,7 +641,7 @@ static void rtl8192_update_msr(struct r8192_priv *priv)
 		else if (priv->ieee80211->iw_mode == IW_MODE_MASTER)
 			msr |= (MSR_LINK_MASTER<<MSR_LINK_SHIFT);
 
-	}else
+	} else
 		msr |= (MSR_LINK_NONE<<MSR_LINK_SHIFT);
 
 	write_nic_byte(priv, MSR, msr);
@@ -777,7 +777,7 @@ static void rtl8192_halt_adapter(struct r8192_priv *priv, bool reset)
 			PHY_SetRtl8192eRfOff(priv);
 			ulRegRead = read_nic_dword(priv, CPU_GEN);
 			ulRegRead |= CPU_GEN_SYSTEM_RESET;
-			write_nic_dword(priv,CPU_GEN, ulRegRead);
+			write_nic_dword(priv, CPU_GEN, ulRegRead);
 		} else {
 			/* for WOL */
 			write_nic_dword(priv, WFCRC0, 0xffffffff);
@@ -791,11 +791,11 @@ static void rtl8192_halt_adapter(struct r8192_priv *priv, bool reset)
 		}
 	}
 
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_purge(&priv->ieee80211->skb_waitQ [i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++) {
+		skb_queue_purge(&priv->ieee80211->skb_waitQ[i]);
 	}
-	for(i = 0; i < MAX_QUEUE_SIZE; i++) {
-		skb_queue_purge(&priv->ieee80211->skb_aggQ [i]);
+	for (i = 0; i < MAX_QUEUE_SIZE; i++) {
+		skb_queue_purge(&priv->ieee80211->skb_aggQ[i]);
 	}
 
 	skb_queue_purge(&priv->skb_queue);
-- 
1.7.1


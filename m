Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab2DDAZI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 20:25:08 -0400
Received: from na3sys009aog136.obsmtp.com ([74.125.149.85]:36810 "EHLO
	psmtp.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754026Ab2DDAZG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 20:25:06 -0400
X-Greylist: delayed 479 seconds by postgrey-1.27 at vger.kernel.org; Tue, 03 Apr 2012 20:25:06 EDT
From: Bing Zhao <bzhao@marvell.com>
To: Joe Perches <joe@perches.com>, "John W. Linville" <linville@tuxdriver.com>
CC: Christian Lamparter <chunkeey@googlemail.com>,
        Brett Rudley <brudley@broadcom.com>,
        Roland Vossen <rvossen@broadcom.com>,
        Arend van Spriel <arend@broadcom.com>,
        "Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
        Kan Yan <kanyan@broadcom.com>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Tue, 3 Apr 2012 17:13:11 -0700
Subject: RE: [PATCH wireless-next] wireless: Remove unnecessary ; from while
 (0) macros
Thread-Topic: [PATCH wireless-next] wireless: Remove unnecessary ; from
 while (0) macros
Thread-Index: Ac0R40o8K+xenIyCTE2q2HBP+cCZWAAFDXFw
Message-ID: <477F20668A386D41ADCC57781B1F7043083A0BE5E3@SC-VEXCH1.marvell.com>
References: <1333489609.2695.14.camel@joe2Laptop>
In-Reply-To: <1333489609.2695.14.camel@joe2Laptop>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id q340PkEY015132

> Semicolons are not necessary after macros that end in while (0).
> Remove them.
> 
> Simplify the macros with tests of
> do { if (foo>size) memset1; else memset2;} while (0);
> to a single line memset(,,min_t(size_t, foo, size))
> 
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  drivers/net/wireless/ath/carl9170/cmd.h       |    6 +++---
>  drivers/net/wireless/brcm80211/brcmsmac/d11.h |    2 +-
>  drivers/net/wireless/mwifiex/sdio.h           |    8 ++++----

For mwifiex part,
Acked-by: Bing Zhao <bzhao@marvell.com>

Thanks,
Bing

>  drivers/net/wireless/rtlwifi/rtl8192ce/trx.h  |    7 +------
>  drivers/net/wireless/rtlwifi/rtl8192de/trx.h  |    8 ++------
>  drivers/net/wireless/rtlwifi/rtl8192se/def.h  |    7 +------
>  drivers/net/wireless/rtlwifi/rtl8192se/fw.h   |    6 +++---
>  7 files changed, 15 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/net/wireless/ath/carl9170/cmd.h b/drivers/net/wireless/ath/carl9170/cmd.h
> index 885c427..65919c9 100644
> --- a/drivers/net/wireless/ath/carl9170/cmd.h
> +++ b/drivers/net/wireless/ath/carl9170/cmd.h
> @@ -114,7 +114,7 @@ __regwrite_out :							\
> 
>  #define carl9170_regwrite_result()					\
>  	__err;								\
> -} while (0);
> +} while (0)
> 
> 
>  #define carl9170_async_regwrite_get_buf()				\
> @@ -126,7 +126,7 @@ do {									\
>  		__err = -ENOMEM;					\
>  		goto __async_regwrite_out;				\
>  	}								\
> -} while (0);
> +} while (0)
> 
>  #define carl9170_async_regwrite_begin(carl)				\
>  do {									\
> @@ -169,6 +169,6 @@ __async_regwrite_out:							\
> 
>  #define carl9170_async_regwrite_result()				\
>  	__err;								\
> -} while (0);
> +} while (0)
> 
>  #endif /* __CMD_H */
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/d11.h
> b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
> index 1948cb2..3f659e0 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/d11.h
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/d11.h
> @@ -733,7 +733,7 @@ struct cck_phy_hdr {
>  	do { \
>  		plcp[1] = len & 0xff; \
>  		plcp[2] = ((len >> 8) & 0xff); \
> -	} while (0);
> +	} while (0)
> 
>  #define BRCMS_SET_MIMO_PLCP_AMPDU(plcp) (plcp[3] |= MIMO_PLCP_AMPDU)
>  #define BRCMS_CLR_MIMO_PLCP_AMPDU(plcp) (plcp[3] &= ~MIMO_PLCP_AMPDU)
> diff --git a/drivers/net/wireless/mwifiex/sdio.h b/drivers/net/wireless/mwifiex/sdio.h
> index a3fb322..0ead152 100644
> --- a/drivers/net/wireless/mwifiex/sdio.h
> +++ b/drivers/net/wireless/mwifiex/sdio.h
> @@ -193,7 +193,7 @@
>  		a->mpa_tx.ports |= (1<<(a->mpa_tx.pkt_cnt+1+(MAX_PORT -	\
>  						a->mp_end_port)));	\
>  	a->mpa_tx.pkt_cnt++;						\
> -} while (0);
> +} while (0)
> 
>  /* SDIO Tx aggregation limit ? */
>  #define MP_TX_AGGR_PKT_LIMIT_REACHED(a)					\
> @@ -211,7 +211,7 @@
>  	a->mpa_tx.buf_len = 0;						\
>  	a->mpa_tx.ports = 0;						\
>  	a->mpa_tx.start_port = 0;					\
> -} while (0);
> +} while (0)
> 
>  /* SDIO Rx aggregation limit ? */
>  #define MP_RX_AGGR_PKT_LIMIT_REACHED(a)					\
> @@ -242,7 +242,7 @@
>  	a->mpa_rx.skb_arr[a->mpa_rx.pkt_cnt] = skb;			\
>  	a->mpa_rx.len_arr[a->mpa_rx.pkt_cnt] = skb->len;		\
>  	a->mpa_rx.pkt_cnt++;						\
> -} while (0);
> +} while (0)
> 
>  /* Reset SDIO Rx aggregation buffer parameters */
>  #define MP_RX_AGGR_BUF_RESET(a) do {					\
> @@ -250,7 +250,7 @@
>  	a->mpa_rx.buf_len = 0;						\
>  	a->mpa_rx.ports = 0;						\
>  	a->mpa_rx.start_port = 0;					\
> -} while (0);
> +} while (0)
> 
> 
>  /* data structure for SDIO MPA TX */
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
> b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
> index efb9ab2..c4adb97 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192ce/trx.h
> @@ -530,12 +530,7 @@
>  	SET_BITS_OFFSET_LE(__pdesc+28, 0, 32, __val)
> 
>  #define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)	\
> -do {							\
> -	if (_size > TX_DESC_NEXT_DESC_OFFSET)		\
> -		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
> -	else						\
> -		memset(__pdesc, 0, _size);	\
> -} while (0);
> +	memset(__pdesc, 0, min_t(size_t, _size, TX_DESC_NEXT_DESC_OFFSET))
> 
>  struct rx_fwinfo_92c {
>  	u8 gain_trsw[4];
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
> b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
> index 0dc736c..057a524 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192de/trx.h
> @@ -530,12 +530,8 @@
>  	SET_BITS_OFFSET_LE(__pdesc+28, 0, 32, __val)
> 
>  #define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)	\
> -do {							\
> -	if (_size > TX_DESC_NEXT_DESC_OFFSET)		\
> -		memset((void *)__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
> -	else						\
> -		memset((void *)__pdesc, 0, _size);	\
> -} while (0);
> +	memset((void *)__pdesc, 0,			\
> +	       min_t(size_t, _size, TX_DESC_NEXT_DESC_OFFSET))
> 
>  /* For 92D early mode */
>  #define SET_EARLYMODE_PKTNUM(__paddr, __value)		\
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> index d1b0a1e..20afec6 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/def.h
> @@ -252,12 +252,7 @@
>   * the desc is cleared. */
>  #define	TX_DESC_NEXT_DESC_OFFSET			36
>  #define CLEAR_PCI_TX_DESC_CONTENT(__pdesc, _size)		\
> -do {								\
> -	if (_size > TX_DESC_NEXT_DESC_OFFSET)			\
> -		memset(__pdesc, 0, TX_DESC_NEXT_DESC_OFFSET);	\
> -	else							\
> -		memset(__pdesc, 0, _size);			\
> -} while (0);
> +	memset(__pdesc, 0, min_t(size_t, _size, TX_DESC_NEXT_DESC_OFFSET))
> 
>  /* Rx Desc */
>  #define RX_STATUS_DESC_SIZE				24
> diff --git a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> index b4afff6..d53f433 100644
> --- a/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> +++ b/drivers/net/wireless/rtlwifi/rtl8192se/fw.h
> @@ -345,7 +345,7 @@ enum fw_h2c_cmd {
>  	do {							\
>  		udelay(1000);					\
>  		rtlpriv->rtlhal.fwcmd_iomap &= (~_Bit);		\
> -	} while (0);
> +	} while (0)
> 
>  #define FW_CMD_IO_UPDATE(rtlpriv, _val)				\
>  	rtlpriv->rtlhal.fwcmd_iomap = _val;
> @@ -354,13 +354,13 @@ enum fw_h2c_cmd {
>  	do {							\
>  		rtl_write_word(rtlpriv, LBUS_MON_ADDR, (u16)_val);	\
>  		FW_CMD_IO_UPDATE(rtlpriv, _val);		\
> -	} while (0);
> +	} while (0)
> 
>  #define FW_CMD_PARA_SET(rtlpriv, _val)				\
>  	do {							\
>  		rtl_write_dword(rtlpriv, LBUS_ADDR_MASK, _val);	\
>  		rtlpriv->rtlhal.fwcmd_ioparam = _val;		\
> -	} while (0);
> +	} while (0)
> 
>  #define FW_CMD_IO_QUERY(rtlpriv)				\
>  	(u16)(rtlpriv->rtlhal.fwcmd_iomap)
> 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

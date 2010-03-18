Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752864Ab0CRRFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 13:05:42 -0400
Received: from courier.cs.helsinki.fi ([128.214.9.1]:39299 "EHLO
	mail.cs.helsinki.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751035Ab0CRRFk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 13:05:40 -0400
Message-ID: <4BA25348.1080308@cs.helsinki.fi>
Date: Thu, 18 Mar 2010 18:22:32 +0200
From: Pekka Enberg <penberg@cs.helsinki.fi>
User-Agent: Thunderbird 2.0.0.24 (Macintosh/20100228)
MIME-Version: 1.0
To: Lars Lindley <lindley@coyote.org>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: localpara.h whitespace and indentation
 fixes.
References: <1268727716-20422-1-git-send-email-lindley@coyote.org>
In-Reply-To: <1268727716-20422-1-git-send-email-lindley@coyote.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lars Lindley wrote:
> +/* refer Bitmap2RateValue table */
> +#define LOCAL_ALL_SUPPORTED_RATES_BITMAP	0x130c1a66 /*
> +							    * the bitmap value
> +							    * of all the H/W
> +							    * supported rates:
> +							    * 1, 2, 5.5, 11,
> +							    * 6, 9, 12, 18,
> +							    * 24, 36, 48, 54
> +							    */
> +#define LOCAL_OFDM_SUPPORTED_RATES_BITMAP	0x130c1240 /*
> +							    * the bitmap value
> +							    * of all the H/W
> +							    * supported rates
> +							    * except to non-OFDM
> +							    * rates:
> +							    * 6, 9, 12, 18,
> +							    * 24, 36, 48, 54
> +							    */

The comments look funny. You might want to move them above the #defines.

> +struct wb_local_para {
> +	/* read from EPROM, manufacture set for each NetCard */
> +	u8	PermanentAddress[MAC_ADDR_LENGTH + 2];
> +	/* the driver will use this one actually. */
> +	u8	ThisMacAddress[MAC_ADDR_LENGTH + 2];
> +	u32	MTUsize;	/* Ind to Uplayer, Max transmission unit size */
> +	u8	region_INF;	/* region setting from INF */
> +	u8	region;		/* real region setting of the device */
> +	u8	Reserved_1[2];
> +
> +/* power-save variables */

I think this wants to be moved one indentation level to the right.

> +	u8	iPowerSaveMode; /* 0 indicates on, 1 indicates off */
> +	u8	ATIMmode;
> +	u8	ExcludeUnencrypted;
> +	/* Unit ime count for the decision to enter PS mode */
> +	u16	CheckCountForPS;
> +	u8	boHasTxActivity;/* tx activity has occurred */
> +	u8	boMacPsValid;	/* Power save mode obtained from H/W is valid or not */
> +
> +/* Rate */

ditto

> +	u8	TxRateMode; /*
> +			     * Initial, input from Registry,
> +			     * may be updated by GUI
> +			     * Tx Rate Mode: auto(DTO on), max, 1M, 2M, ..
> +			     */
> +	u8	CurrentTxRate;		/* The current Tx rate */
> +	u8	CurrentTxRateForMng;	/*
> +					 * The current Tx rate for management
> +					 * frames. It will be decided before
> +					 * connection succeeds.
> +					 */
> +	u8	CurrentTxFallbackRate;
> +
> +/* for Rate handler */

ditto

> +	u8	BRateSet[32];		/* basic rate set */
> +	u8	SRateSet[32];		/* support rate set */
> +
> +	u8	NumOfBRate;
> +	u8	NumOfSRate;
> +	u8	NumOfDsssRateInSRate;	/* number of DSSS rates in supported rate set */
> +	u8	reserved1;
> +
> +	u32	dwBasicRateBitmap;	/* bit map of basic rates */
> +
> +	u32	dwSupportRateBitmap;	/* bit map of all support rates including basic and operational rates */
> +
> +
> +/* For SME/MLME handler */

ditto

> +
> +	u16	wOldSTAindex;		/* valid when boHandover=TRUE, store old connected STA index */
> +	u16	wConnectedSTAindex;	/* Index of peerly connected AP or IBSS in the descriptionset. */
> +	u16	Association_ID;		/* The Association ID in the (Re)Association Response frame. */
> +	u16	ListenInterval;		/* The listen interval when SME invoking MLME_ (Re)Associate_Request(). */
> +
> +	struct	radio_off RadioOffStatus;
> +	u8	Reserved0[2];
> +	u8	boMsRadioOff;		/* Ndis demands to be true when set Disassoc. OID and be false when set SSID OID. */
> +	u8	bAntennaNo;		/* which antenna */
> +	u8	bConnectFlag;		/* the connect status flag for roaming task */
> +
> +	u8	RoamStatus;
> +	u8	reserved7[3];
> +
> +	struct	chan_info CurrentChan;	/* Current channel no. and channel band. It may be changed by scanning. */
> +	u8	boHandover;		/* Roaming, Hnadover to other AP. */
> +	u8	boCCAbusy;
> +
> +	u16	CWMax;			/* It may not be the real value that H/W used */
> +	u8	CWMin;			/* 255: set according to 802.11 spec. */
> +	u8	reserved2;
> +
> +/* 11G: */

ditto

> +	u8	bMacOperationMode;	/* operation in 802.11b or 802.11g */
> +	u8	bSlotTimeMode;		/* AUTO, s32 */
> +	u8	bPreambleMode;		/* AUTO, s32 */
> +	u8	boNonERPpresent;
> +
> +	u8	boProtectMechanism;	/* H/W will take the necessary action based on this variable */
> +	u8	boShortPreamble;	/* Same here */
> +	u8	boShortSlotTime;	/* Same here */
> +	u8	reserved_3;
> +
> +	u32	RSN_IE_Bitmap;
> +	u32	RSN_OUI_Type;
> +
> +/* For the BSSID */

ditto

> +	u8	HwBssid[MAC_ADDR_LENGTH + 2];
> +	u32	HwBssidValid;
> +
> +/* For scan list */

ditto

> +	u8	BssListCount;		/* Total count of valid descriptor indexes */
> +	u8	boReceiveUncorrectInfo;	/* important settings in beacon/probe resp. have been changed */
> +	u8	NoOfJoinerInIbss;
> +	u8	reserved_4;
> +
> +	/* Store the valid descriptor indexes obtained from scannings */
> +	u8	BssListIndex[(MAX_BSS_DESCRIPT_ELEMENT + 3) & ~0x03];
> +	/*
> +	 * Save the BssDescriptor index in this IBSS.
> +	 * The index 0 is local descriptor (psLOCAL->wConnectedSTAindex).
> +	 * If CONNECTED : NoOfJoinerInIbss >= 2
> +	 * else		: NoOfJoinerInIbss <= 1
> +	 */
> +	u8	JoinerInIbss[(MAX_BSS_DESCRIPT_ELEMENT + 3) & ~0x03];
> +
> +/* General Statistics, count at Rx_handler or Tx_callback interrupt handler */

ditto

> +	u64	GS_XMIT_OK;		/* Good Frames Transmitted */
> +	u64	GS_RCV_OK;		/* Good Frames Received */
> +	u32	GS_RCV_ERROR;		/* Frames received with crc error */
> +	u32	GS_XMIT_ERROR;		/* Bad Frames Transmitted */
> +	u32	GS_RCV_NO_BUFFER;	/* Receive Buffer underrun */
> +	u32	GS_XMIT_ONE_COLLISION;	/* one collision */
> +	u32	GS_XMIT_MORE_COLLISIONS;/* more collisions */
> +
> +/*
> + * ================================================================
> + * Statistics (no matter whether it had done successfully) -wkchen
> + * ================================================================
> + */

ditto

> +	u32	_NumRxMSDU;
> +	u32	_NumTxMSDU;
> +	u32	_dot11WEPExcludedCount;
> +	u32	_dot11WEPUndecryptableCount;
> +	u32	_dot11FrameDuplicateCount;
> +
> +	struct	chan_info IbssChanSetting;	/* 2B. Start IBSS Channel setting by registry or WWU. */
> +	u8	reserved_5[2];		/* It may not be used after considering RF type, region and modulation type. */
> +
> +	u8	reserved_6[2];		/* two variables are for wep key error detection */
> +	u32	bWepKeyError;
> +	u32	bToSelfPacketReceived;
> +	u32	WepKeyDetectTimerCount;
> +
> +	u16	SignalLostTh;
> +	u16	SignalRoamTh;
> +
>  	u8		IE_Append_data[MAX_IE_APPEND_SIZE];
>  	u16		IE_Append_size;
>  	u16		reserved_7;
> -
>  };
>  
>  #endif


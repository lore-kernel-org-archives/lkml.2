Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1K2B0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Nov 2011 20:26:46 -0500
Received: from mailout4.samsung.com ([203.254.224.34]:10114 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751402Ab1K2B0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Nov 2011 20:26:45 -0500
X-AuditID: cbfee611-b7c19ae000001aed-39-4ed4327a10f2
Date: Tue, 29 Nov 2011 01:26:44 +0000 (GMT)
From: MyungJoo Ham <myungjoo.ham@samsung.com>
Subject: Re: [PATCH 2/4] max17042: Align register definitions with data sheet
 and init appnote
To: "dirk.brandewie@gmail.com" <dirk.brandewie@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: "cbouatmailru@gmail.com" <cbouatmailru@gmail.com>,
        =?euc-kr?Q?=B1=E8=B5=BF=B1=D9?= <dg77.kim@samsung.com>,
        =?euc-kr?Q?=B9=DA=B0=E6=B9=CE?= <kyungmin.park@samsung.com>,
        "Jason.Wortham@maxim-ic.com" <Jason.Wortham@maxim-ic.com>,
        "alan@linux.intel.com" <alan@linux.intel.com>
Reply-to: myungjoo.ham@samsung.com
MIME-version: 1.0
X-MTR: 20111129012512876@myungjoo.ham
Msgkey: 20111129012512876@myungjoo.ham
X-EPLocale: ko_KR.euc-kr
X-Priority: 3
X-EPWebmail-Msg-Type: personal
X-EPWebmail-Reply-Demand: 0
X-EPApproval-Locale: 
X-EPHeader: ML
X-EPTrCode: 
X-EPTrName: 
X-MLAttribute: 
X-RootMTR: 20111129012512876@myungjoo.ham
X-ParentMTR: 
Content-type: text/plain; charset=euc-kr
MIME-version: 1.0
Message-id: <29933944.99561322530003472.JavaMail.weblogic@epml27>
DLP-Filter: Pass
X-Brightmail-Tracker: AAAAAQAAAZE=
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAT1Qskk003920

Sender : dirk.brandewie@gmail.com<dirk.brandewie@gmail.com>
Date : 2011-11-29 04:49 (GMT+09:00)
Title : [PATCH 2/4] max17042: Align register definitions with data sheet and init appnote
> 
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
> 
> align the register names with max17042 data sheet removing
> registers that are marked reserved that are not used.
> 
> Add register definitions defined in the maxim initialization appnote
> 
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>

Acked-by: MyungJoo Ham <myungjoo.ham@samsung.com>

> ---
> include/linux/power/max17042_battery.h |   37 ++++++++++++++++++++++++-------
> 1 files changed, 28 insertions(+), 9 deletions(-)
> 
> diff --git a/include/linux/power/max17042_battery.h b/include/linux/power/max17042_battery.h
> index fe99211..67eeada 100644
> --- a/include/linux/power/max17042_battery.h
> +++ b/include/linux/power/max17042_battery.h
> @@ -40,11 +40,11 @@ enum max17042_register {
> MAX17042_VCELL = 0x09,
> MAX17042_Current = 0x0A,
> MAX17042_AvgCurrent = 0x0B,
> - MAX17042_Qresidual = 0x0C,
> +
> MAX17042_SOC = 0x0D,
> MAX17042_AvSOC = 0x0E,
> MAX17042_RemCap = 0x0F,
> - MAX17402_FullCAP = 0x10,
> + MAX17042_FullCAP = 0x10,
> MAX17042_TTE = 0x11,
> MAX17042_V_empty = 0x12,
> 
> @@ -62,14 +62,14 @@ enum max17042_register {
> MAX17042_AvCap = 0x1F,
> MAX17042_ManName = 0x20,
> MAX17042_DevName = 0x21,
> - MAX17042_DevChem = 0x22,
> 
> + MAX17042_FullCAPNom = 0x23,
> MAX17042_TempNom = 0x24,
> - MAX17042_TempCold = 0x25,
> + MAX17042_TempLim = 0x25,
> MAX17042_TempHot = 0x26,
> MAX17042_AIN = 0x27,
> MAX17042_LearnCFG = 0x28,
> - MAX17042_SHFTCFG = 0x29,
> + MAX17042_FilterCFG = 0x29,
> MAX17042_RelaxCFG = 0x2A,
> MAX17042_MiscCFG = 0x2B,
> MAX17042_TGAIN = 0x2C,
> @@ -77,22 +77,41 @@ enum max17042_register {
> MAX17042_CGAIN = 0x2E,
> MAX17042_COFF = 0x2F,
> 
> - MAX17042_Q_empty = 0x33,
> + MAX17042_MaskSOC = 0x32,
> + MAX17042_SOC_empty = 0x33,
> MAX17042_T_empty = 0x34,
> 
> + MAX17042_FullCAP0       = 0x35,
> + MAX17042_LAvg_empty = 0x36,
> + MAX17042_FCTC = 0x37,
> MAX17042_RCOMP0 = 0x38,
> MAX17042_TempCo = 0x39,
> - MAX17042_Rx = 0x3A,
> - MAX17042_T_empty0 = 0x3B,
> + MAX17042_EmptyTempCo = 0x3A,
> + MAX17042_K_empty0 = 0x3B,
> MAX17042_TaskPeriod = 0x3C,
> MAX17042_FSTAT = 0x3D,
> 
> MAX17042_SHDNTIMER = 0x3F,
> 
> - MAX17042_VFRemCap = 0x4A,
> + MAX17042_dQacc = 0x45,
> + MAX17042_dPacc = 0x46,
> +
> + MAX17042_VFSOC0 = 0x48,
> 
> MAX17042_QH = 0x4D,
> MAX17042_QL = 0x4E,
> +
> + MAX17042_VFSOC0Enable = 0x60,
> + MAX17042_MLOCKReg1 = 0x62,
> + MAX17042_MLOCKReg2 = 0x63,
> +
> + MAX17042_MODELChrTbl = 0x80,
> +
> + MAX17042_OCV = 0xEE,
> +
> + MAX17042_OCVInternal = 0xFB,
> +
> + MAX17042_VFSOC = 0xFF,
> };
> 
> /*
> -- 
> 1.7.7.3
> 
> 




 MyungJoo Ham (ÇÔ¸íÁÖ)

Mobile Software Platform Lab,
Digital Media and Communications (DMC) Business
Samsung Electronics
cell: +82-10-6714-2858 / office: +82-31-279-8033



 

ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥

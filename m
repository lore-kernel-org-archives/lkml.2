Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852Ab0CUWaz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:30:55 -0400
Received: from smtprelay-h21.telenor.se ([195.54.99.196]:45542 "EHLO
	smtprelay-h21.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753799Ab0CUWax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:30:53 -0400
X-SENDER-IP: [83.226.249.129]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AldCAIs6pktT4vmBPGdsb2JhbACbOQwBAQEBNy2rZYxVhH0E
X-IronPort-AV: E=Sophos;i="4.51,284,1267398000"; 
   d="scan'208";a="53872969"
From: Lars Lindley <lindley@coyote.org>
To: gregkh@suse.de, greg@kroah.com, penberg@cs.helsinki.fi, pavel@ucw.cz
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
       Lars Lindley <lindley@coyote.org>
Subject: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
Date: Sun, 21 Mar 2010 23:30:58 +0100
Message-Id: <1269210658-9518-1-git-send-email-lindley@coyote.org>
X-Mailer: git-send-email 1.7.0.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I fixed the checkpatch things except a couple of long lines.
I also removed hungarian notation from the argument names
and some "commented away" code.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35reg_f.h |  104 ++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index d352bce..1c1e3d8 100644
--- a/drivers/staging/winbond/wb35reg_f.h
+++ b/drivers/staging/winbond/wb35reg_f.h
@@ -3,59 +3,63 @@
 
 #include "wbhal_s.h"
 
-//====================================
-// Interface function declare
-//====================================
-unsigned char Wb35Reg_initial(  struct hw_data * pHwData );
-void Uxx_power_on_procedure(  struct hw_data * pHwData );
-void Uxx_power_off_procedure(  struct hw_data * pHwData );
-void Uxx_ReadEthernetAddress(  struct hw_data * pHwData );
-void Dxx_initial(  struct hw_data * pHwData );
-void Mxx_initial(  struct hw_data * pHwData );
-void RFSynthesizer_initial(  struct hw_data * pHwData );
-//void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  s8 Channel );
-void RFSynthesizer_SwitchingChannel(  struct hw_data * pHwData,  struct chan_info Channel );
-void BBProcessor_initial(  struct hw_data * pHwData );
-void BBProcessor_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060613.1
-//void RF_RateChanging(  struct hw_data * pHwData,  u8 rate ); // 20060626.5.c Add
-u8 RFSynthesizer_SetPowerIndex(  struct hw_data * pHwData,  u8 PowerIndex );
-u8 RFSynthesizer_SetMaxim2828_24Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetMaxim2828_50Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetMaxim2827_24Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetMaxim2827_50Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetMaxim2825Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetAiroha2230Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetAiroha7230Power(  struct hw_data *,  u8 index );
-u8 RFSynthesizer_SetWinbond242Power(  struct hw_data *,  u8 index );
-void GetTxVgaFromEEPROM(  struct hw_data * pHwData );
-void EEPROMTxVgaAdjust(  struct hw_data * pHwData ); // 20060619.5 Add
-
-#define RFWriteControlData( _A, _V ) Wb35Reg_Write( _A, 0x0864, _V )
-
-void Wb35Reg_destroy(  struct hw_data * pHwData );
-
-unsigned char Wb35Reg_Read(  struct hw_data * pHwData,  u16 RegisterNo,   u32 * pRegisterValue );
-unsigned char Wb35Reg_ReadSync(  struct hw_data * pHwData,  u16 RegisterNo,   u32 * pRegisterValue );
-unsigned char Wb35Reg_Write(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue );
-unsigned char Wb35Reg_WriteSync(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue );
-unsigned char Wb35Reg_WriteWithCallbackValue(  struct hw_data * pHwData,
-								 u16 RegisterNo,
-								 u32 RegisterValue,
-								 s8 *pValue,
-								 s8 Len);
-unsigned char Wb35Reg_BurstWrite(  struct hw_data * pHwData,  u16 RegisterNo,  u32 * pRegisterData,  u8 NumberOfData,  u8 Flag );
-
-void Wb35Reg_EP0VM(  struct hw_data * pHwData );
-void Wb35Reg_EP0VM_start(  struct hw_data * pHwData );
+/*
+ * ====================================
+ * Interface function declare
+ * ====================================
+ */
+unsigned char Wb35Reg_initial(struct hw_data *HwData);
+void Uxx_power_on_procedure(struct hw_data *HwData);
+void Uxx_power_off_procedure(struct hw_data *HwData);
+void Uxx_ReadEthernetAddress(struct hw_data *HwData);
+void Dxx_initial(struct hw_data *HwData);
+void Mxx_initial(struct hw_data *HwData);
+void RFSynthesizer_initial(struct hw_data *HwData);
+void RFSynthesizer_SwitchingChannel(struct hw_data *HwData, struct chan_info Channel);
+void BBProcessor_initial(struct hw_data *HwData);
+void BBProcessor_RateChanging(struct hw_data *HwData, u8 rate);
+u8 RFSynthesizer_SetPowerIndex(struct hw_data *HwData, u8 PowerIndex);
+u8 RFSynthesizer_SetMaxim2828_24Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2828_50Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2827_24Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2827_50Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2825Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetAiroha2230Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetAiroha7230Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetWinbond242Power(struct hw_data *, u8 index);
+void GetTxVgaFromEEPROM(struct hw_data *HwData);
+void EEPROMTxVgaAdjust(struct hw_data *HwData);
+
+#define RFWriteControlData(_A, _V) Wb35Reg_Write(_A, 0x0864, _V)
+
+void Wb35Reg_destroy(struct hw_data *HwData);
+
+unsigned char Wb35Reg_Read(struct hw_data *HwData, u16 RegisterNo, u32 *RegisterValue);
+unsigned char Wb35Reg_ReadSync(struct hw_data *HwData, u16 RegisterNo, u32 *RegisterValue);
+unsigned char Wb35Reg_Write(struct hw_data *HwData, u16 RegisterNo, u32 RegisterValue);
+unsigned char Wb35Reg_WriteSync(struct hw_data *HwData, u16 RegisterNo, u32 RegisterValue);
+unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *HwData,
+							 u16 RegisterNo,
+							 u32 RegisterValue,
+							 s8 *Value,
+							 s8 Len);
+unsigned char Wb35Reg_BurstWrite(struct hw_data *HwData,
+					u16 RegisterNo,
+					u32 *RegisterData,
+					u8 NumberOfData,
+					u8 Flag);
+
+void Wb35Reg_EP0VM(struct hw_data *HwData);
+void Wb35Reg_EP0VM_start(struct hw_data *HwData);
 void Wb35Reg_EP0VM_complete(struct urb *urb);
 
-u32 BitReverse( u32 dwData, u32 DataLength);
+u32 BitReverse(u32 Data, u32 DataLength);
 
-void CardGetMulticastBit(   u8 Address[MAC_ADDR_LENGTH],  u8 *Byte,  u8 *Value );
-u32 CardComputeCrc(  u8 * Buffer,  u32 Length );
+void CardGetMulticastBit(u8 Address[MAC_ADDR_LENGTH], u8 *Byte, u8 *Value);
+u32 CardComputeCrc(u8 *Buffer, u32 Length);
 
-void Wb35Reg_phy_calibration(  struct hw_data * pHwData );
-void Wb35Reg_Update(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue );
-unsigned char adjust_TXVGA_for_iq_mag(  struct hw_data * pHwData );
+void Wb35Reg_phy_calibration(struct hw_data *HwData);
+void Wb35Reg_Update(struct hw_data *HwData, u16 RegisterNo, u32 RegisterValue);
+unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *HwData);
 
 #endif
-- 
1.7.0.2


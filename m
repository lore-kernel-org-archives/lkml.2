Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530Ab0CVKzZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 06:55:25 -0400
Received: from smtprelay-h12.telenor.se ([62.127.194.5]:59918 "EHLO
	smtprelay-h12.telenor.se" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab0CVKzX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 06:55:23 -0400
X-SENDER-IP: [83.226.248.59]
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Al1BACfppktT4vg7PGdsb2JhbACBO4QsgXeTWAEBAQE3uiqEfQQ
X-IronPort-AV: E=Sophos;i="4.51,286,1267398000"; 
   d="scan'208";a="54014397"
Message-ID: <4BA74CA2.7070305@coyote.org>
Date: Mon, 22 Mar 2010 11:55:30 +0100
From: Lars Lindley <lindley@coyote.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100322 Thunderbird/3.0.3
MIME-Version: 1.0
To: Pekka Enberg <penberg@cs.helsinki.fi>
CC: gregkh@suse.de, greg@kroah.com, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: winbond: wb35reg_f.h Coding style fixes.
References: <1269210658-9518-1-git-send-email-lindley@coyote.org>	 <4BA71949.9040809@cs.helsinki.fi> <4BA73C4C.4020708@coyote.org> <84144f021003220257k1bd88315x3eb21057b4696a8f@mail.gmail.com>
In-Reply-To: <84144f021003220257k1bd88315x3eb21057b4696a8f@mail.gmail.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-03-22 10:57, Pekka Enberg wrote:
> On Mon, Mar 22, 2010 at 11:45 AM, Lars Lindley <lindley@coyote.org> wrote:
>> On 2010-03-22 08:16, Pekka Enberg wrote:
>>>> +unsigned char Wb35Reg_initial(struct hw_data *HwData);
>>>
>>> Lets avoid CamelCase for the arguments so "hw_data" here, for example. I
>>> see the same thing elsewhere in this patch as well.
>>>
>> I thought struct hw_data *hw_data looked a bit confusing..Thats why I left
>> CamelCase alone for now. I can make it like that if you want..
> 
> Yes please.
> 


Here's a new patch against master that fixes CamelCase too.



[PATCH] staging: winbond: wb35reg_f.h Coding style fixes.

I fixed the checkpatch things except a couple of long lines.
I also removed hungarian notation and CamelCase from the argument names
and some "commented away" code.

Signed-off-by: Lars Lindley <lindley@coyote.org>
---
 drivers/staging/winbond/wb35reg_f.h |  104 ++++++++++++++++++-----------------
 1 files changed, 54 insertions(+), 50 deletions(-)

diff --git a/drivers/staging/winbond/wb35reg_f.h b/drivers/staging/winbond/wb35reg_f.h
index d352bce..bf23c10 100644
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
+unsigned char Wb35Reg_initial(struct hw_data *hw_data);
+void Uxx_power_on_procedure(struct hw_data *hw_data);
+void Uxx_power_off_procedure(struct hw_data *hw_data);
+void Uxx_ReadEthernetAddress(struct hw_data *hw_data);
+void Dxx_initial(struct hw_data *hw_data);
+void Mxx_initial(struct hw_data *hw_data);
+void RFSynthesizer_initial(struct hw_data *hw_data);
+void RFSynthesizer_SwitchingChannel(struct hw_data *hw_data, struct chan_info channel);
+void BBProcessor_initial(struct hw_data *hw_data);
+void BBProcessor_RateChanging(struct hw_data *hw_data, u8 rate);
+u8 RFSynthesizer_SetPowerIndex(struct hw_data *hw_data, u8 power_index);
+u8 RFSynthesizer_SetMaxim2828_24Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2828_50Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2827_24Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2827_50Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetMaxim2825Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetAiroha2230Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetAiroha7230Power(struct hw_data *, u8 index);
+u8 RFSynthesizer_SetWinbond242Power(struct hw_data *, u8 index);
+void GetTxVgaFromEEPROM(struct hw_data *hw_data);
+void EEPROMTxVgaAdjust(struct hw_data *hw_data);
+
+#define RFWriteControlData(_A, _V) Wb35Reg_Write(_A, 0x0864, _V)
+
+void Wb35Reg_destroy(struct hw_data *hw_data);
+
+unsigned char Wb35Reg_Read(struct hw_data *hw_data, u16 register_no, u32 *register_value);
+unsigned char Wb35Reg_ReadSync(struct hw_data *hw_data, u16 register_no, u32 *register_value);
+unsigned char Wb35Reg_Write(struct hw_data *hw_data, u16 register_no, u32 register_value);
+unsigned char Wb35Reg_WriteSync(struct hw_data *hw_data, u16 register_no, u32 register_value);
+unsigned char Wb35Reg_WriteWithCallbackValue(struct hw_data *hw_data,
+							 u16 register_no,
+							 u32 register_value,
+							 s8 *value,
+							 s8 len);
+unsigned char Wb35Reg_BurstWrite(struct hw_data *hw_data,
+					u16 register_no,
+					u32 *register_data,
+					u8 number_of_data,
+					u8 flag);
+
+void Wb35Reg_EP0VM(struct hw_data *hw_data);
+void Wb35Reg_EP0VM_start(struct hw_data *hw_data);
 void Wb35Reg_EP0VM_complete(struct urb *urb);
 
-u32 BitReverse( u32 dwData, u32 DataLength);
+u32 BitReverse(u32 data, u32 data_length);
 
-void CardGetMulticastBit(   u8 Address[MAC_ADDR_LENGTH],  u8 *Byte,  u8 *Value );
-u32 CardComputeCrc(  u8 * Buffer,  u32 Length );
+void CardGetMulticastBit(u8 address[MAC_ADDR_LENGTH], u8 *byte, u8 *value);
+u32 CardComputeCrc(u8 *buffer, u32 length);
 
-void Wb35Reg_phy_calibration(  struct hw_data * pHwData );
-void Wb35Reg_Update(  struct hw_data * pHwData,  u16 RegisterNo,  u32 RegisterValue );
-unsigned char adjust_TXVGA_for_iq_mag(  struct hw_data * pHwData );
+void Wb35Reg_phy_calibration(struct hw_data *hw_data);
+void Wb35Reg_Update(struct hw_data *hw_data, u16 register_no, u32 register_value);
+unsigned char adjust_TXVGA_for_iq_mag(struct hw_data *hw_data);
 
 #endif
-- 
1.7.0.2

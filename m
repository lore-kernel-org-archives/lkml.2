Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753263Ab2CPEWq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 00:22:46 -0400
Received: from haggis.pcug.org.au ([203.10.76.10]:59349 "EHLO
	members.tip.net.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752479Ab2CPEWi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 00:22:38 -0400
Date: Fri, 16 Mar 2012 15:22:08 +1100
From: Stephen Rothwell <sfr@canb.auug.org.au>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH 5/5] powerpc: remove the rest of the legacy iSeries include
 files
Message-Id: <20120316152208.64f5942df793415b5d35b24e@canb.auug.org.au>
In-Reply-To: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
References: <20120316151459.dab3cdcc2d5984b05e2d2b5c@canb.auug.org.au>
X-Mailer: Sylpheed 3.2.0beta6 (GTK+ 2.24.10; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature";
 micalg="PGP-SHA256";
 boundary="Signature=_Fri__16_Mar_2012_15_22_08_+1100_.PDmKV=tc4HP2WC8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Signature=_Fri__16_Mar_2012_15_22_08_+1100_.PDmKV=tc4HP2WC8
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

since they are not referenced any more.

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
---
 arch/powerpc/include/asm/iseries/alpaca.h       |   31 ------
 arch/powerpc/include/asm/iseries/hv_call.h      |  111 --------------------
 arch/powerpc/include/asm/iseries/hv_call_sc.h   |   50 ---------
 arch/powerpc/include/asm/iseries/hv_call_xm.h   |   61 -----------
 arch/powerpc/include/asm/iseries/hv_lp_config.h |  128 -------------------=
----
 arch/powerpc/include/asm/iseries/hv_types.h     |  112 --------------------
 arch/powerpc/include/asm/iseries/it_lp_queue.h  |   78 --------------
 arch/powerpc/include/asm/iseries/lpar_map.h     |   85 ---------------
 arch/powerpc/include/asm/iseries/mf.h           |   51 ---------
 9 files changed, 0 insertions(+), 707 deletions(-)
 delete mode 100644 arch/powerpc/include/asm/iseries/alpaca.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_sc.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_call_xm.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_lp_config.h
 delete mode 100644 arch/powerpc/include/asm/iseries/hv_types.h
 delete mode 100644 arch/powerpc/include/asm/iseries/it_lp_queue.h
 delete mode 100644 arch/powerpc/include/asm/iseries/lpar_map.h
 delete mode 100644 arch/powerpc/include/asm/iseries/mf.h

diff --git a/arch/powerpc/include/asm/iseries/alpaca.h b/arch/powerpc/inclu=
de/asm/iseries/alpaca.h
deleted file mode 100644
index c0cce67..0000000
--- a/arch/powerpc/include/asm/iseries/alpaca.h
+++ /dev/null
@@ -1,31 +0,0 @@
-/*
- * Copyright =C2=A9 2008  Stephen Rothwell IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_ALPACA_H
-#define _ASM_POWERPC_ISERIES_ALPACA_H
-
-/*
- * This is the part of the paca that the iSeries hypervisor
- * needs to be statically initialised. Immediately after boot
- * we switch to the normal Linux paca.
- */
-struct alpaca {
-	struct lppaca *lppaca_ptr;	/* Pointer to LpPaca for PLIC */
-	const void *reg_save_ptr;	/* Pointer to LpRegSave for PLIC */
-};
-
-#endif /* _ASM_POWERPC_ISERIES_ALPACA_H */
diff --git a/arch/powerpc/include/asm/iseries/hv_call.h b/arch/powerpc/incl=
ude/asm/iseries/hv_call.h
deleted file mode 100644
index 162d653..0000000
--- a/arch/powerpc/include/asm/iseries/hv_call.h
+++ /dev/null
@@ -1,111 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- *
- * This file contains the "hypervisor call" interface which is used to
- * drive the hypervisor from the OS.
- */
-#ifndef _ASM_POWERPC_ISERIES_HV_CALL_H
-#define _ASM_POWERPC_ISERIES_HV_CALL_H
-
-#include <asm/iseries/hv_call_sc.h>
-#include <asm/iseries/hv_types.h>
-#include <asm/paca.h>
-
-/* Type of yield for HvCallBaseYieldProcessor */
-#define HvCall_YieldTimed	0	/* Yield until specified time (tb) */
-#define HvCall_YieldToActive	1	/* Yield until all active procs have run */
-#define HvCall_YieldToProc	2	/* Yield until the specified processor has ru=
n */
-
-/* interrupt masks for setEnabledInterrupts */
-#define HvCall_MaskIPI		0x00000001
-#define HvCall_MaskLpEvent	0x00000002
-#define HvCall_MaskLpProd	0x00000004
-#define HvCall_MaskTimeout	0x00000008
-
-/* Log buffer formats */
-#define HvCall_LogBuffer_ASCII          0
-#define HvCall_LogBuffer_EBCDIC         1
-
-#define HvCallBaseAckDeferredInts			HvCallBase +  0
-#define HvCallBaseCpmPowerOff				HvCallBase +  1
-#define HvCallBaseGetHwPatch				HvCallBase +  2
-#define HvCallBaseReIplSpAttn				HvCallBase +  3
-#define HvCallBaseSetASR				HvCallBase +  4
-#define HvCallBaseSetASRAndRfi				HvCallBase +  5
-#define HvCallBaseSetIMR				HvCallBase +  6
-#define HvCallBaseSendIPI				HvCallBase +  7
-#define HvCallBaseTerminateMachine			HvCallBase +  8
-#define HvCallBaseTerminateMachineSrc			HvCallBase +  9
-#define HvCallBaseProcessPlicInterrupts			HvCallBase + 10
-#define HvCallBaseIsPrimaryCpmOrMsdIpl			HvCallBase + 11
-#define HvCallBaseSetVirtualSIT				HvCallBase + 12
-#define HvCallBaseVaryOffThisProcessor			HvCallBase + 13
-#define HvCallBaseVaryOffMemoryChunk			HvCallBase + 14
-#define HvCallBaseVaryOffInteractivePercentage		HvCallBase + 15
-#define HvCallBaseSendLpProd				HvCallBase + 16
-#define HvCallBaseSetEnabledInterrupts			HvCallBase + 17
-#define HvCallBaseYieldProcessor			HvCallBase + 18
-#define HvCallBaseVaryOffSharedProcUnits		HvCallBase + 19
-#define HvCallBaseSetVirtualDecr			HvCallBase + 20
-#define HvCallBaseClearLogBuffer			HvCallBase + 21
-#define HvCallBaseGetLogBufferCodePage			HvCallBase + 22
-#define HvCallBaseGetLogBufferFormat			HvCallBase + 23
-#define HvCallBaseGetLogBufferLength			HvCallBase + 24
-#define HvCallBaseReadLogBuffer				HvCallBase + 25
-#define HvCallBaseSetLogBufferFormatAndCodePage		HvCallBase + 26
-#define HvCallBaseWriteLogBuffer			HvCallBase + 27
-#define HvCallBaseRouter28				HvCallBase + 28
-#define HvCallBaseRouter29				HvCallBase + 29
-#define HvCallBaseRouter30				HvCallBase + 30
-#define HvCallBaseSetDebugBus				HvCallBase + 31
-
-#define HvCallCcSetDABR					HvCallCc + 7
-
-static inline void HvCall_setVirtualDecr(void)
-{
-	/*
-	 * Ignore any error return codes - most likely means that the
-	 * target value for the LP has been increased and this vary off
-	 * would bring us below the new target.
-	 */
-	HvCall0(HvCallBaseSetVirtualDecr);
-}
-
-static inline void HvCall_yieldProcessor(unsigned typeOfYield, u64 yieldPa=
rm)
-{
-	HvCall2(HvCallBaseYieldProcessor, typeOfYield, yieldParm);
-}
-
-static inline void HvCall_setEnabledInterrupts(u64 enabledInterrupts)
-{
-	HvCall1(HvCallBaseSetEnabledInterrupts, enabledInterrupts);
-}
-
-static inline void HvCall_setLogBufferFormatAndCodepage(int format,
-		u32 codePage)
-{
-	HvCall2(HvCallBaseSetLogBufferFormatAndCodePage, format, codePage);
-}
-
-extern void HvCall_writeLogBuffer(const void *buffer, u64 bufLen);
-
-static inline void HvCall_sendIPI(struct paca_struct *targetPaca)
-{
-	HvCall1(HvCallBaseSendIPI, targetPaca->paca_index);
-}
-
-#endif /* _ASM_POWERPC_ISERIES_HV_CALL_H */
diff --git a/arch/powerpc/include/asm/iseries/hv_call_sc.h b/arch/powerpc/i=
nclude/asm/iseries/hv_call_sc.h
deleted file mode 100644
index f5d2109..0000000
--- a/arch/powerpc/include/asm/iseries/hv_call_sc.h
+++ /dev/null
@@ -1,50 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_HV_CALL_SC_H
-#define _ASM_POWERPC_ISERIES_HV_CALL_SC_H
-
-#include <linux/types.h>
-
-#define HvCallBase		0x8000000000000000ul
-#define HvCallCc		0x8001000000000000ul
-#define HvCallCfg		0x8002000000000000ul
-#define HvCallEvent		0x8003000000000000ul
-#define HvCallHpt		0x8004000000000000ul
-#define HvCallPci		0x8005000000000000ul
-#define HvCallSm		0x8007000000000000ul
-#define HvCallXm		0x8009000000000000ul
-
-extern u64 HvCall0(u64);
-extern u64 HvCall1(u64, u64);
-extern u64 HvCall2(u64, u64, u64);
-extern u64 HvCall3(u64, u64, u64, u64);
-extern u64 HvCall4(u64, u64, u64, u64, u64);
-extern u64 HvCall5(u64, u64, u64, u64, u64, u64);
-extern u64 HvCall6(u64, u64, u64, u64, u64, u64, u64);
-extern u64 HvCall7(u64, u64, u64, u64, u64, u64, u64, u64);
-
-extern u64 HvCall0Ret16(u64, void *);
-extern u64 HvCall1Ret16(u64, void *, u64);
-extern u64 HvCall2Ret16(u64, void *, u64, u64);
-extern u64 HvCall3Ret16(u64, void *, u64, u64, u64);
-extern u64 HvCall4Ret16(u64, void *, u64, u64, u64, u64);
-extern u64 HvCall5Ret16(u64, void *, u64, u64, u64, u64, u64);
-extern u64 HvCall6Ret16(u64, void *, u64, u64, u64, u64, u64, u64);
-extern u64 HvCall7Ret16(u64, void *, u64, u64 ,u64 ,u64 ,u64 ,u64 ,u64);
-
-#endif /* _ASM_POWERPC_ISERIES_HV_CALL_SC_H */
diff --git a/arch/powerpc/include/asm/iseries/hv_call_xm.h b/arch/powerpc/i=
nclude/asm/iseries/hv_call_xm.h
deleted file mode 100644
index 392ac3f..0000000
--- a/arch/powerpc/include/asm/iseries/hv_call_xm.h
+++ /dev/null
@@ -1,61 +0,0 @@
-/*
- * This file contains the "hypervisor call" interface which is used to
- * drive the hypervisor from SLIC.
- */
-#ifndef _ASM_POWERPC_ISERIES_HV_CALL_XM_H
-#define _ASM_POWERPC_ISERIES_HV_CALL_XM_H
-
-#include <asm/iseries/hv_call_sc.h>
-#include <asm/iseries/hv_types.h>
-
-#define HvCallXmGetTceTableParms	HvCallXm +  0
-#define HvCallXmTestBus			HvCallXm +  1
-#define HvCallXmConnectBusUnit		HvCallXm +  2
-#define HvCallXmLoadTod			HvCallXm +  8
-#define HvCallXmTestBusUnit		HvCallXm +  9
-#define HvCallXmSetTce			HvCallXm + 11
-#define HvCallXmSetTces			HvCallXm + 13
-
-static inline void HvCallXm_getTceTableParms(u64 cb)
-{
-	HvCall1(HvCallXmGetTceTableParms, cb);
-}
-
-static inline u64 HvCallXm_setTce(u64 tceTableToken, u64 tceOffset, u64 tc=
e)
-{
-	return HvCall3(HvCallXmSetTce, tceTableToken, tceOffset, tce);
-}
-
-static inline u64 HvCallXm_setTces(u64 tceTableToken, u64 tceOffset,
-		u64 numTces, u64 tce1, u64 tce2, u64 tce3, u64 tce4)
-{
-	return HvCall7(HvCallXmSetTces, tceTableToken, tceOffset, numTces,
-			     tce1, tce2, tce3, tce4);
-}
-
-static inline u64 HvCallXm_testBus(u16 busNumber)
-{
-	return HvCall1(HvCallXmTestBus, busNumber);
-}
-
-static inline u64 HvCallXm_testBusUnit(u16 busNumber, u8 subBusNumber,
-		u8 deviceId)
-{
-	return HvCall2(HvCallXmTestBusUnit, busNumber,
-			(subBusNumber << 8) | deviceId);
-}
-
-static inline u64 HvCallXm_connectBusUnit(u16 busNumber, u8 subBusNumber,
-		u8 deviceId, u64 interruptToken)
-{
-	return HvCall5(HvCallXmConnectBusUnit, busNumber,
-			(subBusNumber << 8) | deviceId, interruptToken, 0,
-			0 /* HvLpConfig::mapDsaToQueueIndex(HvLpDSA(busNumber, xBoard, xCard)) =
*/);
-}
-
-static inline u64 HvCallXm_loadTod(void)
-{
-	return HvCall0(HvCallXmLoadTod);
-}
-
-#endif /* _ASM_POWERPC_ISERIES_HV_CALL_XM_H */
diff --git a/arch/powerpc/include/asm/iseries/hv_lp_config.h b/arch/powerpc=
/include/asm/iseries/hv_lp_config.h
deleted file mode 100644
index a006fd1..0000000
--- a/arch/powerpc/include/asm/iseries/hv_lp_config.h
+++ /dev/null
@@ -1,128 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_HV_LP_CONFIG_H
-#define _ASM_POWERPC_ISERIES_HV_LP_CONFIG_H
-
-/*
- * This file contains the interface to the LPAR configuration data
- * to determine which resources should be allocated to each partition.
- */
-
-#include <asm/iseries/hv_call_sc.h>
-#include <asm/iseries/hv_types.h>
-
-enum {
-	HvCallCfg_Cur	=3D 0,
-	HvCallCfg_Init	=3D 1,
-	HvCallCfg_Max	=3D 2,
-	HvCallCfg_Min	=3D 3
-};
-
-#define HvCallCfgGetSystemPhysicalProcessors		HvCallCfg +  6
-#define HvCallCfgGetPhysicalProcessors			HvCallCfg +  7
-#define HvCallCfgGetMsChunks				HvCallCfg +  9
-#define HvCallCfgGetSharedPoolIndex			HvCallCfg + 20
-#define HvCallCfgGetSharedProcUnits			HvCallCfg + 21
-#define HvCallCfgGetNumProcsInSharedPool		HvCallCfg + 22
-#define HvCallCfgGetVirtualLanIndexMap			HvCallCfg + 30
-#define HvCallCfgGetHostingLpIndex			HvCallCfg + 32
-
-extern HvLpIndex HvLpConfig_getLpIndex_outline(void);
-extern HvLpIndex HvLpConfig_getLpIndex(void);
-extern HvLpIndex HvLpConfig_getPrimaryLpIndex(void);
-
-static inline u64 HvLpConfig_getMsChunks(void)
-{
-	return HvCall2(HvCallCfgGetMsChunks, HvLpConfig_getLpIndex(),
-			HvCallCfg_Cur);
-}
-
-static inline u64 HvLpConfig_getSystemPhysicalProcessors(void)
-{
-	return HvCall0(HvCallCfgGetSystemPhysicalProcessors);
-}
-
-static inline u64 HvLpConfig_getNumProcsInSharedPool(HvLpSharedPoolIndex s=
PI)
-{
-	return (u16)HvCall1(HvCallCfgGetNumProcsInSharedPool, sPI);
-}
-
-static inline u64 HvLpConfig_getPhysicalProcessors(void)
-{
-	return HvCall2(HvCallCfgGetPhysicalProcessors, HvLpConfig_getLpIndex(),
-			HvCallCfg_Cur);
-}
-
-static inline HvLpSharedPoolIndex HvLpConfig_getSharedPoolIndex(void)
-{
-	return HvCall1(HvCallCfgGetSharedPoolIndex, HvLpConfig_getLpIndex());
-}
-
-static inline u64 HvLpConfig_getSharedProcUnits(void)
-{
-	return HvCall2(HvCallCfgGetSharedProcUnits, HvLpConfig_getLpIndex(),
-			HvCallCfg_Cur);
-}
-
-static inline u64 HvLpConfig_getMaxSharedProcUnits(void)
-{
-	return HvCall2(HvCallCfgGetSharedProcUnits, HvLpConfig_getLpIndex(),
-			HvCallCfg_Max);
-}
-
-static inline u64 HvLpConfig_getMaxPhysicalProcessors(void)
-{
-	return HvCall2(HvCallCfgGetPhysicalProcessors, HvLpConfig_getLpIndex(),
-			HvCallCfg_Max);
-}
-
-static inline HvLpVirtualLanIndexMap HvLpConfig_getVirtualLanIndexMapForLp(
-		HvLpIndex lp)
-{
-	/*
-	 * This is a new function in V5R1 so calls to this on older
-	 * hypervisors will return -1
-	 */
-	u64 retVal =3D HvCall1(HvCallCfgGetVirtualLanIndexMap, lp);
-	if (retVal =3D=3D -1)
-		retVal =3D 0;
-	return retVal;
-}
-
-static inline HvLpVirtualLanIndexMap HvLpConfig_getVirtualLanIndexMap(void)
-{
-	return HvLpConfig_getVirtualLanIndexMapForLp(
-			HvLpConfig_getLpIndex_outline());
-}
-
-static inline int HvLpConfig_doLpsCommunicateOnVirtualLan(HvLpIndex lp1,
-		HvLpIndex lp2)
-{
-	HvLpVirtualLanIndexMap virtualLanIndexMap1 =3D
-		HvLpConfig_getVirtualLanIndexMapForLp(lp1);
-	HvLpVirtualLanIndexMap virtualLanIndexMap2 =3D
-		HvLpConfig_getVirtualLanIndexMapForLp(lp2);
-	return ((virtualLanIndexMap1 & virtualLanIndexMap2) !=3D 0);
-}
-
-static inline HvLpIndex HvLpConfig_getHostingLpIndex(HvLpIndex lp)
-{
-	return HvCall1(HvCallCfgGetHostingLpIndex, lp);
-}
-
-#endif /* _ASM_POWERPC_ISERIES_HV_LP_CONFIG_H */
diff --git a/arch/powerpc/include/asm/iseries/hv_types.h b/arch/powerpc/inc=
lude/asm/iseries/hv_types.h
deleted file mode 100644
index c3e6d2a..0000000
--- a/arch/powerpc/include/asm/iseries/hv_types.h
+++ /dev/null
@@ -1,112 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_HV_TYPES_H
-#define _ASM_POWERPC_ISERIES_HV_TYPES_H
-
-/*
- * General typedefs for the hypervisor.
- */
-
-#include <asm/types.h>
-
-typedef u8	HvLpIndex;
-typedef u16	HvLpInstanceId;
-typedef u64	HvLpTOD;
-typedef u64	HvLpSystemSerialNum;
-typedef u8	HvLpDeviceSerialNum[12];
-typedef u16	HvLpSanHwSet;
-typedef u16	HvLpBus;
-typedef u16	HvLpBoard;
-typedef u16	HvLpCard;
-typedef u8	HvLpDeviceType[4];
-typedef u8	HvLpDeviceModel[3];
-typedef u64	HvIoToken;
-typedef u8	HvLpName[8];
-typedef u32	HvIoId;
-typedef u64	HvRealMemoryIndex;
-typedef u32	HvLpIndexMap;	/* Must hold HVMAXARCHITECTEDLPS bits!!! */
-typedef u16	HvLpVrmIndex;
-typedef u32	HvXmGenerationId;
-typedef u8	HvLpBusPool;
-typedef u8	HvLpSharedPoolIndex;
-typedef u16	HvLpSharedProcUnitsX100;
-typedef u8	HvLpVirtualLanIndex;
-typedef u16	HvLpVirtualLanIndexMap;	/* Must hold HVMAXARCHITECTEDVIRTUALLA=
NS bits!!! */
-typedef u16	HvBusNumber;	/* Hypervisor Bus Number */
-typedef u8	HvSubBusNumber;	/* Hypervisor SubBus Number */
-typedef u8	HvAgentId;	/* Hypervisor DevFn */
-
-
-#define HVMAXARCHITECTEDLPS		32
-#define HVMAXARCHITECTEDVIRTUALLANS	16
-#define HVMAXARCHITECTEDVIRTUALDISKS	32
-#define HVMAXARCHITECTEDVIRTUALCDROMS	8
-#define HVMAXARCHITECTEDVIRTUALTAPES	8
-#define HVCHUNKSIZE			(256 * 1024)
-#define HVPAGESIZE			(4 * 1024)
-#define HVLPMINMEGSPRIMARY		256
-#define HVLPMINMEGSSECONDARY		64
-#define HVCHUNKSPERMEG			4
-#define HVPAGESPERMEG			256
-#define HVPAGESPERCHUNK			64
-
-#define HvLpIndexInvalid		((HvLpIndex)0xff)
-
-/*
- * Enums for the sub-components under PLIC
- * Used in HvCall  and HvPrimaryCall
- */
-enum {
-	HvCallCompId =3D 0,
-	HvCallCpuCtlsCompId =3D 1,
-	HvCallCfgCompId =3D 2,
-	HvCallEventCompId =3D 3,
-	HvCallHptCompId =3D 4,
-	HvCallPciCompId =3D 5,
-	HvCallSlmCompId =3D 6,
-	HvCallSmCompId =3D 7,
-	HvCallSpdCompId =3D 8,
-	HvCallXmCompId =3D 9,
-	HvCallRioCompId =3D 10,
-	HvCallRsvd3CompId =3D 11,
-	HvCallRsvd2CompId =3D 12,
-	HvCallRsvd1CompId =3D 13,
-	HvCallMaxCompId =3D 14,
-	HvPrimaryCallCompId =3D 0,
-	HvPrimaryCallCfgCompId =3D 1,
-	HvPrimaryCallPciCompId =3D 2,
-	HvPrimaryCallSmCompId =3D 3,
-	HvPrimaryCallSpdCompId =3D 4,
-	HvPrimaryCallXmCompId =3D 5,
-	HvPrimaryCallRioCompId =3D 6,
-	HvPrimaryCallRsvd7CompId =3D 7,
-	HvPrimaryCallRsvd6CompId =3D 8,
-	HvPrimaryCallRsvd5CompId =3D 9,
-	HvPrimaryCallRsvd4CompId =3D 10,
-	HvPrimaryCallRsvd3CompId =3D 11,
-	HvPrimaryCallRsvd2CompId =3D 12,
-	HvPrimaryCallRsvd1CompId =3D 13,
-	HvPrimaryCallMaxCompId =3D HvCallMaxCompId
-};
-
-struct HvLpBufferList {
-	u64 addr;
-	u64 len;
-};
-
-#endif /* _ASM_POWERPC_ISERIES_HV_TYPES_H */
diff --git a/arch/powerpc/include/asm/iseries/it_lp_queue.h b/arch/powerpc/=
include/asm/iseries/it_lp_queue.h
deleted file mode 100644
index 4282788..0000000
--- a/arch/powerpc/include/asm/iseries/it_lp_queue.h
+++ /dev/null
@@ -1,78 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_IT_LP_QUEUE_H
-#define _ASM_POWERPC_ISERIES_IT_LP_QUEUE_H
-
-/*
- *	This control block defines the simple LP queue structure that is
- *	shared between the hypervisor (PLIC) and the OS in order to send
- *	events to an LP.
- */
-
-#include <asm/types.h>
-#include <asm/ptrace.h>
-
-#define IT_LP_MAX_QUEUES	8
-
-#define IT_LP_NOT_USED		0	/* Queue will not be used by PLIC */
-#define IT_LP_DEDICATED_IO	1	/* Queue dedicated to IO processor specified =
*/
-#define IT_LP_DEDICATED_LP	2	/* Queue dedicated to LP specified */
-#define IT_LP_SHARED		3	/* Queue shared for both IO and LP */
-
-#define IT_LP_EVENT_STACK_SIZE	4096
-#define IT_LP_EVENT_MAX_SIZE	256
-#define IT_LP_EVENT_ALIGN	64
-
-struct hvlpevent_queue {
-/*
- * The hq_current_event is the pointer to the next event stack entry
- * that will become valid.  The OS must peek at this entry to determine
- * if it is valid.  PLIC will set the valid indicator as the very last
- * store into that entry.
- *
- * When the OS has completed processing of the event then it will mark
- * the event as invalid so that PLIC knows it can store into that event
- * location again.
- *
- * If the event stack fills and there are overflow events, then PLIC
- * will set the hq_overflow_pending flag in which case the OS will
- * have to fetch the additional LP events once they have drained the
- * event stack.
- *
- * The first 16-bytes are known by both the OS and PLIC.  The remainder
- * of the cache line is for use by the OS.
- */
-	u8		hq_overflow_pending;	/* 0x00 Overflow events are pending */
-	u8		hq_status;		/* 0x01 DedicatedIo or DedicatedLp or NotUsed */
-	u16		hq_proc_index;		/* 0x02 Logical Proc Index for correlation */
-	u8		hq_reserved1[12];	/* 0x04 */
-	char		*hq_current_event;	/* 0x10 */
-	char		*hq_last_event;		/* 0x18 */
-	char		*hq_event_stack;	/* 0x20 */
-	u8		hq_index;		/* 0x28 unique sequential index. */
-	u8		hq_reserved2[3];	/* 0x29-2b */
-	spinlock_t	hq_lock;
-};
-
-extern struct hvlpevent_queue hvlpevent_queue;
-
-extern int hvlpevent_is_pending(void);
-extern void process_hvlpevents(void);
-extern void setup_hvlpevent_queue(void);
-
-#endif /* _ASM_POWERPC_ISERIES_IT_LP_QUEUE_H */
diff --git a/arch/powerpc/include/asm/iseries/lpar_map.h b/arch/powerpc/inc=
lude/asm/iseries/lpar_map.h
deleted file mode 100644
index 5e9f3e1..0000000
--- a/arch/powerpc/include/asm/iseries/lpar_map.h
+++ /dev/null
@@ -1,85 +0,0 @@
-/*
- * Copyright (C) 2001  Mike Corrigan IBM Corporation
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_LPAR_MAP_H
-#define _ASM_POWERPC_ISERIES_LPAR_MAP_H
-
-#ifndef __ASSEMBLY__
-
-#include <asm/types.h>
-
-#endif
-
-/*
- * The iSeries hypervisor will set up mapping for one or more
- * ESID/VSID pairs (in SLB/segment registers) and will set up
- * mappings of one or more ranges of pages to VAs.
- * We will have the hypervisor set up the ESID->VSID mapping
- * for the four kernel segments (C-F).  With shared processors,
- * the hypervisor will clear all segment registers and reload
- * these four whenever the processor is switched from one
- * partition to another.
- */
-
-/* The Vsid and Esid identified below will be used by the hypervisor
- * to set up a memory mapping for part of the load area before giving
- * control to the Linux kernel.  The load area is 64 MB, but this must
- * not attempt to map the whole load area.  The Hashed Page Table may
- * need to be located within the load area (if the total partition size
- * is 64 MB), but cannot be mapped.  Typically, this should specify
- * to map half (32 MB) of the load area.
- *
- * The hypervisor will set up page table entries for the number of
- * pages specified.
- *
- * In 32-bit mode, the hypervisor will load all four of the
- * segment registers (identified by the low-order four bits of the
- * Esid field.  In 64-bit mode, the hypervisor will load one SLB
- * entry to map the Esid to the Vsid.
-*/
-
-#define HvEsidsToMap	2
-#define HvRangesToMap	1
-
-/* Hypervisor initially maps 32MB of the load area */
-#define HvPagesToMap	8192
-
-#ifndef __ASSEMBLY__
-struct LparMap {
-	u64	xNumberEsids;	// Number of ESID/VSID pairs
-	u64	xNumberRanges;	// Number of VA ranges to map
-	u64	xSegmentTableOffs; // Page number within load area of seg table
-	u64	xRsvd[5];
-	struct {
-		u64	xKernelEsid;	// Esid used to map kernel load
-		u64	xKernelVsid;	// Vsid used to map kernel load
-	} xEsids[HvEsidsToMap];
-	struct {
-		u64	xPages;		// Number of pages to be mapped
-		u64	xOffset;	// Offset from start of load area
-		u64	xVPN;		// Virtual Page Number
-	} xRanges[HvRangesToMap];
-};
-
-extern const struct LparMap	xLparMap;
-
-#endif /* __ASSEMBLY__ */
-
-/* the fixed address where the LparMap exists */
-#define LPARMAP_PHYS		0x7000
-
-#endif /* _ASM_POWERPC_ISERIES_LPAR_MAP_H */
diff --git a/arch/powerpc/include/asm/iseries/mf.h b/arch/powerpc/include/a=
sm/iseries/mf.h
deleted file mode 100644
index eb851a9..0000000
--- a/arch/powerpc/include/asm/iseries/mf.h
+++ /dev/null
@@ -1,51 +0,0 @@
-/*
- * Copyright (C) 2001  Troy D. Armstrong IBM Corporation
- * Copyright (C) 2004  Stephen Rothwell IBM Corporation
- *
- * This modules exists as an interface between a Linux secondary partition
- * running on an iSeries and the primary partition's Virtual Service
- * Processor (VSP) object.  The VSP has final authority over powering on/o=
ff
- * all partitions in the iSeries.  It also provides miscellaneous low-level
- * machine facility type operations.
- *
- * This program is free software; you can redistribute it and/or modify
- * it under the terms of the GNU General Public License as published by
- * the Free Software Foundation; either version 2 of the License, or
- * (at your option) any later version.
- *
- * This program is distributed in the hope that it will be useful,
- * but WITHOUT ANY WARRANTY; without even the implied warranty of
- * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
- * GNU General Public License for more details.
- *
- * You should have received a copy of the GNU General Public License
- * along with this program; if not, write to the Free Software
- * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307 USA
- */
-#ifndef _ASM_POWERPC_ISERIES_MF_H
-#define _ASM_POWERPC_ISERIES_MF_H
-
-#include <linux/types.h>
-
-#include <asm/iseries/hv_types.h>
-#include <asm/iseries/hv_call_event.h>
-
-struct rtc_time;
-
-typedef void (*MFCompleteHandler)(void *clientToken, int returnCode);
-
-extern void mf_allocate_lp_events(HvLpIndex targetLp, HvLpEvent_Type type,
-		unsigned size, unsigned amount, MFCompleteHandler hdlr,
-		void *userToken);
-extern void mf_deallocate_lp_events(HvLpIndex targetLp, HvLpEvent_Type typ=
e,
-		unsigned count, MFCompleteHandler hdlr, void *userToken);
-
-extern void mf_power_off(void);
-extern void mf_reboot(char *cmd);
-
-extern void mf_display_src(u32 word);
-extern void mf_display_progress(u16 value);
-
-extern void mf_init(void);
-
-#endif /* _ASM_POWERPC_ISERIES_MF_H */
--=20
1.7.9.1

--=20
Cheers,
Stephen Rothwell                    sfr@canb.auug.org.au
http://www.canb.auug.org.au/~sfr/

--Signature=_Fri__16_Mar_2012_15_22_08_+1100_.PDmKV=tc4HP2WC8
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iQIcBAEBCAAGBQJPYr/wAAoJEECxmPOUX5FEJQQQAKOdSguZEP0Pe/guXiD23Imo
a5/XKb2bOHVAjbFZUrqgMgRd9MonBEgiPJSEvjxDXcFOiswz9hrqd+TbbyulTdei
nf2vpne+LxlduG8eVS7kj4y7C3seXhkPmPkvaGMWGjWkswRgbIKDFL3dm8PYI94d
TWrXYIDo3X7i0h+4ft/WZOcKnuHKjA+9RwCsiWyCqKB+gDN2fmByh1c2rujRrfhu
U0ykdSQhXLaCPMOR7fm6ECqNtiyMV0U3bJEcfbsScPhIGRSQKA7XKC823d2m5hHI
SuBDE9C2BeDA3abKofuO7oLa2BFd613Nss3zSJCJjmKTiLPN46Yqt1dnfgvkeLuK
h/MwFQcpO6ZNVz7cesWikzWQM+urrn2yrLPCsOKj/odUo5ohm2i58wW5UYWDr2uS
h8Mo9IYt1g3qkAEyPkZUrWTXWHz0uN9zGgt/NW51Ofq3UAySPdzO0/+zdEIKfnZ5
yjxEzVI3u3718VKSxer7maTUoo6VcVkWNE5jOrTzJtdL/xAIh6IxanGqJaeOAHR+
Prs4LNnol96KnilDlmVP+lqhbm46tel3vYKLOrxKsgGpzeljJgR1wWL1eOX5+mEK
2Dt1ymbOpR0o0+iTyBARPs9pSRy1MCt7BLOSthVZUhkuYnr+zfeYKpZDmQZ1B5Fa
JakfEMUCiGq2mFOME8rt
=tii5
-----END PGP SIGNATURE-----

--Signature=_Fri__16_Mar_2012_15_22_08_+1100_.PDmKV=tc4HP2WC8--

Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754187Ab0DYNnt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Apr 2010 09:43:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:43928 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754025Ab0DYNnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Apr 2010 09:43:45 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:in-reply-to:references
         :x-mailer:mime-version:content-type:content-transfer-encoding;
        b=WV4ivlmdW68UJw43zpFFEHUhlCQGldv9DdgRkG7PQThG2qrVYCmNefqm5JzGxXIASr
         XohKvbulFkkDILPU8Jb8r3wgaKo8TqDooLBM8FS9WwHFwEUzSim8FDDWRDMjP5eAk8Uo
         7IaGW563hMUuiS1ZIQ+87FGYPjFUvITGv9MzI=
Date: Sun, 25 Apr 2010 22:21:19 +0900
From: Yoichi Yuasa <yuasa@linux-mips.org>
To: Greg Kroah-Hartman <greg@kroah.com>
Cc: yuasa@linux-mips.org, Naren Sankar <nsankar@broadcom.com>,
       Jarod Wilson <jarod@wilsonet.com>, Scott Davilla <davilla@4pi.com>,
       Manu Abraham <abraham.manu@gmail.com>, linux-kernel@vger.kernel.org
Subject: [PATCH 02/11] staging: crystalhd: remove unused definitions in
 header files
Message-Id: <20100425222119.a16fbf30.yuasa@linux-mips.org>
In-Reply-To: <20100425221851.223dc284.yuasa@linux-mips.org>
References: <20100425221851.223dc284.yuasa@linux-mips.org>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Yoichi Yuasa <yuasa@linux-mips.org>
---
 drivers/staging/crystalhd/bc_dts_defs.h     |  313 +--------------------------
 drivers/staging/crystalhd/bc_dts_glob_lnx.h |   29 +---
 drivers/staging/crystalhd/crystalhd_hw.h    |    1 -
 drivers/staging/crystalhd/crystalhd_lnx.h   |    1 -
 drivers/staging/crystalhd/crystalhd_misc.c  |   21 --
 drivers/staging/crystalhd/crystalhd_misc.h  |    1 -
 6 files changed, 3 insertions(+), 363 deletions(-)

diff --git a/drivers/staging/crystalhd/bc_dts_defs.h b/drivers/staging/crystalhd/bc_dts_defs.h
index cd12605..e825312 100644
--- a/drivers/staging/crystalhd/bc_dts_defs.h
+++ b/drivers/staging/crystalhd/bc_dts_defs.h
@@ -62,38 +62,6 @@ typedef enum _BC_STATUS {
 	BC_STS_ERROR		= -1
 } BC_STATUS;
 
-/*------------------------------------------------------*
- *    Registry Key Definitions				*
- *------------------------------------------------------*/
-#define BC_REG_KEY_MAIN_PATH	"Software\\Broadcom\\MediaPC\\70010"
-#define BC_REG_KEY_FWPATH		"FirmwareFilePath"
-#define BC_REG_KEY_SEC_OPT		"DbgOptions"
-
-/*
- * Options:
- *
- *  b[5] = Enable RSA KEY in EEPROM Support
- *  b[6] = Enable Old PIB scheme. (0 = Use PIB with video scheme)
- *
- *  b[12] = Enable send message to NotifyIcon
- *
- */
-
-typedef enum _BC_SW_OPTIONS {
-	BC_OPT_DOSER_OUT_ENCRYPT	= BC_BIT(3),
-	BC_OPT_LINK_OUT_ENCRYPT		= BC_BIT(29),
-} BC_SW_OPTIONS;
-
-typedef struct _BC_REG_CONFIG{
-	uint32_t		DbgOptions;
-} BC_REG_CONFIG;
-
-#if defined(__KERNEL__) || defined(__LINUX_USER__)
-#else
-/* Align data structures */
-#define ALIGN(x)	__declspec(align(x))
-#endif
-
 /* mode
  * b[0]..b[7]	= _DtsDeviceOpenMode
  * b[8]		=  Load new FW
@@ -113,54 +81,9 @@ enum _DtsDeviceOpenMode {
 	DTS_HWINIT_MODE
 };
 
-/* To enable the filter to selectively enable/disable fixes or erratas */
-enum _DtsDeviceFixMode {
-	DTS_LOAD_NEW_FW		= BC_BIT(8),
-	DTS_LOAD_FILE_PLAY_FW	= BC_BIT(9),
-	DTS_DISK_FMT_BD		= BC_BIT(10),
-	/* b[11]-b[15] : Default output resolution */
-	DTS_SKIP_TX_CHK_CPB	= BC_BIT(16),
-	DTS_ADAPTIVE_OUTPUT_PER	= BC_BIT(17),
-	DTS_INTELLIMAP		= BC_BIT(18),
-	/* b[19]-b[21] : select clock frequency */
-	DTS_PLAYBACK_DROP_RPT_MODE = BC_BIT(22)
-};
-
-#define DTS_DFLT_RESOLUTION(x)	(x<<11)
-
-#define DTS_DFLT_CLOCK(x) (x<<19)
-
-/* F/W File Version corresponding to S/W Releases */
-enum _FW_FILE_VER {
-	/* S/W release: 02.04.02	F/W release 2.12.2.0 */
-	BC_FW_VER_020402 = ((12<<16) | (2<<8) | (0))
-};
-
-/*------------------------------------------------------*
- *    Stream Types for DtsOpenDecoder()			*
- *------------------------------------------------------*/
-enum _DtsOpenDecStreamTypes {
-	BC_STREAM_TYPE_ES		= 0,
-	BC_STREAM_TYPE_PES		= 1,
-	BC_STREAM_TYPE_TS		= 2,
-	BC_STREAM_TYPE_ES_TSTAMP	= 6,
-};
-
-/*------------------------------------------------------*
- *    Video Algorithms for DtsSetVideoParams()		*
- *------------------------------------------------------*/
-enum _DtsSetVideoParamsAlgo {
-	BC_VID_ALGO_H264		= 0,
-	BC_VID_ALGO_MPEG2		= 1,
-	BC_VID_ALGO_VC1			= 4,
-	BC_VID_ALGO_VC1MP		= 7,
-};
-
 /*------------------------------------------------------*
  *    MPEG Extension to the PPB				*
  *------------------------------------------------------*/
-#define BC_MPEG_VALID_PANSCAN		(1)
-
 typedef struct _BC_PIB_EXT_MPEG {
 	uint32_t	valid;
 	/* Always valid,  defaults to picture size if no
@@ -179,10 +102,6 @@ typedef struct _BC_PIB_EXT_MPEG {
 /*------------------------------------------------------*
  *    H.264 Extension to the PPB			*
  *------------------------------------------------------*/
-/* Bit definitions for 'other.h264.valid' field */
-#define H264_VALID_PANSCAN		(1)
-#define H264_VALID_SPS_CROP		(2)
-#define H264_VALID_VUI			(4)
 
 typedef struct _BC_PIB_EXT_H264 {
 	/* 'valid' specifies which fields (or sets of
@@ -213,7 +132,6 @@ typedef struct _BC_PIB_EXT_H264 {
 /*------------------------------------------------------*
  *    VC1 Extension to the PPB				*
  *------------------------------------------------------*/
-#define VC1_VALID_PANSCAN		(1)
 
 typedef struct _BC_PIB_EXT_VC1 {
 	uint32_t	valid;
@@ -236,133 +154,6 @@ typedef struct _BC_PIB_EXT_VC1 {
 /*------------------------------------------------------*
  *    Picture Information Block				*
  *------------------------------------------------------*/
-#if defined(_WIN32) || defined(_WIN64) || defined(__LINUX_USER__)
-/* Values for 'pulldown' field.  '0' means no pulldown information
- * was present for this picture. */
-enum {
-	vdecNoPulldownInfo	= 0,
-	vdecTop			= 1,
-	vdecBottom		= 2,
-	vdecTopBottom		= 3,
-	vdecBottomTop		= 4,
-	vdecTopBottomTop	= 5,
-	vdecBottomTopBottom	= 6,
-	vdecFrame_X2		= 7,
-	vdecFrame_X3		= 8,
-	vdecFrame_X1		= 9,
-	vdecFrame_X4		= 10,
-};
-
-/* Values for the 'frame_rate' field. */
-enum {
-	vdecFrameRateUnknown = 0,
-	vdecFrameRate23_97,
-	vdecFrameRate24,
-	vdecFrameRate25,
-	vdecFrameRate29_97,
-	vdecFrameRate30,
-	vdecFrameRate50,
-	vdecFrameRate59_94,
-	vdecFrameRate60,
-};
-
-/* Values for the 'aspect_ratio' field. */
-enum {
-	vdecAspectRatioUnknown = 0,
-	vdecAspectRatioSquare,
-	vdecAspectRatio12_11,
-	vdecAspectRatio10_11,
-	vdecAspectRatio16_11,
-	vdecAspectRatio40_33,
-	vdecAspectRatio24_11,
-	vdecAspectRatio20_11,
-	vdecAspectRatio32_11,
-	vdecAspectRatio80_33,
-	vdecAspectRatio18_11,
-	vdecAspectRatio15_11,
-	vdecAspectRatio64_33,
-	vdecAspectRatio160_99,
-	vdecAspectRatio4_3,
-	vdecAspectRatio16_9,
-	vdecAspectRatio221_1,
-	vdecAspectRatioOther = 255,
-};
-
-/* Values for the 'colour_primaries' field. */
-enum {
-	vdecColourPrimariesUnknown = 0,
-	vdecColourPrimariesBT709,
-	vdecColourPrimariesUnspecified,
-	vdecColourPrimariesReserved,
-	vdecColourPrimariesBT470_2M = 4,
-	vdecColourPrimariesBT470_2BG,
-	vdecColourPrimariesSMPTE170M,
-	vdecColourPrimariesSMPTE240M,
-	vdecColourPrimariesGenericFilm,
-};
-
-enum {
-	vdecRESOLUTION_CUSTOM	= 0x00000000, /* custom */
-	vdecRESOLUTION_480i	= 0x00000001, /* 480i */
-	vdecRESOLUTION_1080i	= 0x00000002, /* 1080i (1920x1080, 60i) */
-	vdecRESOLUTION_NTSC	= 0x00000003, /* NTSC (720x483, 60i) */
-	vdecRESOLUTION_480p	= 0x00000004, /* 480p (720x480, 60p) */
-	vdecRESOLUTION_720p	= 0x00000005, /* 720p (1280x720, 60p) */
-	vdecRESOLUTION_PAL1	= 0x00000006, /* PAL_1 (720x576, 50i) */
-	vdecRESOLUTION_1080i25	= 0x00000007, /* 1080i25 (1920x1080, 50i) */
-	vdecRESOLUTION_720p50	= 0x00000008, /* 720p50 (1280x720, 50p) */
-	vdecRESOLUTION_576p	= 0x00000009, /* 576p (720x576, 50p) */
-	vdecRESOLUTION_1080i29_97 = 0x0000000A, /* 1080i (1920x1080, 59.94i) */
-	vdecRESOLUTION_720p59_94  = 0x0000000B, /* 720p (1280x720, 59.94p) */
-	vdecRESOLUTION_SD_DVD	= 0x0000000C, /* SD DVD (720x483, 60i) */
-	vdecRESOLUTION_480p656	= 0x0000000D, /* 480p (720x480, 60p), output bus width 8 bit, clock 74.25MHz */
-	vdecRESOLUTION_1080p23_976 = 0x0000000E, /* 1080p23_976 (1920x1080, 23.976p) */
-	vdecRESOLUTION_720p23_976  = 0x0000000F, /* 720p23_976 (1280x720p, 23.976p) */
-	vdecRESOLUTION_240p29_97   = 0x00000010, /* 240p (1440x240, 29.97p ) */
-	vdecRESOLUTION_240p30	= 0x00000011, /* 240p (1440x240, 30p) */
-	vdecRESOLUTION_288p25	= 0x00000012, /* 288p (1440x288p, 25p) */
-	vdecRESOLUTION_1080p29_97 = 0x00000013, /* 1080p29_97 (1920x1080, 29.97p) */
-	vdecRESOLUTION_1080p30	= 0x00000014, /* 1080p30 (1920x1080, 30p) */
-	vdecRESOLUTION_1080p24	= 0x00000015, /* 1080p24 (1920x1080, 24p) */
-	vdecRESOLUTION_1080p25	= 0x00000016, /* 1080p25 (1920x1080, 25p) */
-	vdecRESOLUTION_720p24	= 0x00000017, /* 720p24 (1280x720, 25p) */
-	vdecRESOLUTION_720p29_97  = 0x00000018, /* 720p29.97 (1280x720, 29.97p) */
-	vdecRESOLUTION_480p23_976 = 0x00000019, /* 480p23.976 (720*480, 23.976) */
-	vdecRESOLUTION_480p29_97  = 0x0000001A, /* 480p29.976 (720*480, 29.97p) */
-	vdecRESOLUTION_576p25	= 0x0000001B, /* 576p25 (720*576, 25p) */
-	/* For Zero Frame Rate */
-	vdecRESOLUTION_480p0	= 0x0000001C, /* 480p (720x480, 0p) */
-	vdecRESOLUTION_480i0	= 0x0000001D, /* 480i (720x480, 0i) */
-	vdecRESOLUTION_576p0	= 0x0000001E, /* 576p (720x576, 0p) */
-	vdecRESOLUTION_720p0	= 0x0000001F, /* 720p (1280x720, 0p) */
-	vdecRESOLUTION_1080p0	= 0x00000020, /* 1080p (1920x1080, 0p) */
-	vdecRESOLUTION_1080i0	= 0x00000021, /* 1080i (1920x1080, 0i) */
-};
-
-/* Bit definitions for 'flags' field */
-#define VDEC_FLAG_EOS				(0x0004)
-
-#define VDEC_FLAG_FRAME				(0x0000)
-#define VDEC_FLAG_FIELDPAIR			(0x0008)
-#define VDEC_FLAG_TOPFIELD			(0x0010)
-#define VDEC_FLAG_BOTTOMFIELD			(0x0018)
-
-#define VDEC_FLAG_PROGRESSIVE_SRC		(0x0000)
-#define VDEC_FLAG_INTERLACED_SRC		(0x0020)
-#define VDEC_FLAG_UNKNOWN_SRC			(0x0040)
-
-#define VDEC_FLAG_BOTTOM_FIRST			(0x0080)
-#define VDEC_FLAG_LAST_PICTURE			(0x0100)
-
-#define VDEC_FLAG_PICTURE_META_DATA_PRESENT	(0x40000)
-
-#endif /* _WIN32 || _WIN64 */
-
-enum _BC_OUTPUT_FORMAT {
-	MODE420				= 0x0,
-	MODE422_YUY2			= 0x1,
-	MODE422_UYVY			= 0x2,
-};
 
 typedef struct _BC_PIC_INFO_BLOCK {
 	/* Common fields. */
@@ -389,108 +180,6 @@ typedef struct _BC_PIC_INFO_BLOCK {
 		BC_PIB_EXT_VC1	 vc1;
 	} other;
 
-} BC_PIC_INFO_BLOCK, *PBC_PIC_INFO_BLOCK;
-
-/*------------------------------------------------------*
- *    ProcOut Info					*
- *------------------------------------------------------*/
-/* Optional flags for ProcOut Interface.*/
-enum _POUT_OPTIONAL_IN_FLAGS_{
-	/* Flags from App to Device */
-	BC_POUT_FLAGS_YV12	  = 0x01,	/* Copy Data in YV12 format */
-	BC_POUT_FLAGS_STRIDE	  = 0x02,	/* Stride size is valid. */
-	BC_POUT_FLAGS_SIZE	  = 0x04,	/* Take size information from Application */
-	BC_POUT_FLAGS_INTERLACED  = 0x08,	/* copy only half the bytes */
-	BC_POUT_FLAGS_INTERLEAVED = 0x10,	/* interleaved frame */
-
-	/* Flags from Device to APP */
-	BC_POUT_FLAGS_FMT_CHANGE  = 0x10000,	/* Data is not VALID when this flag is set */
-	BC_POUT_FLAGS_PIB_VALID	  = 0x20000,	/* PIB Information valid */
-	BC_POUT_FLAGS_ENCRYPTED	  = 0x40000,	/* Data is encrypted. */
-	BC_POUT_FLAGS_FLD_BOT	  = 0x80000,	/* Bottom Field data */
-};
-
-#if defined(__KERNEL__) || defined(__LINUX_USER__)
-typedef BC_STATUS(*dts_pout_callback)(void  *shnd, uint32_t width, uint32_t height, uint32_t stride, void *pOut);
-#else
-typedef BC_STATUS(*dts_pout_callback)(void  *shnd, uint32_t width, uint32_t height, uint32_t stride, struct _BC_DTS_PROC_OUT *pOut);
-#endif
-
-/* Line 21 Closed Caption */
-/* User Data */
-#define MAX_UD_SIZE		1792	/* 1920 - 128 */
-
-typedef struct _BC_DTS_PROC_OUT {
-	uint8_t		*Ybuff;			/* Caller Supplied buffer for Y data */
-	uint32_t	YbuffSz;		/* Caller Supplied Y buffer size */
-	uint32_t	YBuffDoneSz;		/* Transferred Y datasize */
-
-	uint8_t		*UVbuff;		/* Caller Supplied buffer for UV data */
-	uint32_t	UVbuffSz;		/* Caller Supplied UV buffer size */
-	uint32_t	UVBuffDoneSz;		/* Transferred UV data size */
-
-	uint32_t	StrideSz;		/* Caller supplied Stride Size */
-	uint32_t	PoutFlags;		/* Call IN Flags */
-
-	uint32_t	discCnt;		/* Picture discontinuity count */
-
-	BC_PIC_INFO_BLOCK PicInfo;		/* Picture Information Block Data */
-
-	/* Line 21 Closed Caption */
-	/* User Data */
-	uint32_t	UserDataSz;
-	uint8_t		UserData[MAX_UD_SIZE];
-
-	void		*hnd;
-	dts_pout_callback AppCallBack;
-	uint8_t		DropFrames;
-	uint8_t		b422Mode;		/* Picture output Mode */
-	uint8_t		bPibEnc;		/* PIB encrypted */
-	uint8_t		bRevertScramble;
-
-} BC_DTS_PROC_OUT;
-
-typedef struct _BC_DTS_STATUS {
-	uint8_t		ReadyListCount;	/* Number of frames in ready list (reported by driver) */
-	uint8_t		FreeListCount;	/* Number of frame buffers free.  (reported by driver) */
-	uint8_t		PowerStateChange; /* Number of active state power transitions (reported by driver) */
-	uint8_t		reserved_[1];
-
-	uint32_t	FramesDropped;	/* Number of frames dropped.  (reported by DIL) */
-	uint32_t	FramesCaptured;	/* Number of frames captured. (reported by DIL) */
-	uint32_t	FramesRepeated;	/* Number of frames repeated. (reported by DIL) */
-
-	uint32_t	InputCount;	/* Times compressed video has been sent to the HW.
-					 * i.e. Successful DtsProcInput() calls (reported by DIL) */
-	uint64_t	InputTotalSize;	/* Amount of compressed video that has been sent to the HW.
-					 * (reported by DIL) */
-	uint32_t	InputBusyCount;	/* Times compressed video has attempted to be sent to the HW
-					 * but the input FIFO was full. (reported by DIL) */
-
-	uint32_t	PIBMissCount;	/* Amount of times a PIB is invalid. (reported by DIL) */
-
-	uint32_t	cpbEmptySize;	/* supported only for H.264, specifically changed for
-					 * Adobe. Report size of CPB buffer available.
-					 * Reported by DIL */
-	uint64_t	NextTimeStamp;	/* TimeStamp of the next picture that will be returned
-					 * by a call to ProcOutput. Added for Adobe. Reported
-					 * back from the driver */
-	uint8_t		reserved__[16];
-
-} BC_DTS_STATUS;
-
-#define BC_SWAP32(_v)			\
-	((((_v) & 0xFF000000)>>24)|	\
-	  (((_v) & 0x00FF0000)>>8)|	\
-	  (((_v) & 0x0000FF00)<<8)|	\
-	  (((_v) & 0x000000FF)<<24))
-
-#define WM_AGENT_TRAYICON_DECODER_OPEN	10001
-#define WM_AGENT_TRAYICON_DECODER_CLOSE	10002
-#define WM_AGENT_TRAYICON_DECODER_START	10003
-#define WM_AGENT_TRAYICON_DECODER_STOP	10004
-#define WM_AGENT_TRAYICON_DECODER_RUN	10005
-#define WM_AGENT_TRAYICON_DECODER_PAUSE	10006
-
+} BC_PIC_INFO_BLOCK;
 
 #endif	/* _BC_DTS_DEFS_H_ */
diff --git a/drivers/staging/crystalhd/bc_dts_glob_lnx.h b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
index b3125e3..cc8a2aa 100644
--- a/drivers/staging/crystalhd/bc_dts_glob_lnx.h
+++ b/drivers/staging/crystalhd/bc_dts_glob_lnx.h
@@ -28,31 +28,10 @@
 #ifndef _BC_DTS_GLOB_LNX_H_
 #define _BC_DTS_GLOB_LNX_H_
 
-#ifdef __LINUX_USER__
-#include <stdio.h>
-#include <stdlib.h>
-#include <unistd.h>
-#include <fcntl.h>
-#include <ctype.h>
-#include <string.h>
-#include <errno.h>
-#include <netdb.h>
-#include <sys/time.h>
-#include <time.h>
-#include <arpa/inet.h>
-#include <asm/param.h>
-#include <linux/ioctl.h>
-#include <sys/select.h>
-
-#define DRVIFLIB_INT_API
-
-#endif
-
 #include "bc_dts_defs.h"
 #include "bcm_70012_regs.h"	/* Link Register defs */
 
 #define CRYSTALHD_API_NAME	"crystalhd"
-#define CRYSTALHD_API_DEV_NAME	"/dev/crystalhd"
 
 /*
  * These are SW stack tunable parameters shared
@@ -82,17 +61,13 @@ typedef struct _BC_CMD_DEV_MEM {
 } BC_CMD_DEV_MEM;
 
 /* FW Passthrough command structure */
-enum _bc_fw_cmd_flags {
-	BC_FW_CMD_FLAGS_NONE	= 0,
-	BC_FW_CMD_PIB_QS	= 0x01,
-};
 
 typedef struct _BC_FW_CMD {
 	uint32_t		cmd[BC_MAX_FW_CMD_BUFF_SZ];
 	uint32_t		rsp[BC_MAX_FW_CMD_BUFF_SZ];
 	uint32_t		flags;
 	uint32_t		add_data;
-} BC_FW_CMD, *PBC_FW_CMD;
+} BC_FW_CMD;
 
 typedef struct _BC_HW_TYPE {
 	uint16_t		PciDevId;
@@ -163,7 +138,7 @@ typedef struct _BC_PROC_INPUT_ {
 	uint8_t			Encrypted;
 	uint8_t			Rsrd[2];
 	uint32_t		DramOffset;	/* For debug use only */
-} BC_PROC_INPUT, *PBC_PROC_INPUT;
+} BC_PROC_INPUT;
 
 typedef struct _BC_DEC_YUV_BUFFS {
 	uint32_t		b422Mode;
diff --git a/drivers/staging/crystalhd/crystalhd_hw.h b/drivers/staging/crystalhd/crystalhd_hw.h
index 1c6318e..7fd748f 100644
--- a/drivers/staging/crystalhd/crystalhd_hw.h
+++ b/drivers/staging/crystalhd/crystalhd_hw.h
@@ -34,7 +34,6 @@
 #define DMA_ENGINE_CNT		2
 #define MAX_PIB_Q_DEPTH		64
 #define MIN_PIB_Q_DEPTH		2
-#define WR_POINTER_OFF		4
 
 #define ASPM_L1_ENABLE		(BC_BIT(27))
 
diff --git a/drivers/staging/crystalhd/crystalhd_lnx.h b/drivers/staging/crystalhd/crystalhd_lnx.h
index d338ae9..e4cb6c7 100644
--- a/drivers/staging/crystalhd/crystalhd_lnx.h
+++ b/drivers/staging/crystalhd/crystalhd_lnx.h
@@ -90,7 +90,6 @@ struct crystalhd_adp {
 
 
 struct crystalhd_adp *chd_get_adp(void);
-void chd_set_log_level(struct crystalhd_adp *adp, char *arg);
 
 #endif
 
diff --git a/drivers/staging/crystalhd/crystalhd_misc.c b/drivers/staging/crystalhd/crystalhd_misc.c
index 587dcc4..15bfdc4 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.c
+++ b/drivers/staging/crystalhd/crystalhd_misc.c
@@ -1007,24 +1007,3 @@ void crystalhd_delete_elem_pool(struct crystalhd_adp *adp)
 
 	BCMLOG(BCMLOG_DBG, "released %d elem\n", dbg_cnt);
 }
-
-/*================ Debug support routines.. ================================*/
-void crystalhd_show_buffer(uint32_t off, uint8_t *buff, uint32_t dwcount)
-{
-	uint32_t i, k = 1;
-
-	for (i = 0; i < dwcount; i++) {
-		if (k == 1)
-			BCMLOG(BCMLOG_DATA, "0x%08X : ", off);
-
-		BCMLOG(BCMLOG_DATA, " 0x%08X ", *((uint32_t *)buff));
-
-		buff += sizeof(uint32_t);
-		off  += sizeof(uint32_t);
-		k++;
-		if ((i == dwcount - 1) || (k > 4)) {
-			BCMLOG(BCMLOG_DATA, "\n");
-			k = 1;
-		}
-	}
-}
diff --git a/drivers/staging/crystalhd/crystalhd_misc.h b/drivers/staging/crystalhd/crystalhd_misc.h
index a2aa6ad..3bf7b8c 100644
--- a/drivers/staging/crystalhd/crystalhd_misc.h
+++ b/drivers/staging/crystalhd/crystalhd_misc.h
@@ -190,7 +190,6 @@ extern void crystalhd_delete_elem_pool(struct crystalhd_adp *);
 
 
 /*================ Debug routines/macros .. ================================*/
-extern void crystalhd_show_buffer(uint32_t off, uint8_t *buff, uint32_t dwcount);
 
 enum _chd_log_levels {
 	BCMLOG_ERROR		= 0x80000000,	/* Don't disable this option */
-- 
1.7.1


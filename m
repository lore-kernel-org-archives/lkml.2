Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753270Ab1KIR3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Nov 2011 12:29:42 -0500
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:51027 "EHLO
	earthlight.etchedpixels.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753214Ab1KIR3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Nov 2011 12:29:40 -0500
Date: Wed, 9 Nov 2011 17:30:37 +0000
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Greg KH <greg@kroah.com>, Vinod Koul <vinod.koul@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: Staging clear up
Message-ID: <20111109173037.66bea268@lxorguk.ukuu.org.uk>
In-Reply-To: <20111109165829.GC4016@opensource.wolfsonmicro.com>
References: <20111108211656.29defdda@lxorguk.ukuu.org.uk>
	<20111109121329.GC21630@sirena.org.uk>
	<1320854413.32205.948.camel@vkoul-udesk3>
	<20111109164211.GA4016@opensource.wolfsonmicro.com>
	<20111109165518.GA13451@kroah.com>
	<20111109165829.GC4016@opensource.wolfsonmicro.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.7; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 9 Nov 2011 16:58:29 +0000
Mark Brown <broonie@opensource.wolfsonmicro.com> wrote:

> On Wed, Nov 09, 2011 at 08:55:18AM -0800, Greg KH wrote:
> > On Wed, Nov 09, 2011 at 04:42:12PM +0000, Mark Brown wrote:
> 
> > > Someone will need to fix the build breakage from peering at the headers
> > > from staging.
> 
> > What code is including header files from the staging tree in the rest of
> > the kernel?
> 
> The mainline ASoC driver for one of these Intel SoCs, can't remember
> which one.

Something like this I think

commit a0404920aea226d74043ea56aab06be25def5475
Author: Alan Cox <alan@linux.intel.com>
Date:   Tue Nov 8 21:13:00 2011 +0000

    mrst: Kill the sst audio driver
    
    The sst audio mode isn't exposed in the PC mode used by Oaktrail devices so
    it isn't in any products. The Medfield device has a similar audio layer but
    this is handled by the ALSA SoC driver so we don't need this driver any
    more.
    
    We have to move a couple of headers because soc was fishing in the staging
    directory when it shouldn't. I've pointed this out some months back and they
    did nothing so I'm doing it for them.
    
    Signed-off-by: Alan Cox <alan@linux.intel.com>

diff --git a/sound/soc/codecs/sn95031.c b/sound/soc/codecs/sn95031.c
index 0fc34c9..30f8c79 100644
--- a/sound/soc/codecs/sn95031.c
+++ b/sound/soc/codecs/sn95031.c
@@ -39,7 +39,7 @@
 #include <sound/initval.h>
 #include <sound/tlv.h>
 #include <sound/jack.h>
-#include "../../../drivers/staging/intel_sst/intel_sst.h"
+#include "../mid-x86/intel_sst.h"
 #include "sn95031.h"
 
 #define SN95031_RATES (SNDRV_PCM_RATE_8000_96000)
diff --git a/sound/soc/mid-x86/intel_sst.h b/sound/soc/mid-x86/intel_sst.h
new file mode 100644
index 0000000..9a189f8
--- /dev/null
+++ b/sound/soc/mid-x86/intel_sst.h
@@ -0,0 +1,153 @@
+#ifndef __INTEL_SST_H__
+#define __INTEL_SST_H__
+/*
+ *  intel_sst.h - Intel SST Driver for audio engine
+ *
+ *  Copyright (C) 2008-10 Intel Corporation
+ *  Authors:	Vinod Koul <vinod.koul@intel.com>
+ *		Harsha Priya <priya.harsha@intel.com>
+ *		Dharageswari R <dharageswari.r@intel.com>
+ *		KP Jeeja <jeeja.kp@intel.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This driver exposes the audio engine functionalities to the ALSA
+ *	and middleware.
+ *  This file is shared between the SST and MAD drivers
+ */
+#include "intel_sst_ioctl.h"
+#include <sound/jack.h>
+
+#define SST_CARD_NAMES "intel_mid_card"
+
+#define MFLD_MAX_HW_CH 4
+/* control list Pmic & Lpe */
+/* Input controls */
+enum port_status {
+	ACTIVATE = 1,
+	DEACTIVATE,
+};
+
+/* Card states */
+enum sst_card_states {
+	SND_CARD_UN_INIT = 0,
+	SND_CARD_INIT_DONE,
+};
+
+enum sst_controls {
+	SST_SND_ALLOC =			0x1000,
+	SST_SND_PAUSE =			0x1001,
+	SST_SND_RESUME =		0x1002,
+	SST_SND_DROP =			0x1003,
+	SST_SND_FREE =			0x1004,
+	SST_SND_BUFFER_POINTER =	0x1005,
+	SST_SND_STREAM_INIT =		0x1006,
+	SST_SND_START	 =		0x1007,
+	SST_SND_STREAM_PROCESS =	0x1008,
+	SST_CONTROL_BASE =		0x1000,
+	SST_ENABLE_RX_TIME_SLOT =	0x1009,
+	SST_SND_DEVICE_SUSPEND =	0x1010,
+	SST_VMIC_CHANNEL_SELECT =	0x1011,
+	SST_SND_DEVICE_RESUME =		0x1012,
+	SST_SND_DEVICE_RESUME_SYNC =	0x1013,
+	SST_MAX_CONTROLS =		0x1013,
+};
+
+enum SND_CARDS {
+	SND_FS = 0,
+	SND_MX,
+	SND_NC,
+	SND_MSIC
+};
+
+struct pcm_stream_info {
+	int str_id;
+	void *mad_substream;
+	void (*period_elapsed) (void *mad_substream);
+	unsigned long long buffer_ptr;
+	unsigned long long pcm_delay;
+	int sfreq;
+};
+
+struct snd_pmic_ops {
+	int card_status;
+	int master_mute;
+	int num_channel;
+	int input_dev_id;
+	int mute_status;
+	struct mutex lock;
+	int pb_on, pbhs_on;
+	int cap_on;
+	int output_dev_id;
+	int lineout_dev_id, line_out_names_cnt;
+	int prev_lineout_dev_id;
+	bool jack_interrupt_status;
+	void (*pmic_irq_cb) (void *cb_data, u8 value);
+	void (*pmic_irq_enable)(void *data);
+	int (*pmic_jack_enable) (void);
+	int (*pmic_get_mic_bias)(void *intelmaddata);
+	int (*pmic_set_headset_state)(int state);
+
+	unsigned int hw_dmic_map[MFLD_MAX_HW_CH];
+	unsigned int available_dmics;
+	int (*set_hw_dmic_route) (u8 index);
+
+	int gpio_amp;
+};
+
+extern void sst_mad_send_jack_report(struct snd_jack *jack,
+				     int buttonpressevent,
+				     int status);
+
+
+int intemad_set_headset_state(int state);
+int intelmad_get_mic_bias(void);
+
+struct intel_sst_pcm_control {
+	int (*open) (struct snd_sst_params *str_param);
+	int (*device_control) (int cmd, void *arg);
+	int (*close) (unsigned int str_id);
+};
+struct intel_sst_card_ops {
+	unsigned int  vendor_id;
+	struct intel_sst_pcm_control *pcm_control;
+};
+
+/* modified for generic access */
+struct sc_reg_access {
+	u16 reg_addr;
+	u8 value;
+	u8 mask;
+};
+enum sc_reg_access_type {
+	PMIC_READ = 0,
+	PMIC_WRITE,
+	PMIC_READ_MODIFY,
+};
+
+enum intel_sst_pll_mode {
+	SST_PLL_VOICE = 0x1,
+	SST_PLL_AUDIO = 0x2,
+	SST_PLL_AUDIENCE = 0x4,
+	SST_PLL_VIBRA1 = 0x8,
+	SST_PLL_VIBRA2 = 0x10,
+};
+
+int register_sst_card(struct intel_sst_card_ops *card);
+void unregister_sst_card(struct intel_sst_card_ops *card);
+int intel_sst_set_pll(unsigned int enable, enum intel_sst_pll_mode mode);
+#endif /* __INTEL_SST_H__ */
diff --git a/sound/soc/mid-x86/intel_sst_ioctl.h b/sound/soc/mid-x86/intel_sst_ioctl.h
new file mode 100644
index 0000000..34cd6cd
--- /dev/null
+++ b/sound/soc/mid-x86/intel_sst_ioctl.h
@@ -0,0 +1,446 @@
+#ifndef __INTEL_SST_IOCTL_H__
+#define __INTEL_SST_IOCTL_H__
+/*
+ *  intel_sst_ioctl.h - Intel SST Driver for audio engine
+ *
+ *  Copyright (C) 2008-10 Intel Corporation
+ *  Authors:	Vinod Koul <vinod.koul@intel.com>
+ *		Harsha Priya <priya.harsha@intel.com>
+ *		Dharageswari R <dharageswari.r@intel.com>
+ *		KP Jeeja <jeeja.kp@intel.com>
+ *  ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This program is free software; you can redistribute it and/or modify
+ *  it under the terms of the GNU General Public License as published by
+ *  the Free Software Foundation; version 2 of the License.
+ *
+ *  This program is distributed in the hope that it will be useful, but
+ *  WITHOUT ANY WARRANTY; without even the implied warranty of
+ *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
+ *  General Public License for more details.
+ *
+ *  You should have received a copy of the GNU General Public License along
+ *  with this program; if not, write to the Free Software Foundation, Inc.,
+ *  59 Temple Place, Suite 330, Boston, MA 02111-1307 USA.
+ *
+ * ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
+ *
+ *  This file defines all sst ioctls
+ */
+
+/* codec and post/pre processing related info */
+
+#include <linux/types.h>
+
+enum sst_codec_types {
+/*  AUDIO/MUSIC	CODEC Type Definitions */
+	SST_CODEC_TYPE_UNKNOWN = 0,
+	SST_CODEC_TYPE_PCM,	/* Pass through Audio codec */
+	SST_CODEC_TYPE_MP3,
+	SST_CODEC_TYPE_MP24,
+	SST_CODEC_TYPE_AAC,
+	SST_CODEC_TYPE_AACP,
+	SST_CODEC_TYPE_eAACP,
+	SST_CODEC_TYPE_WMA9,
+	SST_CODEC_TYPE_WMA10,
+	SST_CODEC_TYPE_WMA10P,
+	SST_CODEC_TYPE_RA,
+	SST_CODEC_TYPE_DDAC3,
+	SST_CODEC_TYPE_STEREO_TRUE_HD,
+	SST_CODEC_TYPE_STEREO_HD_PLUS,
+
+	/*  VOICE CODEC Type Definitions */
+	SST_CODEC_TYPE_VOICE_PCM = 0x21, /* Pass through voice codec */
+};
+
+enum sst_algo_types {
+	SST_CODEC_SRC = 0x64,
+	SST_CODEC_MIXER = 0x65,
+	SST_CODEC_DOWN_MIXER = 0x66,
+	SST_CODEC_VOLUME_CONTROL = 0x67,
+	SST_CODEC_OEM1 = 0xC8,
+	SST_CODEC_OEM2 = 0xC9,
+};
+
+enum snd_sst_stream_ops {
+	STREAM_OPS_PLAYBACK = 0,	/* Decode */
+	STREAM_OPS_CAPTURE,		/* Encode */
+	STREAM_OPS_PLAYBACK_DRM,	/* Play Audio/Voice */
+	STREAM_OPS_PLAYBACK_ALERT,	/* Play Audio/Voice */
+	STREAM_OPS_CAPTURE_VOICE_CALL,	/* CSV Voice recording */
+};
+
+enum stream_mode {
+	SST_STREAM_MODE_NONE = 0,
+	SST_STREAM_MODE_DNR = 1,
+	SST_STREAM_MODE_FNF = 2,
+	SST_STREAM_MODE_CAPTURE = 3
+};
+
+enum stream_type {
+	SST_STREAM_TYPE_NONE = 0,
+	SST_STREAM_TYPE_MUSIC = 1,
+	SST_STREAM_TYPE_NORMAL = 2,
+	SST_STREAM_TYPE_LONG_PB = 3,
+	SST_STREAM_TYPE_LOW_LATENCY = 4,
+};
+
+enum snd_sst_audio_device_type {
+	SND_SST_DEVICE_HEADSET = 1,
+	SND_SST_DEVICE_IHF,
+	SND_SST_DEVICE_VIBRA,
+	SND_SST_DEVICE_HAPTIC,
+	SND_SST_DEVICE_CAPTURE,
+};
+
+/* Firmware Version info */
+struct snd_sst_fw_version {
+	__u8 build;	/* build number*/
+	__u8 minor;	/* minor number*/
+	__u8 major;	/* major number*/
+	__u8 type; /* build type */
+};
+
+/* Port info structure */
+struct snd_sst_port_info {
+	__u16 port_type;
+	__u16 reserved;
+};
+
+/* Mixer info structure */
+struct snd_sst_mix_info {
+	__u16 max_streams;
+	__u16 reserved;
+};
+
+/* PCM Parameters */
+struct snd_pcm_params {
+	__u16 codec;	/* codec type */
+	__u8 num_chan;	/* 1=Mono, 2=Stereo */
+	__u8 pcm_wd_sz;	/* 16/24 - bit*/
+	__u32 reserved;	/* Bitrate in bits per second */
+	__u32 sfreq;	/* Sampling rate in Hz */
+	__u32 ring_buffer_size;
+	__u32 period_count;	/* period elapsed in samples*/
+	__u32 ring_buffer_addr;
+};
+
+/* MP3 Music Parameters Message */
+struct snd_mp3_params {
+	__u16 codec;
+	__u8  num_chan;	/* 1=Mono, 2=Stereo	*/
+	__u8  pcm_wd_sz; /* 16/24 - bit*/
+	__u32 brate; /* Use the hard coded value. */
+	__u32 sfreq; /* Sampling freq eg. 8000, 441000, 48000 */
+	__u8  crc_check; /* crc_check - disable (0) or enable (1) */
+	__u8  op_align; /* op align 0- 16 bit, 1- MSB, 2 LSB*/
+	__u16 reserved;	/* Unused */
+};
+
+#define AAC_BIT_STREAM_ADTS		0
+#define AAC_BIT_STREAM_ADIF		1
+#define AAC_BIT_STREAM_RAW		2
+
+/* AAC Music Parameters Message */
+struct snd_aac_params {
+	__u16 codec;
+	__u8 num_chan; /* 1=Mono, 2=Stereo*/
+	__u8 pcm_wd_sz; /* 16/24 - bit*/
+	__u32 brate;
+	__u32 sfreq; /* Sampling freq eg. 8000, 441000, 48000 */
+	__u32 aac_srate;	/* Plain AAC decoder operating sample rate */
+	__u8 mpg_id; /* 0=MPEG-2, 1=MPEG-4 */
+	__u8 bs_format; /* input bit stream format adts=0, adif=1, raw=2 */
+	__u8 aac_profile; /* 0=Main Profile, 1=LC profile, 3=SSR profile */
+	__u8 ext_chl; /* No.of external channels */
+	__u8 aot; /* Audio object type. 1=Main , 2=LC , 3=SSR, 4=SBR*/
+	__u8 op_align; /* output alignment 0=16 bit , 1=MSB, 2= LSB align */
+	__u8 brate_type; /* 0=CBR, 1=VBR */
+	__u8 crc_check; /* crc check 0= disable, 1=enable */
+	__s8 bit_stream_format[8]; /* input bit stream format adts/adif/raw */
+	__u8 jstereo; /* Joint stereo Flag */
+	__u8 sbr_present; /* 1 = SBR Present, 0 = SBR absent, for RAW */
+	__u8 downsample;       /* 1 = Downsampling ON, 0 = Downsampling OFF */
+	__u8 num_syntc_elems; /* 1- Mono/stereo, 0 - Dual Mono, 0 - for raw */
+	__s8 syntc_id[2]; /* 0 for ID_SCE(Dula Mono), -1 for raw */
+	__s8 syntc_tag[2]; /* raw - -1 and 0 -16 for rest of the streams */
+	__u8 pce_present; /* Flag. 1- present 0 - not present, for RAW */
+	__u8 sbr_type;		/* sbr_type: 0-plain aac, 1-aac-v1, 2-aac-v2 */
+	__u8 outchmode;  /*0- mono, 1-stereo, 2-dual mono 3-Parametric stereo */
+	__u8 ps_present;
+};
+
+/* WMA Music Parameters Message */
+struct snd_wma_params {
+	__u16 codec;
+	__u8  num_chan;	/* 1=Mono, 2=Stereo */
+	__u8  pcm_wd_sz;	/* 16/24 - bit*/
+	__u32 brate;	/* Use the hard coded value. */
+	__u32 sfreq;	/* Sampling freq eg. 8000, 441000, 48000 */
+	__u32 channel_mask;  /* Channel Mask */
+	__u16 format_tag;	/* Format Tag */
+	__u16 block_align;	/* packet size */
+	__u16 wma_encode_opt;/* Encoder option */
+	__u8 op_align;	/* op align 0- 16 bit, 1- MSB, 2 LSB */
+	__u8 pcm_src;	/* input pcm bit width */
+};
+
+/* Pre processing param structure */
+struct snd_prp_params {
+	__u32 reserved;	/* No pre-processing defined yet */
+};
+
+/* Pre and post processing params structure */
+struct snd_ppp_params {
+	__u8			algo_id;/* Post/Pre processing algorithm ID  */
+	__u8			str_id;	/*Only 5 bits used 0 - 31 are valid*/
+	__u8			enable;	/* 0= disable, 1= enable*/
+	__u8			reserved;
+	__u32			size;	/*Size of parameters for all blocks*/
+	void			*params;
+} __attribute__ ((packed));
+
+struct snd_sst_postproc_info {
+	__u32 src_min;		/* Supported SRC Min sampling freq */
+	__u32 src_max;		/* Supported SRC Max sampling freq */
+	__u8  src;		/* 0=Not supported, 1=Supported */
+	__u8  bass_boost;		/* 0=Not Supported, 1=Supported */
+	__u8  stereo_widening;	/* 0=Not Supported, 1=Supported */
+	__u8  volume_control;	/* 0=Not Supported, 1=Supported */
+	__s16 min_vol;		/* Minimum value of Volume in dB */
+	__s16 max_vol;		/* Maximum value of Volume in dB */
+	__u8 mute_control;	/* 0=No Mute, 1=Mute */
+	__u8 reserved1;
+	__u16 reserved2;
+};
+
+/* pre processing Capability info structure */
+struct snd_sst_prp_info {
+	__s16 min_vol;			/* Minimum value of Volume in dB */
+	__s16 max_vol;			/* Maximum value of Volume in dB */
+	__u8 volume_control;		/* 0=Not Supported, 1=Supported */
+	__u8 reserved1;			/* for 32 bit alignment */
+	__u16 reserved2;		/* for 32 bit alignment */
+} __attribute__ ((packed));
+
+/*Pre / Post processing algorithms support*/
+struct snd_sst_ppp_info {
+	__u32 src:1;		/* 0=Not supported, 1=Supported */
+	__u32 mixer:1;		/* 0=Not supported, 1=Supported */
+	__u32 volume_control:1;	/* 0=Not Supported, 1=Supported */
+	__u32 mute_control:1;	/* 0=Not Supported, 1=Supported */
+	__u32 anc:1;		/* 0=Not Supported, 1=Supported */
+	__u32 side_tone:1;	/* 0=Not Supported, 1=Supported */
+	__u32 dc_removal:1;	/* 0=Not Supported, 1=Supported */
+	__u32 equalizer:1;	/* 0=Not Supported, 1=Supported */
+	__u32 spkr_prot:1;	/* 0=Not Supported, 1=Supported */
+	__u32 bass_boost:1;	/* 0=Not Supported, 1=Supported */
+	__u32 stereo_widening:1;/* 0=Not Supported, 1=Supported */
+	__u32 rsvd1:21;
+	__u32 rsvd2;
+};
+
+/* Firmware capabilities info */
+struct snd_sst_fw_info {
+	struct snd_sst_fw_version fw_version; /* Firmware version */
+	__u8 audio_codecs_supported[8];	/* Codecs supported by FW */
+	__u32 recommend_min_duration; /* Min duration for Lowpower Playback */
+	__u8 max_pcm_streams_supported; /* Max num of PCM streams supported */
+	__u8 max_enc_streams_supported;	/* Max number of Encoded streams  */
+	__u16 reserved;		/* 32 bit alignment*/
+	struct snd_sst_ppp_info ppp_info; /* pre_processing mod cap info */
+	struct snd_sst_postproc_info pop_info; /* Post processing cap info*/
+	struct snd_sst_port_info port_info[3]; /* Port info */
+	struct snd_sst_mix_info mix_info;/* Mixer info */
+	__u32 min_input_buf; /* minmum i/p buffer for decode */
+};
+
+/* Codec params struture */
+union  snd_sst_codec_params {
+	struct snd_pcm_params pcm_params;
+	struct snd_mp3_params mp3_params;
+	struct snd_aac_params aac_params;
+	struct snd_wma_params wma_params;
+};
+
+
+struct snd_sst_stream_params {
+	union snd_sst_codec_params uc;
+} __attribute__ ((packed));
+
+struct snd_sst_params {
+	__u32 result;
+	__u32 stream_id;
+	__u8 codec;
+	__u8 ops;
+	__u8 stream_type;
+	__u8 device_type;
+	struct snd_sst_stream_params sparams;
+};
+
+struct snd_sst_vol {
+	__u32	stream_id;
+	__s32	volume;
+	__u32	ramp_duration;
+	__u32	ramp_type;		/* Ramp type, default=0 */
+};
+
+struct snd_sst_mute {
+	__u32	stream_id;
+	__u32	mute;
+};
+
+/* ioctl related stuff here */
+struct snd_sst_pmic_config {
+	__u32  sfreq;                /* Sampling rate in Hz */
+	__u16  num_chan;             /* Mono =1 or Stereo =2 */
+	__u16  pcm_wd_sz;            /* Number of bits per sample */
+} __attribute__ ((packed));
+
+struct snd_sst_get_stream_params {
+	struct snd_sst_params codec_params;
+	struct snd_sst_pmic_config pcm_params;
+};
+
+enum snd_sst_target_type {
+	SND_SST_TARGET_PMIC = 1,
+	SND_SST_TARGET_LPE,
+	SND_SST_TARGET_MODEM,
+	SND_SST_TARGET_BT,
+	SND_SST_TARGET_FM,
+	SND_SST_TARGET_NONE,
+};
+
+enum snd_sst_device_type {
+	SND_SST_DEVICE_SSP = 1,
+	SND_SST_DEVICE_PCM,
+	SND_SST_DEVICE_OTHER,
+};
+
+enum snd_sst_device_mode {
+
+	SND_SST_DEV_MODE_PCM_MODE1 = 1, /*(16-bit word, bit-length frame sync)*/
+	SND_SST_DEV_MODE_PCM_MODE2,
+	SND_SST_DEV_MODE_PCM_MODE3,
+	SND_SST_DEV_MODE_PCM_MODE4_RIGHT_JUSTIFIED,
+	SND_SST_DEV_MODE_PCM_MODE4_LEFT_JUSTIFIED,
+	SND_SST_DEV_MODE_PCM_MODE4_I2S, /*(I2S mode, 16-bit words)*/
+	SND_SST_DEV_MODE_PCM_MODE5,
+	SND_SST_DEV_MODE_PCM_MODE6,
+};
+
+enum snd_sst_port_action {
+	SND_SST_PORT_PREPARE = 1,
+	SND_SST_PORT_ACTIVATE,
+};
+
+enum stream_param_type {
+	SET_TIME_SLOT = 0,
+	OTHERS = 1, /*reserved for other params that need to be set in future*/
+};
+
+/* Target selection per device structure */
+struct snd_sst_slot_info {
+	__u8 mix_enable;	/* Mixer enable or disable */
+	__u8 device_type;
+	__u8 device_instance;	/* 0, 1, 2 */
+	__u8 target_device;
+	__u16 target_sink;
+	__u8 slot[2];
+	__u8 master;
+	__u8 action;
+	__u8 device_mode;
+	__u8 reserved;
+	struct snd_sst_pmic_config pcm_params;
+} __attribute__ ((packed));
+
+#define SST_MAX_TARGET_DEVICES 3
+/* Target device list structure */
+struct snd_sst_target_device  {
+	__u32 device_route;
+	struct snd_sst_slot_info devices[SST_MAX_TARGET_DEVICES];
+} __attribute__ ((packed));
+
+struct snd_sst_driver_info {
+	__u32 version;	/* Version of the driver */
+	__u32 active_pcm_streams;
+	__u32 active_enc_streams;
+	__u32 max_pcm_streams;
+	__u32 max_enc_streams;
+	__u32 buf_per_stream;
+};
+
+enum snd_sst_buff_type {
+	SST_BUF_USER = 1,
+	SST_BUF_MMAP,
+	SST_BUF_RAR,
+};
+
+struct snd_sst_mmap_buff_entry {
+	unsigned int offset;
+	unsigned int size;
+};
+
+struct snd_sst_mmap_buffs {
+	unsigned int entries;
+	enum snd_sst_buff_type type;
+	struct snd_sst_mmap_buff_entry *buff;
+};
+
+struct snd_sst_buff_entry {
+	void *buffer;
+	unsigned int size;
+};
+
+struct snd_sst_buffs {
+	unsigned int entries;
+	__u8 type;
+	struct snd_sst_buff_entry *buff_entry;
+};
+
+struct snd_sst_dbufs  {
+	unsigned long long input_bytes_consumed;
+	unsigned long long output_bytes_produced;
+	struct snd_sst_buffs *ibufs;
+	struct snd_sst_buffs *obufs;
+};
+
+struct snd_sst_tuning_params {
+	__u8 type;
+	__u8 str_id;
+	__u8 size;
+	__u8 rsvd;
+	__u64 addr;
+} __attribute__ ((packed));
+/*IOCTL defined here */
+/*SST MMF IOCTLS only */
+#define SNDRV_SST_STREAM_SET_PARAMS _IOR('L', 0x00, \
+					struct snd_sst_stream_params *)
+#define SNDRV_SST_STREAM_GET_PARAMS _IOWR('L', 0x01, \
+					struct snd_sst_get_stream_params *)
+#define SNDRV_SST_STREAM_GET_TSTAMP _IOWR('L', 0x02, __u64 *)
+#define	SNDRV_SST_STREAM_DECODE	_IOWR('L', 0x03, struct snd_sst_dbufs *)
+#define SNDRV_SST_STREAM_BYTES_DECODED _IOWR('L', 0x04, __u64 *)
+#define SNDRV_SST_STREAM_START	_IO('A', 0x42)
+#define SNDRV_SST_STREAM_DROP	_IO('A', 0x43)
+#define SNDRV_SST_STREAM_DRAIN	_IO('A', 0x44)
+#define SNDRV_SST_STREAM_PAUSE	_IOW('A', 0x45, int)
+#define SNDRV_SST_STREAM_RESUME _IO('A', 0x47)
+#define SNDRV_SST_MMAP_PLAY	_IOW('L', 0x05, struct snd_sst_mmap_buffs *)
+#define SNDRV_SST_MMAP_CAPTURE _IOW('L', 0x06, struct snd_sst_mmap_buffs *)
+/*SST common ioctls */
+#define SNDRV_SST_DRIVER_INFO	_IOR('L', 0x10, struct snd_sst_driver_info *)
+#define SNDRV_SST_SET_VOL	_IOW('L', 0x11, struct snd_sst_vol *)
+#define SNDRV_SST_GET_VOL	_IOW('L', 0x12, struct snd_sst_vol *)
+#define SNDRV_SST_MUTE		_IOW('L', 0x13, struct snd_sst_mute *)
+/*AM Ioctly only */
+#define SNDRV_SST_FW_INFO	_IOR('L', 0x20,  struct snd_sst_fw_info *)
+#define SNDRV_SST_SET_TARGET_DEVICE _IOW('L', 0x21, \
+					struct snd_sst_target_device *)
+/*DSP Ioctls on /dev/intel_sst_ctrl only*/
+#define SNDRV_SST_SET_ALGO	_IOW('L', 0x30,  struct snd_ppp_params *)
+#define SNDRV_SST_GET_ALGO	_IOWR('L', 0x31,  struct snd_ppp_params *)
+#define SNDRV_SST_TUNING_PARAMS	_IOW('L', 0x32,  struct snd_sst_tuning_params *)
+#define SNDRV_SST_SET_RUNTIME_PARAMS _IOW('L', 0x40,  struct snd_sst_tuning_params *)
+
+#endif /* __INTEL_SST_IOCTL_H__ */

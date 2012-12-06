Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964823Ab2LFDMu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Dec 2012 22:12:50 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:38342 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752101Ab2LFDMt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Dec 2012 22:12:49 -0500
MIME-Version: 1.0
In-Reply-To: <50BFFB6E.5080108@zytor.com>
References: <50BFFB6E.5080108@zytor.com>
Date: Wed, 5 Dec 2012 19:12:47 -0800
X-Google-Sender-Auth: oTjIxWGTRmjeTpE8x_TqOWY4S94
Message-ID: <CAE9FiQU9mZpqhwX_a4Sv0a0aiReTxJfyJqNRVXTTXvjkFLrVZA@mail.gmail.com>
Subject: Re: kexec and struct boot_params
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 5, 2012 at 5:57 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> Hi Eric,
>
> Could you give a list of struct boot_params field which are initialized
> properly by kexec?  I think we need to do the sentinel hack, and want to
> know what to whitelist.

the one with *
? means set only when lfb_depth > 8
also
   0xa2 to 0x1df is not set

struct x86_linux_param_header {
	uint8_t  orig_x;			/* 0x00 */  *
	uint8_t  orig_y;			/* 0x01 */  *
	uint16_t ext_mem_k;			/* 0x02 -- EXT_MEM_K sits here */   *
	uint16_t orig_video_page;		/* 0x04 */  *
	uint8_t  orig_video_mode;		/* 0x06 */  *
	uint8_t  orig_video_cols;		/* 0x07 */  *
	uint16_t unused2;			/* 0x08 */
	uint16_t orig_video_ega_bx;		/* 0x0a */  *
	uint16_t unused3;			/* 0x0c */
	uint8_t	 orig_video_lines;		/* 0x0e */  *
	uint8_t	 orig_video_isVGA;		/* 0x0f */   *
	uint16_t orig_video_points;		/* 0x10 */   *

	/* VESA graphic mode -- linear frame buffer */
	uint16_t lfb_width;			/* 0x12 */   *
	uint16_t lfb_height;			/* 0x14 */   *
	uint16_t lfb_depth;			/* 0x16 */   *
	uint32_t lfb_base;			/* 0x18 */   *
	uint32_t lfb_size;			/* 0x1c */   *
	uint16_t cl_magic;			/* 0x20 */   *
#define CL_MAGIC_VALUE 0xA33F
	uint16_t cl_offset;			/* 0x22 */   *
	uint16_t lfb_linelength;		/* 0x24 */   *
	uint8_t	 red_size;			/* 0x26 */   ?
	uint8_t	 red_pos;			/* 0x27 */   ?
	uint8_t	 green_size;			/* 0x28 */   ?
	uint8_t	 green_pos;			/* 0x29 */   ?
	uint8_t	 blue_size;			/* 0x2a */   ?
	uint8_t	 blue_pos;			/* 0x2b */   ?
	uint8_t	 rsvd_size;			/* 0x2c */   ?
	uint8_t	 rsvd_pos;			/* 0x2d */   ?
	uint16_t vesapm_seg;			/* 0x2e */   *
	uint16_t vesapm_off;			/* 0x30 */
	uint16_t pages;				/* 0x32 */   *
	uint8_t  reserved4[12];			/* 0x34 -- 0x3f reserved for future expansion */

	struct apm_bios_info apm_bios_info;	/* 0x40 */   *
	struct drive_info_struct drive_info;	/* 0x80 */   *
	struct sys_desc_table sys_desc_table;	/* 0xa0 */   * only .length =
0, aka 0xa2 to 0x1df is not set
	uint32_t alt_mem_k;			/* 0x1e0 */  *
	uint8_t  reserved5[4];			/* 0x1e4 */
	uint8_t  e820_map_nr;			/* 0x1e8 */  *
	uint8_t  eddbuf_entries;		/* 0x1e9 */  *
	uint8_t  edd_mbr_sig_buf_entries;	/* 0x1ea */  *
	uint8_t  reserved6[6];			/* 0x1eb */
	HEADER.....					    copied and or meset 0 and set.
	uint8_t  reserved16[0x290 - 0x248];	/* 0x248 */
	uint32_t edd_mbr_sig_buffer[EDD_MBR_SIG_MAX];	/* 0x290 */  *
#endif
	struct 	e820entry e820_map[E820MAX];	/* 0x2d0 */   *
	uint8_t _pad8[48];			/* 0xcd0 */
	struct 	edd_info eddbuf[EDDMAXNR];	/* 0xd00 */   *
						/* 0xeec */
#define COMMAND_LINE_SIZE 2048
};


>
> Also, does kexec set a bootloader ID?

no, 0xff

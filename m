Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab0JPIIT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 04:08:19 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40315 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab0JPIIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 04:08:13 -0400
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Subject: Re: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF card
Date: Sat, 16 Oct 2010 11:07:59 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.35-smp+; KDE/4.4.3; i686; ; )
Cc: linux-media@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Abylai Ospan <aospan@netup.ru>
References: <201010040135.59454.liplianin@me.by> <4CB747E0.5050308@redhat.com> <4CB752FB.3080402@redhat.com>
In-Reply-To: <4CB752FB.3080402@redhat.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010161108.00083.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от 14 октября 2010 21:59:07 автор Mauro Carvalho Chehab написал:
> Em 14-10-2010 15:11, Mauro Carvalho Chehab escreveu:
> > Em 03-10-2010 19:35, Igor M. Liplianin escreveu:
> >> Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc.
> >> 
> >> 	http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
> >> 
> >> Features:
> >> 
> >> PCI-e x1
> >> Supports two DVB-T/DVB-C transponders simultaneously
> >> Supports two analog audio/video channels simultaneously
> >> Independent descrambling of two transponders
> >> Hardware PID filtering
> >> 
> >> Components:
> >> 
> >> Conexant CX23885
> >> STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip
> >> receiver Xceive XC5000 silicon TV tuner
> >> Altera FPGA for Common Interafce
> >> 
> >> The following changes since commit c8dd732fd119ce6d562d5fa82a10bbe75a376575:
> >>   V4L/DVB: gspca - sonixj: Have 0c45:6130 handled by sonixj instead of
> >>   sn9c102 (2010-10-01
> >> 
> >> 18:14:35 -0300)
> >> 
> >> are available in the git repository at:
> >>   http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree
> >> 
> >> Abylay Ospan (6):
> >>       cx23885: Altera FPGA CI interface reworked.
> >>       stv0367: change default value for AGC register.
> >>       stv0367: implement uncorrected blocks counter.
> >>       cx23885, cimax2.c: Fix case of two CAM insertion irq.
> >>       Fix CI code for NetUP Dual  DVB-T/C CI RF card
> >>       Force xc5000 firmware loading for NetUP Dual  DVB-T/C CI RF card
> >> 
> >> Igor M. Liplianin (14):
> >>       Altera FPGA firmware download module.
> >>       Altera FPGA based CI driver module.
> >>       Support for stv0367 multi-standard demodulator.
> >>       xc5000: add support for DVB-C tuning.
> >>       Initial commit to support NetUP Dual DVB-T/C CI RF card.
> >>       cx23885: implement tuner_bus parameter for cx23885_board
> >>       structure. cx23885: implement num_fds_portb, num_fds_portc
> >>       parameters for cx23885_board structure. stv0367: Fix potential
> >>       divide error
> >>       cx23885: remove duplicate set interrupt mask
> >>       stv0367: coding style corrections
> >>       cx25840: Fix subdev registration and typo in cx25840-core.c
> >>       cx23885: 0xe becomes 0xc again for NetUP Dual DVB-S2
> >>       cx23885: disable MSI for NetUP cards, otherwise CI is not working
> >>       cx23885, altera-ci: enable all PID's less than 0x20 in hardware
> >>       PID filter.
> >>  
> >>  drivers/media/common/tuners/xc5000.c        |   18 +
> >>  drivers/media/dvb/frontends/Kconfig         |    7 +
> >>  drivers/media/dvb/frontends/Makefile        |    1 +
> >>  drivers/media/dvb/frontends/stv0367.c       | 3419
> >>  +++++++++++++++++++++++++ drivers/media/dvb/frontends/stv0367.h      
> >>  |   62 +
> >>  drivers/media/dvb/frontends/stv0367_priv.h  |  211 ++
> >>  drivers/media/dvb/frontends/stv0367_regs.h  | 3614
> >>  +++++++++++++++++++++++++++ drivers/media/video/cx23885/Kconfig       
> >>   |   12 +-
> >>  drivers/media/video/cx23885/Makefile        |    1 +
> >>  drivers/media/video/cx23885/altera-ci.c     |  841 +++++++
> >>  drivers/media/video/cx23885/altera-ci.h     |  102 +
> >>  drivers/media/video/cx23885/cimax2.c        |   24 +-
> >>  drivers/media/video/cx23885/cx23885-cards.c |  116 +-
> >>  drivers/media/video/cx23885/cx23885-core.c  |   35 +-
> >>  drivers/media/video/cx23885/cx23885-dvb.c   |  175 ++-
> >>  drivers/media/video/cx23885/cx23885-reg.h   |    1 +
> >>  drivers/media/video/cx23885/cx23885-video.c |    7 +-
> >>  drivers/media/video/cx23885/cx23885.h       |    7 +-
> >>  drivers/media/video/cx25840/cx25840-core.c  |    4 +-
> >>  drivers/misc/Kconfig                        |    1 +
> >>  drivers/misc/Makefile                       |    1 +
> >>  drivers/misc/stapl-altera/Kconfig           |    8 +
> >>  drivers/misc/stapl-altera/Makefile          |    3 +
> >>  drivers/misc/stapl-altera/altera.c          | 2739 ++++++++++++++++++++
> >>  drivers/misc/stapl-altera/jbicomp.c         |  163 ++
> >>  drivers/misc/stapl-altera/jbiexprt.h        |   94 +
> >>  drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
> >>  drivers/misc/stapl-altera/jbijtag.h         |   83 +
> >>  drivers/misc/stapl-altera/jbistub.c         |   70 +
> >>  include/misc/altera.h                       |   49 +
> >>  30 files changed, 12872 insertions(+), 34 deletions(-)
> >>  create mode 100644 drivers/media/dvb/frontends/stv0367.c
> >>  create mode 100644 drivers/media/dvb/frontends/stv0367.h
> >>  create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
> >>  create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h
> >>  create mode 100644 drivers/media/video/cx23885/altera-ci.c
> >>  create mode 100644 drivers/media/video/cx23885/altera-ci.h
> >>  create mode 100644 drivers/misc/stapl-altera/Kconfig
> >>  create mode 100644 drivers/misc/stapl-altera/Makefile
> >>  create mode 100644 drivers/misc/stapl-altera/altera.c
> >>  create mode 100644 drivers/misc/stapl-altera/jbicomp.c
> >>  create mode 100644 drivers/misc/stapl-altera/jbiexprt.h
> >>  create mode 100644 drivers/misc/stapl-altera/jbijtag.c
> >>  create mode 100644 drivers/misc/stapl-altera/jbijtag.h
> >>  create mode 100644 drivers/misc/stapl-altera/jbistub.c
> >>  create mode 100644 include/misc/altera.h
> > 
> > Igor,
> > 
> > I did a quick look at Altera FPGA driver, and at the cx23885 changes for
> > it to work with this device, I think the FPGA driver deserves some
> > discussion at linux-kernel.
> > 
> > As there's a V4L/DVB device that depends on it, it is clear to me that
> > the better is to merge the driver via my tree.
> > 
> > So, I'm basically sending your first patch to the mailing lists for
> > review.
> > 
> > ---
> > 
> > From e1fd36695ae082ae89a3155cabb5a84181ae9df4 Mon Sep 17 00:00:00 2001
> > From: Igor M. Liplianin <liplianin@netup.ru>
> > Date: Mon, 24 May 2010 13:09:23 +0300
> > Subject: Altera FPGA firmware download module.
> > Cc: Linux Media Mailing List <linux-media@vger.kernel.org>
> > 
> > It uses STAPL files and programs Altera FPGA through JTAG.
> > Interface to JTAG must be provided from main device module,
> > for example through cx23885 GPIO.
> > 
> > Signed-off-by: Igor M. Liplianin <liplianin@netup.ru>
> > Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> > ---
> > 
> >  drivers/misc/Kconfig                 |    1 +
> >  drivers/misc/Makefile                |    1 +
> >  drivers/misc/stapl-altera/Kconfig    |    8 +
> >  drivers/misc/stapl-altera/Makefile   |    3 +
> >  drivers/misc/stapl-altera/altera.c   | 2739
> >  ++++++++++++++++++++++++++++++++++ drivers/misc/stapl-altera/jbicomp.c 
> >  |  163 ++
> >  drivers/misc/stapl-altera/jbiexprt.h |   94 ++
> >  drivers/misc/stapl-altera/jbijtag.c  | 1038 +++++++++++++
> >  drivers/misc/stapl-altera/jbijtag.h  |   83 +
> >  drivers/misc/stapl-altera/jbistub.c  |   70 +
> >  include/misc/altera.h                |   49 +
> >  11 files changed, 4249 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/misc/stapl-altera/Kconfig
> >  create mode 100644 drivers/misc/stapl-altera/Makefile
> >  create mode 100644 drivers/misc/stapl-altera/altera.c
> >  create mode 100644 drivers/misc/stapl-altera/jbicomp.c
> >  create mode 100644 drivers/misc/stapl-altera/jbiexprt.h
> >  create mode 100644 drivers/misc/stapl-altera/jbijtag.c
> >  create mode 100644 drivers/misc/stapl-altera/jbijtag.h
> >  create mode 100644 drivers/misc/stapl-altera/jbistub.c
> >  create mode 100644 include/misc/altera.h
> > 
> > diff --git a/drivers/misc/Kconfig b/drivers/misc/Kconfig
> > index 9b089df..3cfc47c 100644
> > --- a/drivers/misc/Kconfig
> > +++ b/drivers/misc/Kconfig
> > @@ -367,5 +367,6 @@ source "drivers/misc/c2port/Kconfig"
> > 
> >  source "drivers/misc/eeprom/Kconfig"
> >  source "drivers/misc/cb710/Kconfig"
> >  source "drivers/misc/iwmc3200top/Kconfig"
> > 
> > +source "drivers/misc/stapl-altera/Kconfig"
> > 
> >  endif # MISC_DEVICES
> > 
> > diff --git a/drivers/misc/Makefile b/drivers/misc/Makefile
> > index 67552d6..58e794c 100644
> > --- a/drivers/misc/Makefile
> > +++ b/drivers/misc/Makefile
> > @@ -32,3 +32,4 @@ obj-y				+= eeprom/
> > 
> >  obj-y				+= cb710/
> >  obj-$(CONFIG_VMWARE_BALLOON)	+= vmware_balloon.o
> >  obj-$(CONFIG_ARM_CHARLCD)	+= arm-charlcd.o
> > 
> > +obj-y				+= stapl-altera/
> > diff --git a/drivers/misc/stapl-altera/Kconfig
> > b/drivers/misc/stapl-altera/Kconfig new file mode 100644
> > index 0000000..19ba4a9
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/Kconfig
> > @@ -0,0 +1,8 @@
> > +comment "Altera FPGA firmware download module"
> > +
> > +config STAPL_ALTERA
> > +	tristate "Altera FPGA firmware download module"
> > +	depends on I2C
> > +	default m
> > +	help
> > +	  An Altera FPGA module. Say Y when you want to support this tool.
> > diff --git a/drivers/misc/stapl-altera/Makefile
> > b/drivers/misc/stapl-altera/Makefile new file mode 100644
> > index 0000000..db56178
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/Makefile
> > @@ -0,0 +1,3 @@
> > +stapl-altera-objs = jbistub.o jbijtag.o jbicomp.o altera.o
> > +
> > +obj-$(CONFIG_STAPL_ALTERA) += stapl-altera.o
> > diff --git a/drivers/misc/stapl-altera/altera.c
> > b/drivers/misc/stapl-altera/altera.c new file mode 100644
> > index 0000000..9628d9c
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/altera.c
> > @@ -0,0 +1,2739 @@
> > +/*
> > + * altera.c
> > + *
> > + * altera FPGA driver
> > + *
> > + * Copyright (C) Altera Corporation 1998-2001
> > + * Copyright (C) 2010 NetUP Inc.
> > + * Copyright (C) 2010 Igor M. Liplianin <liplianin@netup.ru>
> > + *
> > + * This program is free software; you can redistribute it and/or modify
> > + * it under the terms of the GNU General Public License as published by
> > + * the Free Software Foundation; either version 2 of the License, or
> > + * (at your option) any later version.
> > + *
> > + * This program is distributed in the hope that it will be useful,
> > + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> > + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> > + *
> > + * GNU General Public License for more details.
> > + *
> > + * You should have received a copy of the GNU General Public License
> > + * along with this program; if not, write to the Free Software
> > + * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
> > + */
> > +
> > +#include <linux/firmware.h>
> > +#include <linux/slab.h>
> > +#include <misc/altera.h>
> > +#include "jbiexprt.h"
> > +
> > +static int verbose = 1;
> > +module_param(verbose, int, 0644);
> > +MODULE_PARM_DESC(verbose, "enable debugging information");
> 
> Better to call it as "debug".
> 
> > +
> > +MODULE_DESCRIPTION("altera FPGA kernel module");
> > +MODULE_AUTHOR("Igor M. Liplianin  <liplianin@netup.ru>");
> > +MODULE_LICENSE("GPL");
> > +
> > +#include "jbijtag.h"
> > +
> > +#define JBI_STACK_SIZE 128
> > +
> > +#define JBIC_MESSAGE_LENGTH 1024
> > +
> > +/* This macro checks if a code address is inside the code section */
> > +#define CHECK_PC \
> > +	if ((pc < code_section) || (pc >= debug_section)) { \
> > +		status = JBIC_BOUNDS_ERROR; \
> > +	}
> 
> This is ugly: a macro with 3 hidden arguments... you might define it as:
> 
> #define check_pc(pc, code_section, debug_section)	\
> +	(((pc < code_section) || (pc >= debug_section)) ? JBIC_BOUNDS_ERROR : 0)
> 
> and call it as:
> 	status = check_pc(pc, code_section, debug_section);
> 
> But I suspect that the better would be do do, instead:
> 
> 	if ((pc < code_section) || (pc >= debug_section))
> 		goto jbic_bounds_error;
> 
> on all places you're using it.
> 
> > +
> > +#define dprintk(args...) \
> > +	if (verbose) { \
> > +		printk(KERN_DEBUG args); \
> > +	}
> > +
> > +char *error_text[] = {
> > +	/* JBIC_SUCCESS            0 */ "success",
> > +	/* JBIC_OUT_OF_MEMORY      1 */ "out of memory",
> > +	/* JBIC_IO_ERROR           2 */ "file access error",
> > +	/* JAMC_SYNTAX_ERROR       3 */ "syntax error",
> > +	/* JBIC_UNEXPECTED_END     4 */ "unexpected end of file",
> > +	/* JBIC_UNDEFINED_SYMBOL   5 */ "undefined symbol",
> > +	/* JAMC_REDEFINED_SYMBOL   6 */ "redefined symbol",
> > +	/* JBIC_INTEGER_OVERFLOW   7 */ "integer overflow",
> > +	/* JBIC_DIVIDE_BY_ZERO     8 */ "divide by zero",
> > +	/* JBIC_CRC_ERROR          9 */ "CRC mismatch",
> > +	/* JBIC_INTERNAL_ERROR    10 */ "internal error",
> > +	/* JBIC_BOUNDS_ERROR      11 */ "bounds error",
> > +	/* JAMC_TYPE_MISMATCH     12 */ "type mismatch",
> > +	/* JAMC_ASSIGN_TO_CONST   13 */ "assignment to constant",
> > +	/* JAMC_NEXT_UNEXPECTED   14 */ "NEXT unexpected",
> > +	/* JAMC_POP_UNEXPECTED    15 */ "POP unexpected",
> > +	/* JAMC_RETURN_UNEXPECTED 16 */ "RETURN unexpected",
> > +	/* JAMC_ILLEGAL_SYMBOL    17 */ "illegal symbol name",
> > +	/* JBIC_VECTOR_MAP_FAILED 18 */ "vector signal name not found",
> > +	/* JBIC_USER_ABORT        19 */ "execution cancelled",
> > +	/* JBIC_STACK_OVERFLOW    20 */ "stack overflow",
> > +	/* JBIC_ILLEGAL_OPCODE    21 */ "illegal instruction code",
> > +	/* JAMC_PHASE_ERROR       22 */ "phase error",
> > +	/* JAMC_SCOPE_ERROR       23 */ "scope error",
> > +	/* JBIC_ACTION_NOT_FOUND  24 */ "action not found",
> > +};
> 
> The better would be to use standard Unix error codes here.
> 
> > +
> > +#define MAX_ERROR_CODE
> > (int)((sizeof(error_text)/sizeof(error_text[0]))+1) +
> > +/* This function checks if enough parameters are available on the stack.
> > */ +static int jbi_check_stack(int stack_ptr, int count, int *status) +{
> > +	if (stack_ptr < count) {
> > +		*status = JBIC_STACK_OVERFLOW;
> > +		return 0;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +static int jbi_strlen(char *string)
> > +{
> > +	int len = 0;
> > +
> > +	while (string[len] != '\0')
> > +		++len;
> > +
> > +	return len;
> > +}
> 
> Linux has strlen. Don't re-invent the wheel.
> 
> > +
> > +static void jbi_ltoa(char *buffer, s32 number)
> > +{
> > +	int index = 0;
> > +	int rev_index = 0;
> > +	char reverse[32];
> > +
> > +	if (number < 0L) {
> > +		buffer[index++] = '-';
> > +		number = 0 - number;
> > +	} else if (number == 0)
> > +		buffer[index++] = '0';
> > +
> > +	while (number != 0) {
> > +		reverse[rev_index++] = (char)((number % 10) + '0');
> > +		number /= 10;
> > +	}
> > +
> > +	while (rev_index > 0)
> > +		buffer[index++] = reverse[--rev_index];
> > +
> > +	buffer[index] = '\0';
> > +}
> > +
> > +static char jbi_toupper(char ch)
> > +{
> > +	return (char)(((ch >= 'a') && (ch <= 'z')) ? (ch + 'A' - 'a') : ch);
> > +}
> > +
> > +static int jbi_stricmp(char *left, char *right)
> > +{
> > +	int result = 0;
> > +	char l, r;
> > +
> > +	do {
> > +		l = jbi_toupper(*left);
> > +		r = jbi_toupper(*right);
> > +		result = l - r;
> > +		++left;
> > +		++right;
> > +	} while ((result == 0) && (l != '\0') && (r != '\0'));
> > +
> > +	return result;
> > +}
> > +
> > +static void jbi_strncpy(char *left, char *right, int count)
> > +{
> > +	char ch;
> > +
> > +	do {
> > +		*left = *right;
> > +		ch = *right;
> > +		++left;
> > +		++right;
> > +		--count;
> > +	} while ((ch != '\0') && (count != 0));
> > +}
> 
> Linux has functions for the above. Don't re-invent the wheel.
> 
> > +
> > +static void jbi_make_dword(u8 *buf, u32 num)
> > +{
> > +	buf[0] = (u8) num;
> > +	buf[1] = (u8)(num >> 8L);
> > +	buf[2] = (u8)(num >> 16L);
> > +	buf[3] = (u8)(num >> 24L);
> > +}
> > +
> > +static u32 jbi_get_dword(u8 *buf)
> > +{
> > +	return
> > +	    (((u32)buf[0]) |
> > +	     (((u32)buf[1]) << 8L) |
> > +	     (((u32)buf[2]) << 16L) |
> > +	     (((u32)buf[3]) << 24L));
> > +}
> 
> Use the proper Linux functions to handle big/little endian.
> 
> > +
> > +static void jbi_export_integer(char *key, s32 value)
> > +{
> > +	dprintk("Export: key = \"%s\", value = %d\n", key, value);
> > +}
> > +
> > +#define HEX_LINE_CHARS 72
> > +#define HEX_LINE_BITS (HEX_LINE_CHARS * 4)
> > +
> > +static char conv_to_hex(u32 value)
> > +{
> > +	char c;
> > +
> > +	if (value > 9)
> > +		c = (char)(value + ('A' - 10));
> > +	else
> > +		c = (char)(value + '0');
> > +
> > +	return c;
> > +}
> 
> There are some Linux functions for this also.
> 
> > +
> > +static void jbi_export_boolean_array(char *key, u8 *data, s32 count)
> > +{
> > +	char string[HEX_LINE_CHARS + 1];
> > +	s32 i, offset;
> > +	u32 size, line, lines, linebits, value, j, k;
> > +
> > +	if (count > HEX_LINE_BITS) {
> > +		dprintk("Export: key = \"%s\", %d bits, value = HEX\n",
> > +							key, count);
> > +		lines = (count + (HEX_LINE_BITS - 1)) / HEX_LINE_BITS;
> > +
> > +		for (line = 0; line < lines; ++line) {
> > +			if (line < (lines - 1)) {
> > +				linebits = HEX_LINE_BITS;
> > +				size = HEX_LINE_CHARS;
> > +				offset = count - ((line + 1) * HEX_LINE_BITS);
> > +			} else {
> > +				linebits =
> > +					count - ((lines - 1) * HEX_LINE_BITS);
> > +				size = (linebits + 3) / 4;
> > +				offset = 0L;
> > +			}
> > +
> > +			string[size] = '\0';
> > +			j = size - 1;
> > +			value = 0;
> > +
> > +			for (k = 0; k < linebits; ++k) {
> > +				i = k + offset;
> > +				if (data[i >> 3] & (1 << (i & 7)))
> > +					value |= (1 << (i & 3));
> > +				if ((i & 3) == 3) {
> > +					string[j] = conv_to_hex(value);
> > +					value = 0;
> > +					--j;
> > +				}
> > +			}
> > +			if ((k & 3) > 0)
> > +				string[j] = conv_to_hex(value);
> > +
> > +			dprintk("%s\n", string);
> > +		}
> > +
> > +	} else {
> > +		size = (count + 3) / 4;
> > +		string[size] = '\0';
> > +		j = size - 1;
> > +		value = 0;
> > +
> > +		for (i = 0; i < count; ++i) {
> > +			if (data[i >> 3] & (1 << (i & 7)))
> > +				value |= (1 << (i & 3));
> > +			if ((i & 3) == 3) {
> > +				string[j] = conv_to_hex(value);
> > +				value = 0;
> > +				--j;
> > +			}
> > +		}
> > +		if ((i & 3) > 0)
> > +			string[j] = conv_to_hex(value);
> > +
> > +		dprintk("Export: key = \"%s\", %d bits, value = HEX %s\n",
> > +			key, count, string);
> > +	}
> > +}
> > +
> > +static JBI_RETURN_TYPE jbi_execute(struct altera_config *astate,
> > +				u8 *program,
> > +				s32 program_size,
> > +				s32 *error_address,
> > +				int *exit_code,
> > +				int *format_version)
> > +{
> > +	static char message_buffer[JBIC_MESSAGE_LENGTH + 1];
> > +	static long stack[JBI_STACK_SIZE] = {0L};/*64 bits*/
> > +	JBI_RETURN_TYPE status = JBIC_SUCCESS;
> > +	u32 first_word = 0L;
> > +	u32 action_table = 0L;
> > +	u32 proc_table = 0L;
> > +	u32 string_table = 0L;
> > +	u32 symbol_table = 0L;
> > +	u32 data_section = 0L;
> > +	u32 code_section = 0L;
> > +	u32 debug_section = 0L;
> > +	u32 action_count = 0L;
> > +	u32 proc_count = 0L;
> > +	u32 symbol_count = 0L;
> > +	long *variables = NULL;/*64bits*/
> > +	s32 *variable_size = NULL;
> > +	char *attributes = NULL;
> > +	u8 *proc_attributes = NULL;
> > +	u32 pc;
> > +	u32 opcode_address;
> > +	u32 args[3];
> > +	u32 opcode;
> > +	u32 name_id;
> > +	u8 charbuf[4];
> > +	long long_temp;/*64bits*/
> > +	u32 variable_id;
> > +	u8 *charptr_temp;
> > +	u8 *charptr_temp2;
> > +	long *longptr_temp;
> > +	int version = 0;
> > +	int delta = 0;
> > +	int stack_ptr = 0;
> > +	u32 arg_count;
> > +	int done = 0;
> > +	int bad_opcode = 0;
> > +	u32 count;
> > +	u32 index;
> > +	u32 index2;
> > +	s32 long_count;
> > +	s32 long_index;
> > +	s32 long_index2;
> > +	u32 i;
> > +	u32 j;
> > +	u32 uncompressed_size;
> > +	u32 offset;
> > +	u32 value;
> > +	int current_proc = 0;
> > +	int reverse;
> > +
> > +	char *name;
> > +
> > +	dprintk("%s\n", __func__);
> > +
> > +	/* Read header information */
> > +	if (program_size > 52L) {
> > +		first_word    = GET_DWORD(0);
> 
> GET_DWORD here masks the fact that it is reading a dword data, from a
> variable called "program". Please, don't do that. Also, again, what this
> function actually does is to convert a data using a given endiannes.
> As it is defined as:
> 
> 	#define GET_BYTE(x) (program[x])
> 	#define GET_DWORD(x) \
> 		(((((u32) GET_BYTE(x)) << 24L) & 0xFF000000L) | \
> 		((((u32) GET_BYTE((x)+1)) << 16L) & 0x00FF0000L) | \
> 		((((u32) GET_BYTE((x)+2)) << 8L) & 0x0000FF00L) | \
> 		(((u32) GET_BYTE((x)+3)) & 0x000000FFL))
> 
> you're getting a 32 bits encoded as little endian. So, the Linux way for it
> would be to use, instead:
> 
> 	get_unaligned_le32(&program[0]);
> 
> (the same applies to all cases of GET_BYTE/GET_WORD/GET_DWORD)
> 
> > +		version = (int)(first_word & 1L);
> > +		*format_version = version + 1;
> > +		delta = version * 8;
> > +
> > +		action_table  = GET_DWORD(4);
> > +		proc_table    = GET_DWORD(8);
> > +		string_table  = GET_DWORD(4 + delta);
> > +		symbol_table  = GET_DWORD(16 + delta);
> > +		data_section  = GET_DWORD(20 + delta);
> > +		code_section  = GET_DWORD(24 + delta);
> > +		debug_section = GET_DWORD(28 + delta);
> > +		action_count  = GET_DWORD(40 + delta);
> > +		proc_count    = GET_DWORD(44 + delta);
> > +		symbol_count  = GET_DWORD(48 + (2 * delta));
> > +	}
> > +
> > +	if ((first_word != 0x4A414D00L) && (first_word != 0x4A414D01L)) {
> > +		done = 1;
> > +		status = JBIC_IO_ERROR;
> > +		goto exit_done;
> > +	}
> > +
> > +	if (symbol_count <= 0)
> > +		goto exit_done;
> > +	/* 64 bits */
> > +	variables = kmalloc((u32)symbol_count * sizeof(long), GFP_KERNEL);
> > +
> > +	if (variables == NULL)
> > +		status = JBIC_OUT_OF_MEMORY;
> 
> status = -ENOMEM;
> 
> > +
> > +	if (status == JBIC_SUCCESS) {
> > +		variable_size = kmalloc(
> > +			(u32)symbol_count * sizeof(s32), GFP_KERNEL);
> > +
> > +		if (variable_size == NULL)
> > +			status = JBIC_OUT_OF_MEMORY;
> > +	}
> > +
> > +	if (status == JBIC_SUCCESS) {
> > +		attributes = (char *)
> > +				kmalloc((u32)symbol_count, GFP_KERNEL);
> > +
> > +		if (attributes == NULL)
> > +			status = JBIC_OUT_OF_MEMORY;
> > +	}
> > +
> > +	if ((status == JBIC_SUCCESS) && (version > 0)) {
> > +		proc_attributes = (u8 *)
> > +				kmalloc((u32)proc_count, GFP_KERNEL);
> > +
> > +		if (proc_attributes == NULL)
> > +			status = JBIC_OUT_OF_MEMORY;
> > +	}
> 
> Same for all above: -ENOMEM.
> 
> > +
> > +	if (status != JBIC_SUCCESS)
> > +		goto exit_done;
> > +
> > +	delta = version * 2;
> > +
> > +	for (i = 0; i < (u32)symbol_count; ++i) {
> > +		offset = (u32)
> > +			(symbol_table + ((11 + delta) * i));
> > +
> > +		value = GET_DWORD(offset + 3 + delta);
> > +
> > +		attributes[i] = GET_BYTE(offset);
> > +
> > +		/* use bit 7 of attribute byte to indicate that
> > +		this buffer was dynamically allocated
> > +		and should be freed later */
> > +		attributes[i] &= 0x7f;
> > +
> > +		variable_size[i] = GET_DWORD(offset + 7 + delta);
> > +
> > +		/*
> > +		Attribute bits:
> > +		bit 0: 0 = read-only, 1 = read-write
> > +		bit 1: 0 = not compressed, 1 = compressed
> > +		bit 2: 0 = not initialized, 1 = initialized
> > +		bit 3: 0 = scalar, 1 = array
> > +		bit 4: 0 = Boolean, 1 = integer
> > +		bit 5: 0 = declared variable,
> > +			1 = compiler created temporary variable
> > +		*/
> > +
> > +		if ((attributes[i] & 0x0c) == 0x04)
> > +			/* initialized scalar variable */
> > +			variables[i] = value;
> > +		else if ((attributes[i] & 0x1e) == 0x0e) {
> > +			/* initialized compressed
> > +			Boolean array */
> > +			uncompressed_size = jbi_get_dword(
> > +				&program[data_section + value]);
> > +
> > +			/* allocate a buffer for the
> > +			uncompressed data */
> > +			variables[i] = (long)kmalloc(uncompressed_size,
> > +								GFP_KERNEL);
> > +			dprintk("%s: var=%lx, (s32)var=%x\n", __func__,
> > +					variables[i], (s32)variables[i]);
> > +			if (variables[i] == 0L)
> > +				status = JBIC_OUT_OF_MEMORY;
> > +			else {
> > +				/* set flag so buffer
> > +				will be freed later */
> > +				attributes[i] |= 0x80;
> > +
> > +				/* uncompress the data */
> > +				if (jbi_uncompress(&program[data_section +
> > +									value],
> > +						variable_size[i],
> > +						(u8 *)variables[i],/*64 bits*/
> > +						uncompressed_size,
> > +						version) != uncompressed_size)
> > +					/* decompression failed */
> > +					status = JBIC_IO_ERROR;
> > +				else /*64 bits?*/
> > +					variable_size[i] =
> > +							uncompressed_size * 8L;
> > +
> > +			}
> > +		} else if ((attributes[i] & 0x1e) == 0x0c) {
> > +			/* initialized Boolean array */
> > +			/*64 bits*/
> > +			variables[i] = value + data_section + (long)program;
> > +		} else if ((attributes[i] & 0x1c) == 0x1c) {
> > +			/* initialized integer array */
> > +			variables[i] = value + data_section;
> > +		} else if ((attributes[i] & 0x0c) == 0x08) {
> > +			/* uninitialized array */
> > +
> > +			/* flag attributes so
> > +			that memory is freed */
> > +			attributes[i] |= 0x80;
> > +
> > +			if (variable_size[i] > 0) {
> > +				u32 size;
> > +
> > +				if (attributes[i] & 0x10)
> > +					/* integer array */
> > +					size = (u32)(variable_size[i] *
> > +								sizeof(s32));
> > +				else
> > +					/* Boolean array */
> > +					size = (u32)
> > +						((variable_size[i] + 7L) / 8L);
> > +				/*64 bits*/
> > +				variables[i] = (long)kmalloc(size, GFP_KERNEL);
> > +
> > +				if (variables[i] == 0) {
> > +					status = JBIC_OUT_OF_MEMORY;
> > +				} else {
> > +					/* zero out memory */
> > +					for (j = 0; j < size; ++j)
> > +						/*64 bits*/
> > +						((u8 *)(variables[i]))[j] = 0;
> > +
> > +				}
> > +			} else
> > +				variables[i] = 0;
> > +
> > +		} else
> > +			variables[i] = 0;
> > +
> > +	}
> > +
> > +exit_done:
> > +	if (status != JBIC_SUCCESS)
> > +		done = 1;
> > +
> > +	jbi_init_jtag();
> > +
> > +	pc = code_section;
> > +	message_buffer[0] = '\0';
> > +
> > +	/*
> > +	For JBC version 2, we will execute the procedures corresponding to
> > +	the selected ACTION */
> > +	if (version > 0) {
> > +		if (astate->action == NULL) {
> > +			status = JBIC_ACTION_NOT_FOUND;
> > +			done = 1;
> > +		} else {
> > +			int action_found = 0;
> > +			for (i = 0; (i < action_count) && !action_found; ++i) {
> > +				name_id = GET_DWORD(action_table + (12 * i));
> > +
> > +				name = (char *)&program[string_table + name_id];
> > +
> > +				if (jbi_stricmp(astate->action, name) == 0) {
> > +					action_found = 1;
> > +					current_proc = (int)
> > +							GET_DWORD(action_table +
> > +								(12 * i) + 8);
> > +				}
> > +			}
> > +
> > +			if (!action_found) {
> > +				status = JBIC_ACTION_NOT_FOUND;
> > +				done = 1;
> > +			}
> > +		}
> > +
> > +		if (status == JBIC_SUCCESS) {
> > +			int first_time = 1;
> > +			i = current_proc;
> > +			while ((i != 0) || first_time) {
> > +				first_time = 0;
> > +				/* check procedure attribute byte */
> > +				proc_attributes[i] = (u8)
> > +						(GET_BYTE(proc_table +
> > +								(13 * i) + 8) &
> > +									0x03);
> > +
> > +				/*
> > +				BIT0 - OPTIONAL
> > +				BIT1 - RECOMMENDED
> > +				BIT6 - FORCED OFF
> > +				BIT7 - FORCED ON
> > +				*/
> > +
> > +				i = (u32)GET_DWORD(proc_table + (13 * i) + 4);
> > +			}
> > +
> > +			/*
> > +			Set current_proc to the first procedure to be executed
> > +			*/
> > +			i = current_proc;
> > +			while ((i != 0) &&
> > +				((proc_attributes[i] == 1) ||
> > +				((proc_attributes[i] & 0xc0) == 0x40))) {
> > +				i = (u32)GET_DWORD(proc_table + (13 * i) + 4);
> > +			}
> > +
> > +			if ((i != 0) || ((i == 0) && (current_proc == 0) &&
> > +				((proc_attributes[0] != 1) &&
> > +				((proc_attributes[0] & 0xc0) != 0x40)))) {
> > +				current_proc = i;
> > +				pc = code_section +
> > +					GET_DWORD(proc_table + (13 * i) + 9);
> > +				CHECK_PC;
> 
> See my comments above. The code will look cleaner if you use, instead of
> the macro, something like:
> 
> 	if ((pc < code_section) || (pc >= debug_section))
> 		goto jbic_bounds_error;
> 
> (if you can simply abort the programming due to the error)
> 
> or
> 
> 	if ((pc < code_section) || (pc >= debug_section))
> 		status = <error code>;
> 
> if you really need to program everything even knowing in advance that an
> error happened.
> 
> > +			} else
> > +				/* there are no procedures to execute! */
> > +				done = 1;
> > +
> > +		}
> > +	}
> > +
> > +	message_buffer[0] = '\0';
> > +
> > +	while (!done) {
> > +		opcode = (u32)(GET_BYTE(pc) & 0xff);
> > +		opcode_address = pc;
> > +		++pc;
> > +
> > +		if (verbose > 1)
> > +			printk("opcode: %02x\n", opcode);
> > +
> > +		arg_count = (opcode >> 6) & 3;
> > +		for (i = 0; i < arg_count; ++i) {
> > +			args[i] = GET_DWORD(pc);
> > +			pc += 4;
> > +		}
> > +
> > +		switch (opcode) {
> > +		case 0x00: /* NOP  */
> > +			break;
> > +		case 0x01: /* DUP  */
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - 1];
> > +				++stack_ptr;
> > +			}
> > +			break;
> > +		case 0x02: /* SWP  */
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				long_temp = stack[stack_ptr - 2];
> > +				stack[stack_ptr - 2] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +			break;
> > +		case 0x03: /* ADD  */
> 
> hmm... the better would be to do:
> 
> enum altera_fpga_opcode {
> 	OP_NOP = 0,
> 	OP_DUP = 1,
> 	OP_SWP = 2,
> 	OP_ADD = 3,
> 	...
> };
> 
> switch (obcode) {
> case OP_NOP:
> 	/* do something */
> ...
> }
> 
> The rest of the driver have the same problems as pointed above.
> 
> Please fix, and submit a version 2.
Thank you Mauro.

I'm working on it.

Igor

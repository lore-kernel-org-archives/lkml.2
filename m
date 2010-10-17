Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932884Ab0JQV2r (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 17:28:47 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:46243 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932781Ab0JQV2p convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 17:28:45 -0400
From: "Igor M. Liplianin" <liplianin@me.by>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Subject: Re: [GIT PATCHES FOR 2.6.37]  Support for NetUP Dual DVB-T/C CI RF card V.2
Date: Mon, 18 Oct 2010 00:28:30 +0300
User-Agent: KMail/1.13.3 (Linux/2.6.35-smp+; KDE/4.4.3; i686; ; )
Cc: linux-media@vger.kernel.org, Abylai Ospan <aospan@netup.ru>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <201010171955.18806.liplianin@me.by> <4CBB37DC.6050507@infradead.org>
In-Reply-To: <4CBB37DC.6050507@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201010180028.31268.liplianin@me.by>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

В сообщении от 17 октября 2010 20:52:28 автор Mauro Carvalho Chehab написал:
> Em 17-10-2010 14:55, Igor M. Liplianin escreveu:
> > Patches to support for NetUP Dual DVB-T/C-CI RF from NetUP Inc.
> > 
> >         http://linuxtv.org/wiki/index.php/NetUP_Dual_DVB_T_C_CI_RF
> > 
> > Version 2,  Altera FPGA firmware download module reworked.
> > 
> > Features:
> > 
> > PCI-e x1
> > Supports two DVB-T/DVB-C transponders simultaneously
> > Supports two analog audio/video channels simultaneously
> > Independent descrambling of two transponders
> > Hardware PID filtering
> > 
> > Components:
> > 
> > Conexant CX23885
> > STM STV0367 low-power and ultra-compact combo DVB-T/C single-chip
> > receiver Xceive XC5000 silicon TV tuner
> > Altera FPGA for Common Interafce
> > 
> > The following changes since commit 1c8c51f7413ec522c7b729c8ebc5ce815fb7d4a8:
> >   V4L/DVB: drivers/media/IR/ene_ir.c: fix NULL dereference (2010-10-17
> >   09:50:42 -0200)
> > 
> > are available in the git repository at:
> >   http://udev.netup.ru/git/v4l-dvb.git netup-for-media-tree-2
> > 
> > Abylay Ospan (6):
> >       cx23885: Altera FPGA CI interface reworked.
> >       stv0367: change default value for AGC register.
> >       stv0367: implement uncorrected blocks counter.
> >       cx23885, cimax2.c: Fix case of two CAM insertion irq.
> >       Fix CI code for NetUP Dual  DVB-T/C CI RF card
> >       Force xc5000 firmware loading for NetUP Dual  DVB-T/C CI RF card
> > 
> > Igor M. Liplianin (14):
> >       Altera FPGA firmware download module.
> >       Altera FPGA based CI driver module.
> >       Support for stv0367 multi-standard demodulator.
> >       xc5000: add support for DVB-C tuning.
> >       Initial commit to support NetUP Dual DVB-T/C CI RF card.
> >       cx23885: implement tuner_bus parameter for cx23885_board structure.
> >       cx23885: implement num_fds_portb, num_fds_portc parameters for
> >       cx23885_board structure. stv0367: Fix potential divide error
> >       cx23885: remove duplicate set interrupt mask
> >       stv0367: coding style corrections
> >       cx25840: Fix subdev registration and typo in cx25840-core.c
> >       cx23885: 0xe becomes 0xc again for NetUP Dual DVB-S2
> >       cx23885: disable MSI for NetUP cards, otherwise CI is not working
> >       cx23885, altera-ci: enable all PID's less than 0x20 in hardware PID
> >       filter.
> >  
> >  drivers/media/common/tuners/xc5000.c        |   18 +
> >  drivers/media/dvb/frontends/Kconfig         |    7 +
> >  drivers/media/dvb/frontends/Makefile        |    1 +
> >  drivers/media/dvb/frontends/stv0367.c       | 3419
> >  +++++++++++++++++++++++++ drivers/media/dvb/frontends/stv0367.h       |
> >    62 +
> >  drivers/media/dvb/frontends/stv0367_priv.h  |  211 ++
> >  drivers/media/dvb/frontends/stv0367_regs.h  | 3614
> >  +++++++++++++++++++++++++++ drivers/media/video/cx23885/Kconfig        
> >  |   12 +-
> >  drivers/media/video/cx23885/Makefile        |    1 +
> >  drivers/media/video/cx23885/altera-ci.c     |  841 +++++++
> >  drivers/media/video/cx23885/altera-ci.h     |  102 +
> >  drivers/media/video/cx23885/cimax2.c        |   24 +-
> >  drivers/media/video/cx23885/cx23885-cards.c |  116 +-
> >  drivers/media/video/cx23885/cx23885-core.c  |   35 +-
> >  drivers/media/video/cx23885/cx23885-dvb.c   |  175 ++-
> >  drivers/media/video/cx23885/cx23885-reg.h   |    1 +
> >  drivers/media/video/cx23885/cx23885-video.c |    7 +-
> >  drivers/media/video/cx23885/cx23885.h       |    7 +-
> >  drivers/media/video/cx25840/cx25840-core.c  |    4 +-
> >  drivers/misc/Kconfig                        |    1 +
> >  drivers/misc/Makefile                       |    1 +
> >  drivers/misc/stapl-altera/Kconfig           |    8 +
> >  drivers/misc/stapl-altera/Makefile          |    3 +
> >  drivers/misc/stapl-altera/altera.c          | 2603 +++++++++++++++++++
> >  drivers/misc/stapl-altera/jbicomp.c         |  163 ++
> >  drivers/misc/stapl-altera/jbiexprt.h        |   32 +
> >  drivers/misc/stapl-altera/jbijtag.c         | 1038 ++++++++
> >  drivers/misc/stapl-altera/jbijtag.h         |   83 +
> >  drivers/misc/stapl-altera/jbistub.c         |   70 +
> >  include/misc/altera.h                       |   49 +
> >  30 files changed, 12674 insertions(+), 34 deletions(-)
> >  create mode 100644 drivers/media/dvb/frontends/stv0367.c
> >  create mode 100644 drivers/media/dvb/frontends/stv0367.h
> >  create mode 100644 drivers/media/dvb/frontends/stv0367_priv.h
> >  create mode 100644 drivers/media/dvb/frontends/stv0367_regs.h
> >  create mode 100644 drivers/media/video/cx23885/altera-ci.c
> >  create mode 100644 drivers/media/video/cx23885/altera-ci.h
> >  create mode 100644 drivers/misc/stapl-altera/Kconfig
> >  create mode 100644 drivers/misc/stapl-altera/Makefile
> >  create mode 100644 drivers/misc/stapl-altera/altera.c
> >  create mode 100644 drivers/misc/stapl-altera/jbicomp.c
> >  create mode 100644 drivers/misc/stapl-altera/jbiexprt.h
> >  create mode 100644 drivers/misc/stapl-altera/jbijtag.c
> >  create mode 100644 drivers/misc/stapl-altera/jbijtag.h
> >  create mode 100644 drivers/misc/stapl-altera/jbistub.c
> >  create mode 100644 include/misc/altera.h
> 
> There are still a few issues at FPGA patch.
> 
> > Altera FPGA firmware download module.
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
> >  drivers/misc/stapl-altera/altera.c   | 2603
> >  ++++++++++++++++++++++++++++++++++ drivers/misc/stapl-altera/jbicomp.c 
> >  |  163 +++
> >  drivers/misc/stapl-altera/jbiexprt.h |   32 +
> >  drivers/misc/stapl-altera/jbijtag.c  | 1038 ++++++++++++++
> >  drivers/misc/stapl-altera/jbijtag.h  |   83 ++
> >  drivers/misc/stapl-altera/jbistub.c  |   70 +
> >  include/misc/altera.h                |   49 +
> >  11 files changed, 4051 insertions(+), 0 deletions(-)
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
> > index 0000000..989bb79
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/altera.c
> > @@ -0,0 +1,2603 @@
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
> > +#include <asm/unaligned.h>
> > +#include <linux/string.h>
> > +#include <linux/firmware.h>
> > +#include <linux/slab.h>
> > +#include <misc/altera.h>
> > +#include "jbiexprt.h"
> > +
> > +static int debug = 1;
> > +module_param(debug, int, 0644);
> > +MODULE_PARM_DESC(debug, "enable debugging information");
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
> > +#define dprintk(args...) \
> > +	if (debug) { \
> > +		printk(KERN_DEBUG args); \
> > +	}
> > +
> > +enum altera_fpga_opcode {
> > +	OP_NOP = 0,
> > +	OP_DUP,
> > +	OP_SWP,
> > +	OP_ADD,
> > +	OP_SUB,
> > +	OP_MULT,
> > +	OP_DIV,
> > +	OP_MOD,
> > +	OP_SHL,
> > +	OP_SHR,
> > +	OP_NOT,
> > +	OP_AND,
> > +	OP_OR,
> > +	OP_XOR,
> > +	OP_INV,
> > +	OP_GT,
> > +	OP_LT,
> > +	OP_RET,
> > +	OP_CMPS,
> > +	OP_PINT,
> > +	OP_PRNT,
> > +	OP_DSS,
> > +	OP_DSSC,
> > +	OP_ISS,
> > +	OP_ISSC,
> > +	OP_DPR = 0x1c,
> > +	OP_DPRL,
> > +	OP_DPO,
> > +	OP_DPOL,
> > +	OP_IPR,
> > +	OP_IPRL,
> > +	OP_IPO,
> > +	OP_IPOL,
> > +	OP_PCHR,
> > +	OP_EXIT,
> > +	OP_EQU,
> > +	OP_POPT,
> > +	OP_ABS = 0x2c,
> > +	OP_BCH0,
> > +	OP_PSH0 = 0x2f,
> > +	OP_PSHL = 0x40,
> > +	OP_PSHV,
> > +	OP_JMP,
> > +	OP_CALL,
> > +	OP_NEXT,
> > +	OP_PSTR,
> > +	OP_SINT = 0x47,
> > +	OP_ST,
> > +	OP_ISTP,
> > +	OP_DSTP,
> > +	OP_SWPN,
> > +	OP_DUPN,
> > +	OP_POPV,
> > +	OP_POPE,
> > +	OP_POPA,
> > +	OP_JMPZ,
> > +	OP_DS,
> > +	OP_IS,
> > +	OP_DPRA,
> > +	OP_DPOA,
> > +	OP_IPRA,
> > +	OP_IPOA,
> > +	OP_EXPT,
> > +	OP_PSHE,
> > +	OP_PSHA,
> > +	OP_DYNA,
> > +	OP_EXPV = 0x5c,
> > +	OP_COPY = 0x80,
> > +	OP_REVA,
> > +	OP_DSC,
> > +	OP_ISC,
> > +	OP_WAIT,
> > +	OP_VS,
> > +	OP_CMPA = 0xc0,
> > +	OP_VSC,
> > +};
> > +
> > +struct jbi_procinfo {
> > +	char *name;
> > +	u8 attrs;
> > +	struct jbi_procinfo *next;
> > +};
> > +
> > +/* This function checks if enough parameters are available on the stack.
> > */ +static int jbi_check_stack(int stack_ptr, int count, int *status) +{
> > +	if (stack_ptr < count) {
> > +		*status = -EOVERFLOW;
> > +		return 0;
> > +	}
> > +
> > +	return 1;
> > +}
> > +
> > +static void jbi_export_integer(char *key, s32 value)
> > +{
> > +	dprintk("Export: key = \"\", value = 0\n", key, value);
> > +}
> > +
> > +#define HEX_LINE_CHARS 72
> > +#define HEX_LINE_BITS (HEX_LINE_CHARS * 4)
> > +
> > +static void jbi_export_boolean_array(char *key, u8 *data, s32 count)
> > +{
> > +	char string[HEX_LINE_CHARS + 1];
> > +	s32 i, offset;
> > +	u32 size, line, lines, linebits, value, j, k;
> > +
> > +	if (count > HEX_LINE_BITS) {
> > +		dprintk("Export: key = \"\", 0 bits, value = HEX\n",
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
> > +					sprintf(&string[j], "0", value);
> > +					value = 0;
> > +					--j;
> > +				}
> > +			}
> > +			if ((k & 3) > 0)
> > +				sprintf(&string[j], "0", value);
> > +
> > +			dprintk("\n", string);
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
> > +				sprintf(&string[j], "0", value);
> > +				value = 0;
> > +				--j;
> > +			}
> > +		}
> > +		if ((i & 3) > 0)
> > +			sprintf(&string[j], "0", value);
> > +
> > +		dprintk("Export: key = \"\", 0 bits, value = HEX \n",
> > +			key, count, string);
> > +	}
> > +}
> > +
> > +static int jbi_execute(struct altera_config *astate,
> > +				u8 *p,
> > +				s32 program_size,
> > +				s32 *error_address,
> > +				int *exit_code,
> > +				int *format_version)
> > +{
> > +	static char msg_buff[JBIC_MESSAGE_LENGTH + 1];
> > +	static long stack[JBI_STACK_SIZE] = {0L};/*64 bits*/
> 
> On Linux, long int doesn't mean 64 bits. If you want to use a data with 64
> bits, use, instead: u64, for unsigned (or s64, for signed).
> 
> Also, it doesn't seem to be a good idea to define those two data static.
> The proper way is to move those two data to some struct, for example, to
> astate. You may declare it as:
> 
> struct altera_config {
> 	void *dev;
> 	u8 *action;
> 	int (*jtag_io) (void *dev, int tms, int tdi, int tdo);
> 	char msg_buff[JBIC_MESSAGE_LENGTH + 1];
> 	u64 stack[JBI_STACK_SIZE];
> };
> 
> when you'll alloc it with kzconfig, stack will be initialized to zero
> already.
> 
> One advantage is that, if you have two devices, a FPGA init of one device
> wouldn't interfere in the other, even if they happen in parallel.
> 
> If you do that, you can just do here:
> 
> char *msg_buf = astate->msg_buf;
> u64 *stack = astate->stack;
> 
> > +	int status = 0;
> > +	u32 first_word = 0L;
> > +	u32 action_table = 0L;
> > +	u32 proc_table = 0L;
> > +	u32 str_table = 0L;
> > +	u32 sym_table = 0L;
> > +	u32 data_sect = 0L;
> > +	u32 code_sect = 0L;
> > +	u32 debug_sect = 0L;
> > +	u32 action_count = 0L;
> > +	u32 proc_count = 0L;
> > +	u32 sym_count = 0L;
> > +	long *vars = NULL;/*64bits*/
> 
> u64.
> 
> > +	s32 *var_size = NULL;
> > +	char *attrs = NULL;
> > +	u8 *proc_attributes = NULL;
> > +	u32 pc;
> > +	u32 opcode_address;
> > +	u32 args[3];
> > +	u32 opcode;
> > +	u32 name_id;
> > +	u8 charbuf[4];
> > +	long long_temp;/*64bits*/
> 
> u64.
> 
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
> > +	u32 uncomp_size;
> > +	u32 offset;
> > +	u32 value;
> > +	int current_proc = 0;
> > +	int reverse;
> > +
> > +	char *name;
> > +
> > +	dprintk("\n", __func__);
> > +
> > +	/* Read header information */
> > +	if (program_size > 52L) {
> > +		first_word    = get_unaligned_be32(&p[0]);
> > +		version = (int)(first_word & 1L);
> > +		*format_version = version + 1;
> > +		delta = version * 8;
> > +
> > +		action_table  = get_unaligned_be32(&p[4]);
> > +		proc_table    = get_unaligned_be32(&p[8]);
> > +		str_table  = get_unaligned_be32(&p[4 + delta]);
> > +		sym_table  = get_unaligned_be32(&p[16 + delta]);
> > +		data_sect  = get_unaligned_be32(&p[20 + delta]);
> > +		code_sect  = get_unaligned_be32(&p[24 + delta]);
> > +		debug_sect = get_unaligned_be32(&p[28 + delta]);
> > +		action_count  = get_unaligned_be32(&p[40 + delta]);
> > +		proc_count    = get_unaligned_be32(&p[44 + delta]);
> > +		sym_count  = get_unaligned_be32(&p[48 + (2 * delta)]);
> > +	}
> > +
> > +	if ((first_word != 0x4A414D00L) && (first_word != 0x4A414D01L)) {
> > +		done = 1;
> > +		status = -EIO;
> > +		goto exit_done;
> > +	}
> > +
> > +	if (sym_count <= 0)
> > +		goto exit_done;
> > +	/* 64 bits */
> > +	vars = kmalloc((u32)sym_count * sizeof(long), GFP_KERNEL);
> > +
> > +	if (vars == NULL)
> > +		status = -ENOMEM;
> > +
> > +	if (status == 0) {
> > +		var_size = kmalloc((u32)sym_count * sizeof(s32), GFP_KERNEL);
> > +
> > +		if (var_size == NULL)
> > +			status = -ENOMEM;
> > +	}
> > +
> > +	if (status == 0) {
> > +		attrs = (char *)kmalloc((u32)sym_count, GFP_KERNEL);
> > +
> > +		if (attrs == NULL)
> > +			status = -ENOMEM;
> > +	}
> > +
> > +	if ((status == 0) && (version > 0)) {
> > +		proc_attributes = (u8 *)kmalloc((u32)proc_count, GFP_KERNEL);
> > +
> > +		if (proc_attributes == NULL)
> > +			status = -ENOMEM;
> > +	}
> 
> Hmm... are you initializing proc_attributes at the loop bellow? Otherwise,
> the better is to use kzalloc.
> 
> > +
> > +	if (status != 0)
> > +		goto exit_done;
> > +
> > +	delta = version * 2;
> > +
> > +	for (i = 0; i < (u32)sym_count; ++i) {
> > +		offset = (u32)(sym_table + ((11 + delta) * i));
> > +
> > +		value = get_unaligned_be32(&p[offset + 3 + delta]);
> > +
> > +		attrs[i] = p[offset];
> > +
> > +		/* use bit 7 of attribute byte to indicate that
> > +		this buffer was dynamically allocated
> > +		and should be freed later */
> > +		attrs[i] &= 0x7f;
> > +
> > +		var_size[i] = get_unaligned_be32(&p[offset + 7 + delta]);
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
> > +		if ((attrs[i] & 0x0c) == 0x04)
> > +			/* initialized scalar variable */
> > +			vars[i] = value;
> > +		else if ((attrs[i] & 0x1e) == 0x0e) {
> > +			/* initialized compressed
> > +			Boolean array */
> > +			uncomp_size = get_unaligned_le32(&p[data_sect + value]);
> > +
> > +			/* allocate a buffer for the
> > +			uncompressed data */
> > +			vars[i] = (long)kmalloc(uncomp_size, GFP_KERNEL);
> 
> kzalloc?
> 
> > +			if (vars[i] == 0L)
> > +				status = -ENOMEM;
> > +			else {
> > +				/* set flag so buffer
> > +				will be freed later */
> > +				attrs[i] |= 0x80;
> > +
> > +				/* uncompress the data */
> > +				if (jbi_uncompress(&p[data_sect + value],
> > +						var_size[i],
> > +						(u8 *)vars[i],/*64 bits*/
> > +						uncomp_size,
> > +						version) != uncomp_size)
> > +					/* decompression failed */
> > +					status = -EIO;
> > +				else /*64 bits?*/
> > +					var_size[i] = uncomp_size * 8L;
> > +
> > +			}
> > +		} else if ((attrs[i] & 0x1e) == 0x0c) {
> > +			/* initialized Boolean array */
> > +			/*64 bits*/
> > +			vars[i] = value + data_sect + (long)p;
> > +		} else if ((attrs[i] & 0x1c) == 0x1c) {
> > +			/* initialized integer array */
> > +			vars[i] = value + data_sect;
> > +		} else if ((attrs[i] & 0x0c) == 0x08) {
> > +			/* uninitialized array */
> > +
> > +			/* flag attrs so
> > +			that memory is freed */
> > +			attrs[i] |= 0x80;
> > +
> > +			if (var_size[i] > 0) {
> > +				u32 size;
> > +
> > +				if (attrs[i] & 0x10)
> > +					/* integer array */
> > +					size = (u32)(var_size[i] *
> > +								sizeof(s32));
> > +				else
> > +					/* Boolean array */
> > +					size = (u32)
> > +						((var_size[i] + 7L) / 8L);
> > +				/*64 bits*/
> > +				vars[i] = (long)kmalloc(size, GFP_KERNEL);
> 
> kzalloc?
> 
> > +
> > +				if (vars[i] == 0) {
> > +					status = -ENOMEM;
> > +				} else {
> > +					/* zero out memory */
> > +					for (j = 0; j < size; ++j)
> > +						/*64 bits*/
> > +						((u8 *)(vars[i]))[j] = 0;
> > +
> > +				}
> > +			} else
> > +				vars[i] = 0;
> > +
> > +		} else
> > +			vars[i] = 0;
> > +
> > +	}
> > +
> > +exit_done:
> > +	if (status != 0)
> > +		done = 1;
> > +
> > +	jbi_init_jtag();
> > +
> > +	pc = code_sect;
> > +	msg_buff[0] = '\0';
> > +
> > +	/*
> > +	For JBC version 2, we will execute the procedures corresponding to
> > +	the selected ACTION */
> > +	if (version > 0) {
> > +		if (astate->action == NULL) {
> > +			status = -EINVAL;
> > +			done = 1;
> > +		} else {
> > +			int action_found = 0;
> > +			for (i = 0; (i < action_count) && !action_found; ++i) {
> > +				name_id = get_unaligned_be32(&p[action_table + (12 * i)]);
> > +
> > +				name = (char *)&p[str_table + name_id];
> > +
> > +				if (strnicmp(astate->action, name, strlen(name)) == 0) {
> > +					action_found = 1;
> > +					current_proc = (int)
> > +							get_unaligned_be32(&p[action_table +
> > +								(12 * i) + 8]);
> > +				}
> > +			}
> > +
> > +			if (!action_found) {
> > +				status = -EINVAL;
> > +				done = 1;
> > +			}
> > +		}
> > +
> > +		if (status == 0) {
> > +			int first_time = 1;
> > +			i = current_proc;
> > +			while ((i != 0) || first_time) {
> > +				first_time = 0;
> > +				/* check procedure attribute byte */
> > +				proc_attributes[i] = (u8)
> > +						(p[proc_table +
> > +								(13 * i) + 8] &
> > +									0x03);
> > +
> > +				/*
> > +				BIT0 - OPTIONAL
> > +				BIT1 - RECOMMENDED
> > +				BIT6 - FORCED OFF
> > +				BIT7 - FORCED ON
> > +				*/
> > +
> > +				i = (u32)get_unaligned_be32(&p[proc_table + (13 * i) + 4]);
> > +			}
> > +
> > +			/*
> > +			Set current_proc to the first procedure to be executed
> > +			*/
> > +			i = current_proc;
> > +			while ((i != 0) &&
> > +				((proc_attributes[i] == 1) ||
> > +				((proc_attributes[i] & 0xc0) == 0x40))) {
> > +				i = (u32)get_unaligned_be32(&p[proc_table + (13 * i) + 4]);
> > +			}
> > +
> > +			if ((i != 0) || ((i == 0) && (current_proc == 0) &&
> > +				((proc_attributes[0] != 1) &&
> > +				((proc_attributes[0] & 0xc0) != 0x40)))) {
> > +				current_proc = i;
> > +				pc = code_sect +
> > +					get_unaligned_be32(&p[proc_table + (13 * i) + 9]);
> > +				if ((pc < code_sect) || (pc >= debug_sect))
> > +					status = -ERANGE;
> > +			} else
> > +				/* there are no procedures to execute! */
> > +				done = 1;
> > +
> > +		}
> > +	}
> > +
> > +	msg_buff[0] = '\0';
> > +
> > +	while (!done) {
> > +		opcode = (u32)(p[pc] & 0xff);
> > +		opcode_address = pc;
> > +		++pc;
> > +
> > +		if (debug > 1)
> > +			printk("opcode: 00\n", opcode);
> > +
> > +		arg_count = (opcode >> 6) & 3;
> > +		for (i = 0; i < arg_count; ++i) {
> > +			args[i] = get_unaligned_be32(&p[pc]);
> > +			pc += 4;
> > +		}
> > +
> > +		switch (opcode) {
> > +		case OP_NOP:
> > +			break;
> > +		case OP_DUP:
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - 1];
> > +				++stack_ptr;
> > +			}
> > +			break;
> > +		case OP_SWP:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				long_temp = stack[stack_ptr - 2];
> > +				stack[stack_ptr - 2] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +			break;
> > +		case OP_ADD:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] += stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_SUB:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] -= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_MULT:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] *= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_DIV:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] /= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_MOD:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] %= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_SHL:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] <<= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_SHR:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] >>= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_NOT:
> > +			if (jbi_check_stack(stack_ptr, 1, &status))
> > +				stack[stack_ptr - 1] ^= (-1L);
> > +
> > +			break;
> > +		case OP_AND:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] &= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_OR:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] |= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_XOR:
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				--stack_ptr;
> > +				stack[stack_ptr - 1] ^= stack[stack_ptr];
> > +			}
> > +			break;
> > +		case OP_INV:
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			stack[stack_ptr - 1] = stack[stack_ptr - 1] ? 0L : 1L;
> > +			break;
> > +		case OP_GT:
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			--stack_ptr;
> > +			stack[stack_ptr - 1] =
> > +				(stack[stack_ptr - 1] > stack[stack_ptr]) ?
> > +									1L : 0L;
> > +
> > +			break;
> > +		case OP_LT:
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			--stack_ptr;
> > +			stack[stack_ptr - 1] =
> > +				(stack[stack_ptr - 1] < stack[stack_ptr]) ?
> > +									1L : 0L;
> > +
> > +			break;
> > +		case OP_RET:
> > +			if ((version > 0) && (stack_ptr == 0)) {
> > +				/*
> > +				We completed one of the main procedures
> > +				of an ACTION.
> > +				Find the next procedure
> > +				to be executed and jump to it.
> > +				If there are no more procedures, then EXIT.
> > +				*/
> > +				i = (u32)
> > +					get_unaligned_be32(&p[proc_table +
> > +						(13 * current_proc) + 4]);
> > +				while ((i != 0) &&
> > +					((proc_attributes[i] == 1) ||
> > +					((proc_attributes[i] & 0xc0) == 0x40)))
> > +					i = (u32)
> > +						get_unaligned_be32(&p[proc_table +
> > +								(13 * i) + 4]);
> > +
> > +				if (i == 0) {
> > +					/*
> > +					there are no procedures to execute! */
> > +					done = 1;
> > +					*exit_code = 0;	/* success */
> > +				} else {
> > +					current_proc = i;
> > +					pc = code_sect + get_unaligned_be32(
> > +								&p[proc_table +
> > +								(13 * i) + 9]);
> > +					if ((pc < code_sect) ||
> > +					    (pc >= debug_sect))
> > +						status = -ERANGE;
> > +				}
> > +
> > +			} else
> > +				if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +					pc = stack[--stack_ptr] + code_sect;
> > +					if ((pc <= code_sect) ||
> > +					    (pc >= debug_sect))
> > +						status = -ERANGE;
> > +
> > +				}
> > +
> > +			break;
> > +		case OP_CMPS:
> > +			/*
> > +			Array short compare
> > +			...stack 0 is source 1 value
> > +			...stack 1 is source 2 value
> > +			...stack 2 is mask value
> > +			...stack 3 is count
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 4, &status)) {
> > +				s32 a = stack[--stack_ptr];
> > +				s32 b = stack[--stack_ptr];
> > +				long_temp = stack[--stack_ptr];
> > +				count = (u32)stack[stack_ptr - 1];
> > +
> > +				if ((count < 1) || (count > 32))
> > +					status = -ERANGE;
> > +				else {
> > +					long_temp &= ((-1L) >> (32 - count));
> > +
> > +					stack[stack_ptr - 1] =
> > +					((a & long_temp) == (b & long_temp))
> > +								? 1L : 0L;
> > +				}
> > +			}
> > +			break;
> > +		case OP_PINT:
> > +			/*
> > +			PRINT add integer
> > +			...stack 0 is integer value
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			sprintf(&msg_buff[strlen(msg_buff)],
> > +					"0", stack[--stack_ptr]);
> > +			break;
> > +		case OP_PRNT:
> > +			/* PRINT finish */
> > +			if (debug)
> > +				printk(msg_buff, "\n");
> > +
> > +			msg_buff[0] = '\0';
> > +			break;
> > +		case OP_DSS:
> > +			/*
> > +			DRSCAN short
> > +			...stack 0 is scan data
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_temp = stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_do_drscan(astate, count, charbuf, 0);
> > +			break;
> > +		case OP_DSSC:
> > +			/*
> > +			DRSCAN short with capture
> > +			...stack 0 is scan data
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_temp = stack[--stack_ptr];
> > +			count = (u32)stack[stack_ptr - 1];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_swap_dr(astate, count, charbuf,
> > +							0, charbuf, 0);
> > +			stack[stack_ptr - 1] = get_unaligned_le32(&charbuf[0]);
> > +			break;
> > +		case OP_ISS:
> > +			/*
> > +			IRSCAN short
> > +			...stack 0 is scan data
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_temp = stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_do_irscan(astate, count, charbuf, 0);
> > +			break;
> > +		case OP_ISSC:
> > +			/*
> > +			IRSCAN short with capture
> > +			...stack 0 is scan data
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_temp = stack[--stack_ptr];
> > +			count = (u32)stack[stack_ptr - 1];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_swap_ir(astate, count, charbuf,
> > +							0, charbuf, 0);
> > +			stack[stack_ptr - 1] = get_unaligned_le32(&charbuf[0]);
> > +			break;
> > +		case OP_DPR:
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			count = (u32)stack[--stack_ptr];
> > +			status = jbi_set_dr_preamble(count, 0, NULL);
> > +			break;
> > +		case OP_DPRL:
> > +			/*
> > +			DRPRE with literal data
> > +			...stack 0 is count
> > +			...stack 1 is literal data
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			count = (u32)stack[--stack_ptr];
> > +			long_temp = stack[--stack_ptr];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_set_dr_preamble(count, 0, charbuf);
> > +			break;
> > +		case OP_DPO:
> > +			/*
> > +			DRPOST
> > +			...stack 0 is count
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				count = (u32)stack[--stack_ptr];
> > +				status = jbi_set_dr_postamble(count, 0, NULL);
> > +			}
> > +			break;
> > +		case OP_DPOL:
> > +			/*
> > +			DRPOST with literal data
> > +			...stack 0 is count
> > +			...stack 1 is literal data
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			count = (u32)stack[--stack_ptr];
> > +			long_temp = stack[--stack_ptr];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_set_dr_postamble(count, 0, charbuf);
> > +			break;
> > +		case OP_IPR:
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				count = (u32)stack[--stack_ptr];
> > +				status = jbi_set_ir_preamble(count, 0, NULL);
> > +			}
> > +			break;
> > +		case OP_IPRL:
> > +			/*
> > +			IRPRE with literal data
> > +			...stack 0 is count
> > +			...stack 1 is literal data
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				count = (u32)stack[--stack_ptr];
> > +				long_temp = stack[--stack_ptr];
> > +				put_unaligned_le32(long_temp, &charbuf[0]);
> > +				status = jbi_set_ir_preamble(count, 0, charbuf);
> > +			}
> > +			break;
> > +		case OP_IPO:
> > +			/*
> > +			IRPOST
> > +			...stack 0 is count
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				count = (u32)stack[--stack_ptr];
> > +				status = jbi_set_ir_postamble(count, 0, NULL);
> > +			}
> > +			break;
> > +		case OP_IPOL:
> > +			/*
> > +			IRPOST with literal data
> > +			...stack 0 is count
> > +			...stack 1 is literal data
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			count = (u32)stack[--stack_ptr];
> > +			long_temp = stack[--stack_ptr];
> > +			put_unaligned_le32(long_temp, &charbuf[0]);
> > +			status = jbi_set_ir_postamble(count, 0, charbuf);
> > +			break;
> > +		case OP_PCHR:
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				u8 ch;
> > +				count = strlen(msg_buff);
> > +				ch = (char) stack[--stack_ptr];
> > +				if ((ch < 1) || (ch > 127)) {
> > +					/*
> > +					character code out of range
> > +					instead of flagging an error,
> > +					force the value to 127 */
> > +					ch = 127;
> > +				}
> > +				msg_buff[count] = ch;
> > +				msg_buff[count + 1] = '\0';
> > +			}
> > +			break;
> > +		case OP_EXIT:
> > +			if (jbi_check_stack(stack_ptr, 1, &status))
> > +				*exit_code = (int) stack[--stack_ptr];
> > +
> > +			done = 1;
> > +			break;
> > +		case OP_EQU:
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			--stack_ptr;
> > +			stack[stack_ptr - 1] =
> > +				(stack[stack_ptr - 1] == stack[stack_ptr]) ?
> > +									1L : 0L;
> > +			break;
> > +		case OP_POPT:
> > +			if (jbi_check_stack(stack_ptr, 1, &status))
> > +				--stack_ptr;
> > +
> > +			break;
> > +		case OP_ABS:
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			if (stack[stack_ptr - 1] < 0)
> > +				stack[stack_ptr - 1] = 0 - stack[stack_ptr - 1];
> > +
> > +			break;
> > +		case OP_BCH0:
> > +			/*
> > +			Batch operation 0
> > +			SWP
> > +			SWPN 7
> > +			SWP
> > +			SWPN 6
> > +			DUPN 8
> > +			SWPN 2
> > +			SWP
> > +			DUPN 6
> > +			DUPN 6
> > +			*/
> > +
> > +			/* SWP  */
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				long_temp = stack[stack_ptr - 2];
> > +				stack[stack_ptr - 2] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* SWPN 7 */
> > +			index = 7 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				long_temp = stack[stack_ptr - index];
> > +				stack[stack_ptr - index] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* SWP  */
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				long_temp = stack[stack_ptr - 2];
> > +				stack[stack_ptr - 2] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* SWPN 6 */
> > +			index = 6 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				long_temp = stack[stack_ptr - index];
> > +				stack[stack_ptr - index] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* DUPN 8 */
> > +			index = 8 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - index];
> > +				++stack_ptr;
> > +			}
> > +
> > +			/* SWPN 2 */
> > +			index = 2 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				long_temp = stack[stack_ptr - index];
> > +				stack[stack_ptr - index] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* SWP  */
> > +			if (jbi_check_stack(stack_ptr, 2, &status)) {
> > +				long_temp = stack[stack_ptr - 2];
> > +				stack[stack_ptr - 2] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +
> > +			/* DUPN 6 */
> > +			index = 6 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - index];
> > +				++stack_ptr;
> > +			}
> > +
> > +			/* DUPN 6 */
> > +			index = 6 + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - index];
> > +				++stack_ptr;
> > +			}
> > +			break;
> > +		case OP_PSH0:
> > +			stack[stack_ptr++] = 0;
> > +			break;
> > +		case OP_PSHL:
> > +			stack[stack_ptr++] = (s32) args[0];
> > +			break;
> > +		case OP_PSHV:
> > +			stack[stack_ptr++] = vars[args[0]];
> > +			break;
> > +		case OP_JMP:
> > +			pc = args[0] + code_sect;
> > +			if ((pc < code_sect) || (pc >= debug_sect))
> > +				status = -ERANGE;
> > +			break;
> > +		case OP_CALL:
> > +			stack[stack_ptr++] = pc;
> > +			pc = args[0] + code_sect;
> > +			if ((pc < code_sect) || (pc >= debug_sect))
> > +				status = -ERANGE;
> > +			break;
> > +		case OP_NEXT:
> > +			/*
> > +			Process FOR / NEXT loop
> > +			...argument 0 is variable ID
> > +			...stack 0 is step value
> > +			...stack 1 is end value
> > +			...stack 2 is top address
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 3, &status)) {
> > +				s32 step = stack[stack_ptr - 1];
> > +				s32 end = stack[stack_ptr - 2];
> > +				s32 top = stack[stack_ptr - 3];
> > +				s32 iterator = vars[args[0]];
> > +				int break_out = 0;
> > +
> > +				if (step < 0) {
> > +					if (iterator <= end)
> > +						break_out = 1;
> > +				} else if (iterator >= end)
> > +					break_out = 1;
> > +
> > +				if (break_out) {
> > +					stack_ptr -= 3;
> > +				} else {
> > +					vars[args[0]] = iterator + step;
> > +					pc = top + code_sect;
> > +					if ((pc < code_sect) ||
> > +					    (pc >= debug_sect))
> > +						status = -ERANGE;
> > +				}
> > +			}
> > +			break;
> > +		case OP_PSTR:
> > +			/*
> > +			PRINT add string
> > +			...argument 0 is string ID
> > +			*/
> > +			count = strlen(msg_buff);
> > +			strlcpy(&msg_buff[count],
> > +				(char *)&p[str_table + args[0]],
> > +				JBIC_MESSAGE_LENGTH - count);
> > +			break;
> > +		case OP_SINT:
> > +			/*
> > +			STATE intermediate state
> > +			...argument 0 is state code
> > +			*/
> > +			status = jbi_goto_jtag_state(astate, (int) args[0]);
> > +			break;
> > +		case OP_ST:
> > +			/*
> > +			STATE final state
> > +			...argument 0 is state code
> > +			*/
> > +			status = jbi_goto_jtag_state(astate, (int) args[0]);
> > +			break;
> > +		case OP_ISTP:
> > +			/*
> > +			IRSTOP state
> > +			...argument 0 is state code
> > +			*/
> > +			status = jbi_set_irstop_state((int) args[0]);
> > +			break;
> > +		case OP_DSTP:
> > +			/*
> > +			DRSTOP state
> > +			...argument 0 is state code
> > +			*/
> > +			status = jbi_set_drstop_state((int) args[0]);
> > +			break;
> > +
> > +		case OP_SWPN:
> > +			/*
> > +			Exchange top with Nth stack value
> > +			...argument 0 is 0-based stack entry
> > +			to swap with top element
> > +			*/
> > +			index = ((int) args[0]) + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				long_temp = stack[stack_ptr - index];
> > +				stack[stack_ptr - index] = stack[stack_ptr - 1];
> > +				stack[stack_ptr - 1] = long_temp;
> > +			}
> > +			break;
> > +		case OP_DUPN:
> > +			/*
> > +			Duplicate Nth stack value
> > +			...argument 0 is 0-based stack entry to duplicate
> > +			*/
> > +			index = ((int) args[0]) + 1;
> > +			if (jbi_check_stack(stack_ptr, index, &status)) {
> > +				stack[stack_ptr] = stack[stack_ptr - index];
> > +				++stack_ptr;
> > +			}
> > +			break;
> > +		case OP_POPV:
> > +			/*
> > +			* Pop stack into scalar variable
> > +			...argument 0 is variable ID
> > +			...stack 0 is value
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 1, &status))
> > +				vars[args[0]] = stack[--stack_ptr];
> > +
> > +			break;
> > +		case OP_POPE:
> > +			/*
> > +			Pop stack into integer array element
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is value
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			variable_id = (u32)args[0];
> > +
> > +			/*
> > +			If variable is read-only,
> > +			convert to writable array */
> > +			if ((version > 0) &&
> > +				((attrs[variable_id] & 0x9c) == 0x1c)) {
> > +				/* Allocate a writable buffer for this array */
> > +				count = (u32)var_size[variable_id];
> > +				long_temp = vars[variable_id];
> > +				/*64 bits*/
> > +				longptr_temp = (long *)
> > +					kmalloc(count * sizeof(long),
> > +								GFP_KERNEL);
> > +				/*64 bits*/
> > +				vars[variable_id] = (long)longptr_temp;
> > +
> > +				if (vars[variable_id] == 0) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				/* copy previous contents into buffer */
> > +				for (i = 0; i < count; ++i) {
> > +					/*64 QWORD?*/
> > +					longptr_temp[i] = get_unaligned_be32(&p[long_temp]);
> > +					long_temp += sizeof(long);/*64*/
> > +				}
> > +
> > +				/*
> > +				set bit 7 - buffer was
> > +				dynamically allocated */
> > +				attrs[variable_id] |= 0x80;
> > +
> > +				/* clear bit 2 - variable is writable */
> > +				attrs[variable_id] &= ~0x04;
> > +				attrs[variable_id] |= 0x01;
> > +
> > +			}
> > +
> > +			/* check that variable is a writable integer array */
> > +			if ((attrs[variable_id] & 0x1c) != 0x18)
> > +				status = -ERANGE;
> > +			else {
> > +				/*64 bits*/
> > +				longptr_temp = (long *)vars[variable_id];
> > +
> > +				/* pop the array index */
> > +				index = (u32)stack[--stack_ptr];
> > +
> > +				/* pop the value and store it into the array */
> > +				longptr_temp[index] = stack[--stack_ptr];
> > +			}
> > +
> > +			break;
> > +		case OP_POPA:
> > +			/*
> > +			Pop stack into Boolean array
> > +			...argument 0 is variable ID
> > +			...stack 0 is count
> > +			...stack 1 is array index
> > +			...stack 2 is value
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 3, &status))
> > +				break;
> > +			variable_id = (u32)args[0];
> > +
> > +			/*
> > +			If variable is read-only, convert to writable array */
> > +			if ((version > 0) &&
> > +				((attrs[variable_id] & 0x9c) == 0x0c)) {
> > +				/* Allocate a writable buffer for this array */
> > +				long_temp =
> > +					(var_size[variable_id] + 7L) >> 3L;
> > +				charptr_temp2 = (u8 *)vars[variable_id];
> > +				charptr_temp =
> > +					kmalloc((u32)long_temp, GFP_KERNEL);
> > +				/*64 bits*/
> > +				vars[variable_id] = (long)charptr_temp;
> > +
> > +				if (vars[variable_id] == 0) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				/* zero the buffer */
> > +				for (long_index = 0L;
> > +					long_index < long_temp;
> > +					++long_index) {
> > +					charptr_temp[long_index] = 0;
> > +				}
> > +
> > +				/* copy previous contents into buffer */
> > +				for (long_index = 0L;
> > +					long_index < var_size[variable_id];
> > +					++long_index) {
> > +					long_index2 = long_index;
> > +
> > +					if (charptr_temp2[long_index2 >> 3] &
> > +						(1 << (long_index2 & 7))) {
> > +						charptr_temp[long_index >> 3] |=
> > +							(1 << (long_index & 7));
> > +					}
> > +				}
> > +
> > +				/*
> > +				set bit 7 - buffer was dynamically allocated */
> > +				attrs[variable_id] |= 0x80;
> > +
> > +				/* clear bit 2 - variable is writable */
> > +				attrs[variable_id] &= ~0x04;
> > +				attrs[variable_id] |= 0x01;
> > +
> > +			}
> > +
> > +			/*
> > +			check that variable is
> > +			a writable Boolean array */
> > +			if ((attrs[variable_id] & 0x1c) != 0x08) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			charptr_temp = (u8 *)vars[variable_id];
> > +
> > +			/* pop the count (number of bits to copy) */
> > +			long_count = stack[--stack_ptr];
> > +
> > +			/* pop the array index */
> > +			long_index = stack[--stack_ptr];
> > +
> > +			reverse = 0;
> > +
> > +			if (version > 0) {
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index */
> > +
> > +				if (long_index > long_count) {
> > +					reverse = 1;
> > +					long_temp = long_count;
> > +					long_count = 1 + long_index -
> > +								long_count;
> > +					long_index = long_temp;
> > +
> > +					/* reverse POPA is not supported */
> > +					status = -ERANGE;
> > +					break;
> > +				} else
> > +					long_count = 1 + long_count -
> > +								long_index;
> > +
> > +			}
> > +
> > +			/* pop the data */
> > +			long_temp = stack[--stack_ptr];
> > +
> > +			if (long_count < 1) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			for (i = 0; i < (u32)long_count; ++i) {
> > +				if (long_temp & (1L << (s32) i))
> > +					charptr_temp[long_index >> 3L] |=
> > +						(1L << (long_index & 7L));
> > +				else
> > +					charptr_temp[long_index >> 3L] &=
> > +						~(u32)(1L << (long_index & 7L));
> > +
> > +				++long_index;
> > +			}
> > +
> > +			break;
> > +		case OP_JMPZ:
> > +			/*
> > +			Pop stack and branch if zero
> > +			...argument 0 is address
> > +			...stack 0 is condition value
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				if (stack[--stack_ptr] == 0) {
> > +					pc = args[0] + code_sect;
> > +					if ((pc < code_sect) ||
> > +					    (pc >= debug_sect))
> > +						status = -ERANGE;
> > +				}
> > +			}
> > +			break;
> > +		case OP_DS:
> > +		case OP_IS:
> > +			/*
> > +			DRSCAN
> > +			IRSCAN
> > +			...argument 0 is scan data variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_index = stack[--stack_ptr];
> > +			long_count = stack[--stack_ptr];
> > +			reverse = 0;
> > +			if (version > 0) {
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index
> > +				stack 2 = count */
> > +				long_temp = long_count;
> > +				long_count = stack[--stack_ptr];
> > +
> > +				if (long_index > long_temp) {
> > +					reverse = 1;
> > +					long_index = long_temp;
> > +				}
> > +			}
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +
> > +			if (reverse) {
> > +				/*
> > +				allocate a buffer and reverse the data order */
> > +				charptr_temp2 = charptr_temp;
> > +				charptr_temp = kmalloc((long_count >> 3) + 1,
> > +								GFP_KERNEL);
> > +				if (charptr_temp == NULL) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				long_temp = long_index + long_count - 1;
> > +				long_index2 = 0;
> > +				while (long_index2 < long_count) {
> > +					if (charptr_temp2[long_temp >> 3] &
> > +							(1 << (long_temp & 7)))
> > +						charptr_temp[long_index2 >> 3] |= (1 << (long_index2 & 7));
> > +					else
> > +						charptr_temp[long_index2 >> 3] &= ~(1 << (long_index2 & 7));
> > +
> > +					--long_temp;
> > +					++long_index2;
> > +				}
> > +			}
> > +
> > +			if (opcode == 0x51) /* DS */
> > +				status = jbi_do_drscan(astate, (u32)long_count,
> > +						charptr_temp, (u32)long_index);
> > +			else /* IS */
> > +				status = jbi_do_irscan(astate, (u32)long_count,
> > +						charptr_temp, (u32)long_index);
> > +
> > +			if (reverse && (charptr_temp != NULL))
> > +				kfree(charptr_temp);
> > +
> > +			break;
> > +		case OP_DPRA:
> > +			/*
> > +			DRPRE with array data
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			index = (u32)stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +
> > +			if (version > 0)
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index */
> > +				count = 1 + count - index;
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +			status = jbi_set_dr_preamble(count, index,
> > +							charptr_temp);
> > +			break;
> > +		case OP_DPOA:
> > +			/*
> > +			DRPOST with array data
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			index = (u32)stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +
> > +			if (version > 0)
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index */
> > +				count = 1 + count - index;
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +			status = jbi_set_dr_postamble(count, index,
> > +							charptr_temp);
> > +			break;
> > +		case OP_IPRA:
> > +			/*
> > +			IRPRE with array data
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			index = (u32)stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +
> > +			if (version > 0)
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index */
> > +				count = 1 + count - index;
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +			status = jbi_set_ir_preamble(count, index,
> > +							charptr_temp);
> > +
> > +			break;
> > +		case OP_IPOA:
> > +			/*
> > +			IRPOST with array data
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			...stack 1 is count
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			index = (u32)stack[--stack_ptr];
> > +			count = (u32)stack[--stack_ptr];
> > +
> > +			if (version > 0)
> > +				/*
> > +				stack 0 = array right index
> > +				stack 1 = array left index */
> > +				count = 1 + count - index;
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +			status = jbi_set_ir_postamble(count, index,
> > +							charptr_temp);
> > +
> > +			break;
> > +		case OP_EXPT:
> > +			/*
> > +			EXPORT
> > +			...argument 0 is string ID
> > +			...stack 0 is integer expression
> > +			*/
> > +			if (jbi_check_stack(stack_ptr, 1, &status)) {
> > +				name = (char *)&p[str_table + args[0]];
> > +				long_temp = stack[--stack_ptr];
> > +				jbi_export_integer(name, long_temp);
> > +			}
> > +			break;
> > +		case OP_PSHE:
> > +			/*
> > +			Push integer array element
> > +			...argument 0 is variable ID
> > +			...stack 0 is array index
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			variable_id = (u32)args[0];
> > +			index = (u32)stack[stack_ptr - 1];
> > +
> > +			/* check variable type */
> > +			if ((attrs[variable_id] & 0x1f) == 0x19) {
> > +				/* writable integer array */
> > +				longptr_temp = (long *)vars[variable_id];
> > +				stack[stack_ptr - 1] = longptr_temp[index];
> > +			} else if ((attrs[variable_id] & 0x1f) == 0x1c) {
> > +				/* read-only integer array */
> > +				long_temp = vars[variable_id] +
> > +						(sizeof(long) * index);/*64*/
> > +				stack[stack_ptr - 1] = get_unaligned_be32(&p[long_temp]);
> > +			} else
> > +				status = -ERANGE;
> > +
> > +			break;
> > +		case OP_PSHA:
> > +			/*
> > +			Push Boolean array
> > +			...argument 0 is variable ID
> > +			...stack 0 is count
> > +			...stack 1 is array index
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			variable_id = (u32)args[0];
> > +
> > +			/* check that variable is a Boolean array */
> > +			if ((attrs[variable_id] & 0x18) != 0x08) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			charptr_temp = (u8 *)vars[variable_id];
> > +
> > +			/* pop the count (number of bits to copy) */
> > +			count = (u32)stack[--stack_ptr];
> > +
> > +			/* pop the array index */
> > +			index = (u32)stack[stack_ptr - 1];
> > +
> > +			if (version > 0)
> > +				/* stack 0 = array right index */
> > +				/* stack 1 = array left index */
> > +				count = 1 + count - index;
> > +
> > +			if ((count < 1) || (count > 32)) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			long_temp = 0L;
> > +
> > +			for (i = 0; i < count; ++i)
> > +				if (charptr_temp[(i + index) >> 3] &
> > +						(1 << ((i + index) & 7)))
> > +					long_temp |= (1L << i);
> > +
> > +			stack[stack_ptr - 1] = long_temp;
> > +
> > +			break;
> > +		case OP_DYNA:
> > +			/*
> > +			Dynamically change size of array
> > +			...argument 0 is variable ID
> > +			...stack 0 is new size
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 1, &status))
> > +				break;
> > +			variable_id = (u32)args[0];
> > +			long_temp = stack[--stack_ptr];
> > +
> > +			if (long_temp > var_size[variable_id]) {
> > +				var_size[variable_id] = long_temp;
> > +
> > +				if (attrs[variable_id] & 0x10)
> > +					/* allocate integer array */
> > +					long_temp *= sizeof(long);
> > +				else
> > +					/* allocate Boolean array */
> > +					long_temp = (long_temp + 7) >> 3;
> > +
> > +				/*
> > +				If the buffer was previously allocated,
> > +				free it */
> > +				if ((attrs[variable_id] & 0x80) &&
> > +						(vars[variable_id] != 0)) {
> > +					kfree((void *)vars[variable_id]);
> > +					vars[variable_id] = 0;
> > +				}
> > +
> > +				/*
> > +				Allocate a new buffer
> > +				of the requested size */
> > +				/*64 bits*/
> > +				vars[variable_id] = (long)
> > +					kmalloc((u32)long_temp, GFP_KERNEL);
> > +
> > +				if (vars[variable_id] == 0) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				/*
> > +				Set the attribute bit to indicate that
> > +				this buffer was dynamically allocated and
> > +				should be freed later */
> > +				attrs[variable_id] |= 0x80;
> > +
> > +				/* zero out memory */
> > +				count = (u32)
> > +					((var_size[variable_id] + 7L) /
> > +									8L);
> > +				charptr_temp = (u8 *)(vars[variable_id]);
> > +				for (index = 0; index < count; ++index)
> > +					charptr_temp[index] = 0;
> > +
> > +			}
> > +
> > +			break;
> > +		case OP_EXPV:
> > +			/*
> > +			Export Boolean array
> > +			...argument 0 is string ID
> > +			...stack 0 is variable ID
> > +			...stack 1 is array right index
> > +			...stack 2 is array left index
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 3, &status))
> > +				break;
> > +			if (version == 0) {
> > +				/* EXPV is not supported in JBC 1.0 */
> > +				bad_opcode = 1;
> > +				break;
> > +			}
> > +			name = (char *)&p[str_table + args[0]];
> > +			variable_id = (u32)stack[--stack_ptr];
> > +			long_index = stack[--stack_ptr];/* right indx */
> > +			long_index2 = stack[--stack_ptr];/* left indx */
> > +
> > +			if (long_index > long_index2) {
> > +				/* reverse indices not supported */
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			long_count = 1 + long_index2 - long_index;
> > +
> > +			charptr_temp = (u8 *)vars[variable_id];
> > +			charptr_temp2 = NULL;
> > +
> > +			if ((long_index & 7L) != 0) {
> > +				s32 k = long_index;
> > +				charptr_temp2 = kmalloc((u32)
> > +					((long_count + 7L) / 8L), GFP_KERNEL);
> > +				if (charptr_temp2 == NULL) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				for (i = 0; i < (u32)long_count; ++i) {
> > +					if (charptr_temp[k >> 3] &
> > +							(1 << (k & 7)))
> > +						charptr_temp2[i >> 3] |=
> > +								(1 << (i & 7));
> > +					else
> > +						charptr_temp2[i >> 3] &=
> > +								~(1 << (i & 7));
> > +
> > +					++k;
> > +				}
> > +				charptr_temp = charptr_temp2;
> > +
> > +			} else if (long_index != 0)
> > +				charptr_temp = &charptr_temp[long_index >> 3];
> > +
> > +			jbi_export_boolean_array(name, charptr_temp,
> > +							long_count);
> > +
> > +			/* free allocated buffer */
> > +			if (((long_index & 7L) != 0) && (charptr_temp2 != NULL))
> > +				kfree(charptr_temp2);
> > +
> > +			break;
> > +		case OP_COPY: {
> > +			/*
> > +			Array copy
> > +			...argument 0 is dest ID
> > +			...argument 1 is source ID
> > +			...stack 0 is count
> > +			...stack 1 is dest index
> > +			...stack 2 is source index
> > +			*/
> > +			s32 copy_count;
> > +			s32 copy_index;
> > +			s32 copy_index2;
> > +			s32 destleft;
> > +			s32 src_count;
> > +			s32 dest_count;
> > +			int src_reverse = 0;
> > +			int dest_reverse = 0;
> > +
> > +			if (!jbi_check_stack(stack_ptr, 3, &status))
> > +				break;
> > +
> > +			copy_count = stack[--stack_ptr];
> > +			copy_index = stack[--stack_ptr];
> > +			copy_index2 = stack[--stack_ptr];
> > +			reverse = 0;
> > +
> > +			if (version > 0) {
> > +				/*
> > +				stack 0 = source right index
> > +				stack 1 = source left index
> > +				stack 2 = destination right index
> > +				stack 3 = destination left index */
> > +				destleft = stack[--stack_ptr];
> > +
> > +				if (copy_count > copy_index) {
> > +					src_reverse = 1;
> > +					reverse = 1;
> > +					src_count = 1 + copy_count - copy_index;
> > +					/* copy_index = source start index */
> > +				} else {
> > +					src_count = 1 + copy_index - copy_count;
> > +					/* source start index */
> > +					copy_index = copy_count;
> > +				}
> > +
> > +				if (copy_index2 > destleft) {
> > +					dest_reverse = 1;
> > +					reverse = !reverse;
> > +					dest_count = 1 + copy_index2 - destleft;
> > +					/* destination start index */
> > +					copy_index2 = destleft;
> > +				} else
> > +					dest_count = 1 + destleft - copy_index2;
> > +					/*
> > +					copy_index2 = destination start index */
> > +
> > +				copy_count = (src_count < dest_count) ?
> > +							src_count : dest_count;
> > +
> > +				if ((src_reverse || dest_reverse) &&
> > +					(src_count != dest_count))
> > +					/*
> > +					If either the source or destination
> > +					is reversed, we can't tolerate
> > +					a length mismatch, because we
> > +					"left justify" the arrays when copying.
> > +					This won't work correctly
> > +					with reversed arrays. */
> > +					status = -ERANGE;
> > +
> > +			}
> > +
> > +			count = (u32)copy_count;
> > +			index = (u32)copy_index;
> > +			index2 = (u32)copy_index2;
> > +
> > +			/*
> > +			If destination is a read-only array, allocate a buffer
> > +			and convert it to a writable array */
> > +			variable_id = (u32)args[1];
> > +			if ((version > 0) &&
> > +				((attrs[variable_id] & 0x9c) == 0x0c)) {
> > +				/* Allocate a writable buffer for this array */
> > +				long_temp =
> > +					(var_size[variable_id] + 7L) >> 3L;
> > +				charptr_temp2 = (u8 *)vars[variable_id];
> > +				charptr_temp =
> > +					kmalloc((u32)long_temp, GFP_KERNEL);
> > +				/*64 bits*/
> > +				vars[variable_id] = (long)charptr_temp;
> > +
> > +				if (vars[variable_id] == 0) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				/* zero the buffer */
> > +				for (long_index = 0L; long_index < long_temp;
> > +								++long_index)
> > +					charptr_temp[long_index] = 0;
> > +
> > +				/* copy previous contents into buffer */
> > +				for (long_index = 0L;
> > +					long_index < var_size[variable_id];
> > +								++long_index) {
> > +					long_index2 = long_index;
> > +
> > +					if (charptr_temp2[long_index2 >> 3] &
> > +						(1 << (long_index2 & 7)))
> > +						charptr_temp[long_index >> 3] |=
> > +							(1 << (long_index & 7));
> > +
> > +				}
> > +
> > +				/*
> > +				set bit 7 - buffer was dynamically allocated */
> > +				attrs[variable_id] |= 0x80;
> > +
> > +				/* clear bit 2 - variable is writable */
> > +				attrs[variable_id] &= ~0x04;
> > +				attrs[variable_id] |= 0x01;
> > +			}
> > +
> > +			charptr_temp = (u8 *)vars[args[1]];
> > +			charptr_temp2 = (u8 *)vars[args[0]];
> > +
> > +			/* check if destination is a writable Boolean array */
> > +			if ((attrs[args[1]] & 0x1c) != 0x08) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			if (count < 1) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			if (reverse)
> > +				index2 += (count - 1);
> > +
> > +			for (i = 0; i < count; ++i) {
> > +				if (charptr_temp2[index >> 3] &
> > +							(1 << (index & 7)))
> > +					charptr_temp[index2 >> 3] |=
> > +							(1 << (index2 & 7));
> > +				else
> > +					charptr_temp[index2 >> 3] &=
> > +						~(u32)(1 << (index2 & 7));
> > +
> > +				++index;
> > +				if (reverse)
> > +					--index2;
> > +				else
> > +					++index2;
> > +			}
> > +
> > +			break;
> > +		}
> > +		case OP_DSC:
> > +		case OP_ISC: {
> > +			/*
> > +			DRSCAN with capture
> > +			IRSCAN with capture
> > +			...argument 0 is scan data variable ID
> > +			...argument 1 is capture variable ID
> > +			...stack 0 is capture index
> > +			...stack 1 is scan data index
> > +			...stack 2 is count
> > +			*/
> > +			s32 scan_right, scan_left;
> > +			s32 capture_count = 0;
> > +			s32 scan_count = 0;
> > +			s32 capture_index;
> > +			s32 scan_index;
> > +
> > +			if (!jbi_check_stack(stack_ptr, 3, &status))
> > +				break;
> > +
> > +			capture_index = stack[--stack_ptr];
> > +			scan_index = stack[--stack_ptr];
> > +
> > +			if (version > 0) {
> > +				/*
> > +				stack 0 = capture right index
> > +				stack 1 = capture left index
> > +				stack 2 = scan right index
> > +				stack 3 = scan left index
> > +				stack 4 = count */
> > +				scan_right = stack[--stack_ptr];
> > +				scan_left = stack[--stack_ptr];
> > +				capture_count = 1 + scan_index - capture_index;
> > +				scan_count = 1 + scan_left - scan_right;
> > +				scan_index = scan_right;
> > +			}
> > +
> > +			long_count = stack[--stack_ptr];
> > +			/*
> > +			If capture array is read-only, allocate a buffer
> > +			and convert it to a writable array */
> > +			variable_id = (u32)args[1];
> > +			if ((version > 0) &&
> > +				((attrs[variable_id] & 0x9c) == 0x0c)) {
> > +				/* Allocate a writable buffer for this array */
> > +				long_temp =
> > +					(var_size[variable_id] + 7L) >> 3L;
> > +				charptr_temp2 = (u8 *)vars[variable_id];
> > +				charptr_temp =
> > +					kmalloc((u32)long_temp, GFP_KERNEL);
> > +				vars[variable_id] = (long)charptr_temp;
> > +
> > +				if (vars[variable_id] == 0) {
> > +					status = -ENOMEM;
> > +					break;
> > +				}
> > +
> > +				/* zero the buffer */
> > +				for (long_index = 0L; long_index < long_temp;
> > +								++long_index)
> > +					charptr_temp[long_index] = 0;
> > +
> > +				/* copy previous contents into buffer */
> > +				for (long_index = 0L;
> > +					long_index < var_size[variable_id];
> > +								++long_index) {
> > +					long_index2 = long_index;
> > +
> > +					if (charptr_temp2[long_index2 >> 3] &
> > +						(1 << (long_index2 & 7)))
> > +						charptr_temp[long_index >> 3] |=
> > +							(1 << (long_index & 7));
> > +
> > +				}
> > +
> > +				/*
> > +				set bit 7 - buffer was
> > +				dynamically allocated */
> > +				attrs[variable_id] |= 0x80;
> > +
> > +				/* clear bit 2 - variable is writable */
> > +				attrs[variable_id] &= ~0x04;
> > +				attrs[variable_id] |= 0x01;
> > +
> > +			}
> > +
> > +			charptr_temp = (u8 *)vars[args[0]];
> > +			charptr_temp2 = (u8 *)vars[args[1]];
> > +
> > +			if ((version > 0) &&
> > +					((long_count > capture_count) ||
> > +					(long_count > scan_count))) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			/*
> > +			check that capture array
> > +			is a writable Boolean array */
> > +			if ((attrs[args[1]] & 0x1c) != 0x08) {
> > +				status = -ERANGE;
> > +				break;
> > +			}
> > +
> > +			if (status == 0) {
> > +				if (opcode == 0x82) /* DSC */
> > +					status = jbi_swap_dr(astate,
> > +							(u32)long_count,
> > +							charptr_temp,
> > +							(u32)scan_index,
> > +							charptr_temp2,
> > +							(u32)capture_index);
> > +				else /* ISC */
> > +					status = jbi_swap_ir(astate,
> > +							(u32)long_count,
> > +							charptr_temp,
> > +							(u32)scan_index,
> > +							charptr_temp2,
> > +							(u32)capture_index);
> > +
> > +			}
> > +
> > +			break;
> > +		}
> > +		case OP_WAIT:
> > +			/*
> > +			WAIT
> > +			...argument 0 is wait state
> > +			...argument 1 is end state
> > +			...stack 0 is cycles
> > +			...stack 1 is microseconds
> > +			*/
> > +			if (!jbi_check_stack(stack_ptr, 2, &status))
> > +				break;
> > +			long_temp = stack[--stack_ptr];
> > +
> > +			if (long_temp != 0L)
> > +				status = jbi_do_wait_cycles(astate, long_temp,
> > +								(u32)args[0]);
> > +
> > +			long_temp = stack[--stack_ptr];
> > +
> > +			if ((status == 0) && (long_temp != 0L))
> > +				status = jbi_do_wait_microseconds(astate,
> > +								long_temp,
> > +								(u32)args[0]);
> > +
> > +			if ((status == 0) && (args[1] != args[0]))
> > +				status = jbi_goto_jtag_state(astate,
> > +								(u32)args[1]);
> > +
> > +			if (version > 0) {
> > +				--stack_ptr; /* throw away MAX cycles */
> > +				--stack_ptr; /* throw away MAX microseconds */
> > +			}
> > +			break;
> > +		case OP_CMPA: {
> > +			/*
> > +			Array compare
> > +			...argument 0 is source 1 ID
> > +			...argument 1 is source 2 ID
> > +			...argument 2 is mask ID
> > +			...stack 0 is source 1 index
> > +			...stack 1 is source 2 index
> > +			...stack 2 is mask index
> > +			...stack 3 is count
> > +			*/
> > +			s32 a, b;
> > +			u8 *source1 = (u8 *)vars[args[0]];
> > +			u8 *source2 = (u8 *)vars[args[1]];
> > +			u8 *mask = (u8 *)vars[args[2]];
> > +			u32 index1;
> > +			u32 index2;
> > +			u32 mask_index;
> > +
> > +			if (!jbi_check_stack(stack_ptr, 4, &status))
> > +				break;
> > +
> > +			index1 = stack[--stack_ptr];
> > +			index2 = stack[--stack_ptr];
> > +			mask_index = stack[--stack_ptr];
> > +			long_count = stack[--stack_ptr];
> > +
> > +			if (version > 0) {
> > +				/*
> > +				stack 0 = source 1 right index
> > +				stack 1 = source 1 left index
> > +				stack 2 = source 2 right index
> > +				stack 3 = source 2 left index
> > +				stack 4 = mask right index
> > +				stack 5 = mask left index */
> > +				s32 mask_right = stack[--stack_ptr];
> > +				s32 mask_left = stack[--stack_ptr];
> > +				/* source 1 count */
> > +				a = 1 + index2 - index1;
> > +				/* source 2 count */
> > +				b = 1 + long_count - mask_index;
> > +				a = (a < b) ? a : b;
> > +				/* mask count */
> > +				b = 1 + mask_left - mask_right;
> > +				a = (a < b) ? a : b;
> > +				/* source 2 start index */
> > +				index2 = mask_index;
> > +				/* mask start index */
> > +				mask_index = mask_right;
> > +				long_count = a;
> > +			}
> > +
> > +			long_temp = 1L;
> > +
> > +			if (long_count < 1)
> > +				status = -ERANGE;
> > +			else {
> > +				count = (u32)long_count;
> > +
> > +				for (i = 0; i < count; ++i) {
> > +					if (mask[mask_index >> 3] &
> > +						(1 << (mask_index & 7))) {
> > +						a = source1[index1 >> 3] &
> > +							(1 << (index1 & 7))
> > +								? 1 : 0;
> > +						b = source2[index2 >> 3] &
> > +							(1 << (index2 & 7))
> > +								? 1 : 0;
> > +
> > +						if (a != b) /* failure */
> > +							long_temp = 0L;
> > +					}
> > +					++index1;
> > +					++index2;
> > +					++mask_index;
> > +				}
> > +			}
> > +
> > +			stack[stack_ptr++] = long_temp;
> > +
> > +			break;
> > +		}
> > +		default:
> > +			/* Unrecognized opcode -- ERROR! */
> > +			bad_opcode = 1;
> > +			break;
> > +		}
> > +
> > +		if (bad_opcode)
> > +			status = -ENOSYS;
> > +
> > +		if ((stack_ptr < 0) || (stack_ptr >= JBI_STACK_SIZE))
> > +			status = -EOVERFLOW;
> > +
> > +		if (status != 0) {
> > +			done = 1;
> > +			*error_address = (s32)(opcode_address - code_sect);
> > +		}
> > +	}
> > +
> > +	jbi_free_jtag_padding_buffers(astate/*, reset_jtag*/);
> > +
> > +	/* Free all dynamically allocated arrays */
> > +	if ((attrs != NULL) && (vars != NULL)) {
> > +		for (i = 0; i < (u32)sym_count; ++i) {
> > +			if ((attrs[i] & 0x80) && (vars[i] != 0))
> > +				kfree((void *)vars[i]);
> 
> Just do:
> 
> 	if (vars != NULL) {
> 		for (i = 0; i < (u32)sym_count; ++i)
> 			kfree(vars[i]);
> 	}
> 
> > +
> > +		}
> > +	}
> > +
> > +	if (vars != NULL)
> > +		kfree(vars);
> 
> It is safe to call kfree(NULL), so just do:
> 	kfree(vars);
> 
> > +
> > +	if (var_size != NULL)
> > +		kfree(var_size);
> > +
> > +	if (attrs != NULL)
> > +		kfree(attrs);
> > +
> > +	if (proc_attributes != NULL)
> > +		kfree(proc_attributes);
> 
> Same here.
> 
> Hmm... checkpatch.pl should have warned you about this...
> 
> > +
> > +	return status;
> > +}
> > +
> > +static int jbi_get_note(u8 *p, s32 program_size,
> > +			s32 *offset, char *key, char *value, int length)
> > +/*
> > +Gets key and value of NOTE fields in the JBC file.
> > +Can be called in two modes:  if offset pointer is NULL,
> > +then the function searches for note fields which match
> > +the key string provided.  If offset is not NULL, then
> > +the function finds the next note field of any key,
> > +starting at the offset specified by the offset pointer.
> > +Returns 0 for success, else appropriate error code	*/
> > +{
> > +	int status = -ENODATA;
> > +	u32 note_strings = 0L;
> > +	u32 note_table = 0L;
> > +	u32 note_count = 0L;
> > +	u32 first_word = 0L;
> > +	int version = 0;
> > +	int delta = 0;
> > +	char *key_ptr;
> > +	char *value_ptr;
> > +	int i;
> > +
> > +	/* Read header information */
> > +	if (program_size > 52L) {
> > +		first_word    = get_unaligned_be32(&p[0]);
> > +		version = (int)(first_word & 1L);
> > +		delta = version * 8;
> > +
> > +		note_strings  = get_unaligned_be32(&p[8 + delta]);
> > +		note_table    = get_unaligned_be32(&p[12 + delta]);
> > +		note_count    = get_unaligned_be32(&p[44 + (2 * delta)]);
> > +	}
> > +
> > +	if ((first_word != 0x4A414D00L) && (first_word != 0x4A414D01L))
> > +		return -EIO;
> > +
> > +	if (note_count <= 0L)
> > +		return status;
> > +
> > +	if (offset == NULL) {
> > +		/*
> > +		We will search for the first note with a specific key,
> > +		and return only the value */
> > +		for (i = 0; (i < (int)note_count) &&
> > +						(status != 0); ++i) {
> > +			key_ptr = (char *)&p[note_strings +
> > +					get_unaligned_be32(
> > +					&p[note_table + (8 * i)])];
> > +			if ((key != NULL) &&
> > +				(strnicmp(key, key_ptr, strlen(key_ptr)) == 0)) {
> > +				status = 0;
> > +
> > +				value_ptr = (char *)&p[note_strings +
> > +						get_unaligned_be32(
> > +						&p[note_table + (8 * i) + 4])];
> > +
> > +				if (value != NULL)
> > +					strlcpy(value, value_ptr, length);
> > +
> > +			}
> > +		}
> > +	} else {
> > +		/*
> > +		We will search for the next note, regardless of the key,
> > +		and return both the value and the key */
> > +
> > +		i = (int)*offset;
> > +
> > +		if ((i >= 0) && (i < (int) note_count)) {
> > +			status = 0;
> > +
> > +			if (key != NULL)
> > +				strlcpy(key, (char *)&p[note_strings +
> > +						get_unaligned_be32(
> > +						&p[note_table + (8 * i)])],
> > +					length);
> > +
> > +			if (value != NULL)
> > +				strlcpy(value, (char *)&p[note_strings +
> > +						get_unaligned_be32(
> > +						&p[note_table + (8 * i) + 4])],
> > +					length);
> > +
> > +			*offset = i + 1;
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static int jbi_check_crc(u8 *p, s32 program_size)
> > +{
> > +	int status = 0;
> > +	u16 local_expected = 0,
> > +	    local_actual = 0,
> > +	    shift_reg = 0xffff;
> > +	int bit, feedback;
> > +	u8 databyte;
> > +	u32 i;
> > +	u32 crc_section = 0L;
> > +	u32 first_word = 0L;
> > +	int version = 0;
> > +	int delta = 0;
> > +
> > +	if (program_size > 52L) {
> > +		first_word  = get_unaligned_be32(&p[0]);
> > +		version = (int)(first_word & 1L);
> > +		delta = version * 8;
> > +
> > +		crc_section = get_unaligned_be32(&p[32 + delta]);
> > +	}
> > +
> > +	if ((first_word != 0x4A414D00L) && (first_word != 0x4A414D01L))
> > +		status = -EIO;
> > +
> > +	if (crc_section >= (u32)program_size)
> > +		status = -EIO;
> > +
> > +	if (status == 0) {
> > +		local_expected = (u16)get_unaligned_be16(&p[crc_section]);
> > +
> > +		for (i = 0; i < crc_section; ++i) {
> > +			databyte = p[i];
> > +			for (bit = 0; bit < 8; bit++) {
> > +				feedback = (databyte ^ shift_reg) & 0x01;
> > +				shift_reg >>= 1;
> > +				if (feedback)
> > +					shift_reg ^= 0x8408;
> > +
> > +				databyte >>= 1;
> > +			}
> > +		}
> > +
> > +		local_actual = (u16)~shift_reg;
> > +
> > +		if (local_expected != local_actual)
> > +			status = -EILSEQ;
> > +
> > +	}
> > +
> > +	if (debug || status) {
> > +		switch (status) {
> > +		case 0:
> > +			printk(KERN_INFO ": CRC matched: 0000\n", __func__,
> > +				local_actual);
> > +			break;
> > +		case -EILSEQ:
> > +			printk(KERN_ERR ": CRC mismatch: expected 0000, "
> > +				"actual 0000\n", __func__, local_expected,
> > +				local_actual);
> > +			break;
> > +		case -ENODATA:
> > +			printk(KERN_ERR ": expected CRC not found, "
> > +				"actual CRC = 0000\n", __func__,
> > +				local_actual);
> > +			break;
> > +		case -EIO:
> > +			printk(KERN_ERR ": error: format isn't "
> > +				"recognized.\n", __func__);
> > +			break;
> > +		default:
> > +			printk(KERN_ERR ": CRC function returned error "
> > +				"code 0\n", __func__, status);
> > +			break;
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static int jbi_get_file_info(u8 *p,
> > +					s32 program_size,
> > +					int *format_version,
> > +					int *action_count,
> > +					int *procedure_count)
> > +{
> > +	int status = -EIO;
> > +	u32 first_word = 0;
> > +	int version = 0;
> > +
> > +	if (program_size <= 52L)
> > +		return status;
> > +
> > +	first_word = get_unaligned_be32(&p[0]);
> > +
> > +	if ((first_word == 0x4A414D00L) || (first_word == 0x4A414D01L)) {
> > +		status = 0;
> > +
> > +		version = (int)(first_word & 1L);
> > +		*format_version = version + 1;
> > +
> > +		if (version > 0) {
> > +			*action_count = (int)get_unaligned_be32(&p[48]);
> > +			*procedure_count = (int)get_unaligned_be32(&p[52]);
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static int jbi_get_action_info(u8 *p,
> > +					s32 program_size,
> > +					int index,
> > +					char **name,
> > +					char **description,
> > +					struct jbi_procinfo **proc_list)
> > +{
> > +	int status = -EIO;
> > +	struct jbi_procinfo *procptr = NULL;
> > +	struct jbi_procinfo *tmpptr = NULL;
> > +	u32 first_word = 0L;
> > +	u32 action_table = 0L;
> > +	u32 proc_table = 0L;
> > +	u32 str_table = 0L;
> > +	u32 note_strings = 0L;
> > +	u32 action_count = 0L;
> > +	u32 proc_count = 0L;
> > +	u32 act_name_id = 0L;
> > +	u32 act_desc_id = 0L;
> > +	u32 act_proc_id = 0L;
> > +	u32 act_proc_name = 0L;
> > +	u8 act_proc_attribute = 0;
> > +
> > +	if (program_size <= 52L)
> > +		return status;
> > +	/* Read header information */
> > +	first_word = get_unaligned_be32(&p[0]);
> > +
> > +	if (first_word != 0x4A414D01L)
> > +		return status;
> > +
> > +	action_table = get_unaligned_be32(&p[4]);
> > +	proc_table   = get_unaligned_be32(&p[8]);
> > +	str_table = get_unaligned_be32(&p[12]);
> > +	note_strings = get_unaligned_be32(&p[16]);
> > +	action_count = get_unaligned_be32(&p[48]);
> > +	proc_count   = get_unaligned_be32(&p[52]);
> > +
> > +	if (index >= (int)action_count)
> > +		return status;
> > +
> > +	act_name_id = get_unaligned_be32(&p[action_table + (12 * index)]);
> > +	act_desc_id = get_unaligned_be32(&p[action_table + (12 * index) + 4]);
> > +	act_proc_id = get_unaligned_be32(&p[action_table + (12 * index) + 8]);
> > +
> > +	*name = (char *)&p[str_table + act_name_id];
> > +
> > +	if (act_desc_id < (note_strings - str_table))
> > +		*description = (char *)&p[str_table + act_desc_id];
> > +
> > +	do {
> > +		act_proc_name = get_unaligned_be32(
> > +					&p[proc_table + (13 * act_proc_id)]);
> > +		act_proc_attribute = (u8)
> > +			(p[proc_table + (13 * act_proc_id) + 8] & 0x03);
> > +
> > +		procptr = (struct jbi_procinfo *)
> > +				kmalloc(sizeof(struct jbi_procinfo),
> > +								GFP_KERNEL);
> > +
> > +		if (procptr == NULL)
> > +			status = -ENOMEM;
> > +		else {
> > +			procptr->name = (char *)
> > +					&p[str_table + act_proc_name];
> > +			procptr->attrs = act_proc_attribute;
> > +			procptr->next = NULL;
> > +
> > +			/* add record to end of linked list */
> > +			if (*proc_list == NULL)
> > +				*proc_list = procptr;
> > +			else {
> > +				tmpptr = *proc_list;
> > +				while (tmpptr->next != NULL)
> > +					tmpptr = tmpptr->next;
> > +				tmpptr->next = procptr;
> > +			}
> > +		}
> > +
> > +		act_proc_id = get_unaligned_be32(
> > +				&p[proc_table + (13 * act_proc_id) + 4]);
> > +	} while ((act_proc_id != 0) && (act_proc_id < proc_count));
> > +
> > +	return status;
> > +}
> > +
> > +int altera_init(struct altera_config *config, const struct firmware *fw)
> > +{
> > +	static struct altera_config *astate;
> > +	static u8 key[33] = {0};
> > +	static u8 value[257] = {0};
> > +	char *action_name = NULL;
> > +	char *description = NULL;
> > +	char *exit_string = NULL;
> > +	struct jbi_procinfo *proc_list = NULL;
> > +	struct jbi_procinfo *procptr = NULL;
> > +	int exec_result = 0;
> > +	int exit_code = 0;
> > +	int format_version = 0;
> > +	int action_count = 0;
> > +	int procedure_count = 0;
> > +	int index = 0;
> > +	s32 offset = 0L;
> > +	s32 error_address = 0L;
> > +
> > +	astate = kzalloc(sizeof(struct altera_config), GFP_KERNEL);
> > +	if (!astate)
> > +		return -ENOMEM;
> > +
> > +	memcpy(astate, config, sizeof(struct altera_config));
> > +	if (!astate->jtag_io) {
> > +		dprintk(KERN_INFO ": using byteblaster!\n", __func__);
> > +		astate->jtag_io = netup_jtag_io_lpt;
> > +	}
> > +
> > +	jbi_check_crc((u8 *)fw->data, fw->size);
> > +
> > +	if (debug) {
> > +		jbi_get_file_info((u8 *)fw->data, fw->size, &format_version,
> > +					&action_count, &procedure_count);
> > +		printk(KERN_INFO ": File format is  ByteCode format\n",
> > +			__func__, (format_version == 2) ? "Jam STAPL" :
> > +						"pre-standardized Jam 1.1");
> > +		while (jbi_get_note((u8 *)fw->data, fw->size,
> > +					&offset, key, value, 256) == 0)
> > +			printk(KERN_INFO ": NOTE \"\" = \"\"\n",
> > +					__func__, key, value);
> > +	}
> > +
> > +	if (debug && (format_version == 2) && (action_count > 0)) {
> > +		printk(KERN_INFO ": Actions available:\n", __func__);
> > +		for (index = 0; index < action_count; ++index) {
> > +			jbi_get_action_info((u8 *)fw->data, fw->size,
> > +						index, &action_name,
> > +						&description,
> > +						&proc_list);
> > +
> > +			if (description == NULL)
> > +				printk(KERN_INFO ": \n",
> > +						__func__,
> > +						action_name);
> > +			else
> > +				printk(KERN_INFO ":  \"\"\n",
> > +						__func__,
> > +						action_name,
> > +						description);
> > +
> > +			procptr = proc_list;
> > +			while (procptr != NULL) {
> > +				if (procptr->attrs != 0)
> > +					printk(KERN_INFO ":     ()\n",
> > +						__func__,
> > +						procptr->name,
> > +						(procptr->attrs == 1) ?
> > +						"optional" : "recommended");
> > +
> > +				proc_list = procptr->next;
> > +				kfree(procptr);
> > +				procptr = proc_list;
> > +			}
> > +		}
> > +
> > +		printk(KERN_INFO "\n");
> > +	}
> > +
> > +	exec_result = jbi_execute(astate, (u8 *)fw->data, fw->size,
> > +				&error_address, &exit_code, &format_version);
> > +
> > +	if (exec_result == 0) {
> > +		if (format_version == 2) {
> > +			switch (exit_code) {
> > +			case  0:
> > +				exit_string = "Success";
> > +				break;
> > +			case  1:
> > +				exit_string = "Checking chain failure";
> > +				break;
> 
> Huh? Haven't you replace the errors code already by standard Unix errors?
> You don't need this error translation logic. Instead, just return the
> error code to the caller.
It's not related to Unix errors.
Firmware like program itself sets value for exit_code, and I do not control firmware for that 
matter.
To simlify code I can drop it, naturally.
exec_result is related and controlled by.

> 
> > +			case  2:
> > +				exit_string = "Reading IDCODE failure";
> > +				break;
> > +			case  3:
> > +				exit_string = "Reading USERCODE failure";
> > +				break;
> > +			case  4:
> > +				exit_string = "Reading UESCODE failure";
> > +				break;
> > +			case  5:
> > +				exit_string = "Entering ISP failure";
> > +				break;
> > +			case  6:
> > +				exit_string = "Unrecognized device";
> > +				break;
> > +			case  7:
> > +				exit_string = "Device revision is "
> > +						"not supported";
> > +				break;
> > +			case  8:
> > +				exit_string = "Erase failure";
> > +				break;
> > +			case  9:
> > +				exit_string = "Device is not blank";
> > +				break;
> > +			case 10:
> > +				exit_string = "Device programming failure";
> > +				break;
> > +			case 11:
> > +				exit_string = "Device verify failure";
> > +				break;
> > +			case 12:
> > +				exit_string = "Read failure";
> > +				break;
> > +			case 13:
> > +				exit_string = "Calculating checksum failure";
> > +				break;
> > +			case 14:
> > +				exit_string = "Setting security bit failure";
> > +				break;
> > +			case 15:
> > +				exit_string = "Querying security bit failure";
> > +				break;
> > +			case 16:
> > +				exit_string = "Exiting ISP failure";
> > +				break;
> > +			case 17:
> > +				exit_string = "Performing system test failure";
> > +				break;
> > +			default:
> > +				exit_string = "Unknown exit code";
> > +				break;
> > +			}
> > +		} else {
> > +			switch (exit_code) {
> > +			case 0:
> > +				exit_string = "Success";
> > +				break;
> > +			case 1:
> > +				exit_string = "Illegal initialization values";
> > +				break;
> > +			case 2:
> > +				exit_string = "Unrecognized device";
> > +				break;
> > +			case 3:
> > +				exit_string = "Device revision is "
> > +						"not supported";
> > +				break;
> > +			case 4:
> > +				exit_string = "Device programming failure";
> > +				break;
> > +			case 5:
> > +				exit_string = "Device is not blank";
> > +				break;
> > +			case 6:
> > +				exit_string = "Device verify failure";
> > +				break;
> > +			case 7:
> > +				exit_string = "SRAM configuration failure";
> > +				break;
> > +			default:
> > +				exit_string = "Unknown exit code";
> > +				break;
> > +			}
> > +		}
> > +
> > +		printk(KERN_INFO ": exit code = 0... \n", __func__,
> > +						exit_code, exit_string);
> > +	} else if ((format_version == 2) &&
> > +			(exec_result == -EINVAL)) {
> > +		if ((astate->action == NULL) || (*astate->action == '\0'))
> > +			printk(KERN_ERR ": error: no action specified for "
> > +				"Jam STAPL file.\nprogram terminated.\n",
> > +				__func__);
> > +		else
> > +			printk(KERN_ERR ": error: action \"\""
> > +				" is not supported "
> > +				"for this Jam STAPL file.\n"
> > +				"Program terminated.\n", __func__,
> > +				astate->action);
> > +
> > +	} else
> > +		printk(KERN_ERR ": error 0\n", __func__, exec_result);
> > +
> > +	if (astate != NULL) {
> > +		kfree(astate);
> > +		astate = NULL;
> > +	}
> > +
> > +	return 0;
> > +}
> > +EXPORT_SYMBOL(altera_init);
> > diff --git a/drivers/misc/stapl-altera/jbicomp.c
> > b/drivers/misc/stapl-altera/jbicomp.c new file mode 100644
> > index 0000000..5e09ec7
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/jbicomp.c
> > @@ -0,0 +1,163 @@
> > +/*
> > + * jbicomp.c
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
> > +#include <linux/kernel.h>
> > +#include "jbiexprt.h"
> > +
> > +#define	SHORT_BITS		16
> > +#define	CHAR_BITS		8
> > +#define	DATA_BLOB_LENGTH	3
> > +#define	MATCH_DATA_LENGTH	8192
> > +#define JBI_ACA_REQUEST_SIZE	1024
> > +#define JBI_ACA_BUFFER_SIZE	(MATCH_DATA_LENGTH + JBI_ACA_REQUEST_SIZE)
> > +
> > +u32 jbi_in_length = 0L;
> > +u32 jbi_in_index = 0L;	/* byte index into compressed array */
> > +u32 jbi_bits_avail = CHAR_BITS;
> 
> Hmm... global vars? This doesn't seem right... what happens if you have two
> devices simultaneously using those vars? The better is to encapsulete them
> into some per-device struct.
> 
> Also, global vars should generally use EXPORT_SYMBOL_GPL().
> 
> > +
> > +/*
> > +The following functions implement incremental decompression of Boolean
> > +array data, using a small memory window.
> > +This algorithm works by searching previous bytes in the data that match
> > +the current data. If a match is found, then the offset and length of
> > +the matching data can replace the actual data in the output.
> > +Memory usage is reduced by maintaining a "window" buffer which contains/
> > +the uncompressed data for one 8K page, plus some extra amount specified/
> > +by JBI_ACA_REQUEST_SIZE.  The function jbi_uncompress_page() is used to/
> > +request a subrange of the uncompressed data, starting at a particular
> > +bit position and extending a maximum of JBI_ACA_REQUEST_SIZE bytes. */
> > +
> > +static u32 jbi_bits_required(u32 n)
> > +/*
> > +Calculate the minimum number of bits required to represent n.
> > +Returns number of bits. */
> > +{
> > +	u32 result = SHORT_BITS;
> > +
> > +	if (n == 0)
> > +		result = 1;
> > +	else {
> > +		/* Look for the highest non-zero bit position */
> > +		while ((n & (1 << (SHORT_BITS - 1))) == 0) {
> > +			n <<= 1;
> > +			--result;
> > +		}
> > +	}
> > +
> > +	return result;
> > +}
> 
> Hmm... I think there are some functions for this already.
> 
> > +
> > +static u32 jbi_read_packed(u8 *buffer, u32 bits)
> > +/*
> > +Read the next value from the input array "buffer"
> > +Read only "bits" bits from the array. The amount of
> > +bits that have already been read from "buffer" is
> > +stored internally to this function.
> > +Returns up to 16 bit value or -1 if buffer overrun. */
> > +{
> > +	u32 result = 0;
> > +	u32 shift = 0;
> > +	u32 databyte = 0;
> > +
> > +	while (bits > 0) {
> > +		databyte = buffer[jbi_in_index];
> > +		result |= (((databyte >> (CHAR_BITS - jbi_bits_avail))
> > +			& (0xff >> (CHAR_BITS - jbi_bits_avail))) << shift);
> > +
> > +		if (bits <= jbi_bits_avail) {
> > +			result &= (0xffff >> (SHORT_BITS - (bits + shift)));
> > +			jbi_bits_avail -= bits;
> > +			bits = 0;
> > +		} else {
> > +			++jbi_in_index;
> > +			shift += jbi_bits_avail;
> > +			bits -= jbi_bits_avail;
> > +			jbi_bits_avail = CHAR_BITS;
> > +		}
> > +	}
> > +
> > +	return result;
> > +}
> > +
> > +u32 jbi_uncompress(u8 *in, u32 in_length, u8 *out, u32 out_length, s32
> > version) +/*
> > +Uncompress data in "in" and write result to "out".
> > +Returns length of uncompressed data or -1 if:
> > +	1) out_length is too small
> > +	2) Internal error in the code
> > +	3) in doesn't contain ACA compressed data. */
> > +{
> > +	u32 i, j, data_length = 0L;
> > +	u32 offset, length;
> > +	u32 match_data_length = MATCH_DATA_LENGTH;
> > +
> > +	if (version > 0)
> > +		--match_data_length;
> > +
> > +	jbi_in_length = in_length;
> > +	jbi_bits_avail = CHAR_BITS;
> > +	jbi_in_index = 0L;
> > +	for (i = 0; i < out_length; ++i)
> > +		out[i] = 0;
> > +
> > +	/* Read number of bytes in data. */
> > +	for (i = 0; i < sizeof(in_length); ++i) {
> > +		data_length = data_length | ((u32)
> > +			jbi_read_packed(in, CHAR_BITS) << (i * CHAR_BITS));
> > +	}
> > +
> > +	if (data_length > out_length) {
> > +		data_length = 0L;
> > +		return data_length;
> > +	}
> > +
> > +	i = 0;
> > +	while (i < data_length) {
> > +		/* A 0 bit indicates literal data. */
> > +		if (jbi_read_packed(in, 1) == 0) {
> > +			for (j = 0; j < DATA_BLOB_LENGTH; ++j) {
> > +				if (i < data_length) {
> > +					out[i] = (u8)jbi_read_packed(in,
> > +								CHAR_BITS);
> > +					i++;
> > +				}
> > +			}
> > +		} else {
> > +			/* A 1 bit indicates offset/length to follow. */
> > +			offset = jbi_read_packed(in, jbi_bits_required((s16)
> > +					(i > match_data_length ?
> > +						match_data_length : i)));
> > +			length = jbi_read_packed(in, CHAR_BITS);
> > +			for (j = 0; j < length; ++j) {
> > +				if (i < data_length) {
> > +					out[i] = out[i - offset];
> > +					i++;
> > +				}
> > +			}
> > +		}
> > +	}
> > +
> > +	return data_length;
> > +}
> > diff --git a/drivers/misc/stapl-altera/jbiexprt.h
> > b/drivers/misc/stapl-altera/jbiexprt.h new file mode 100644
> > index 0000000..c71fd75
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/jbiexprt.h
> > @@ -0,0 +1,32 @@
> > +/*
> > + * jbiexprt.h
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
> > +#ifndef INC_JBIEXPRT_H
> > +#define INC_JBIEXPRT_H
> > +
> > +u32 jbi_uncompress(u8 *in, u32 in_length, u8 *out, u32 out_length, s32
> > version); +int netup_jtag_io_lpt(void *device, int tms, int tdi, int
> > read_tdo); +
> > +#endif /* INC_JBIEXPRT_H */
> > diff --git a/drivers/misc/stapl-altera/jbijtag.c
> > b/drivers/misc/stapl-altera/jbijtag.c new file mode 100644
> > index 0000000..a2cf842
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/jbijtag.c
> > @@ -0,0 +1,1038 @@
> > +/*
> > + * jbijtag.c
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
> > +#include "jbijtag.h"
> > +
> > +/* maximum JTAG IR and DR lengths (in bits) */
> > +#define JBIC_MAX_JTAG_IR_PREAMBLE   256
> > +#define JBIC_MAX_JTAG_IR_POSTAMBLE  256
> > +#define JBIC_MAX_JTAG_IR_LENGTH     512
> > +#define JBIC_MAX_JTAG_DR_PREAMBLE  1024
> > +#define JBIC_MAX_JTAG_DR_POSTAMBLE 1024
> > +#define JBIC_MAX_JTAG_DR_LENGTH    2048
> > +
> > +#define		jbi_jtag_io(a, b, c)\
> > +			astate->jtag_io(astate->dev, a, b, c);
> > +
> > +#define		jbi_malloc(a)	kzalloc(a, GFP_KERNEL);
> > +
> > +/* Global variable to store the current JTAG state */
> > +enum JBIE_JTAG_STATE jbi_jtag_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +/* Store current stop-state for DR and IR scan commands */
> > +enum JBIE_JTAG_STATE jbi_drstop_state = IDLE;
> > +enum JBIE_JTAG_STATE jbi_irstop_state = IDLE;
> > +
> > +/* Store current padding values */
> > +u32 jbi_dr_preamble;
> > +u32 jbi_dr_postamble;
> > +u32 jbi_ir_preamble;
> > +u32 jbi_ir_postamble;
> > +u32 jbi_dr_length;
> > +u32 jbi_ir_length;
> > +u8 *jbi_dr_preamble_data;
> > +u8 *jbi_dr_postamble_data;
> > +u8 *jbi_ir_preamble_data;
> > +u8 *jbi_ir_postamble_data;
> > +u8 *jbi_dr_buffer;
> > +u8 *jbi_ir_buffer;
> 
> The better is to encapsulate all those global vars into an struct, like
> altera_config, otherwise you'll have serious problems if more than one
> device is connected.
> 
> Do they need to be global?
> 
> > +
> > +/*
> > +This structure shows, for each JTAG state, which state is reached after
> > +a single TCK clock cycle with TMS high or TMS low, respectively.  This
> > +describes all possible state transitions in the JTAG state machine.
> > +*/
> > +struct JBIS_JTAG_MACHINE {
> > +	enum JBIE_JTAG_STATE tms_high;
> > +	enum JBIE_JTAG_STATE tms_low;
> > +} jbi_jtag_state_transitions[] = {
> > +	/* RESET     */	{ RESET,	IDLE },
> > +	/* IDLE      */	{ DRSELECT,	IDLE },
> > +	/* DRSELECT  */	{ IRSELECT,	DRCAPTURE },
> > +	/* DRCAPTURE */	{ DREXIT1,	DRSHIFT },
> > +	/* DRSHIFT   */	{ DREXIT1,	DRSHIFT },
> > +	/* DREXIT1   */	{ DRUPDATE,	DRPAUSE },
> > +	/* DRPAUSE   */	{ DREXIT2,	DRPAUSE },
> > +	/* DREXIT2   */	{ DRUPDATE,	DRSHIFT },
> > +	/* DRUPDATE  */	{ DRSELECT,	IDLE },
> > +	/* IRSELECT  */	{ RESET,	IRCAPTURE },
> > +	/* IRCAPTURE */	{ IREXIT1,	IRSHIFT },
> > +	/* IRSHIFT   */	{ IREXIT1,	IRSHIFT },
> > +	/* IREXIT1   */	{ IRUPDATE,	IRPAUSE },
> > +	/* IRPAUSE   */	{ IREXIT2,	IRPAUSE },
> > +	/* IREXIT2   */	{ IRUPDATE,	IRSHIFT },
> > +	/* IRUPDATE  */	{ DRSELECT,	IDLE }
> > +};
> > +
> > +/*
> > +This table contains the TMS value to be used to take the NEXT STEP on
> > +the path to the desired state.  The array index is the current state,
> > +and the bit position is the desired endstate.  To find out which state
> > +is used as the intermediate state, look up the TMS value in the
> > +jbi_jtag_state_transitions[] table.
> > +*/
> > +u16 jbi_jtag_path_map[16] = {
> > +	/* RST	RTI	SDRS	CDR	SDR	E1DR	PDR	E2DR */
> > +	0x0001,	0xFFFD,	0xFE01,	0xFFE7,	0xFFEF,	0xFF0F,	0xFFBF,	0xFFFF,
> > +	/* UDR	SIRS	CIR	SIR	E1IR	PIR	E2IR	UIR */
> > +	0xFEFD,	0x0001,	0xF3FF,	0xF7FF,	0x87FF,	0xDFFF,	0xFFFF,	0x7FFD
> > +};
> 
> Are those global vars const? If so, declare as const.
> 
> If they are local, declare as "static".
> 
> > +
> > +/* Flag bits for jbi_jtag_io() function */
> > +#define TMS_HIGH   1
> > +#define TMS_LOW    0
> > +#define TDI_HIGH   1
> > +#define TDI_LOW    0
> > +#define READ_TDO   1
> > +#define IGNORE_TDO 0
> > +
> > +int jbi_init_jtag()
> > +{
> > +	/* initial JTAG state is unknown */
> > +	jbi_jtag_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +	/* initialize global variables to default state */
> > +	jbi_drstop_state = IDLE;
> > +	jbi_irstop_state = IDLE;
> > +	jbi_dr_preamble  = 0;
> > +	jbi_dr_postamble = 0;
> > +	jbi_ir_preamble  = 0;
> > +	jbi_ir_postamble = 0;
> > +	jbi_dr_length    = 0;
> > +	jbi_ir_length    = 0;
> > +
> > +	jbi_dr_preamble_data  = NULL;
> > +	jbi_dr_postamble_data = NULL;
> > +	jbi_ir_preamble_data  = NULL;
> > +	jbi_ir_postamble_data = NULL;
> > +	jbi_dr_buffer	 = NULL;
> > +	jbi_ir_buffer	 = NULL;
> > +
> > +	return 0;
> > +}
> > +
> > +int jbi_set_drstop_state(enum JBIE_JTAG_STATE state)
> > +{
> > +	jbi_drstop_state = state;
> > +
> > +	return 0;
> > +}
> > +
> > +int jbi_set_irstop_state(enum JBIE_JTAG_STATE state)
> > +{
> > +	jbi_irstop_state = state;
> > +
> > +	return 0;
> > +}
> > +
> > +int jbi_set_dr_preamble(u32 count, u32 start_index,
> > +				    u8 *preamble_data)
> > +{
> > +	int status = 0;
> > +	u32 i;
> > +	u32 j;
> > +
> > +	if (count > jbi_dr_preamble) {
> > +		kfree(jbi_dr_preamble_data);
> > +		jbi_dr_preamble_data = (u8 *)jbi_malloc((count + 7) >> 3);
> > +		if (jbi_dr_preamble_data == NULL)
> > +			status = -ENOMEM;
> > +		else
> > +			jbi_dr_preamble = count;
> > +	} else
> > +		jbi_dr_preamble = count;
> > +
> > +	if (status == 0) {
> > +		for (i = 0; i < count; ++i) {
> > +			j = i + start_index;
> > +
> > +			if (preamble_data == NULL)
> > +				jbi_dr_preamble_data[i >> 3] |= (1 << (i & 7));
> > +			else {
> > +				if (preamble_data[j >> 3] & (1 << (j & 7)))
> > +					jbi_dr_preamble_data[i >> 3] |=
> > +							(1 << (i & 7));
> > +				else
> > +					jbi_dr_preamble_data[i >> 3] &=
> > +							~(u32)(1 << (i & 7));
> > +
> > +			}
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_set_ir_preamble(u32 count, u32 start_index,
> > +							u8 *preamble_data)
> > +{
> > +	int status = 0;
> > +	u32 i;
> > +	u32 j;
> > +
> > +	if (count > jbi_ir_preamble) {
> > +		kfree(jbi_ir_preamble_data);
> > +		jbi_ir_preamble_data = (u8 *)jbi_malloc((count + 7) >> 3);
> > +		if (jbi_ir_preamble_data == NULL)
> > +			status = -ENOMEM;
> > +		else
> > +			jbi_ir_preamble = count;
> > +
> > +	} else
> > +		jbi_ir_preamble = count;
> > +
> > +	if (status == 0) {
> > +		for (i = 0; i < count; ++i) {
> > +			j = i + start_index;
> > +			if (preamble_data == NULL)
> > +				jbi_ir_preamble_data[i >> 3] |= (1 << (i & 7));
> > +			else {
> > +				if (preamble_data[j >> 3] & (1 << (j & 7)))
> > +					jbi_ir_preamble_data[i >> 3] |=
> > +							(1 << (i & 7));
> > +				else
> > +					jbi_ir_preamble_data[i >> 3] &=
> > +							~(u32)(1 << (i & 7));
> > +
> > +			}
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_set_dr_postamble(u32 count, u32 start_index,
> > +						u8 *postamble_data)
> > +{
> > +	int status = 0;
> > +	u32 i;
> > +	u32 j;
> > +
> > +	if (count > jbi_dr_postamble) {
> > +		kfree(jbi_dr_postamble_data);
> > +		jbi_dr_postamble_data = (u8 *)jbi_malloc((count + 7) >> 3);
> > +
> > +		if (jbi_dr_postamble_data == NULL)
> > +			status = -ENOMEM;
> > +		else
> > +			jbi_dr_postamble = count;
> > +
> > +	} else
> > +		jbi_dr_postamble = count;
> > +
> > +	if (status == 0) {
> > +		for (i = 0; i < count; ++i) {
> > +			j = i + start_index;
> > +
> > +			if (postamble_data == NULL)
> > +				jbi_dr_postamble_data[i >> 3] |= (1 << (i & 7));
> > +			else {
> > +				if (postamble_data[j >> 3] & (1 << (j & 7)))
> > +					jbi_dr_postamble_data[i >> 3] |=
> > +								(1 << (i & 7));
> > +				else
> > +					jbi_dr_postamble_data[i >> 3] &=
> > +					    ~(u32)(1 << (i & 7));
> > +
> > +			}
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_set_ir_postamble(u32 count, u32 start_index,
> > +						u8 *postamble_data)
> > +{
> > +	int status = 0;
> > +	u32 i;
> > +	u32 j;
> > +
> > +	if (count > jbi_ir_postamble) {
> > +		kfree(jbi_ir_postamble_data);
> > +		jbi_ir_postamble_data = (u8 *)jbi_malloc((count + 7) >> 3);
> > +		if (jbi_ir_postamble_data == NULL)
> > +			status = -ENOMEM;
> > +		else
> > +			jbi_ir_postamble = count;
> > +
> > +	} else
> > +		jbi_ir_postamble = count;
> > +
> > +	if (status != 0)
> > +		return status;
> > +
> > +	for (i = 0; i < count; ++i) {
> > +		j = i + start_index;
> > +
> > +		if (postamble_data == NULL)
> > +			jbi_ir_postamble_data[i >> 3] |= (1 << (i & 7));
> > +		else {
> > +			if (postamble_data[j >> 3] & (1 << (j & 7)))
> > +				jbi_ir_postamble_data[i >> 3] |= (1 << (i & 7));
> > +			else
> > +				jbi_ir_postamble_data[i >> 3] &=
> > +				    ~(u32)(1 << (i & 7));
> > +
> > +		}
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static void jbi_jtag_reset_idle(struct altera_config *astate)
> > +{
> > +	int i;
> > +	/* Go to Test Logic Reset (no matter what the starting state may be) */
> > +	for (i = 0; i < 5; ++i)
> > +		jbi_jtag_io(TMS_HIGH, TDI_LOW, IGNORE_TDO);
> > +
> > +	/* Now step to Run Test / Idle */
> > +	jbi_jtag_io(TMS_LOW, TDI_LOW, IGNORE_TDO);
> > +	jbi_jtag_state = IDLE;
> > +}
> > +
> > +int jbi_goto_jtag_state(struct altera_config *astate,
> > +					enum JBIE_JTAG_STATE state)
> > +{
> > +	int tms;
> > +	int count = 0;
> > +	int status = 0;
> > +
> > +	if (jbi_jtag_state == JBI_ILLEGAL_JTAG_STATE)
> > +		/* initialize JTAG chain to known state */
> > +		jbi_jtag_reset_idle(astate);
> > +
> > +	if (jbi_jtag_state == state) {
> > +		/*
> > +		We are already in the desired state.  If it is a stable state,
> > +		loop here.  Otherwise do nothing (no clock cycles).
> > +		*/
> > +		if ((state == IDLE) || (state == DRSHIFT) ||
> > +			(state == DRPAUSE) || (state == IRSHIFT) ||
> > +				(state == IRPAUSE)) {
> > +			jbi_jtag_io(TMS_LOW, TDI_LOW, IGNORE_TDO);
> > +		} else if (state == RESET)
> > +			jbi_jtag_io(TMS_HIGH, TDI_LOW, IGNORE_TDO);
> > +
> > +	} else {
> > +		while ((jbi_jtag_state != state) && (count < 9)) {
> > +			/* Get TMS value to take a step toward desired state */
> > +			tms = (jbi_jtag_path_map[jbi_jtag_state] & (1 << state))
> > +							? TMS_HIGH : TMS_LOW;
> > +
> > +			/* Take a step */
> > +			jbi_jtag_io(tms, TDI_LOW, IGNORE_TDO);
> > +
> > +			if (tms)
> > +				jbi_jtag_state =
> > +					jbi_jtag_state_transitions[jbi_jtag_state].tms_high;
> > +			else
> > +				jbi_jtag_state =
> > +					jbi_jtag_state_transitions[jbi_jtag_state].tms_low;
> > +
> > +			++count;
> > +		}
> > +	}
> > +
> > +	if (jbi_jtag_state != state)
> > +		status = -EREMOTEIO;
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_do_wait_cycles(struct altera_config *astate,
> > +					s32 cycles,
> > +					enum JBIE_JTAG_STATE wait_state)
> > +{
> > +	int tms;
> > +	s32 count;
> > +	int status = 0;
> > +
> > +	if (jbi_jtag_state != wait_state)
> > +		status = jbi_goto_jtag_state(astate, wait_state);
> > +
> > +	if (status == 0) {
> > +		/*
> > +		Set TMS high to loop in RESET state
> > +		Set TMS low to loop in any other stable state
> > +		*/
> > +		tms = (wait_state == RESET) ? TMS_HIGH : TMS_LOW;
> > +
> > +		for (count = 0L; count < cycles; count++)
> > +			jbi_jtag_io(tms, TDI_LOW, IGNORE_TDO);
> > +
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_do_wait_microseconds(struct altera_config *astate,
> > +			s32 microseconds, enum JBIE_JTAG_STATE wait_state)
> > +/*
> > +Causes JTAG hardware to sit in the specified stable
> > +state for the specified duration of real time.  If
> > +no JTAG operations have been performed yet, then only
> > +a delay is performed.  This permits the WAIT USECS
> > +statement to be used in VECTOR programs without causing
> > +any JTAG operations.
> > +Returns 0 for success, else appropriate error code. */
> > +{
> > +	int status = 0;
> > +
> > +	if ((jbi_jtag_state != JBI_ILLEGAL_JTAG_STATE) &&
> > +	    (jbi_jtag_state != wait_state))
> > +		status = jbi_goto_jtag_state(astate, wait_state);
> > +
> > +	if (status == 0)
> > +		/* Wait for specified time interval */
> > +		udelay(microseconds);
> > +
> > +	return status;
> > +}
> > +
> > +static void jbi_jtag_concatenate_data(u8 *buffer,
> > +				u8 *preamble_data,
> > +				u32 preamble_count,
> > +				u8 *target_data,
> > +				u32 start_index,
> > +				u32 target_count,
> > +				u8 *postamble_data,
> > +				u32 postamble_count)
> > +/*
> > +Copies preamble data, target data, and postamble data
> > +into one buffer for IR or DR scans. */
> > +{
> > +	u32 i, j, k;
> > +
> > +	for (i = 0L; i < preamble_count; ++i) {
> > +		if (preamble_data[i >> 3L] & (1L << (i & 7L)))
> > +			buffer[i >> 3L] |= (1L << (i & 7L));
> > +		else
> > +			buffer[i >> 3L] &= ~(u32)(1L << (i & 7L));
> > +
> > +	}
> > +
> > +	j = start_index;
> > +	k = preamble_count + target_count;
> > +	for (; i < k; ++i, ++j) {
> > +		if (target_data[j >> 3L] & (1L << (j & 7L)))
> > +			buffer[i >> 3L] |= (1L << (i & 7L));
> > +		else
> > +			buffer[i >> 3L] &= ~(u32)(1L << (i & 7L));
> > +
> > +	}
> > +
> > +	j = 0L;
> > +	k = preamble_count + target_count + postamble_count;
> > +	for (; i < k; ++i, ++j) {
> > +		if (postamble_data[j >> 3L] & (1L << (j & 7L)))
> > +			buffer[i >> 3L] |= (1L << (i & 7L));
> > +		else
> > +			buffer[i >> 3L] &= ~(u32)(1L << (i & 7L));
> > +
> > +	}
> > +}
> > +
> > +static int jbi_jtag_drscan(struct altera_config *astate,
> > +			int start_state,
> > +			int count,
> > +			u8 *tdi,
> > +			u8 *tdo)
> > +{
> > +	int i = 0;
> > +	int tdo_bit = 0;
> > +	int status = 1;
> > +
> > +	/* First go to DRSHIFT state */
> > +	switch (start_state) {
> > +	case 0:						/* IDLE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* DRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* DRSHIFT */
> > +		break;
> > +
> > +	case 1:						/* DRPAUSE */
> > +		jbi_jtag_io(1, 0, 0);	/* DREXIT2 */
> > +		jbi_jtag_io(1, 0, 0);	/* DRUPDATE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* DRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* DRSHIFT */
> > +		break;
> > +
> > +	case 2:						/* IRPAUSE */
> > +		jbi_jtag_io(1, 0, 0);	/* IREXIT2 */
> > +		jbi_jtag_io(1, 0, 0);	/* IRUPDATE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* DRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* DRSHIFT */
> > +		break;
> > +
> > +	default:
> > +		status = 0;
> > +	}
> > +
> > +	if (status) {
> > +		/* loop in the SHIFT-DR state */
> > +		for (i = 0; i < count; i++) {
> > +			tdo_bit = jbi_jtag_io(
> > +					(i == count - 1),
> > +					tdi[i >> 3] & (1 << (i & 7)),
> > +					(tdo != NULL));
> > +
> > +			if (tdo != NULL) {
> > +				if (tdo_bit)
> > +					tdo[i >> 3] |= (1 << (i & 7));
> > +				else
> > +					tdo[i >> 3] &= ~(u32)(1 << (i & 7));
> > +
> > +			}
> > +		}
> > +
> > +		jbi_jtag_io(0, 0, 0);	/* DRPAUSE */
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static int jbi_jtag_irscan(struct altera_config *astate,
> > +		    int start_state,
> > +		    int count,
> > +		    u8 *tdi,
> > +		    u8 *tdo)
> > +{
> > +	int i = 0;
> > +	int tdo_bit = 0;
> > +	int status = 1;
> > +
> > +	/* First go to IRSHIFT state */
> > +	switch (start_state) {
> > +	case 0:						/* IDLE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(1, 0, 0);	/* IRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* IRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* IRSHIFT */
> > +		break;
> > +
> > +	case 1:						/* DRPAUSE */
> > +		jbi_jtag_io(1, 0, 0);	/* DREXIT2 */
> > +		jbi_jtag_io(1, 0, 0);	/* DRUPDATE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(1, 0, 0);	/* IRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* IRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* IRSHIFT */
> > +		break;
> > +
> > +	case 2:						/* IRPAUSE */
> > +		jbi_jtag_io(1, 0, 0);	/* IREXIT2 */
> > +		jbi_jtag_io(1, 0, 0);	/* IRUPDATE */
> > +		jbi_jtag_io(1, 0, 0);	/* DRSELECT */
> > +		jbi_jtag_io(1, 0, 0);	/* IRSELECT */
> > +		jbi_jtag_io(0, 0, 0);	/* IRCAPTURE */
> > +		jbi_jtag_io(0, 0, 0);	/* IRSHIFT */
> > +		break;
> > +
> > +	default:
> > +		status = 0;
> > +	}
> > +
> > +	if (status) {
> > +		/* loop in the SHIFT-IR state */
> > +		for (i = 0; i < count; i++) {
> > +			tdo_bit = jbi_jtag_io(
> > +				      (i == count - 1),
> > +				      tdi[i >> 3] & (1 << (i & 7)),
> > +				      (tdo != NULL));
> > +			if (tdo != NULL) {
> > +				if (tdo_bit)
> > +					tdo[i >> 3] |= (1 << (i & 7));
> > +				else
> > +					tdo[i >> 3] &= ~(u32)(1 << (i & 7));
> > +
> > +			}
> > +		}
> > +
> > +		jbi_jtag_io(0, 0, 0);	/* IRPAUSE */
> > +	}
> > +
> > +	return status;
> > +}
> > +
> > +static void jbi_jtag_extract_target_data(u8 *buffer,
> > +				u8 *target_data,
> > +				u32 start_index,
> > +				u32 preamble_count,
> > +				u32 target_count)
> > +/*
> > +Copies target data from scan buffer, filtering out
> > +preamble and postamble data. */
> > +{
> > +	u32 i;
> > +	u32 j;
> > +	u32 k;
> > +
> > +	j = preamble_count;
> > +	k = start_index + target_count;
> > +	for (i = start_index; i < k; ++i, ++j) {
> > +		if (buffer[j >> 3] & (1 << (j & 7)))
> > +			target_data[i >> 3] |= (1 << (i & 7));
> > +		else
> > +			target_data[i >> 3] &= ~(u32)(1 << (i & 7));
> > +
> > +	}
> > +}
> > +
> > +int jbi_do_irscan(struct altera_config *astate,
> > +				u32 count,
> > +				u8 *tdi_data,
> > +				u32 start_index)
> > +/* Shifts data into instruction register */
> > +{
> > +	int start_code = 0;
> > +	u32 alloc_chars = 0;
> > +	u32 shift_count = jbi_ir_preamble + count + jbi_ir_postamble;
> > +	int status = 0;
> > +	enum JBIE_JTAG_STATE start_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +	switch (jbi_jtag_state) {
> > +	case JBI_ILLEGAL_JTAG_STATE:
> > +	case RESET:
> > +	case IDLE:
> > +		start_code = 0;
> > +		start_state = IDLE;
> > +		break;
> > +
> > +	case DRSELECT:
> > +	case DRCAPTURE:
> > +	case DRSHIFT:
> > +	case DREXIT1:
> > +	case DRPAUSE:
> > +	case DREXIT2:
> > +	case DRUPDATE:
> > +		start_code = 1;
> > +		start_state = DRPAUSE;
> > +		break;
> > +
> > +	case IRSELECT:
> > +	case IRCAPTURE:
> > +	case IRSHIFT:
> > +	case IREXIT1:
> > +	case IRPAUSE:
> > +	case IREXIT2:
> > +	case IRUPDATE:
> > +		start_code = 2;
> > +		start_state = IRPAUSE;
> > +		break;
> > +
> > +	default:
> > +		status = -EREMOTEIO;
> > +		break;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_jtag_state != start_state)
> > +			status = jbi_goto_jtag_state(astate, start_state);
> > +
> > +	if (status == 0) {
> > +		if (shift_count > jbi_ir_length) {
> > +			alloc_chars = (shift_count + 7) >> 3;
> > +			kfree(jbi_ir_buffer);
> > +			jbi_ir_buffer = (u8 *)jbi_malloc(alloc_chars);
> > +			if (jbi_ir_buffer == NULL)
> > +				status = -ENOMEM;
> > +			else
> > +				jbi_ir_length = alloc_chars * 8;
> > +
> > +		}
> > +	}
> > +
> > +	if (status == 0) {
> > +		/* Copy preamble data, IR data,
> > +		and postamble data into a buffer */
> > +		jbi_jtag_concatenate_data(jbi_ir_buffer,
> > +					jbi_ir_preamble_data,
> > +					jbi_ir_preamble,
> > +					tdi_data,
> > +					start_index,
> > +					count,
> > +					jbi_ir_postamble_data,
> > +					jbi_ir_postamble);
> > +		/* Do the IRSCAN */
> > +		jbi_jtag_irscan(astate,
> > +				start_code,
> > +				shift_count,
> > +				jbi_ir_buffer,
> > +				NULL);
> > +
> > +		/* jbi_jtag_irscan() always ends in IRPAUSE state */
> > +		jbi_jtag_state = IRPAUSE;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_irstop_state != IRPAUSE)
> > +			status = jbi_goto_jtag_state(astate, jbi_irstop_state);
> > +
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_swap_ir(struct altera_config *astate,
> > +			    u32 count,
> > +			    u8 *in_data,
> > +			    u32 in_index,
> > +			    u8 *out_data,
> > +			    u32 out_index)
> > +/* Shifts data into instruction register, capturing output data */
> > +{
> > +	int start_code = 0;
> > +	u32 alloc_chars = 0;
> > +	u32 shift_count = jbi_ir_preamble + count + jbi_ir_postamble;
> > +	int status = 0;
> > +	enum JBIE_JTAG_STATE start_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +	switch (jbi_jtag_state) {
> > +	case JBI_ILLEGAL_JTAG_STATE:
> > +	case RESET:
> > +	case IDLE:
> > +		start_code = 0;
> > +		start_state = IDLE;
> > +		break;
> > +
> > +	case DRSELECT:
> > +	case DRCAPTURE:
> > +	case DRSHIFT:
> > +	case DREXIT1:
> > +	case DRPAUSE:
> > +	case DREXIT2:
> > +	case DRUPDATE:
> > +		start_code = 1;
> > +		start_state = DRPAUSE;
> > +		break;
> > +
> > +	case IRSELECT:
> > +	case IRCAPTURE:
> > +	case IRSHIFT:
> > +	case IREXIT1:
> > +	case IRPAUSE:
> > +	case IREXIT2:
> > +	case IRUPDATE:
> > +		start_code = 2;
> > +		start_state = IRPAUSE;
> > +		break;
> > +
> > +	default:
> > +		status = -EREMOTEIO;
> > +		break;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_jtag_state != start_state)
> > +			status = jbi_goto_jtag_state(astate, start_state);
> > +
> > +	if (status == 0) {
> > +		if (shift_count > jbi_ir_length) {
> > +			alloc_chars = (shift_count + 7) >> 3;
> > +			kfree(jbi_ir_buffer);
> > +			jbi_ir_buffer = (u8 *)jbi_malloc(alloc_chars);
> > +			if (jbi_ir_buffer == NULL)
> > +				status = -ENOMEM;
> > +			else
> > +				jbi_ir_length = alloc_chars * 8;
> > +
> > +		}
> > +	}
> > +
> > +	if (status == 0) {
> > +		/*
> > +		Copy preamble data, IR data,
> > +		and postamble data into a buffer */
> > +		jbi_jtag_concatenate_data(jbi_ir_buffer,
> > +					jbi_ir_preamble_data,
> > +					jbi_ir_preamble,
> > +					in_data,
> > +					in_index,
> > +					count,
> > +					jbi_ir_postamble_data,
> > +					jbi_ir_postamble);
> > +
> > +		/* Do the IRSCAN */
> > +		jbi_jtag_irscan(astate,
> > +				start_code,
> > +				shift_count,
> > +				jbi_ir_buffer,
> > +				jbi_ir_buffer);
> > +
> > +		/* jbi_jtag_irscan() always ends in IRPAUSE state */
> > +		jbi_jtag_state = IRPAUSE;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_irstop_state != IRPAUSE)
> > +			status = jbi_goto_jtag_state(astate, jbi_irstop_state);
> > +
> > +
> > +	if (status == 0)
> > +		/* Now extract the returned data from the buffer */
> > +		jbi_jtag_extract_target_data(jbi_ir_buffer,
> > +					out_data, out_index,
> > +					jbi_ir_preamble, count);
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_do_drscan(struct altera_config *astate,
> > +				u32 count,
> > +				u8 *tdi_data,
> > +				u32 start_index)
> > +/* Shifts data into data register (ignoring output data) */
> > +{
> > +	int start_code = 0;
> > +	u32 alloc_chars = 0;
> > +	u32 shift_count = jbi_dr_preamble + count + jbi_dr_postamble;
> > +	int status = 0;
> > +	enum JBIE_JTAG_STATE start_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +	switch (jbi_jtag_state) {
> > +	case JBI_ILLEGAL_JTAG_STATE:
> > +	case RESET:
> > +	case IDLE:
> > +		start_code = 0;
> > +		start_state = IDLE;
> > +		break;
> > +
> > +	case DRSELECT:
> > +	case DRCAPTURE:
> > +	case DRSHIFT:
> > +	case DREXIT1:
> > +	case DRPAUSE:
> > +	case DREXIT2:
> > +	case DRUPDATE:
> > +		start_code = 1;
> > +		start_state = DRPAUSE;
> > +		break;
> > +
> > +	case IRSELECT:
> > +	case IRCAPTURE:
> > +	case IRSHIFT:
> > +	case IREXIT1:
> > +	case IRPAUSE:
> > +	case IREXIT2:
> > +	case IRUPDATE:
> > +		start_code = 2;
> > +		start_state = IRPAUSE;
> > +		break;
> > +
> > +	default:
> > +		status = -EREMOTEIO;
> > +		break;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_jtag_state != start_state)
> > +			status = jbi_goto_jtag_state(astate, start_state);
> > +
> > +	if (status == 0) {
> > +		if (shift_count > jbi_dr_length) {
> > +			alloc_chars = (shift_count + 7) >> 3;
> > +			kfree(jbi_dr_buffer);
> > +			jbi_dr_buffer = (u8 *)jbi_malloc(alloc_chars);
> > +			if (jbi_dr_buffer == NULL)
> > +				status = -ENOMEM;
> > +			else
> > +				jbi_dr_length = alloc_chars * 8;
> > +
> > +		}
> > +	}
> > +
> > +	if (status == 0) {
> > +		/*
> > +		Copy preamble data, DR data,
> > +		and postamble data into a buffer */
> > +		jbi_jtag_concatenate_data(jbi_dr_buffer,
> > +					jbi_dr_preamble_data,
> > +					jbi_dr_preamble,
> > +					tdi_data,
> > +					start_index,
> > +					count,
> > +					jbi_dr_postamble_data,
> > +					jbi_dr_postamble);
> > +		/* Do the DRSCAN */
> > +		jbi_jtag_drscan(astate, start_code, shift_count,
> > +				jbi_dr_buffer, NULL);
> > +		/* jbi_jtag_drscan() always ends in DRPAUSE state */
> > +		jbi_jtag_state = DRPAUSE;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_drstop_state != DRPAUSE)
> > +			status = jbi_goto_jtag_state(astate, jbi_drstop_state);
> > +
> > +	return status;
> > +}
> > +
> > +int jbi_swap_dr(struct altera_config *astate, u32 count,
> > +				u8 *in_data, u32 in_index,
> > +				u8 *out_data, u32 out_index)
> > +/* Shifts data into data register, capturing output data */
> > +{
> > +	int start_code = 0;
> > +	u32 alloc_chars = 0;
> > +	u32 shift_count = jbi_dr_preamble + count + jbi_dr_postamble;
> > +	int status = 0;
> > +	enum JBIE_JTAG_STATE start_state = JBI_ILLEGAL_JTAG_STATE;
> > +
> > +	switch (jbi_jtag_state) {
> > +	case JBI_ILLEGAL_JTAG_STATE:
> > +	case RESET:
> > +	case IDLE:
> > +		start_code = 0;
> > +		start_state = IDLE;
> > +		break;
> > +
> > +	case DRSELECT:
> > +	case DRCAPTURE:
> > +	case DRSHIFT:
> > +	case DREXIT1:
> > +	case DRPAUSE:
> > +	case DREXIT2:
> > +	case DRUPDATE:
> > +		start_code = 1;
> > +		start_state = DRPAUSE;
> > +		break;
> > +
> > +	case IRSELECT:
> > +	case IRCAPTURE:
> > +	case IRSHIFT:
> > +	case IREXIT1:
> > +	case IRPAUSE:
> > +	case IREXIT2:
> > +	case IRUPDATE:
> > +		start_code = 2;
> > +		start_state = IRPAUSE;
> > +		break;
> > +
> > +	default:
> > +		status = -EREMOTEIO;
> > +		break;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_jtag_state != start_state)
> > +			status = jbi_goto_jtag_state(astate, start_state);
> > +
> > +	if (status == 0) {
> > +		if (shift_count > jbi_dr_length) {
> > +			alloc_chars = (shift_count + 7) >> 3;
> > +			kfree(jbi_dr_buffer);
> > +			jbi_dr_buffer = (u8 *)jbi_malloc(alloc_chars);
> > +
> > +			if (jbi_dr_buffer == NULL)
> > +				status = -ENOMEM;
> > +			else
> > +				jbi_dr_length = alloc_chars * 8;
> > +
> > +		}
> > +	}
> > +
> > +	if (status == 0) {
> > +		/* Copy preamble data, DR data,
> > +		and postamble data into a buffer */
> > +		jbi_jtag_concatenate_data(jbi_dr_buffer,
> > +				jbi_dr_preamble_data,
> > +				jbi_dr_preamble,
> > +				in_data,
> > +				in_index,
> > +				count,
> > +				jbi_dr_postamble_data,
> > +				jbi_dr_postamble);
> > +
> > +		/* Do the DRSCAN */
> > +		jbi_jtag_drscan(astate,
> > +				start_code,
> > +				shift_count,
> > +				jbi_dr_buffer,
> > +				jbi_dr_buffer);
> > +
> > +		/* jbi_jtag_drscan() always ends in DRPAUSE state */
> > +		jbi_jtag_state = DRPAUSE;
> > +	}
> > +
> > +	if (status == 0)
> > +		if (jbi_drstop_state != DRPAUSE)
> > +			status = jbi_goto_jtag_state(astate, jbi_drstop_state);
> > +
> > +	if (status == 0)
> > +		/* Now extract the returned data from the buffer */
> > +		jbi_jtag_extract_target_data(jbi_dr_buffer,
> > +					out_data,
> > +					out_index,
> > +					jbi_dr_preamble,
> > +					count);
> > +
> > +	return status;
> > +}
> > +
> > +void jbi_free_jtag_padding_buffers(struct altera_config *astate/*,
> > +							int reset_jtag*/)
> > +/* Frees memory allocated for JTAG IR and DR buffers */
> > +{
> > +	/* If the JTAG interface was used, reset it to TLR */
> > +	if (/*reset_jtag && (*/jbi_jtag_state != JBI_ILLEGAL_JTAG_STATE/*)*/)
> > +		jbi_jtag_reset_idle(astate);
> > +
> > +	if (jbi_dr_preamble_data != NULL) {
> > +		kfree(jbi_dr_preamble_data);
> > +		jbi_dr_preamble_data = NULL;
> > +	}
> > +
> > +	if (jbi_dr_postamble_data != NULL) {
> > +		kfree(jbi_dr_postamble_data);
> > +		jbi_dr_postamble_data = NULL;
> > +	}
> > +
> > +	if (jbi_dr_buffer != NULL) {
> > +		kfree(jbi_dr_buffer);
> > +		jbi_dr_buffer = NULL;
> > +	}
> > +
> > +	if (jbi_ir_preamble_data != NULL) {
> > +		kfree(jbi_ir_preamble_data);
> > +		jbi_ir_preamble_data = NULL;
> > +	}
> > +
> > +	if (jbi_ir_postamble_data != NULL) {
> > +		kfree(jbi_ir_postamble_data);
> > +		jbi_ir_postamble_data = NULL;
> > +	}
> > +
> > +	if (jbi_ir_buffer != NULL) {
> > +		kfree(jbi_ir_buffer);
> > +		jbi_ir_buffer = NULL;
> > +	}
> 
> Just do
> 	kfree(var);
> 	var = NULL;
> 
> > +}
> > diff --git a/drivers/misc/stapl-altera/jbijtag.h
> > b/drivers/misc/stapl-altera/jbijtag.h new file mode 100644
> > index 0000000..61fd123
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/jbijtag.h
> > @@ -0,0 +1,83 @@
> > +/*
> > + * jbijtag.h
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
> > +#ifndef INC_JBIJTAG_H
> > +#define INC_JBIJTAG_H
> > +
> > +/* Function Prototypes */
> > +enum JBIE_JTAG_STATE {
> > +	JBI_ILLEGAL_JTAG_STATE = -1,
> > +	RESET = 0,
> > +	IDLE = 1,
> > +	DRSELECT = 2,
> > +	DRCAPTURE = 3,
> > +	DRSHIFT = 4,
> > +	DREXIT1 = 5,
> > +	DRPAUSE = 6,
> > +	DREXIT2 = 7,
> > +	DRUPDATE = 8,
> > +	IRSELECT = 9,
> > +	IRCAPTURE = 10,
> > +	IRSHIFT = 11,
> > +	IREXIT1 = 12,
> > +	IRPAUSE = 13,
> > +	IREXIT2 = 14,
> > +	IRUPDATE = 15
> > +
> > +};
> > +
> > +
> > +int jbi_init_jtag(void);
> > +int jbi_set_drstop_state(enum JBIE_JTAG_STATE state);
> > +int jbi_set_irstop_state(enum JBIE_JTAG_STATE state);
> > +int jbi_set_dr_preamble(u32 count, u32 start_index,
> > +				u8 *preamble_data);
> > +int jbi_set_ir_preamble(u32 count, u32 start_index,
> > +				u8 *preamble_data);
> > +int jbi_set_dr_postamble(u32 count, u32 start_index,
> > +				u8 *postamble_data);
> > +int jbi_set_ir_postamble(u32 count, u32 start_index,
> > +				u8 *postamble_data);
> > +int jbi_goto_jtag_state(struct altera_config *astate,
> > +				enum JBIE_JTAG_STATE state);
> > +int jbi_do_wait_cycles(struct altera_config *astate,
> > +				s32 cycles, enum JBIE_JTAG_STATE wait_state);
> > +int jbi_do_wait_microseconds(struct altera_config *astate,
> > +				s32 microseconds,
> > +				enum JBIE_JTAG_STATE wait_state);
> > +int jbi_do_irscan(struct altera_config *astate, u32 count,
> > +				u8 *tdi_data, u32 start_index);
> > +int jbi_swap_ir(struct altera_config *astate,
> > +				u32 count, u8 *in_data,
> > +				u32 in_index, u8 *out_data,
> > +				u32 out_index);
> > +int jbi_do_drscan(struct altera_config *astate, u32 count,
> > +				u8 *tdi_data, u32 start_index);
> > +int jbi_swap_dr(struct altera_config *astate, u32 count,
> > +				u8 *in_data, u32 in_index,
> > +				u8 *out_data, u32 out_index);
> > +void jbi_free_jtag_padding_buffers(struct altera_config *astate/*,
> > +				int reset_jtag*/);
> > +#endif /* INC_JBIJTAG_H */
> > diff --git a/drivers/misc/stapl-altera/jbistub.c
> > b/drivers/misc/stapl-altera/jbistub.c new file mode 100644
> > index 0000000..9194afe
> > --- /dev/null
> > +++ b/drivers/misc/stapl-altera/jbistub.c
> > @@ -0,0 +1,70 @@
> > +/*
> > + * jbistub.c
> > + *
> > + * altera FPGA driver
> > + *
> > + * Copyright (C) Altera Corporation 1998-2001
> > + * Copyright (C) 2010 NetUP Inc.
> > + * Copyright (C) 2010 Abylay Ospan <aospan@netup.ru>
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
> > +#include <linux/io.h>
> > +#include <linux/kernel.h>
> > +#include "jbiexprt.h"
> > +
> > +int jtag_hardware_initialized;
> > +
> > +static void write_byteblaster(int port, int data)
> > +{
> > +	outb((u8)data, (u16)(port + 0x378));
> > +};
> > +
> > +static int read_byteblaster(int port)
> > +{
> > +	int data = 0;
> > +	data = inb((u16)(port + 0x378));
> > +	return data & 0xff;
> > +};
> > +
> > +int netup_jtag_io_lpt(void *device, int tms, int tdi, int read_tdo)
> > +{
> > +	int data = 0;
> > +	int tdo = 0;
> > +	int initial_lpt_ctrl = 0;
> > +
> > +	if (!jtag_hardware_initialized) {
> > +		initial_lpt_ctrl = read_byteblaster(2);
> > +		write_byteblaster(2, (initial_lpt_ctrl | 0x02) & 0xdf);
> > +		jtag_hardware_initialized = 1;
> > +	}
> > +
> > +	data = ((tdi ? 0x40 : 0) | (tms ? 0x02 : 0));
> > +
> > +	write_byteblaster(0, data);
> > +
> > +	if (read_tdo) {
> > +		tdo = read_byteblaster(1);
> > +		tdo = ((tdo & 0x80) ? 0 : 1);
> > +	}
> > +
> > +	write_byteblaster(0, data | 0x01);
> > +
> > +	write_byteblaster(0, data);
> > +
> > +	return tdo;
> > +}
> > diff --git a/include/misc/altera.h b/include/misc/altera.h
> > new file mode 100644
> > index 0000000..bf6d878
> > --- /dev/null
> > +++ b/include/misc/altera.h
> > @@ -0,0 +1,49 @@
> > +/*
> > + * altera.h
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
> > +#ifndef __ALTERA_H
> > +#define __ALTERA_H
> > +
> > +struct altera_config {
> > +	void *dev;
> > +	u8 *action;
> > +	int (*jtag_io) (void *dev, int tms, int tdi, int tdo);
> > +};
> > +
> > +#if defined(CONFIG_STAPL_ALTERA) || \
> > +		(defined(CONFIG_STAPL_ALTERA_MODULE) && defined(MODULE))
> > +
> > +extern int altera_init(struct altera_config *config, const struct
> > firmware *fw); +#else
> > +
> > +static inline int altera_init(struct altera_config *config,
> > +						const struct firmware *fw)
> > +{
> > +	printk(KERN_WARNING ": driver disabled by Kconfig\n", __func__);
> > +	return 0;
> > +}
> > +#endif /* CONFIG_STAPL_ALTERA */
> > +
> > +#endif /* __ALTERA_H */
> 
> PS.: I noticed that you've declare a large number of symbols as global. You
> need to be sure that those names won't conflict with other symbols in
> Linux, otherwise, kernel won't compile with allyesconfig. What we
> generally do for driver symbols is to start all of them with the driver
> name.
> 
> So, for example, a better name for jbi_init_jtag() would be
> altera_jbi_init_jtag().
> 
> Btw, checkpatch got two warnings:
> 
> WARNING: unnecessary cast may hide bugs, see
> http://c-faq.com/malloc/mallocnocast.html #407: FILE:
> drivers/misc/stapl-altera/altera.c:322:
> +		attrs = (char *)kmalloc((u32)sym_count, GFP_KERNEL);
> 
> WARNING: unnecessary cast may hide bugs, see
> http://c-faq.com/malloc/mallocnocast.html #414: FILE:
> drivers/misc/stapl-altera/altera.c:329:
> +		proc_attributes = (u8 *)kmalloc((u32)proc_count, GFP_KERNEL);
> 
> Please, use typecasts only when it is _really_ needed.
> 
> Cheers,
> Mauro

-- 
Igor M. Liplianin
Microsoft Windows Free Zone - Linux used for all Computing Tasks

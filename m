Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933607Ab0DHUbX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:31:23 -0400
Received: from kroah.org ([198.145.64.141]:42689 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933435Ab0DHU1u (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:50 -0400
Date: Thu, 8 Apr 2010 12:40:33 -0700
From: Greg KH <greg@kroah.com>
To: Maurice Dawson <mauricedawson2699@googlemail.com>
Cc: gregkh@suse.de, wfp5p@virginia.edu, mithlesh@linsyssoft.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 27/27] Staging: comedi: fix brace, print(k), indent and
 over 80 characters coding style issues in adv_pci_dio.c
Message-ID: <20100408194033.GR31571@kroah.com>
References: <1270645926-3357-1-git-send-email-mauricedawson2699@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270645926-3357-1-git-send-email-mauricedawson2699@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 07, 2010 at 02:12:05PM +0100, Maurice Dawson wrote:
> This is a patch to the adv_pci_dio.c file that fixes up brace, print(k), indent and over 80 character warnings found by the checkpatch.pl tool
> 
> Signed-off-by: Maurice Dawson <mauricedawson2699@googlemail.com>
> ---
>  drivers/staging/comedi/drivers/adv_pci_dio.c |  399 +++++++++++++++-----------
>  1 files changed, 226 insertions(+), 173 deletions(-)
> 
> diff --git a/drivers/staging/comedi/drivers/adv_pci_dio.c b/drivers/staging/comedi/drivers/adv_pci_dio.c
> index 61d35fe..b768ea5 100644
> --- a/drivers/staging/comedi/drivers/adv_pci_dio.c
> +++ b/drivers/staging/comedi/drivers/adv_pci_dio.c
> @@ -8,8 +8,8 @@
>  /*
>  Driver: adv_pci_dio
>  Description: Advantech PCI-1730, PCI-1733, PCI-1734, PCI-1736UP,
> -             PCI-1750, PCI-1751, PCI-1752, PCI-1753/E, PCI-1754,
> -             PCI-1756, PCI-1762
> +		PCI-1750, PCI-1751, PCI-1752, PCI-1753/E, PCI-1754,
> +		PCI-1756, PCI-1762
>  Author: Michal Dobes <dobes@tesnet.cz>
>  Devices: [Advantech] PCI-1730 (adv_pci_dio), PCI-1733,
>    PCI-1734, PCI-1736UP, PCI-1750,
> @@ -24,9 +24,8 @@ This driver supports now only insn interface for DI/DO/DIO.
>  Configuration options:
>    [0] - PCI bus of device (optional)
>    [1] - PCI slot of device (optional)
> -          If bus/slot is not specified, the first available PCI
> -          device will be used.
> -
> +	If bus/slot is not specified, the first available PCI
> +	device will be used.
>  */
>  
>  #include "../comedidev.h"
> @@ -64,41 +63,44 @@ enum hw_io_access {
>  
>  #define MAX_DI_SUBDEVS	2	/* max number of DI subdevices per card */
>  #define MAX_DO_SUBDEVS	2	/* max number of DO subdevices per card */
> -#define MAX_DIO_SUBDEVG	2	/* max number of DIO subdevices group per card */
> +#define MAX_DIO_SUBDEVG	2
> +			/* max number of DIO subdevices group per card */
>  
>  #define SIZE_8255	   4	/* 8255 IO space length */
>  
>  #define PCIDIO_MAINREG	   2	/* main I/O region for all Advantech cards? */
>  
>  /* Register offset definitions */
> -/*  Advantech PCI-1730/3/4 */
> +/* Advantech PCI-1730/3/4 */
>  #define PCI1730_IDI	   0	/* R:   Isolated digital input  0-15 */
>  #define PCI1730_IDO	   0	/* W:   Isolated digital output 0-15 */
>  #define PCI1730_DI	   2	/* R:   Digital input  0-15 */
>  #define PCI1730_DO	   2	/* W:   Digital output 0-15 */
>  #define PCI1733_IDI	   0	/* R:   Isolated digital input  0-31 */
>  #define	PCI1730_3_INT_EN	0x08	/* R/W: enable/disable interrupts */
> -#define	PCI1730_3_INT_RF	0x0c	/* R/W: set falling/raising edge for interrupts */
> +#define	PCI1730_3_INT_RF	0x0c
> +			/* R/W: set falling/raising edge for interrupts */
>  #define	PCI1730_3_INT_CLR	0x10	/* R/W: clear interrupts */
>  #define PCI1734_IDO	   0	/* W:   Isolated digital output 0-31 */
>  #define PCI173x_BOARDID	   4	/* R:   Board I/D switch for 1730/3/4 */
>  
> -/*  Advantech PCI-1736UP */
> +/* Advantech PCI-1736UP */
>  #define PCI1736_IDI        0	/* R:   Isolated digital input  0-15 */
>  #define PCI1736_IDO        0	/* W:   Isolated digital output 0-15 */
>  #define PCI1736_3_INT_EN        0x08	/* R/W: enable/disable interrupts */
> -#define PCI1736_3_INT_RF        0x0c	/* R/W: set falling/raising edge for interrupts */
> +#define PCI1736_3_INT_RF        0x0c
> +			/* R/W: set falling/raising edge for interrupts */
>  #define PCI1736_3_INT_CLR       0x10	/* R/W: clear interrupts */
>  #define PCI1736_BOARDID    4	/* R:   Board I/D switch for 1736UP */
>  #define PCI1736_MAINREG    0	/* Normal register (2) doesn't work */
>  
> -/*  Advantech PCI-1750 */
> +/* Advantech PCI-1750 */
>  #define PCI1750_IDI	   0	/* R:   Isolated digital input  0-15 */
>  #define PCI1750_IDO	   0	/* W:   Isolated digital output 0-15 */
>  #define PCI1750_ICR	  32	/* W:   Interrupt control register */
>  #define PCI1750_ISR	  32	/* R:   Interrupt status register */
>  
> -/*  Advantech PCI-1751/3/3E */
> +/* Advantech PCI-1751/3/3E */
>  #define PCI1751_DIO	   0	/* R/W: begin of 8255 registers block */
>  #define PCI1751_ICR	  32	/* W:   Interrupt control register */
>  #define PCI1751_ISR	  32	/* R:   Interrupt status register */
> @@ -113,7 +115,7 @@ enum hw_io_access {
>  #define PCI1753E_ICR2	  50	/* R/W: Interrupt control register group 2 */
>  #define PCI1753E_ICR3	  51	/* R/W: Interrupt control register group 3 */
>  
> -/*  Advantech PCI-1752/4/6 */
> +/* Advantech PCI-1752/4/6 */
>  #define PCI1752_IDO	   0	/* R/W: Digital output  0-31 */
>  #define PCI1752_IDO2	   4	/* R/W: Digital output 32-63 */
>  #define PCI1754_IDI	   0	/* R:   Digital input   0-31 */
> @@ -127,14 +129,14 @@ enum hw_io_access {
>  #define PCI1752_6_CFC	0x12	/* R/W: set/read channel freeze function */
>  #define PCI175x_BOARDID	0x10	/* R:   Board I/D switch for 1752/4/6 */
>  
> -/*  Advantech PCI-1762 registers */
> +/* Advantech PCI-1762 registers */
>  #define PCI1762_RO	   0	/* R/W: Relays status/output */
>  #define PCI1762_IDI	   2	/* R:   Isolated input status */
>  #define PCI1762_BOARDID	   4	/* R:   Board I/D switch */
>  #define PCI1762_ICR	   6	/* W:   Interrupt control register */
>  #define PCI1762_ISR	   6	/* R:   Interrupt status register */
>  
> -/*  Advantech PCI-1760 registers */
> +/* Advantech PCI-1760 registers */
>  #define OMB0		0x0c	/* W:   Mailbox outgoing registers */
>  #define OMB1		0x0d
>  #define OMB2		0x0e
> @@ -148,38 +150,71 @@ enum hw_io_access {
>  #define INTCSR2		0x3a
>  #define INTCSR3		0x3b
>  
> -/*  PCI-1760 mailbox commands */
> -#define CMD_ClearIMB2		0x00	/* Clear IMB2 status and return actaul DI status in IMB3 */
> +/* PCI-1760 mailbox commands */
> +#define CMD_ClearIMB2		0x00
> +		/* Clear IMB2 status and return actual DI status in IMB3 */
>  #define CMD_SetRelaysOutput	0x01	/* Set relay output from OMB0 */
>  #define CMD_GetRelaysStatus	0x02	/* Get relay status to IMB0 */
> -#define CMD_ReadCurrentStatus	0x07	/* Read the current status of the register in OMB0, result in IMB0 */
> -#define CMD_ReadFirmwareVersion	0x0e	/* Read the firmware ver., result in IMB1.IMB0 */
> -#define CMD_ReadHardwareVersion	0x0f	/* Read the hardware ver., result in IMB1.IMB0 */
> -#define CMD_EnableIDIFilters	0x20	/* Enable IDI filters based on bits in OMB0 */
> -#define CMD_EnableIDIPatternMatch 0x21	/* Enable IDI pattern match based on bits in OMB0 */
> -#define CMD_SetIDIPatternMatch	0x22	/* Enable IDI pattern match based on bits in OMB0 */
> -#define CMD_EnableIDICounters	0x28	/* Enable IDI counters based on bits in OMB0 */
> -#define CMD_ResetIDICounters	0x29	/* Reset IDI counters based on bits in OMB0 to its reset values */
> -#define CMD_OverflowIDICounters	0x2a	/* Enable IDI counters overflow interrupts  based on bits in OMB0 */
> -#define CMD_MatchIntIDICounters	0x2b	/* Enable IDI counters match value interrupts  based on bits in OMB0 */
> -#define CMD_EdgeIDICounters	0x2c	/* Set IDI up counters count edge (bit=0 - rising, =1 - falling) */
> -#define CMD_GetIDICntCurValue	0x2f	/* Read IDI{OMB0} up counter current value */
> -#define CMD_SetIDI0CntResetValue 0x40	/* Set IDI0 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI1CntResetValue 0x41	/* Set IDI1 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI2CntResetValue 0x42	/* Set IDI2 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI3CntResetValue 0x43	/* Set IDI3 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI4CntResetValue 0x44	/* Set IDI4 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI5CntResetValue 0x45	/* Set IDI5 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI6CntResetValue 0x46	/* Set IDI6 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI7CntResetValue 0x47	/* Set IDI7 Counter Reset Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI0CntMatchValue 0x48	/* Set IDI0 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI1CntMatchValue 0x49	/* Set IDI1 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI2CntMatchValue 0x4a	/* Set IDI2 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI3CntMatchValue 0x4b	/* Set IDI3 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI4CntMatchValue 0x4c	/* Set IDI4 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI5CntMatchValue 0x4d	/* Set IDI5 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI6CntMatchValue 0x4e	/* Set IDI6 Counter Match Value 256*OMB1+OMB0 */
> -#define CMD_SetIDI7CntMatchValue 0x4f	/* Set IDI7 Counter Match Value 256*OMB1+OMB0 */
> +#define CMD_ReadCurrentStatus	0x07
> +	/* Read the current status of the register in OMB0, result in IMB0 */
> +#define CMD_ReadFirmwareVersion	0x0e
> +			/* Read the firmware ver., result in IMB1.IMB0 */
> +#define CMD_ReadHardwareVersion	0x0f
> +			/* Read the hardware ver., result in IMB1.IMB0 */
> +#define CMD_EnableIDIFilters	0x20
> +				/* Enable IDI filters based on bits in OMB0 */
> +#define CMD_EnableIDIPatternMatch 0x21
> +			/* Enable IDI pattern match based on bits in OMB0 */

No, put the comment on the line above, not below it, that just confuses
things.

thanks,

greg k-h

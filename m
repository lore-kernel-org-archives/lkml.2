Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932496Ab0I3VWc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 17:22:32 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:34545 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932483Ab0I3VWb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 17:22:31 -0400
Date: Thu, 30 Sep 2010 14:20:55 -0700
From: matt mooney <mfm@muteddisk.com>
To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, jmorris@namei.org, joe@perches.com,
        christophe-h.ricard@st.com
Subject: Re: [PATCH 1/3] TPM: new stm i2c device driver
Message-ID: <20100930212055.GA6369@haskell.muteddisk.com>
Mail-Followup-To: Rajiv Andrade <srajiv@linux.vnet.ibm.com>,
	linux-kernel@vger.kernel.org, jmorris@namei.org, joe@perches.com,
	christophe-h.ricard@st.com
References: <cover.1285870690.git.srajiv@linux.vnet.ibm.com>
 <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e828eb98bf5b36fea2bd89760d7bc3cf3d5b6755.1285870690.git.srajiv@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 16:09 Thu 30 Sep     , Rajiv Andrade wrote:
> From: Christophe Henri RICARD <christophe-h.ricard@st.com>
> 
> This driver uses the Linux I2C, TPM and generic gpio interfaces.
> 
> Signed-off-by: Christophe Henri RICARD <christophe-h.ricard@st.com>
> Signed-off-by: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
> ---
>  Documentation/tpm/tpm_stm_st19_i2c.txt |  168 +++++++
>  drivers/char/tpm/Kconfig               |    9 +
>  drivers/char/tpm/Makefile              |    1 +
>  drivers/char/tpm/tpm_stm_st19_i2c.c    |  822 ++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_stm_st19_i2c.h    |   63 +++
>  include/linux/i2c/tpm_stm_st19_i2c.h   |   45 ++
>  6 files changed, 1108 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/tpm/tpm_stm_st19_i2c.txt
>  create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.c
>  create mode 100644 drivers/char/tpm/tpm_stm_st19_i2c.h
>  create mode 100644 include/linux/i2c/tpm_stm_st19_i2c.h
> 
> diff --git a/Documentation/tpm/tpm_stm_st19_i2c.txt b/Documentation/tpm/tpm_stm_st19_i2c.txt
> new file mode 100644
> index 0000000..39e3ed8
> --- /dev/null
> +++ b/Documentation/tpm/tpm_stm_st19_i2c.txt
> @@ -0,0 +1,168 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> + * Copyright (C) 2009, 2010 STMicroelectronics
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @Author: Christophe RICARD tpmsupport@st.com
> + */
> +
> +PURPOSE OF THE DOCUMENT
> +------------------------
> +This document is intend to describe how to install the TPM driver for

intend -> intended

The sentence could be worded better though; e.g., "... describe the installation
of the TPM driver ..."

> +TPM ST19NP18 using I2C protocols.
> +
> +
> +PLATFORM USED FOR TESTING
> +--------------------------
> +During the development, several embedded platforms running ARM CPU have been

... running an ARM CPU were used.

"have been" is a present perfect tense and does not fit here.

> +used.
> +Validated platforms listing:

It would be better to say "Listing of validated platforms:"

> +- TI Beagleboard
> +- STMicroelectronics Spear 300
> +- STMicroelectronics Spear 600
> +
> +REQUIREMENTS
> +-------------
> +Software
> +=========
> +This TPM driver could be install under a kernel which implement at least the
> +following features:

The TPM driver can be installed under a kernel that implements ...

> +- Linux GENERIC_GPIO programming interfaces.
> +- I2C new style programming interface base (with probe & remove functions)

There should be a period at the end of the previous sentence for uniformity.

> +- 1 I2C adapter (I2C Linux controller driver) or use of I2C_GPIO driver for I2C
> +bitbanging.
> +
> +
> +Hardware
> +=========
> +To run a TPM the platform needs  at least:

Comma after TPM and there is an extra space btw. needs and at.

> +- 2 Power supply (3.3V).

supply -> supplies

> +- 1 I2C controller or 2 GPIOs used for SDA & SCL (I2C bit bang method).
> +- 2 GPIOs for signals accept_command & data_available.
> +
> +TPM I2C speed is 100Khz (Maximum)
> +
> +All TPM signals work at 3.3V
> +
> +HOW TO INSTALL
> +---------------
> +Platform installation file
> +===========================
> +(N.B: platform file in arch/<processor_type>/mach-<platform-name>/
> +
> +
> +1 - Software integration
> +=========================
> +<processor_type> could be: alpha, arm, avr32, blackfin, cris, frv, h8300, ia64,
> +m32r, m68k, m68knommu, parisc, powerpc, s390, sh, sparc, sparc64, um, x86,
> +xtensa...
> +<platform-name> corresponds to your platform
> +
> +In the file where the machine_init() function exists, the developer must
> +declare:
> +- 1 struct st19np18_platform_data to provide which gpio the driver will use.
> +	* The accept_pin and data_avail_pin gpio are configured as input only.
> +	* This gpio management is under the platform developer responsability.

... developer's responsibility.

> +Finally in the machine_init() function provided in the same file, the developer

Comma after finally

> +should use the well known function i2c_register_board_info() from the I2C Linux
> +API Core.
> +
> +2- Hardware integration
> +========================
> +- ST recommends connecting VPS1 and VPS2 to board power supply and at least two

Needs a "the" before board.

> +GNDs (on each side of TSSOP28 package). (See datasheet for further informations)

... information.)

> +
> +- As the ST19NP18 has no internal pull up, ST recommands to had:

to had -> having
The use of a colon here is questionable.

> +  * 2 external pull up on SDA & SCL signals (RpSDA/RpSCL) with value according

value -> values

> +to the abacus on page 40 or the "I2C Bus specification", version 2.1 January

Comman should go inside quotes

> +2000.
> +
> +
> +Platform integration advises
> +=============================
> +
> +For power management purposes, the kernel will send a TPM_SaveState command in the
> +suspend tpm driver function.
> +If the platform generate a TPM Init event on wakeup, the first TPM command that should

Add "s" to generate

> +be executed before the Linux kernel is back (resume function execution) is
> +TPM_Startup(ST_STATE).

The second half of the conditional is passive and should be reworded.

> +
> +Here is an example with beagleboard:
> +====================================
> +Depending on the platform, the developper should specify in

miss spelled developer

> +the platform init file the following informations:

no "s" after information
Again, the sentence structure could be reworked for readability. I would break
out the first preposition to its own sentence and move the second preposition to
the beginning or ending of the newly formed second sentence.

> +- The platform gpio's used to managed the tpm's accept_pin/data_avail_pin
> +(in a struct st19np18_platform_data declaration).
> +- The TPM I2C 7 bits address (TPM_I2C_ST19_ADDR_WR) (in a struct i2c_board_info).
> +
> +Then the developper should add  the TPM slave device to the good i2c adapter with the

developper -> developer
There is an extra space btw. add and the

> +i2c_register_board_info function (Assuming that the gpio and the i2c bus are well configured).

Do not capitalize "A" in assuming, unless you make it a parenthetical sentence.

> +file arch\arm\mach-omap2\board-omap3beagle.c
> +add the following:
> +-----------------------------------------------------------------------
> +
> +static struct st19np18_platform_data tpm_data = {
> +        .accept_pin = 135,
> +        .data_avail_pin = 143,
> +};
> +
> +static struct i2c_board_info __initdata tpm_st19_i2c_board_info[] = {
> +        {
> +         I2C_BOARD_INFO(TPM_DRIVER_NAME, TPM_I2C_ST19_ADDR_WR),
> +         .platform_data = &tpm_data,
> +         },
> +};
> +
> +------------------------------------------------------------------------
> +Then complete the beagleboard init to be like that:
> +------------------------------------------------------------------------

that -> this

> +static void __init omap3_beagle_init(void)
> +{
> +        omap3_mux_init(board_mux, OMAP_PACKAGE_CBB);
> +        omap3_beagle_i2c_init();
> +        platform_add_devices(omap3_beagle_devices,
> +                        ARRAY_SIZE(omap3_beagle_devices));
> +        omap_serial_init();
> +
> +        omap_mux_init_gpio(170, OMAP_PIN_INPUT);
> +        gpio_request(170, "DVI_nPD");
> +        /* REVISIT leave DVI powered down until it's needed ... */
> +        gpio_direction_output(170, true);
> +
> +        usb_musb_init(&musb_board_data);
> +        usb_ehci_init(&ehci_pdata);
> +        omap3beagle_flash_init();
> +
> +        beagle_display_init();
> +
> +        /* Ensure SDRC pins are mux'd for self-refresh */
> +        omap_mux_init_signal("sdrc_cke0", OMAP_PIN_OUTPUT);
> +        omap_mux_init_signal("sdrc_cke1", OMAP_PIN_OUTPUT);
> +        omap_mux_init_gpio(((struct st19np18_platform_data *)
> +                           tpm_st19_i2c_board_info[0].platform_data)->data_avail_pin,
> +                           OMAP_PIN_INPUT);
> +	omap_mux_init_gpio(((struct st19np18_platform_data *)
> +                           tpm_st19_i2c_board_info[0].platform_data)->accept_pin,
> +                           OMAP_PIN_INPUT);
> +
> +	i2c_register_board_info(3, tpm_st19_i2c_board_info, ARRAY_SIZE(tpm_st19_i2c_board_info));
> +}
> diff --git a/drivers/char/tpm/Kconfig b/drivers/char/tpm/Kconfig
> index 4dc338f..2e99033 100644
> --- a/drivers/char/tpm/Kconfig
> +++ b/drivers/char/tpm/Kconfig
> @@ -60,4 +60,13 @@ config TCG_INFINEON
>  	  Further information on this driver and the supported hardware
>  	  can be found at http://www.prosec.rub.de/tpm
>  
> +config TCG_ST19_I2C
> +        tristate "STMicroelectronics ST19 I2C TPM"
> +        depends on I2C
> +        depends on GPIOLIB
> +        ---help---
> +        If you have a TPM security chip from STMicroelectronics working with
> +        an I2C bus say Yes and it will be accessible from within Linux.

Comma after bus

I hope that helps.

-mfm

> +        To compile this driver as a module, choose M here; the module will be
> +        called tpm_stm_st19_i2c.
>  endif # TCG_TPM
> diff --git a/drivers/char/tpm/Makefile b/drivers/char/tpm/Makefile
> index ea3a1e0..f2f9526 100644
> --- a/drivers/char/tpm/Makefile
> +++ b/drivers/char/tpm/Makefile
> @@ -9,3 +9,4 @@ obj-$(CONFIG_TCG_TIS) += tpm_tis.o
>  obj-$(CONFIG_TCG_NSC) += tpm_nsc.o
>  obj-$(CONFIG_TCG_ATMEL) += tpm_atmel.o
>  obj-$(CONFIG_TCG_INFINEON) += tpm_infineon.o
> +obj-$(CONFIG_TCG_ST19_I2C) += tpm_stm_st19_i2c.o
> diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.c b/drivers/char/tpm/tpm_stm_st19_i2c.c
> new file mode 100644
> index 0000000..35307d2
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_stm_st19_i2c.c
> @@ -0,0 +1,822 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> + * Copyright (C) 2009, 2010  STMicroelectronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @Author: Christophe RICARD tpmsupport@st.com
> + *
> + * @File: tpm_stm_st19_i2c.c
> + *
> + * @Synopsis:
> + * ----------------------------------------------------------------------
> + *	02/12/2008
> + *	- Stand alone implementation (without any TPM api)
> + * ----------------------------------------------------------------------
> + *	03/02/2010
> + *	- Power management (suspend and resume functions)
> + *	implementation
> + * ----------------------------------------------------------------------
> + *	03/19/2010
> + *	- Use of the linux kernel TPM api --> driver/char/tpm
> + * ----------------------------------------------------------------------
> + *	05/26/2010
> + *	- Update code for code submission and bug fixes:
> + *	- Comments spelling fixes
> + *	- Lindent script execution
> + *	- checkpatch.pl script execution
> + *	- fix syslog error when loaded as a module:
> + *	 "release() function missing and must be fixed"
> + *	- name files change from
> + *	  stm_st19_tpm_i2c to tpm_stm_st19_i2c
> + * ----------------------------------------------------------------------
> + *	06/15/2010
> + *	- Update for new tpm core device.
> + *	num_opens --> is_open
> + * ----------------------------------------------------------------------
> + *	07/08/2010
> + *	- Update probe, resume suspend functions
> + *	- Fix issue suspend buffer and work around related to the
> + *	chip->data_buffer not allocated.
> + * ----------------------------------------------------------------------
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/delay.h>
> +#include <linux/init.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>
> +#include <linux/wait.h>
> +#include <linux/string.h>
> +#include <linux/interrupt.h>
> +#include <linux/spinlock.h>
> +#include <linux/sysfs.h>
> +#include <linux/gpio.h>
> +#include <linux/sched.h>
> +#include <linux/uaccess.h>
> +#include <linux/io.h>
> +#include <linux/slab.h>
> +
> +#include <linux/i2c/tpm_stm_st19_i2c.h>
> +
> +#include "tpm.h"
> +
> +#include "tpm_stm_st19_i2c.h"
> +
> +/*
> + * @Comments: tpm_stm_st19_platform_specific.h deliver shows a platform specific
> + * file example.
> + * It has been created to split TPM datas and platform.
> + * This example could be used when the driver is built as a module.
> + * In case of other platform, please add a struct i2c_board_info in your arch/
> + * platform file.
> + */
> +static struct st19np18_platform_data *pin_infos;
> +
> +/*
> + * gpio_readpin is a wrapper to read a gpio value.
> + * Use generic gpio APIs
> + * @param: pin_id, the pin identifier where the value will be read.
> + * @return: the gpio value (should be 0 or 1) or negative errno
> + */
> +static int gpio_readpin(int pin_id)
> +{
> +	int ret;
> +	ret = gpio_direction_input(pin_id);
> +	if (ret == 0)
> +		return gpio_get_value(pin_id);
> +	return ret;
> +}
> +
> +/*
> + * gpio_writepin is a wrapper to write a gpio value.
> + * Use generic gpio APIs.
> + * @param: pin_id, the pin identifier where the value will be wrote.
> + * @param: value, the value that will be written.
> + * @return: 0 in case of success
> + */
> +#ifdef DEBUG
> +static int gpio_writepin(int pin_id, int value)
> +{
> +	int ret;
> +	ret = gpio_direction_output(pin_id, value);
> +
> +	if (ret == 0)
> +		gpio_set_value(pin_id, value);
> +	return ret;
> +}
> +#endif
> +
> +static int wait_until_good_shape(void)
> +{
> +	int state_data = 0;
> +	int state_command = 0;
> +	int timeout = msecs_to_jiffies(STARTUP_WAIT_INTERVAL);
> +	int time = msecs_to_jiffies(TICK_GPIO_SPOOLING);
> +	int ret = 0;
> +	wait_queue_head_t queue;
> +
> +	int wait_time = 0;
> +	DEFINE_WAIT(__wait);
> +	init_waitqueue_head(&queue);
> +
> +	do {
> +		prepare_to_wait(&queue, &__wait, TASK_INTERRUPTIBLE);
> +		state_data = gpio_readpin(pin_infos->data_avail_pin);
> +		state_command = gpio_readpin(pin_infos->accept_pin);
> +
> +		if (state_data == 0 && state_command > 0)
> +			return 0;
> +		else if (wait_time >= timeout)
> +			return -EIO;
> +		else if (!signal_pending(current)) {
> +			ret = schedule_timeout(time);
> +			wait_time += time;
> +		} else
> +			ret = -ERESTARTSYS;
> +	} while (1);
> +	finish_wait(&queue, &__wait);
> +
> +	return ret;
> +}
> +
> +/*
> + * wait_event_interruptible_on_gpio is a function that poll on
> + * GPIO dataavailable and GPIO acceptcommand
> + * @param: queue, the queue where the work will be stored
> + * @param: timeout, maximal pooling time.
> + * @return: DATA_ON in case of data_available pin goes high (logical value 1).
> + * COMMAND_ON in case of accept_command pin goes high (logical value 1).
> + * -EIO in case of data_available & accept_command pin goes high
> + *		(logical value 1).
> + * -EPERM in case of data_available & accept_command pin still low
> + *		(logical value 0).
> + */
> +static int wait_event_interruptible_on_gpio(wait_queue_head_t queue,
> +					    int timeout)
> +{
> +	int state_data = 0;
> +	int state_command = 0;
> +	int ret = msecs_to_jiffies(TICK_GPIO_SPOOLING);
> +	struct tpm_chip *chip =
> +	    (struct tpm_chip *)i2c_get_clientdata(pin_infos->client);
> +	int long_timeout =
> +	    tpm_calc_ordinal_duration(chip, TPM_I2C_ORDINAL_LONG);
> +	int wait_time = 0;
> +	DEFINE_WAIT(__wait);
> +
> +	if (timeout > long_timeout)
> +		timeout = long_timeout;
> +
> +	do {
> +		prepare_to_wait(&queue, &__wait, TASK_INTERRUPTIBLE);
> +		state_data = gpio_readpin(pin_infos->data_avail_pin);
> +		state_command = gpio_readpin(pin_infos->accept_pin);
> +
> +		if (state_data > 0 || state_command > 0)
> +			break;
> +		else if (wait_time >= timeout)
> +			break;
> +		else if (!signal_pending(current)) {
> +			ret =
> +			    schedule_timeout(msecs_to_jiffies
> +					     (TICK_GPIO_SPOOLING));
> +			wait_time += msecs_to_jiffies(TICK_GPIO_SPOOLING);
> +		} else {
> +			ret = -ERESTARTSYS;
> +			break;
> +		}
> +	} while (1);
> +	finish_wait(&queue, &__wait);
> +
> +	return (state_data && state_command) ? -EIO : state_data ? DATA_ON :
> +	    state_command ? COMMAND_ON : -EPERM;
> +}
> +
> +/*
> + * responseSize return the command size
> + * @param: buffer, command buffer.
> + * @param: size, the buffer size.
> + * @return: the command size.
> + */
> +static int responseSize(const char *buffer, size_t size)
> +{
> +	size_t val = 0;
> +	if (size >= TPM_HEADER_SIZE) {
> +		val = (size_t) (((unsigned)buffer[2]) << 24
> +				| ((unsigned)buffer[3]) << 16
> +				| ((unsigned)buffer[4]) << 8 | (unsigned)
> +				buffer[5]);
> +	}
> +
> +	if (val < TPM_BUFSIZE)
> +		return val;
> +	else
> +		return TPM_BUFSIZE;
> +}
> +
> +/*
> + * tpm_stm_i2c_send send TPM commands through the I2C bus.
> + * Before sending any TPM commands, tpm_stm_i2c_send poll data_available and
> + * accept_command TPM GPIOs.
> + *
> + * In case the data_available is high (logical value 1), tpm_stm_i2c_send will
> + * empty the TPM FIFO by reading all the datas stored inside the TPM.
> + *
> + * Then, if the accept_command TPM GPIO is high(logical value 1)
> + * tpm_stm_i2c_send will first send the 10 bytes header of the TCG commands and
> + * then send the others bytes by 40 bytes blocks.
> + *
> + * data_available and accept_command TPM GPIOs will goes low when the TPM
> + * compute the command.
> + *
> + * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
> + * @param: buf,	the buffer to send.
> + * @param: count, the number of bytes to send.
> + * @return: In case of success the number of bytes sent.
> + *			In other case, a < 0 value describing the issue.
> + */
> +static int tpm_stm_i2c_send(struct tpm_chip *chip, unsigned char *buf,
> +			    size_t count)
> +{
> +	u32 ret = 0, i, size, ordinal, pin = 0;
> +	struct i2c_client *client;
> +
> +#ifdef DEBUG
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_stm_i2c_send\n");
> +#endif
> +
> +	if (chip == NULL)
> +		return -EBUSY;
> +	if (count < TPM_HEADER_SIZE)
> +		return -EBUSY;
> +	client = (struct i2c_client *)pin_infos->client;
> +
> +	ordinal = be32_to_cpu(*((__be32 *) (buf + 6)));
> +
> +	/* i2c_client initialization */
> +	client->flags = 0;
> +
> +	/* Wait for AcceptCmd signal high */
> +	/* Check if data are available before */
> +	/* sending data (data_avail_pin hight) */
> +	/* If data are available, we read the data */
> +	init_waitqueue_head(&pin_infos->write_queue);
> +	pin = wait_event_interruptible_on_gpio(pin_infos->write_queue,
> +					       tpm_calc_ordinal_duration
> +					       (chip, ordinal));
> +	if (pin < 0) {
> +		ret = pin;
> +		goto end;
> +	}
> +
> +	client->flags = I2C_M_RD;
> +
> +	size = TPM_HEADER_SIZE;
> +	for (i = 0; pin == DATA_ON && i < size;) {
> +		ret = i2c_master_recv(client,
> +				      pin_infos->tpm_i2c_buffer[1],
> +				      (i == 0) ? TPM_HEADER_SIZE :
> +				      count - i > TPM_I2C_BLOCK_SIZE ?
> +				      TPM_I2C_BLOCK_SIZE : count - i);
> +		if (ret < 0)
> +			goto end;
> +		if (i == 0)
> +			size =
> +			    responseSize(pin_infos->tpm_i2c_buffer[1], count);
> +		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> +
> +		if (i < size)
> +			pin =
> +			    wait_event_interruptible_on_gpio(pin_infos->
> +							     write_queue,
> +							     msecs_to_jiffies
> +							     (TPM_I2C_SHORT));
> +	}
> +
> +	pin = wait_event_interruptible_on_gpio(pin_infos->write_queue,
> +					       msecs_to_jiffies(TPM_I2C_SHORT));
> +
> +	/* i2c_client initialization */
> +	client->flags = 0;
> +
> +	size = TPM_HEADER_SIZE;
> +	for (i = 0; i < size && pin == COMMAND_ON;) {
> +		memcpy(pin_infos->tpm_i2c_buffer[0], buf + i,
> +		       (i == 0) ? TPM_HEADER_SIZE : count - i >
> +		       TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE : count - i);
> +
> +		if (i == 0) {
> +			size = responseSize(buf, count);
> +			size = (size < count ? size : count);
> +		}
> +		ret =
> +		    i2c_master_send(client,
> +				    pin_infos->tpm_i2c_buffer[0],
> +				    count >= TPM_HEADER_SIZE ? (i ==
> +								0) ?
> +				    TPM_HEADER_SIZE : count - i >
> +				    TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
> +				    count - i : count);
> +		if (ret < 0) {
> +			printk(KERN_INFO "tpm_st19_i2c: Failed to send data\n");
> +			goto end;
> +		}
> +
> +		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> +		/* Wait for AcceptCmd signal hight */
> +		if (i < size)
> +			pin =
> +			    wait_event_interruptible_on_gpio(pin_infos->
> +							     write_queue,
> +							     msecs_to_jiffies
> +							     (TPM_I2C_SHORT));
> +
> +		if (pin != COMMAND_ON) {
> +			printk(KERN_INFO
> +			       "tpm_st19_i2c:"
> +			       " Failed to read gpio pin (AcceptCmd)\n");
> +			ret = -EIO;
> +			goto end;
> +		}
> +	}
> +	if (i == 0) {
> +		printk(KERN_INFO
> +		       "tpm_st19_i2c: Failed to read gpio pin (AcceptCmd)\n");
> +		ret = -EIO;
> +	}
> +end:
> +	return ret ? ret : count;
> +}
> +
> +/*
> + * tpm_stm_i2c_recv received TPM response through the I2C bus.
> + * Before receiving any TPM response, tpm_stm_i2c_recv poll data_available and
> + * accept_command TPM GPIOs.
> + *
> + * In case the accept_command is high (logical value 1), tpm_stm_i2c_recv will
> + * do nothing.
> + *
> + * Then, if the data_available TPM GPIO is high(logical value 1)
> + * tpm_stm_i2c_recv will first receive the 10 bytes header of the TCG TPM
> + * response and then receive the others bytes by 40 bytes blocks.
> + *
> + * accept_command TPM GPIOs will goes high when the TPM Fofo is empty.
> + *
> + * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
> + * @param: buf,	the buffer to store datas.
> + * @param: count, the number of bytes to send.
> + * @return: In case of success the number of bytes received.
> + *			In other case, a < 0 value describing the issue.
> + */
> +static int tpm_stm_i2c_recv(struct tpm_chip *chip, unsigned char *buf,
> +			    size_t count)
> +{
> +	int ret = 0;
> +	int i, size;
> +	int pin = 0;
> +	struct i2c_client *client;
> +
> +#ifdef DEBUG
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_stm_i2c_recv\n");
> +#endif
> +
> +	if (chip == NULL)
> +		return -EBUSY;
> +	if (count < TPM_HEADER_SIZE)
> +		return -EBUSY;
> +
> +	client = (struct i2c_client *)pin_infos->client;
> +
> +	/* Configure TPM I2C */
> +	client->flags = I2C_M_RD;
> +
> +	/* Spool on the good gpio as long as pin GPIO 3 not HIGHT */
> +	init_waitqueue_head(&chip->vendor.read_queue);
> +	pin = wait_event_interruptible_on_gpio(chip->vendor.read_queue,
> +					       tpm_calc_ordinal_duration
> +					       (chip, TPM_I2C_ORDINAL_LONG));
> +
> +	size = TPM_HEADER_SIZE;
> +	for (i = 0; i < size && pin == DATA_ON;) {
> +		ret =
> +		    i2c_master_recv(client,
> +				    pin_infos->tpm_i2c_buffer[1],
> +				    (count >= TPM_HEADER_SIZE ? i ==
> +				     0 ? TPM_HEADER_SIZE : (size - i) >
> +				     TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE :
> +				     size - i : count));
> +		if (ret < 0) {
> +			printk(KERN_INFO
> +			       "tpm_st19_i2c:"
> +			       " Failed to read gpio pin (DataAvalaible)\n");
> +			goto end;
> +		}
> +
> +		if (buf != NULL) {
> +			memcpy(buf + i, pin_infos->tpm_i2c_buffer[1],
> +			       (count >= TPM_HEADER_SIZE ? i == 0 ?
> +				TPM_HEADER_SIZE : (size - i) >
> +				TPM_I2C_BLOCK_SIZE ? TPM_I2C_BLOCK_SIZE : size -
> +				i : count));
> +
> +			if (i == 0) {
> +				size = responseSize(buf, size);
> +				if (size > count)
> +					size = count;
> +			}
> +		} else {
> +			printk(KERN_INFO "tpm_st19_i2c: read buffer is NULL\n");
> +			goto end;
> +		}
> +
> +		(i == 0) ? (i += TPM_HEADER_SIZE) : (i += TPM_I2C_BLOCK_SIZE);
> +
> +		if (i < size)
> +			pin =
> +			    wait_event_interruptible_on_gpio(chip->vendor.
> +							     read_queue,
> +							     msecs_to_jiffies
> +							     (TPM_I2C_SHORT));
> +	}
> +
> +	if (i == 0) {
> +		printk(KERN_INFO
> +		       "tpm_st19_i2c: "
> +		       "Failed to read gpio pin (DataAvalaible)\n");
> +		ret = -EIO;
> +		goto end;
> +	}
> +	return size;
> +end:
> +	return ret;
> +}
> +
> +/*
> + * tpm_stm_i2c_cancel, cancel is not implemented.
> + * @param: chip, the tpm_chip description as specified in driver/char/tpm/tpm.h.
> + */
> +static void tpm_stm_i2c_cancel(struct tpm_chip *chip)
> +{
> +}				/* tpm_stm_i2c_cancel() */
> +
> +/*
> + * tpm_stm_i2c_status is not implemented because TIS registers are not
> + * implemented.
> + */
> +static u8 tpm_stm_i2c_status(struct tpm_chip *chip)
> +{
> +	return -ENOSYS;
> +}				/* tpm_stm_i2c_status() */
> +
> +#ifdef _MODULE
> +
> +static void tpm_st19_i2c_dummy(struct device *dev)
> +{
> +
> +}				/*tpm_st19_i2c_dummy() */
> +
> +/*
> + * tpm_st19_i2c_release do nothing
> + * @param: kobj, not used
> + */
> +static void tpm_st19_i2c_release(struct kobject *kobj)
> +{
> +	struct tpm_chip *chip;
> +	printk(KERN_INFO "tpm_st19_i2c_release\n");
> +
> +	if (_client != NULL) {
> +		chip = (struct tpm_chip *)i2c_get_clientdata(_client);
> +
> +		if (chip != NULL) {
> +			chip->release = tpm_st19_i2c_dummy;
> +			chip->dev->release(chip->dev);
> +		}
> +	}
> +}				/* tpm_st19_i2c_release() */
> +#endif /*_MODULE */
> +/*
> + * tpm_st19_i2c_ioctl provides 2 handles:
> + * - TPMIOC_CANCEL: allow to CANCEL a TPM commands execution.
> + *   See tpm_stm_i2c_cancel description above
> + * - TPMIOC_TRANSMIT: allow to transmit a TPM commands.
> + *
> + * @return: In case of success, return TPM response size.
> + * In other case return < 0 value describing the issue.
> + */
> +static ssize_t tpm_st19_i2c_ioctl(struct inode *inode, struct file *file,
> +				  unsigned int cmd, unsigned long arg)
> +{
> +	int in_size = 0, out_size = 0;
> +	struct tpm_chip *chip = file->private_data;
> +
> +	switch (cmd) {
> +	case TPMIOC_CANCEL:
> +		tpm_stm_i2c_cancel(chip);
> +		return -ENOSYS;
> +	case TPMIOC_TRANSMIT:
> +		if (copy_from_user(pin_infos->tpm_i2c_buffer[0],
> +		    (const char *)arg, TPM_HEADER_SIZE))
> +			return -EFAULT;
> +		in_size = responseSize(pin_infos->tpm_i2c_buffer[0],
> +				      TPM_HEADER_SIZE);
> +		if (in_size > sizeof(pin_infos->tpm_i2c_buffer[0]))
> +			in_size = sizeof(pin_infos->tpm_i2c_buffer[0]);
> +		if (copy_from_user(pin_infos->tpm_i2c_buffer[0],
> +				   (const char *)arg, in_size))
> +			return -EFAULT;
> +		tpm_stm_i2c_send(chip, pin_infos->tpm_i2c_buffer[0], in_size);
> +
> +		out_size = tpm_stm_i2c_recv(chip, pin_infos->tpm_i2c_buffer[1],
> +					    TPM_BUFSIZE);
> +		if (copy_to_user((char *)arg, pin_infos->tpm_i2c_buffer[1],
> +				 out_size))
> +			return -EFAULT;
> +		return out_size;
> +	default:
> +		return -ENOTTY;
> +	}
> +	return -ENOTTY;
> +}
> +
> +static const struct file_operations tpm_st19_i2c_fops = {
> +	.owner = THIS_MODULE,
> +	.llseek = no_llseek,
> +	.read = tpm_read,
> +	.ioctl = tpm_st19_i2c_ioctl,
> +	.write = tpm_write,
> +	.open = tpm_open,
> +	.release = tpm_release,
> +};
> +
> +static DEVICE_ATTR(pubek, S_IRUGO, tpm_show_pubek, NULL);
> +static DEVICE_ATTR(pcrs, S_IRUGO, tpm_show_pcrs, NULL);
> +static DEVICE_ATTR(enabled, S_IRUGO, tpm_show_enabled, NULL);
> +static DEVICE_ATTR(active, S_IRUGO, tpm_show_active, NULL);
> +static DEVICE_ATTR(owned, S_IRUGO, tpm_show_owned, NULL);
> +static DEVICE_ATTR(temp_deactivated, S_IRUGO, tpm_show_temp_deactivated, NULL);
> +static DEVICE_ATTR(caps, S_IRUGO, tpm_show_caps_1_2, NULL);
> +static DEVICE_ATTR(cancel, S_IWUSR | S_IWGRP, NULL, tpm_store_cancel);
> +
> +static struct attribute *stm_tpm_attrs[] = {
> +	&dev_attr_pubek.attr,
> +	&dev_attr_pcrs.attr,
> +	&dev_attr_enabled.attr,
> +	&dev_attr_active.attr,
> +	&dev_attr_owned.attr,
> +	&dev_attr_temp_deactivated.attr,
> +	&dev_attr_caps.attr,
> +	&dev_attr_cancel.attr, NULL,
> +};
> +
> +static struct attribute_group stm_tpm_attr_grp = {
> +	.attrs = stm_tpm_attrs
> +};
> +
> +static struct tpm_vendor_specific st_i2c_tpm = {
> +	.send = tpm_stm_i2c_send,
> +	.recv = tpm_stm_i2c_recv,
> +	.cancel = tpm_stm_i2c_cancel,
> +	.status = tpm_stm_i2c_status,
> +	.attr_group = &stm_tpm_attr_grp,
> +	.miscdev = {.fops = &tpm_st19_i2c_fops,},
> +};
> +
> +/*
> + * tpm_st19_i2c_probe initialize the TPM device
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @param: id, the i2c_device_id struct.
> + * @return: 0 in case of success.
> + *			-1 in other case.
> + */
> +static int
> +tpm_st19_i2c_probe(struct i2c_client *client, const struct i2c_device_id *id)
> +{
> +	int err;
> +	struct tpm_chip *chip;
> +	struct st19np18_platform_data *platform_data;
> +
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_probe\n");
> +
> +	err = 0;
> +
> +	/* Check I2C platform functionnalities */
> +	if (client == NULL) {
> +		printk(KERN_INFO "client is NULL. exiting.\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	if (!i2c_check_functionality(client->adapter, I2C_FUNC_I2C)) {
> +		printk(KERN_INFO "tpm_st19_i2c: client not i2c capable\n");
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	chip = tpm_register_hardware(&client->dev, &st_i2c_tpm);
> +	if (!chip) {
> +		err = -ENODEV;
> +		goto end;
> +	}
> +
> +	/*
> +	 * ST19 TPM does not support interrupt. chip->vendor.irq is only
> +	 * set to a value greater that 0 because status function have no
> +	 * sense with this device (TIS register not available)
> +	 */
> +	chip->vendor.irq = 1;
> +
> +	platform_data = client->dev.platform_data;
> +	pin_infos = platform_data;
> +	platform_data->tpm_i2c_buffer[0] =
> +	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> +	if (platform_data->tpm_i2c_buffer[0] == NULL) {
> +		err = -ENOMEM;
> +		goto _tpm_clean_answer;
> +	}
> +	platform_data->tpm_i2c_buffer[1] =
> +	    kmalloc(TPM_BUFSIZE * sizeof(u8), GFP_KERNEL);
> +	if (platform_data->tpm_i2c_buffer[1] == NULL) {
> +		err = -ENOMEM;
> +		goto _tpm_clean_response;
> +	}
> +
> +	platform_data->client = client;
> +
> +	/* Register GPIO pin through generic Linux GPIO API */
> +	err = gpio_request(platform_data->accept_pin, "accept command");
> +	if (err)
> +		goto _gpio_init;
> +
> +	err = gpio_request(platform_data->data_avail_pin, "data available");
> +	if (err)
> +		goto _gpio_init;
> +
> +	err = wait_until_good_shape();
> +	if (err)
> +		goto _gpio_set;
> +
> +	tpm_get_timeouts(chip);
> +
> +	/* attach chip datas to client */
> +	i2c_set_clientdata(client, chip);
> +	pin_infos->bChipF = false;
> +
> +	printk(KERN_INFO "tpm_st19_i2c: TPM I2C Initialized\n");
> +	return 0;
> +_gpio_set:
> +_gpio_init:
> +	if (platform_data) {
> +		gpio_free(platform_data->accept_pin);
> +		gpio_free(platform_data->data_avail_pin);
> +	}
> +_tpm_clean_response:
> +	tpm_remove_hardware(chip->dev);
> +	if (platform_data->tpm_i2c_buffer[1] != NULL) {
> +		kfree(platform_data->tpm_i2c_buffer[1]);
> +		platform_data->tpm_i2c_buffer[1] = NULL;
> +	}
> +_tpm_clean_answer:
> +	if (platform_data->tpm_i2c_buffer[0] != NULL) {
> +		kfree(platform_data->tpm_i2c_buffer[0]);
> +		platform_data->tpm_i2c_buffer[0] = NULL;
> +	}
> +	pin_infos->bChipF = true;
> +end:
> +	printk(KERN_INFO "tpm_st19_i2c: TPM I2C initialisation fail\n");
> +	return err;
> +}
> +
> +/*
> + * tpm_st19_i2c_remove remove the TPM device
> + * @param: client, the i2c_client drescription (TPM I2C description).
> +		clear_bit(0, &chip->is_open);
> + * @return: 0 in case of success.
> + */
> +static __devexit int tpm_st19_i2c_remove(struct i2c_client *client)
> +{
> +	struct tpm_chip *chip = (struct tpm_chip *)i2c_get_clientdata(client);
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_remove\n");
> +
> +	if (pin_infos != NULL) {
> +		gpio_free(pin_infos->accept_pin);
> +		gpio_free(pin_infos->data_avail_pin);
> +
> +		/* Check if chip has been previously clean */
> +		if (pin_infos->bChipF != true)
> +			tpm_remove_hardware(chip->dev);
> +		if (pin_infos->tpm_i2c_buffer[1] != NULL) {
> +			kfree(pin_infos->tpm_i2c_buffer[1]);
> +			pin_infos->tpm_i2c_buffer[1] = NULL;
> +		}
> +		if (pin_infos->tpm_i2c_buffer[0] != NULL) {
> +			kfree(pin_infos->tpm_i2c_buffer[0]);
> +			pin_infos->tpm_i2c_buffer[0] = NULL;
> +		}
> +	}
> +
> +	return 0;
> +}
> +
> +/*
> + * tpm_st19_i2c_pm_suspend suspend the TPM device
> + * Added: Work around when suspend and no tpm application is running, suspend
> + * may fail because chip->data_buffer is not set (only set in tpm_open in Linux
> + * TPM core)
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @param: mesg, the power management message.
> + * @return: 0 in case of success.
> + */
> +static int tpm_st19_i2c_pm_suspend(struct i2c_client *client, pm_message_t mesg)
> +{
> +	struct tpm_chip *chip =
> +	    (struct tpm_chip *)i2c_get_clientdata(pin_infos->client);
> +	int ret = 0;
> +	if (chip->data_buffer == NULL)
> +		chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> +	ret = tpm_pm_suspend(&client->dev, mesg);
> +	return ret;
> +}				/* tpm_st19_i2c_suspend() */
> +
> +/*
> + * tpm_st19_i2c_pm_resume resume the TPM device
> + * This part of the Linux driver should be move in an other part or
> + * environment (bootloader ?)
> + * @param: client, the i2c_client drescription (TPM I2C description).
> + * @return: 0 in case of success.
> + */
> +static int tpm_st19_i2c_pm_resume(struct i2c_client *client)
> +{
> +	struct tpm_chip *chip =
> +	    (struct tpm_chip *)i2c_get_clientdata(pin_infos->client);
> +	int ret = 0;
> +	if (chip->data_buffer == NULL)
> +		chip->data_buffer = pin_infos->tpm_i2c_buffer[0];
> +	ret = tpm_pm_resume(&client->dev);
> +	return ret;
> +}				/* tpm_st19_i2c_pm_resume() */
> +
> +static const struct i2c_device_id tpm_st19_i2c_id[] = {
> +	{TPM_DRIVER_NAME, 0},
> +	{}
> +};
> +
> +MODULE_DEVICE_TABLE(i2c, tpm_st19_i2c_id);
> +
> +static struct i2c_driver tpm_st19_i2c_driver = {
> +	.driver = {
> +		   .owner = THIS_MODULE,
> +		   .name = TPM_DRIVER_NAME,
> +		   },
> +	.probe = tpm_st19_i2c_probe,
> +	.remove = tpm_st19_i2c_remove,
> +	.resume = tpm_st19_i2c_pm_resume,
> +	.suspend = tpm_st19_i2c_pm_suspend,
> +	.id_table = tpm_st19_i2c_id
> +};
> +
> +/*
> + * tpm_st19_i2c_init initialize driver
> + * @return: 0 if successful, else non zero value.
> + */
> +static int __init tpm_st19_i2c_init(void)
> +{
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_init\n");
> +	return i2c_add_driver(&tpm_st19_i2c_driver);
> +}
> +
> +/*
> + * tpm_st19_i2c_exit The kernel calls this function during unloading the
> + * module or during shut down process
> + */
> +static void __exit tpm_st19_i2c_exit(void)
> +{
> +	printk(KERN_INFO "tpm_st19_i2c: tpm_st19_i2c_exit\n");
> +	i2c_del_driver(&tpm_st19_i2c_driver);
> +}
> +
> +module_init(tpm_st19_i2c_init);
> +module_exit(tpm_st19_i2c_exit);
> +
> +MODULE_AUTHOR("Christophe Ricard (tpmsupport@st.com)");
> +MODULE_DESCRIPTION("STM TPM I2C ST19 Driver");
> +MODULE_VERSION("1.2.0");
> +MODULE_LICENSE("GPL");
> diff --git a/drivers/char/tpm/tpm_stm_st19_i2c.h b/drivers/char/tpm/tpm_stm_st19_i2c.h
> new file mode 100644
> index 0000000..db3a059
> --- /dev/null
> +++ b/drivers/char/tpm/tpm_stm_st19_i2c.h
> @@ -0,0 +1,63 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> + * Copyright (C) 2009, 2010  STMicroelectronics
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @Author: Christophe RICARD tpmsupport@st.com
> + *
> + * @File: stm_st19_tpm_i2c.h
> + *
> + * @Date: 02/12/2008
> + */
> +#ifndef __STM_ST19_TPM_I2C_MAIN_H__
> +#define __STM_ST19_TPM_I2C_MAIN_H__
> +
> +#include <linux/pci.h>
> +#include <linux/module.h>
> +#include <linux/platform_device.h>
> +#include <linux/i2c.h>
> +#include <linux/i2c-id.h>
> +#include <linux/fs.h>
> +#include <linux/miscdevice.h>
> +
> +#define MINOR_NUM_I2C		224
> +
> +#define TPM_DRIVER_NAME		"st19np18"
> +
> +#define	TPM_BUFSIZE		2048
> +
> +#define TPM_HEADER_SIZE		10
> +#define TPM_I2C_BLOCK_SIZE	0x28
> +
> +#define TPM_I2C_ORDINAL_LONG	0x0D	/* TPM_ORD_TakeOwnership */
> +
> +#define TPM_I2C_SHORT	2000	/* 2s */
> +#define TICK_GPIO_SPOOLING	2
> +#define STARTUP_WAIT_INTERVAL	8 /* 8ms */
> +
> +/* ioctl commands */
> +#define TPMIOC_CANCEL		_IO('T', 0x00)	/* Not supported */
> +#define TPMIOC_TRANSMIT		_IO('T', 0x01)
> +
> +#define DATA_ON			  1	/* data available */
> +#define COMMAND_ON		  2	/* accept command */
> +
> +#endif /* __STM_ST19_TPM_I2C_MAIN_H__ */
> diff --git a/include/linux/i2c/tpm_stm_st19_i2c.h b/include/linux/i2c/tpm_stm_st19_i2c.h
> new file mode 100644
> index 0000000..cdac5f4
> --- /dev/null
> +++ b/include/linux/i2c/tpm_stm_st19_i2c.h
> @@ -0,0 +1,45 @@
> +/*
> + * STMicroelectronics TPM I2C Linux driver for TPM ST19NP18
> + * Copyright (C) 2009, 2010 STMicroelectronics
> + * Christophe RICARD tpmsupport@st.com
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation; either version 2 of the License, or
> + * (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> + * GNU General Public License for more details.
> + *
> + * You should have received a copy of the GNU General Public License along
> + * with this program; if not, write to the Free Software Foundation, Inc.,
> + * 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.
> + *
> + * STMicroelectronics version 1.2.0, Copyright (C) 2010
> + * STMicroelectronics comes with ABSOLUTELY NO WARRANTY.
> + * This is free software, and you are welcome to redistribute it
> + * under certain conditions.
> + *
> + * @File: stm_st19_tpm_i2c.h
> + *
> + * @Date: 06/15/2008
> + */
> +#ifndef __STM_ST19_TPM_I2C_H__
> +#define __STM_ST19_TPM_I2C_H__
> +
> +#include <linux/i2c.h>
> +
> +#define TPM_DRIVER_NAME         "st19np18"
> +#define TPM_I2C_ST19_ADDR_WR	(0x26 >> 1)
> +
> +struct st19np18_platform_data {
> +	int accept_pin;	/* accept command pin */
> +	int data_avail_pin;/* data available pin */
> +	struct i2c_client *client;
> +	bool bChipF;
> +	u8 *tpm_i2c_buffer[2]; /* 0 Request 1 Response */
> +	wait_queue_head_t write_queue;
> +};
> +
> +#endif /* __STM_ST19_TPM_I2C_H__ */
> -- 
> 1.7.2.2
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
> 
